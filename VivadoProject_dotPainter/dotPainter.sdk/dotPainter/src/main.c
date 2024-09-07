/*
 * main.c
 *
 *  Created on: 2024. 4. 1.
 *      Author: qwer
 */

#include "myGPIO.h"
#include "myJSTK2.h"
#include "myNewOLEDrgb.h"
#include "sleep.h"

//	DIRECTION
//		1
//	3	0	4
//		2
#define DIR_N	0
#define DIR_U	1
#define DIR_D	2
#define DIR_L	3
#define DIR_R	4

#define DIR_TH_H	255 * 0.8
#define DIR_TH_L	255 * 0.2

#define CURSOR_COLOR 	C_GREEN
#define PAINT_COLOR		C_RED

#define	CURSOR_COL_MAX 96
#define CURSOR_ROW_MAX 64

#define CURSOR_COL	6
#define CURSOR_ROW	8

#define BTN_AS_TRIG	1

int cursor[2] 		= {0}; // Col, Row
int oledOn 			= 0;
int directionPrev 	= 0;
int tempDirection 	= 0;
int direction 		= 0;
int oldCol 			= 0;
int oldRow 			= 0;
int trigger			= 0;
int triggerPrev		= 0;

int paintedArea[CURSOR_ROW_MAX/CURSOR_ROW][CURSOR_COL_MAX/CURSOR_COL] = { 0
//		{0, 0, 0, 0, 0, 0, 0, 0},
//		{0, 0, 0, 0, 0, 0, 0, 0},
//		{0, 0, 0, 0, 0, 0, 0, 0},
//		{0, 0, 0, 0, 0, 0, 0, 0},
//		{0, 0, 0, 0, 0, 0, 0, 0},
//		{0, 0, 0, 0, 0, 0, 0, 0},
//		{0, 0, 0, 0, 0, 0, 0, 0},
//		{0, 0, 0, 0, 0, 0, 0, 0}
};


void paint(int row, int col){
	cmd_drawRectangle(col, row, col+(CURSOR_COL-1), row+(CURSOR_ROW-1), PAINT_COLOR, PAINT_COLOR, 1);
	paintedArea[row/CURSOR_ROW][col/CURSOR_COL] = 1;
}

void clear(int row, int col){
	cmd_clearWindow(col, row, col+(CURSOR_COL-1), row+(CURSOR_ROW-1));
	paintedArea[row/CURSOR_ROW][col/CURSOR_COL] = 0;
}

void floatCursor(){
	cmd_drawRectangle(cursor[0], cursor[1], cursor[0]+(CURSOR_COL-1), cursor[1]+(CURSOR_ROW-1), CURSOR_COLOR, CURSOR_COLOR, 0);
}

void determineDirection(){
	int xPos = 0;
	int yPos = 0;
	u16 rawPos = 0x0000;
	rawPos = cmdGetPosition();

	xPos = (rawPos & 0xFF00) >> 8;
	yPos = (rawPos & 0x00FF) >> 0;


	if (xPos > DIR_TH_H){
		tempDirection = DIR_R;
	}
	else if (xPos < DIR_TH_L){
		tempDirection = DIR_L;
	}
	else if (yPos > DIR_TH_H){
		tempDirection = DIR_U;
	}
	else if (yPos < DIR_TH_L){
		tempDirection = DIR_D;
	}
	else{
		tempDirection = 0;
	}

	direction = tempDirection;
}

void determineTrigger(){
	u8 rawButton = 0x00;
	rawButton = cmdGetButtonState();
	if (BTN_AS_TRIG){
		trigger = (rawButton & 0x01);
	}
	else{
		trigger = (rawButton & 0x02) >> 1;
	}
}

void updateCursor(int* cursorArr, int direction){

	if (direction != 0){

		switch (direction){
		// Up (Row--)
		case DIR_U :
			if ((cursorArr[1] - CURSOR_ROW) < (int)ROW_MIN)
				cursorArr[1] = ((int)ROW_MAX+1)-CURSOR_ROW;
			else
				cursorArr[1] -= CURSOR_ROW;
			break;

		// Right (Col++)
		case DIR_R :
			if ((cursorArr[0] + CURSOR_COL) == (int)COL_MAX+1)
				cursorArr[0] = (int)COL_MIN;
			else
				cursorArr[0] += CURSOR_COL;
			break;

		// Down (Row++)
		case DIR_D :
			if ((cursorArr[1] + CURSOR_ROW) == (int)ROW_MAX+1)
				cursorArr[1] = (int)ROW_MIN;
			else
				cursorArr[1] += CURSOR_ROW;
			break;
		// Left (Col--)
		case DIR_L :
			if ((cursorArr[0] - CURSOR_COL) < (int)COL_MIN)
				cursorArr[0] = ((int)COL_MAX+1)-CURSOR_COL;
			else
				cursorArr[0] -= CURSOR_COL;
			break;

		default :
			break;
		}

		floatCursor();

		if (paintedArea[oldRow/CURSOR_ROW][oldCol/CURSOR_COL]){
			// Paint it back
			paint(oldRow, oldCol);
		}
		else{
			// Clear
			clear(oldRow, oldCol);
		}
	}
}

int diffCaptureDirection(){
	if (direction == directionPrev){
		return 0;
	}
	else{
		directionPrev = direction;
		return 1;
	}
}

int diffCaptureTrigger(){
	if (trigger == triggerPrev){
		return 0;
	}
	else{
		triggerPrev = trigger;
		return 1;
	}
}

void themeScreen(){
//	For debug
//	cmd_drawLine(COL_MIN, ROW_MIN, COL_MID, ROW_MID, C_RED);
//	cmd_drawLine(COL_MIN, ROW_MAX, COL_MID, ROW_MID, C_GREEN);
//	cmd_drawLine(COL_MAX, ROW_MIN, COL_MID, ROW_MID, C_BLUE);
//	cmd_drawLine(COL_MAX, ROW_MAX, COL_MID, ROW_MID, C_YELLOW);
}


int main(){
	volatile int i, j;

	cmdSetInversion(0, 1);
	while(1){
//		OLED On
		while((readSwitch() & 0x01)){
			if (!oledOn){
				OLEDDevInit();
				oledOn = 1;
				themeScreen();
			}
			else{

				determineTrigger();
				if (diffCaptureTrigger()){
					paint(cursor[1], cursor[0]);
				}
				else if (readButton() & 0x08){
					clear(cursor[1], cursor[0]);
				}

				determineDirection();
				if (diffCaptureDirection()){
					oldCol = cursor[0];
					oldRow = cursor[1];
					updateCursor(cursor, direction);
				}
				else{
					floatCursor();
				}


			}
			usleep(100*1000);
		}
		if (oledOn){
			OLEDDevTerm();
			oledOn = 0;
			cursor[0]		= 0;
			cursor[1]		= 0;
			directionPrev 	= 0;
			tempDirection 	= 0;
			direction 		= 0;
			oldCol 			= 0;
			oldRow 			= 0;
			trigger			= 0;
			triggerPrev		= 0;

			for (i = 0; i < CURSOR_ROW_MAX/CURSOR_ROW; i++){
				for (j=0; j < CURSOR_COL_MAX/CURSOR_COL; j++){
					paintedArea[i][j] = 0;
				}
			}
		}
		else{
			usleep(100);
		}
	}

	while(1){
		// Safe Loop
	}


	return 0;
}

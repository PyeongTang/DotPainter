/*
 * main.c
 *
 *  Created on: 2024. 3. 23.
 *      Author: qwer
 */


#include "stdio.h"
#include "xparameters.h"
#include "xil_io.h"
#include "myPmodJSTK2.h"
#include "sleep.h"

int main(){

	u16 rawPos		=	0x0000;
	u8  rawButton	=	0x00;
	int xPos		=	0;
	int yPos		=	0;
	int pushButton	=	0;
	int trigger		=	0;

	cmdSetInversion(0, 1);

	while(1){
		rawPos 		=	cmdGetPosition();
		xPos		=	(int)((rawPos & 0xFF00) >> 8);
		yPos		=	(int)((rawPos & 0x00FF) >> 0);

		rawButton 	=	cmdGetButtonState();
		pushButton 	=	rawButton & 0x01;
		trigger 	=	(rawButton & 0x02) >> 1;

		xil_printf("X : %5d\t\tY : %5d\t\tB : %1d\t\tT : %1d\n", xPos, yPos, pushButton, trigger);
		usleep(1000*10);
	}
	return 0;
}

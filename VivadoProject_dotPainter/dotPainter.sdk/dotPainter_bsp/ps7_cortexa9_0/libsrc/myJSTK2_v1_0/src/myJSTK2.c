
/***************************** Include Files *******************************/
#include "myJSTK2.h"

/************************** Function Definitions ***************************/

int isJSTK2Done(){
	if (MYSPI_mReadReg(BASEADDR, 0) & 0x000400){
		return 1;
	}
	else{
		return 0;
	}
}

void resetCommand(){
	MYSPI_mWriteReg(BASEADDR, 0, 0x000200);
}

u8 dcdRxByte(int byteNum){
	u8 byteValue = 0x00;
	switch(byteNum){
	case 1 : byteValue = (MYSPI_mReadReg(BASEADDR, 8) & 0xFF000000) >> 24;
		break;
	case 2 : byteValue = (MYSPI_mReadReg(BASEADDR, 8) & 0x00FF0000) >> 16;
		break;
	case 3 : byteValue = (MYSPI_mReadReg(BASEADDR, 8) & 0x0000FF00) >> 8;
		break;
	case 4 : byteValue = (MYSPI_mReadReg(BASEADDR, 8) & 0x000000FF) >> 0;
		break;
	case 5 : byteValue = (MYSPI_mReadReg(BASEADDR, 12) & 0x00FF0000) >> 16;
		break;
	case 6 : byteValue = (MYSPI_mReadReg(BASEADDR, 12) & 0x0000FF00) >> 8;
		break;
	case 7 : byteValue = (MYSPI_mReadReg(BASEADDR, 12) & 0x000000FF) >> 0;
		break;
	case 8 : byteValue = (MYSPI_mReadReg(BASEADDR, 12) & 0xFF000000) >> 24;
		break;
	default : byteValue = 0x00;
		break;
	}
	return byteValue;
}

/*
 * In AXI4
 *
 * slv_reg0[31 : 24]	= 	i_cmd_echo
 * slv_reg0[23 : 11]	= 	-
 * slv_reg0[10]			=	i_spi_done
 * slv_reg0[9]			=	o_fetch
 * slv_reg0[8]			=	o_cmd_valid
 * slv_reg0[7 : 0]		=	o_cmd
 *
 * slv_reg1[31 : 24]	=	o_param_1
 * slv_reg1[23 : 16]	=	o_param_2
 * slv_reg1[15 : 8]		=	o_param_3
 * slv_reg1[7 : 0]		=	o_param_4
 *
 * slv_reg2[31 : 24]	=	rx_byte1
 * slv_reg2[23 : 16]	=	rx_byte2
 * slv_reg2[15 : 8]		=	rx_byte3
 * slv_reg2[7 : 0]		=	rx_byte4
 *
 * slv_reg3[31 : 24]	=	-
 * slv_reg3[23 : 16]	=	rx_byte5
 * slv_reg3[15 : 8]		=	rx_byte6
 * slv_reg3[7 : 0]		=	rx_byte7
 *
 */
void callCMD(u8 cmd){
	MYSPI_mWriteReg(BASEADDR, 0, (0x01 << 8) | cmd);
}

void setParam(u8 param1, u8 param2, u8 param3, u8 param4){
	MYSPI_mWriteReg(BASEADDR, 4, ((param1 << 24) | (param2 << 16) | (param3 << 8) | param4));
}

u16 cmdGetPosition(){
/*
 * Get the 8-bit position variables
 *
 * Byte 6 : X position
 * Byte 7 : Y position
 */
	u16 returnVal = 0x0000;
	callCMD(0xC0);
	while(!isJSTK2Done()){}
	returnVal = (dcdRxByte(6) << 8 | dcdRxByte(7));
	resetCommand();
	return returnVal;
}

u8 cmdGetButtonState(){
	u8 returnVal = 0x00;
	callCMD(0x00);
	while(!isJSTK2Done()){}
	returnVal = dcdRxByte(5);
	resetCommand();
	return returnVal;
}

u8 cmdGetStatus(){
/*
 * Get a copy of the device's status register (8-bit).
 *
 * Byte 6 : Status
 */
	u8 returnVal = 0x0000;
	callCMD(0xF0);
	while(!isJSTK2Done()){}
	returnVal = (dcdRxByte(6));
	resetCommand();
	return returnVal;
}

u16 cmdGetFirmwareVer(){
/*
 * Get a copy of the device's firmware version.
 *
 * Byte 6 : Low byte
 * Byte 7 : High byte
 */
	u16 returnVal = 0x0000;
	callCMD(0xF1);
	while(!isJSTK2Done()){}
	returnVal = (dcdRxByte(7) << 8 | dcdRxByte(6));
	resetCommand();
	return returnVal;
}

u16 cmdGetCalXMin(){
/*
 * Get a copy of the smpXMin calibration constant.
 *
 * Byte 6 : Low byte
 * Byte 7 : High byte
 */
	u16 returnVal = 0x0000;
	callCMD(0xE0);
	while(!isJSTK2Done()){}
	returnVal = (dcdRxByte(7) << 8 | dcdRxByte(6));
	resetCommand();
	return returnVal;
}

u16 cmdGetCalXMax(){
/*
 * Get a copy of the smpXMax calibration constant.
 *
 * Byte 6 : Low byte
 * Byte 7 : High byte
 */
	u16 returnVal = 0x0000;
	callCMD(0xE1);
	while(!isJSTK2Done()){}
	returnVal = (dcdRxByte(7) << 8 | dcdRxByte(6));
	resetCommand();
	return returnVal;
}

u16 cmdGetCalYMin(){
/*
 * Get a copy of the smpYMin calibration constant.
 *
 * Byte 6 : Low byte
 * Byte 7 : High byte
 */
	u16 returnVal = 0x0000;
	callCMD(0xE2);
	while(!isJSTK2Done()){}
	returnVal = (dcdRxByte(7) << 8 | dcdRxByte(6));
	resetCommand();
	return returnVal;
}

u16 cmdGetCalYMax(){
/*
 * Get a copy of the smpYMax calibration constant.
 *
 * Byte 6 : Low byte
 * Byte 7 : High byte
 */
	u16 returnVal = 0x0000;
	callCMD(0xE3);
	while(!isJSTK2Done()){}
	returnVal = (dcdRxByte(7) << 8 | dcdRxByte(6));
	resetCommand();
	return returnVal;
}

u16 cmdGetCalXCenMin(){
/*
 * Get a copy of the smpXCenterMin calibration constant.
 *
 * Byte 6 : Low byte
 * Byte 7 : High byte
 */
	u16 returnVal = 0x0000;
	callCMD(0xE4);
	while(!isJSTK2Done()){}
	returnVal = (dcdRxByte(7) << 8 | dcdRxByte(6));
	resetCommand();
	return returnVal;
}

u16 cmdGetCalXCenMax(){
/*
 * Get a copy of the smpXCenterMax calibration constant.
 *
 * Byte 6 : Low byte
 * Byte 7 : High byte
 */
	u16 returnVal = 0x0000;
	callCMD(0xE5);
	while(!isJSTK2Done()){}
	returnVal = (dcdRxByte(7) << 8 | dcdRxByte(6));
	resetCommand();
	return returnVal;
}

u16 cmdGetCalYCenMin(){
/*
 * Get a copy of the smpYCenterMin calibration constant.
 *
 * Byte 6 : Low byte
 * Byte 7 : High byte
 */
	u16 returnVal = 0x0000;
	callCMD(0xE6);
	while(!isJSTK2Done()){}
	returnVal = (dcdRxByte(7) << 8 | dcdRxByte(6));
	resetCommand();
	return returnVal;
}

u16 cmdGetCalYCenMax(){
/*
 * Get a copy of the smpYCenterMax calibration constant.
 *
 * Byte 6 : Low byte
 * Byte 7 : High byte
 */
	u16 returnVal = 0x0000;
	callCMD(0xE7);
	while(!isJSTK2Done()){}
	returnVal = (dcdRxByte(7) << 8 | dcdRxByte(6));
	resetCommand();
	return returnVal;
}

void cmdSetLed(int ledOn){
/*
 * Turn the Green LED on or off.
 */
	callCMD(0x80 | 0x01*ledOn);
}

void cmdSetLedRGB(int redDuty, int greenDuty, int blueDuty){
/*
 * Set the duty cycles for the Red, Green, and Blue LEDs.
 * PARAM1 - Red
 * PARAM2 - Green
 * PARAM3 - Blue
 * PARAM4 - ignored
 */
	int r = 0;
	int g = 0;
	int b = 0;

//	Red
	if (redDuty < 0){
		r = 0;
	}
	else if (redDuty > 100){
		r = 100;
	}
	r = redDuty / 100 * 255;

//	Green
	if (greenDuty < 0){
		g = 0;
	}
	else if (greenDuty > 100){
		g = 100;
	}
	g = greenDuty / 100 * 255;

//	Blue
	if (blueDuty < 0){
		b = 0;
	}
	else if (blueDuty > 100){
		b = 100;
	}
	b = blueDuty / 100 * 255;

	setParam(r, g, b, 0);
	callCMD(0x84);
	while(!isJSTK2Done()){}
	resetCommand();
}

void cmdSetInversion(int x, int y){
/*
 * Enable inversion of the 8-bit position value (from cmdGetPosition)
 */
	callCMD((0x88 | x*0x10) | y*0x01);
	while(!isJSTK2Done()){}
	resetCommand();
}

void cmdSetCalXMin(unsigned int value){
/*
 * Set the smpXMin calibration constant.
 *
 * Note : smpXMin < smpXCenterMin
 */
	setParam((value & 0x00FF), (value & 0xFF00) >> 8, 0, 0);
	callCMD(0xA8);
	while(!isJSTK2Done()){}
	resetCommand();
}

void cmdSetCalXMax(unsigned int value){
/*
 * Set the smpXMax calibration constant.
 *
 * Note : smpXMax > smpXCenterMax
 */
	setParam((value & 0x00FF), (value & 0xFF00) >> 8, 0, 0);
	callCMD(0xA9);
	while(!isJSTK2Done()){}
	resetCommand();
}

void cmdSetCalYMin(unsigned int value){
/*
 * Set the smpYMin calibration constant.
 *
 * Note : smpYMin < smpYCenterMin
 */
	setParam((value & 0x00FF), (value & 0xFF00) >> 8, 0, 0);
	callCMD(0xAA);
	while(!isJSTK2Done()){}
	resetCommand();
}

void cmdSetCalYMax(unsigned int value){
/*
 * Set the smpYMax calibration constant.
 *
 * Note : smpYMax > smpYCenterMax
 */
	setParam((value & 0x00FF), (value & 0xFF00) >> 8, 0, 0);
	callCMD(0xAB);
	while(!isJSTK2Done()){}
	resetCommand();
}

void cmdSetCalXCenMin(unsigned int value){
/*
 * Set the smpXCenterMin calibration constant.
 *
 * Note : smpXMin < smpXCenterMin < smpXCenterMax
 */
	setParam((value & 0x00FF), (value & 0xFF00) >> 8, 0, 0);
	callCMD(0xAC);
	while(!isJSTK2Done()){}
	resetCommand();
}

void cmdSetCalXCenMax(unsigned int value){
/*
 * Set the smpXCenterMax calibration constant.
 *
 * Note : smpXCenterMin < smpXCenterMax < smpXMax
 */
	setParam((value & 0x00FF), (value & 0xFF00) >> 8, 0, 0);
	callCMD(0xAD);
	while(!isJSTK2Done()){}
	resetCommand();
}

void cmdSetCalYCenMin(unsigned int value){
/*
 * Set the smpXCenterMin calibration constant.
 *
 * Note : smpYMin < smpXCenterMin < smpYCenterMax
 */
	setParam((value & 0x00FF), (value & 0xFF00) >> 8, 0, 0);
	callCMD(0xAE);
	while(!isJSTK2Done()){}
	resetCommand();
}

void cmdSetCalYCenMax(unsigned int value){
/*
 * Set the smpYCenterMax calibration constant.
 *
 * Note : smpYCenterMin < smpYCenterMax < smpYMax
 */
	setParam((value & 0x00FF), (value & 0xFF00) >> 8, 0, 0);
	callCMD(0xAF);
	while(!isJSTK2Done()){}
	resetCommand();
}

void cmdSetCalXMinMax(unsigned int minVal, unsigned int maxVal){
/*
 * Set the smpXMin and smpXMax calibration constants.
 *
 * Note : smpXMin < smpXCenterMin
 * 		: smpXMax > smpXCenterMax
 */
	setParam((minVal & 0x00FF), (minVal & 0xFF00) >> 8, (maxVal & 0x00FF), (maxVal & 0xFF00) >> 8);
	callCMD(0xB0);
	while(!isJSTK2Done()){}
	resetCommand();
}

void cmdSetCalYMinMax(unsigned int minVal, unsigned int maxVal){
/*
 * Set the smpYMin and smpYMax calibration constants.
 *
 * Note : smpYMin < smpYCenterMin
 * 		: smpYMax > smpYCenterMax
 */
	setParam((minVal & 0x00FF), (minVal & 0xFF00) >> 8, (maxVal & 0x00FF), (maxVal & 0xFF00) >> 8);
	callCMD(0xB1);
	while(!isJSTK2Done()){}
	resetCommand();
}

void cmdSetCalXCenMinMax(unsigned int minVal, unsigned int maxVal){
/*
 * Set the smpXCenterMin and smpXCenterMax calibration constants.
 *
 * Note : smpXMin < smpXCenterMin
 * 		: smpXMax > smpXCenterMax
 * 		: smpXCenterMin < smpXCenterMax
 */
	setParam((minVal & 0x00FF), (minVal & 0xFF00) >> 8, (maxVal & 0x00FF), (maxVal & 0xFF00) >> 8);
	callCMD(0xB2);
	while(!isJSTK2Done()){}
	resetCommand();
}

void cmdSetCalYCenMinMax(unsigned int minVal, unsigned int maxVal){
/*
 * Set the smpYCenterMin and smpYCenterMax calibration constants.
 *
 * Note : smpYMin < smpYCenterMin
 * 		: smpYMax > smpYCenterMax
 * 		: smpYCenterMin < smpYCenterMax
 */
	setParam((minVal & 0x00FF), (minVal & 0xFF00) >> 8, (maxVal & 0x00FF), (maxVal & 0xFF00) >> 8);
	callCMD(0xB3);
	while(!isJSTK2Done()){}
	resetCommand();
}

void cmdCalibrate(){
/*
 * Enter Joystick calibration mode.
 */
	callCMD(0xA4);
	while(!isJSTK2Done()){}
	resetCommand();
}

void cmdWriteFlash(){
/*
 * Write the calibration constants from RAM to High Endurance Flash.
 */
	callCMD(0xB8);
	while(!isJSTK2Done()){}
	resetCommand();
}

void cmdRldFromFlash(){
/*
 * Read the calibration constants from High Endurance Flash and load them into RAM
 */
	callCMD(0xBC);
	while(!isJSTK2Done()){}
	resetCommand();
}

/*
 * myGPIO.c
 *
 *  Created on: 2024. 2. 23.
 *      Author: qwer
 */

#include "myGPIO.h"

void initGPIO(GPIO* gp, u32 baseAddr){
	gp->baseAddr = baseAddr;
	gp->slv_reg_offset_led 		= 0;
	gp->slv_reg_offset_button 	= 4;
	gp->slv_reg_offset_rgb 		= 8;
	gp->slv_reg_offset_sw 		= 12;
}

void writeLED(GPIO* gp, int value){
	Xil_Out32(gp->baseAddr+gp->slv_reg_offset_led, value);
}

void writeRGB(GPIO* gp, int value){
	Xil_Out32(gp->baseAddr+gp->slv_reg_offset_rgb, value);
}

u32 readButton(GPIO* gp){
	return Xil_In32(gp->baseAddr+gp->slv_reg_offset_button);
}

u32 readSwitch(GPIO* gp){
	return Xil_In32(gp->baseAddr+gp->slv_reg_offset_sw);
}

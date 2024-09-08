/*
 * myGPIO.h
 *
 *  Created on: 2024. 2. 23.
 *      Author: qwer
 */

#include <xil_types.h>
#include <xil_io.h>

#ifndef SRC_MYGPIO_H_
#define SRC_MYGPIO_H_

typedef struct GPIO{
	u32 baseAddr;
	int slv_reg_offset_led;
	int slv_reg_offset_button;
	int slv_reg_offset_rgb;
	int slv_reg_offset_sw;
} GPIO;

void initGPIO(GPIO* gp, u32 baseAddr);

void writeLED(GPIO* gp, int value);

void writeRGB(GPIO* gp, int value);

u32 readButton(GPIO* gp);

u32 readSwitch(GPIO* gp);

#endif /* SRC_MYGPIO_H_ */

/*
 * myGPIO_example.c
 *
 *  Created on: 2024. 2. 23.
 *      Author: qwer
 */


#include "stdio.h"
#include "myGPIO.h"
#include "xparameters.h"

#define BASEADDR XPAR_MYGPIO_0_S00_AXI_BASEADDR
#define DELAY 6e7

int main(){
	volatile int i;
	GPIO gp;
	int led = 0;
	int rgb = 1;
	int sw;
	int btn;

	initGPIO(&gp, BASEADDR);

	while(1){
		sw = readSwitch(&gp);
		btn = readButton(&gp);

		writeLED(&gp, led);
		writeRGB(&gp, rgb);

		printf("sw : %x, btn : %x, led : %x, rgb : %x\n", sw, btn, led, rgb);

		for (i=0; i<DELAY; i++){
			;
		}
		rgb = rgb << 1;
		if (rgb == 128)
			rgb = 1;
		if (led++ == 15)
			led = 0;
	}
}

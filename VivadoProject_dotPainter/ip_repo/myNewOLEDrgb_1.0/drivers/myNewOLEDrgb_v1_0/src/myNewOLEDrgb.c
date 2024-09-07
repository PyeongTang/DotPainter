
/***************************** Include Files *******************************/
#include "myNewOLEDrgb.h"

/************************** Function Definitions ***************************/


u8 R_RGB(u16 color){
   return (u8) ((color >> 11) & 0x1F) << 1;
}

u8 G_RGB(u16 color){
   return (u8) ((color >> 5) & 0x3F);
}

u8 B_RGB(u16 color){
   return (u8) (color & 0x1F) << 1;
}

void clrCMD(){
	MYNEWOLEDRGB_mWriteReg(BASEADDR_OLEDrgb, 12, (0x01 << 5));
}

int OLED_isDone(){
	if (MYNEWOLEDRGB_mReadReg(BASEADDR_OLEDrgb, 4) & 0x01){
		return 1;
	}
	else {
		return 0;
	}
}

void setCMD(int num, u8 cmd1, u8 cmd2, u8 cmd3, u8 cmd4, u8 cmd5, u8 cmd6, u8 cmd7, u8 cmd8, u8 cmd9, u8 cmd10, u8 cmd11, u8 cmd12, u8 cmd13, u8 cmd14, u8 cmd15){
	u8 byte_0 = 0x00;
	byte_0 = (0x01) << 4 | (num);

	u32 bytes_1 = 0x00000000;
	bytes_1 = (cmd3 << 24 | cmd2 << 16 | cmd1 << 8 | byte_0);

	u32 bytes_2 = 0x00000000;
	bytes_2 = (cmd7 << 24 | cmd6 << 16 | cmd5 << 8 | cmd4);

	u32 bytes_3 = 0x00000000;
	bytes_3 = (cmd11 << 24 | cmd10 << 16 | cmd9 << 8 | cmd8);

	u32 bytes_4 = 0x00000000;
	bytes_4 = (cmd15 << 24 | cmd14 << 16 | cmd13 << 8 | cmd12);

	MYNEWOLEDRGB_mWriteReg(BASEADDR_OLEDrgb, 16, bytes_2);
	MYNEWOLEDRGB_mWriteReg(BASEADDR_OLEDrgb, 20, bytes_3);
	MYNEWOLEDRGB_mWriteReg(BASEADDR_OLEDrgb, 24, bytes_4);
	MYNEWOLEDRGB_mWriteReg(BASEADDR_OLEDrgb, 12, bytes_1);

	while (!OLED_isDone()){}
	clrCMD();
}

void setCMDSingleByte(u8 cmd1){
	setCMD(1, cmd1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

void setCMDDoubleByte(u8 cmd1, u8 cmd2){
	setCMD(2, cmd1, cmd2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

u8 cutOffValue(u8 value, u8 threshold){
	if (value > threshold){
		return threshold;
	}
	else {
		return value;
	}
}

//COMMAND TABLE

// Setup Column start and end BASEADDR_OLEDrgbess
void cmd_setColumnBASEADDR_OLEDrgbess(u8 start, u8 end){
	setCMDDoubleByte(cutOffValue(start, COL_MAX), cutOffValue(end, COL_MAX));
}

// Setup Row start and end BASEADDR_OLEDrgbess
void cmd_setRowBASEADDR_OLEDrgbess(u8 start, u8 end){
	setCMDDoubleByte(cutOffValue(start, ROW_MAX), cutOffValue(end, ROW_MAX));
}

// Set contrast for all color "A" segment
void cmd_setContrastForColorA(u8 contrast){
	setCMDDoubleByte(0x81, cutOffValue(contrast, 0xFF));
}

// Set contrast for all color "B" segment
void cmd_setContrastForColorB(u8 contrast){
	setCMDDoubleByte(0x82, cutOffValue(contrast, 0xFF));
}

// Set contrast for all color "C" segment
void cmd_setContrastForColorC(u8 contrast){
	setCMDDoubleByte(0x83, cutOffValue(contrast, 0xFF));
}

// Set master current attenuation factor
void cmd_masterCurrentControl(u8 factor){
	setCMDDoubleByte(0x87, cutOffValue(factor, 0x0F));
}

// Set Second Pre-charge Speed for Color A
void cmd_setSecondPreChargeSpeedForColorA(u8 speed){
	setCMDDoubleByte(0x8A, cutOffValue(speed, 0xFF));
}

// Set Second Pre-charge Speed for Color B
void cmd_setSecondPreChargeSpeedForColorB(u8 speed){
	setCMDDoubleByte(0x8B, cutOffValue(speed, 0xFF));
}

// Set Second Pre-charge Speed for Color C
void cmd_setSecondPreChargeSpeedForColorC(u8 speed){
	setCMDDoubleByte(0x8C, cutOffValue(speed, 0xFF));
}

// Set driver remap and color depth
void cmd_setRemapAndColorDepth(u8 value){
	setCMDDoubleByte(0xA0, cutOffValue(value, 0xFF));
}

// Set Display start line register by Row
void cmd_setDisplayStartLine(u8 line){
	setCMDDoubleByte(0xA1, cutOffValue(line, ROW_MAX));
}

// Set vertical offset by Com
void cmd_setDisplayOffset(u8 offset){
	setCMDDoubleByte(0xA2, cutOffValue(offset, ROW_MAX));
}

// Set Normal Dislay Mode
void cmd_setDisplayModeNormal(){
	setCMDSingleByte(0xA4);
}

// Set MUX ratio to N+1 Mux
void cmd_setMultiplexRatio(u8 ratio){
	setCMDDoubleByte(0xA8, cutOffValue(ratio, 0x3F));
}

// Configure dim mode setting
void cmd_dimModeSetting(u8 contrastColorA, u8 contrastColorB, u8 contrastColorC, u8 precharge){
	setCMD(6, 0xAB, 0x00, cutOffValue(contrastColorA, 0xFF), cutOffValue(contrastColorB, 0xFF), cutOffValue(contrastColorC, 0xFF), cutOffValue(precharge, 0x1F), 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

// Set Master Configuration
void cmd_setMasterConfiguration(int externalVCC){
	setCMDDoubleByte(0xAD, 0x8E | ~externalVCC);
}

// Set Display On
void cmd_displayOn(int dimMode){
	if (dimMode){
		setCMDSingleByte(0xAC);
	}
	else{
		setCMDSingleByte(0xAF);
	}
}

// Set Display Off
void cmd_displayOff(){
	setCMDSingleByte(0xAE);
}

// Power Save Mode
void cmd_powerSaveMode(int enable){
	if (enable){
		setCMDDoubleByte(0xB0, 0x1A);
	}
	else {
		setCMDDoubleByte(0xB0, 0x0B);
	}
}

// Phase period adjustment
void cmd_phasePeriodAdjustment(u8 value){
	setCMDDoubleByte(0xB1, value);
}

// Display Clock divider / Oscillator Frequency
void cmd_displayClockDividerOscillatorFrequency(u8 value){
	setCMDDoubleByte(0xB3, value);
}

// Set pre-charge voltage level, All three color share the same pre-charge voltage
void cmd_setPreChargeLevel(u8 level){
	setCMDDoubleByte(0xBB, level);
}

// Set COM deslect voltage level
void cmd_setVCOMH(u8 level){
	setCMDDoubleByte(0xBE, level);
}

// Set Command Lock
void cmd_setCommandLock(int lock){
	u8 cmd = 0x00;
	cmd = (0x01 << 4) | (lock << 2) | 0x02;
	setCMDDoubleByte(0xFD, cmd);
}

// Draw Line
void cmd_drawLine(u8 startCol, u8 startRow, u8 endCol, u8 endRow, u16 color){
	setCMD(8, 0x21, startCol, startRow, endCol, endRow, R_RGB(color), G_RGB(color), B_RGB(color), 0, 0, 0, 0, 0, 0, 0);
}

// Draw Rectangle
void cmd_drawRectangle(u8 startCol, u8 startRow, u8 endCol, u8 endRow, u16 lineColor, u16 fillColor, int fill){
	if (fill){
		setCMDDoubleByte(0x26, 0x01);
	}
	setCMD(11, 0x22, startCol, startRow, endCol, endRow, R_RGB(lineColor), G_RGB(lineColor), B_RGB(lineColor), R_RGB(fillColor), G_RGB(fillColor), B_RGB(fillColor), 0, 0, 0, 0);
	if (fill){
		setCMDDoubleByte(0x26, 0x00);
	}
}

// Copy
void cmd_copy(u8 startCol, u8 startRow, u8 endCol, u8 endRow, u8 newCol, u8 newRow){
	setCMD(7, 0x23, startCol, startRow, endCol, endRow, newCol, newRow, 0, 0, 0, 0, 0, 0, 0, 0);
}

// Dim window
void cmd_dimWindow(u8 startCol, u8 startRow, u8 endCol, u8 endRow){
	setCMD(5, 0x24, startCol, startRow, endCol, endRow, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

// Clear window
void cmd_clearWindow(u8 startCol, u8 startRow, u8 endCol, u8 endRow){
	setCMD(5, 0x25, startCol, startRow, endCol, endRow, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

// Continous Horizontal & Vertical Scrolling Setup
void cmd_scrollingSetup(u8 numColH, u8 startRow, u8 numRowH, u8 numRowV, u8 frame){
	if (((int)startRow + (int)numRowH) > 64){
		xil_printf("Row index exceeded\n");
	}
	else {
		// frame
		// 00b : 6 		frames
		// 01b : 10 	frames
		// 10b : 100 	frames
		// 11b : 200 	frames

		setCMD(6, 0x27, cutOffValue(numColH, COL_MAX), cutOffValue(startRow, ROW_MAX), cutOffValue(numRowH, ROW_MAX), cutOffValue(numRowV, ROW_MAX), cutOffValue(frame, 0x03), 0, 0, 0, 0, 0, 0, 0, 0, 0);
	}
}

// This command deactivates the scrolling action
void cmd_deactiveScrolling(){
	setCMDSingleByte(0x2E);
}

// This command activates the scrolling function
void cmd_activateScrolling(){
	setCMDSingleByte(0x2F);
}

void setPins(u8 pinMode){
	// [PMODEN, VCCEN, RES, DC]
	MYNEWOLEDRGB_mWriteReg(BASEADDR_OLEDrgb, 0, pinMode);
}

void OLEDDevInit(){
//	1. Bring DC low
//	2. Bring RST high
//	3. Bring VCCEN low
//	4. Bring PmodEn high and delay 20ms
	setPins(0x0A); // 0b1010
	usleep(1000 * 20);

//	5. Bring RES low and wait for at least 3 us,
//	and then bring it back to high
	setPins(0x8); // 0b1000
	usleep(1000);
	setPins(0xA); // 0b1010

//	6. Wait for the reset operation to complete
//	This takes a maximum of 3 us to complete
	usleep(1000);

//	7. Enable the driver IC to accept commands
	cmd_setCommandLock(0);

//	8. Send the display off command
	cmd_displayOff();

//	9. Set the Remap and Display formats
	cmd_setRemapAndColorDepth(0x72);

//	10. Set the display start line to the top line
	cmd_setDisplayStartLine(0x00);

//	11. Set the display offset to no vertical offset
	cmd_setDisplayOffset(0x00);

//	12. Make it normal display
//	with no color inversion or forcing the pixels on/off
	cmd_setDisplayModeNormal();

//	13. Set the Mux ratio
	cmd_setMultiplexRatio(0x3F);

//	14. Set the master configuration
//	to use a required external Vcc supply
	cmd_setMasterConfiguration(1);

//	15. Disable power saving mode
	cmd_powerSaveMode(0);

//	16. Set the phase length of the charge and discharge rates
	cmd_phasePeriodAdjustment(0x31);

//	17. Set the clock divide ratio and oscillator freq.
	cmd_displayClockDividerOscillatorFrequency(0xF0);

//	18. Set the Second Pre-charge speed of color A
	cmd_setSecondPreChargeSpeedForColorA(0x64);

//	19. Set the Second Pre-Charge Speed of Color B
	cmd_setSecondPreChargeSpeedForColorB(0x78);

//	20. Set the Second Pre-Charge Speed of Color C
	cmd_setSecondPreChargeSpeedForColorC(0x64);

//	21. Set the Pre-Charge Voltage to approximately 45% of Vcc
	cmd_setPreChargeLevel(0x3A);

//	22. Set the VCOMH Level
	cmd_setVCOMH(0x3E);

//	23. Set Master Current Attenuation Factor
	cmd_masterCurrentControl(0x06);

//	24. Set the Contrast for Color A (default red)
	cmd_setContrastForColorA(0x91);

//	25. Set the Contrast for Color B (default green)
	cmd_setContrastForColorB(0x50);

//	26. Set the Contrast for Color C (default blue)
	cmd_setContrastForColorC(0x7D);

//	27. Disable Scrolling
	cmd_deactiveScrolling();

//	28. Clear the screen by sending the clear command
	cmd_clearWindow(COL_MIN, ROW_MIN, COL_MAX, ROW_MAX);

//	29. Bring VCCEN (pin 9) logic high and wait 25 ms.
	setPins(0xE); // 0b1110
	usleep(25*1000);

//	30. Turn the display on
	cmd_displayOn(0);

//	31. Wait 100 ms
	usleep(100*1000);

	xil_printf(" ** OLED Initialized.. ** \n");
}

void OLEDDevTerm(){

	cmd_displayOff();
	setPins(0x0B); // 0b1011
	usleep(400*1000);
	xil_printf(" ** OLED Terminated.. ** \n");
}

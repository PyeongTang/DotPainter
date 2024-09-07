
#ifndef MYNEWOLEDRGB_H
#define MYNEWOLEDRGB_H


/****************** Include Files ********************/
#include "xstatus.h"
#include "stdio.h"
#include "xparameters.h"
#include "xil_io.h"
#include "xil_types.h"
#include "sleep.h"

#define MYNEWOLEDRGB_S00_AXI_SLV_REG0_OFFSET 0
#define MYNEWOLEDRGB_S00_AXI_SLV_REG1_OFFSET 4
#define MYNEWOLEDRGB_S00_AXI_SLV_REG2_OFFSET 8
#define MYNEWOLEDRGB_S00_AXI_SLV_REG3_OFFSET 12
#define MYNEWOLEDRGB_S00_AXI_SLV_REG4_OFFSET 16
#define MYNEWOLEDRGB_S00_AXI_SLV_REG5_OFFSET 20
#define MYNEWOLEDRGB_S00_AXI_SLV_REG6_OFFSET 24
#define MYNEWOLEDRGB_S00_AXI_SLV_REG7_OFFSET 28

#define BASEADDR_OLEDrgb 		XPAR_MYNEWOLEDRGB_0_S00_AXI_BASEADDR
#define CMD_DRAWLINE 	        0x21

#define C_PINK 			        0xF814
#define C_RED 			        0xF800
#define C_BLUE 			        0x001F
#define C_GREEN 		        0x07E0
#define C_YELLOW 		        0xE7E0
#define C_WHITE			        0xFFFF

#define COL_MIN			        0x00
#define COL_MID			        0x30
#define COL_MAX			        0x5F

#define ROW_MIN			        0x00
#define ROW_MID			        0x20
#define ROW_MAX			        0x3F

#define CMD_DELAY		        100


/**************************** Type Definitions *****************************/
/**
 *
 * Write a value to a MYNEWOLEDRGB register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the MYNEWOLEDRGBdevice.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void MYNEWOLEDRGB_mWriteReg(u32 BaseAddress, unsigned RegOffset, u32 Data)
 *
 */
#define MYNEWOLEDRGB_mWriteReg(BaseAddress, RegOffset, Data) \
  	Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))

/**
 *
 * Read a value from a MYNEWOLEDRGB register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the MYNEWOLEDRGB device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	u32 MYNEWOLEDRGB_mReadReg(u32 BaseAddress, unsigned RegOffset)
 *
 */
#define MYNEWOLEDRGB_mReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))

/************************** Function Prototypes ****************************/
/**
 *
 * Run a self-test on the driver/device. Note this may be a destructive test if
 * resets of the device are performed.
 *
 * If the hardware system is not built correctly, this function may never
 * return to the caller.
 *
 * @param   baseaddr_p is the base address of the MYNEWOLEDRGB instance to be worked on.
 *
 * @return
 *
 *    - XST_SUCCESS   if all self-test code passed
 *    - XST_FAILURE   if any self-test code failed
 *
 * @note    Caching must be turned off for this function to work.
 * @note    Self test may fail if data memory and device are not on the same bus.
 *
 */
XStatus MYNEWOLEDRGB_Reg_SelfTest(void * baseaddr_p);

u8 R_RGB(u16 color);
u8 G_RGB(u16 color);
u8 B_RGB(u16 color);
void clrCMD();
int OLED_isDone();
void setCMD(int num, u8 cmd1, u8 cmd2, u8 cmd3, u8 cmd4, u8 cmd5, u8 cmd6, u8 cmd7, u8 cmd8, u8 cmd9, u8 cmd10, u8 cmd11, u8 cmd12, u8 cmd13, u8 cmd14, u8 cmd15);
void setCMDSingleByte(u8 cmd1);
void setCMDDoubleByte(u8 cmd1, u8 cmd2);
u8 cutOffValue(u8 value, u8 threshold);
void cmd_setColumnBASEADDR_OLEDrgbess(u8 start, u8 end);
void cmd_setRowBASEADDR_OLEDrgbess(u8 start, u8 end);
void cmd_setContrastForColorA(u8 contrast);
void cmd_setContrastForColorB(u8 contrast);
void cmd_setContrastForColorC(u8 contrast);
void cmd_masterCurrentControl(u8 factor);
void cmd_setSecondPreChargeSpeedForColorA(u8 speed);
void cmd_setSecondPreChargeSpeedForColorB(u8 speed);
void cmd_setSecondPreChargeSpeedForColorC(u8 speed);
void cmd_setRemapAndColorDepth(u8 value);
void cmd_setDisplayStartLine(u8 line);
void cmd_setDisplayOffset(u8 offset);
void cmd_setDisplayModeNormal();
void cmd_setMultiplexRatio(u8 ratio);
void cmd_dimModeSetting(u8 contrastColorA, u8 contrastColorB, u8 contrastColorC, u8 precharge);
void cmd_setMasterConfiguration(int externalVCC);
void cmd_displayOn(int dimMode);
void cmd_displayOff();
void cmd_powerSaveMode(int enable);
void cmd_phasePeriodAdjustment(u8 value);
void cmd_displayClockDividerOscillatorFrequency(u8 value);
void cmd_setPreChargeLevel(u8 level);
void cmd_setVCOMH(u8 level);
void cmd_setCommandLock(int lock);
void cmd_drawLine(u8 startCol, u8 startRow, u8 endCol, u8 endRow, u16 color);
void cmd_drawRectangle(u8 startCol, u8 startRow, u8 endCol, u8 endRow, u16 lineColor, u16 fillColor, int fill);
void cmd_copy(u8 startCol, u8 startRow, u8 endCol, u8 endRow, u8 newCol, u8 newRow);
void cmd_dimWindow(u8 startCol, u8 startRow, u8 endCol, u8 endRow);
void cmd_clearWindow(u8 startCol, u8 startRow, u8 endCol, u8 endRow);
void cmd_scrollingSetup(u8 numColH, u8 startRow, u8 numRowH, u8 numRowV, u8 frame);
void cmd_deactiveScrolling();
void cmd_activateScrolling();
void setPins(u8 pinMode);
void OLEDDevInit();
void OLEDDevTerm();


#endif // MYNEWOLEDRGB_H

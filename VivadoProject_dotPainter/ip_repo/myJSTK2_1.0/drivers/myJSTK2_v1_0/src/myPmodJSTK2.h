/*
 * spiController.h
 *
 *  Created on: 2024. 4. 1.
 *      Author: qwer
 */

#ifndef SRC_MYPMODJSTK2_H_
#define SRC_MYPMODJSTK2_H_

/****************** Include Files ********************/
#include "xil_types.h"
#include "xstatus.h"
#include "xil_io.h"
#include "xparameters.h"

#define BASEADDR XPAR_MYJSTK2_0_S00_AXI_BASEADDR

#define MYSPI_S00_AXI_SLV_REG0_OFFSET 0
#define MYSPI_S00_AXI_SLV_REG1_OFFSET 4
#define MYSPI_S00_AXI_SLV_REG2_OFFSET 8
#define MYSPI_S00_AXI_SLV_REG3_OFFSET 12


/**************************** Type Definitions *****************************/
/**
 *
 * Write a value to a MYSPI register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the MYSPIdevice.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void MYSPI_mWriteReg(u32 BaseAddress, unsigned RegOffset, u32 Data)
 *
 */
#define MYSPI_mWriteReg(BaseAddress, RegOffset, Data) \
  	Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))

/**
 *
 * Read a value from a MYSPI register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the MYSPI device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	u32 MYSPI_mReadReg(u32 BaseAddress, unsigned RegOffset)
 *
 */
#define MYSPI_mReadReg(BaseAddress, RegOffset) \
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
 * @param   baseaddr_p is the base address of the MYSPI instance to be worked on.
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
XStatus MYSPI_Reg_SelfTest(void * baseaddr_p);

int isJSTK2Done();
void resetCommand();
u8 dcdRxByte(int byteNum);
void callCMD(u8 cmd);
void setParam(u8 param1, u8 param2, u8 param3, u8 param4);

// Get Functions
u16 cmdGetPosition();
u8	cmdGetButtonState();
u8	cmdGetStatus();
u16 cmdGetFirmwareVer();

u16 cmdGetCalXMin();
u16 cmdGetCalXMax();
u16 cmdGetCalYMin();
u16 cmdGetCalYMax();

u16 cmdGetCalXCenMin();
u16 cmdGetCalXCenMax();
u16 cmdGetCalYCenMin();
u16 cmdGetCalYCenMax();

// Set Functions
void cmdSetLed(int ledOn);
void cmdSetLedRGB(int redDuty, int greenDuty, int blueDuty);
void cmdSetInversion(int x, int y);

void cmdSetCalXMin(unsigned int value);
void cmdSetCalXMax(unsigned int value);
void cmdSetCalYMin(unsigned int value);
void cmdSetCalYMax(unsigned int value);

void cmdSetCalXCenMin(unsigned int value);
void cmdSetCalXCenMax(unsigned int value);
void cmdSetCalYCenMin(unsigned int value);
void cmdSetCalYCenMax(unsigned int value);

void cmdSetCalXMinMax(unsigned int minVal, unsigned int maxVal);
void cmdSetCalYMinMax(unsigned int minVal, unsigned int maxVal);
void cmdSetCalXCenMinMax(unsigned int minVal, unsigned int maxVal);
void cmdSetCalYCenMinMax(unsigned int minVal, unsigned int maxVal);

void cmdCalibrate();
void cmdWriteFlash();
void cmdRldFromFlash();

#endif /* SRC_MYPMODJSTK2_H_ */

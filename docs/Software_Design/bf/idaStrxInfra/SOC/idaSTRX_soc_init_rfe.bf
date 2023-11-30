
// BOOTLOADER or Debugger Access starts

//1. Wait for TCM initialization finished => FUNCTIONAL: BOOTLOADER AND CMM
// Check status of MEMSTS.xDONE are 111 (RFE-M7 TCM init done bits. On reset, RFE M7 TCM are initialized to 0 by HW) (Address 0x4441_0068 bit [2:0] should be 111).
//CPU_CTRL_RFE_CREG.MEMSTS = 0x4441_0000 + 0x068
sleep_bv(CPU_CTRL_RFE_CREG.MEMSTS.D0DONE , 1);
sleep_bv(CPU_CTRL_RFE_CREG.MEMSTS.D1DONE , 1);
sleep_bv(CPU_CTRL_RFE_CREG.MEMSTS.ITDONE , 1);

//2. RFE-M7 Clock Enable (this is not release from reset!) => FUNCTIONAL: BOOTLOADER AND CMM
//Enable the RFE M7 core partition (refer to section Partition Processes under MC_ME chapter) RFE CM7 is mapped to partition 0 and core 1.
//Core clock enable from MC_ME
//MC_ME.PRTN0_CORE1_PCONF addr = 0x400D_0000 + 0x160
MC_ME.PRTN0_CORE1_PCONF.CCE = 0x1;

//3. Run SoC init in Boot or CMM => Enables PIN for RFE (SPI, UART, GPIO)
#include "idaSTRX_soc_init_rfe_debug.bf"

//4. Release RFE-M7 => FUNCTIONAL: BOOTLOADER AND CMM
//Write '0' to bit RFE_ACCESS_CSR.RFE_M7_CTL.CPUWAIT (0x4444_8010 bit 0) to release the CPUWAIT of RFE_M7.
//RFE_ACCESS_CSR.RFE_M7_CTL.address = 0x4444_8000 + 0x010
RFE_ACCESS_CSR.RFE_M7_CTL.CPUWAIT = 0;

// BOOTLOADER or Debugger Access ends

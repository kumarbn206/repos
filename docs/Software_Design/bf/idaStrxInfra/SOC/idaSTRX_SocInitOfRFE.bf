
// BOOTLOADER or Debugger Access starts

//1. Wait for TCM initialization finished => FUNCTIONAL: BOOTLOADER AND CMM
// Check status of MEMSTS.xDONE are 111 (RFE-M7 TCM init done bits. On reset, RFE M7 TCM are initialized to 0 by HW) (Address 0x4441_0068 bit [2:0] should be 111).
//CPU_CTRL_RFE_CREG.MEMSTS = 0x4441_0000 + 0x068
sleep_bv(CPU_CTRL_RFE_CREG.MEMSTS.D0DONE == 'h1);
sleep_bv(CPU_CTRL_RFE_CREG.MEMSTS.D1DONE == 'h1);
sleep_bv(CPU_CTRL_RFE_CREG.MEMSTS.ITDONE == 'h1);

//2. RFE-M7 Clock Enable (this is not release from reset!) => FUNCTIONAL: BOOTLOADER AND CMM
//Enable the RFE M7 core partition (refer to section Partition Processes under MC_ME chapter) RFE CM7 is mapped to partition 0 and core 1.
//Core clock enable from MC_ME
//MC_ME.PRTN0_CORE1_PCONF addr = 0x400D_0000 + 0x160
MC_ME.PRTN0_CORE1_PCONF.CCE = 0x1;

//3. Load RFE-M7 => FUNCTIONAL: BOOTLOADER AND CMM
// Load RFE M7 TCM memories (Refer "RFE M7 I/D-TCM Backdoor" addressed in the attached memory map sheet)
// ITCM backdoor access Address -> 2030_0000 - 2031_FFFF
// DTCM backdoor access Address -> 2038_0000 - 2038_7FFF

//4. Program the SPI external IO => NOT FUNCTIONAL (DEBUG): CMM AND MINMAL VALIDATION APP
// W32((*(vuint32_t*) (0x40100000 + 0x240)), 0x9F000);//pad[0] SPI_MOSI
// W32((*(vuint32_t*) (0x40100000 + 0xA84)), 0x1);//pad[0] SPI_MOSI
// W32((*(vuint32_t*) (0x40100000 + 0x244)), 0x29F801);//pad[1] SPI_SCLK
// W32((*(vuint32_t*) (0x40100000 + 0xA88)), 0x1);//pad[1] SPI_SCLK
// W32((*(vuint32_t*) (0x40100000 + 0x248)), 0x29F801);//pad[2] SPI_SS_N
// W32((*(vuint32_t*) (0x40100000 + 0xA8C)), 0x1);//pad[2] SPI_SS_N
// W32((*(vuint32_t*) (0x40100000 + 0x24C)), 0x200803);//pad[3] SPI_MISO
// SIUL2.MSCR0 = + 240h + (a * 4h)
//SIUL2.MSCR0.
(*(vuint32_t*) (0x40100000 + 0x240)) = 0x9F000;
(*(vuint32_t*) (0x40100000 + 0xA84)) = 0x1;
(*(vuint32_t*) (0x40100000 + 0x244)) = 0x29F801;
(*(vuint32_t*) (0x40100000 + 0xA88)) = 0x1;
(*(vuint32_t*) (0x40100000 + 0x248)) = 0x29F801;
(*(vuint32_t*) (0x40100000 + 0xA8C)) = 0x1;
(*(vuint32_t*) (0x40100000 + 0x24C)) = 0x200803;

//5. UART PINS => NOT FUNCTIONAL (DEBUG): CMM AND MINMAL VALIDATION APP
// LPUART 
// register sequence will come
//RFE UART pinmux
W32((*(vuint32_t*) (0x40100000 + 0x260)), 0x200801);//pad[8]
W32((*(vuint32_t*) (0x40100000 + 0x264)), 0x80001);//pad[9]
W32((*(vuint32_t*) (0x40100000 + 0xACC)), 0x1);//pad[9]

//6. RFE GPIO PINS  => NOT FUNCTIONAL (DEBUG): CMM AND MINMAL VALIDATION APP
// register sequence will come

Configure PAD as outputs
//W32((*(vuint32_t*) (0x40100000 + 0x254)), 0x200007);//pad[5] o/p 
//W32((*(vuint32_t*) (0x40100000 + 0x270)), 0x200007);//pad [12] o/p
//W32((*(vuint32_t*) (0x40100000 + 0x274)), 0x200007);//pad [13] o/p
//W32((*(vuint32_t*) (0x40100000 + 0x278)), 0x200007);//pad [14] o/p
//W32((*(vuint32_t*) (0x40100000 + 0x27C)), 0x200007);//pad [15] o/p
//W32((*(vuint32_t*) (0x40100000 + 0x288)), 0x200007);//pad [18] o/p
//W32((*(vuint32_t*) (0x40100000 + 0x28C)), 0x200007);//pad [19] o/p
//W32((*(vuint32_t*) (0x40100000 + 0x290)), 0x200007);//pad [20] o/p
//W32((*(vuint32_t*) (0x40100000 + 0x258 )),0x200001 );//pad [6] o/p
//W32((*(vuint32_t*) (0x40100000 + 0x25C )),0x200001 );//pad [7] o/p

(*(vuint32_t*) (0x40100000 + 0x254)) = 0x200007;
(*(vuint32_t*) (0x40100000 + 0x270)) = 0x200007;
(*(vuint32_t*) (0x40100000 + 0x274)) = 0x200007;
(*(vuint32_t*) (0x40100000 + 0x278)) = 0x200007;
(*(vuint32_t*) (0x40100000 + 0x27C)) = 0x200007;
(*(vuint32_t*) (0x40100000 + 0x288)) = 0x200007;
(*(vuint32_t*) (0x40100000 + 0x28C)) = 0x200007;
(*(vuint32_t*) (0x40100000 + 0x290)) = 0x200007;
//(*(vuint32_t*) (0x40100000 + 0x258)) = 0x200001;  //chirpstart_out
//(*(vuint32_t*) (0x40100000 + 0x25C)) = 0x200001;  //chirpstart_out

//source select MMW debug out
//W32(VPTR(ADDRESS_IDA_RFE_ACCESS_CSR_RFE_ACCESS_CSR_DEBUG_RFE_IO_CTRL), 0x11111111)
//RFE_ACCESS_CSR.DEBUG_RFE_IO_CTRL address = 0x4444_8000h + 0x018 = 0x11111111;

RFE_ACCESS_CSR.DEBUG_RFE_IO_CTRL.IO_CTRL7 =0x1;
RFE_ACCESS_CSR.DEBUG_RFE_IO_CTRL.IO_CTRL6 =0x1;
RFE_ACCESS_CSR.DEBUG_RFE_IO_CTRL.IO_CTRL5 =0x1;
RFE_ACCESS_CSR.DEBUG_RFE_IO_CTRL.IO_CTRL4 =0x1;
RFE_ACCESS_CSR.DEBUG_RFE_IO_CTRL.IO_CTRL3 =0x1;
RFE_ACCESS_CSR.DEBUG_RFE_IO_CTRL.IO_CTRL2 =0x1;
RFE_ACCESS_CSR.DEBUG_RFE_IO_CTRL.IO_CTRL1 =0x1;
RFE_ACCESS_CSR.DEBUG_RFE_IO_CTRL.IO_CTRL0 =0x1;

//7. Release RFE-M7 => FUNCTIONAL: BOOTLOADER AND CMM
//Write '0' to bit RFE_ACCESS_CSR.RFE_M7_CTL.CPUWAIT (0x4444_8010 bit 0) to release the CPUWAIT of RFE_M7.
//RFE_ACCESS_CSR.RFE_M7_CTL.address = 0x4444_8000 + 0x010
RFE_ACCESS_CSR.RFE_M7_CTL.CPUWAIT. = 'b0;

// BOOTLOADER or Debugger Access ends

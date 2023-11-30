//STEP 15:
//Enable the divided clock (160) and not max freq (320)
//W32(RFE_CGM_DIV(0), RFE_CGM_DIV_VAL(3));
//MC_CGM.MUX_0_DC_0 address = 0x44408000 + 0x308


MC_CGM.MUX_0_DC_0.DIV = 0x3; // divide by 4 => 160MHz
MC_CGM.MUX_0_DC_0.DE = 0x1; //(div enable)

//MC_CGM.MUX_0_CSC address = 0x44408000 + 0x300
MC_CGM.MUX_0_CSC.SELCTL = 0x1;
MC_CGM.MUX_0_CSC.CLK_SW = 0x1; //?

//MC_CGM.MUX_0_CSS address = 0x44408000 + 0x304
sleep_bv(MC_CGM.MUX_0_CSS.SWTRG == 'h1);
sleep_bv(MC_CGM.MUX_0_CSS.SWIP == 'h0);
sleep_bv(MC_CGM.MUX_0_CSS.CLK_SW == 'h1);


//RFE PLL clock switch for external SPI access
//W32(RFE_CGM_SRC(1), RFE_CGM_SRC_VAL(RFE_PLL));
//WAIT_RE32(RFE_CGM_SRC_STAT(1), RFE_CGM_SRC_STAT_VAL(RFE_PLL), 10);

//MC_CGM.MUX_1_DC_0 address = 0x44408000 + 0x348
MC_CGM.MUX_1_DC_0.DIV = 0x3; //
MC_CGM.MUX_1_DC_0.DE = 0x1; //

//MC_CGM.MUX_1_CSC address = 0x44408000 + 0x340
MC_CGM.MUX_1_CSC.SELCTL = 0x1;
MC_CGM.MUX_1_CSC.CLK_SW = 0x1; //?

//MC_CGM.MUX_1_CSS address = 0x44408000 + 0x344
sleep_bv(MC_CGM.MUX_1_CSS.SWTRG == 'h1);
sleep_bv(MC_CGM.MUX_1_CSS.SWIP == 'h0);
sleep_bv(MC_CGM.MUX_1_CSS.CLK_SW == 'h1);

//RFE PLL clock switch for core and peripherals
//W32(RFE_CGM_SRC(0), RFE_CGM_SRC_VAL(RFE_PLL));
//WAIT_RE32(RFE_CGM_SRC_STAT(0), RFE_CGM_SRC_STAT_VAL(RFE_PLL), 10);

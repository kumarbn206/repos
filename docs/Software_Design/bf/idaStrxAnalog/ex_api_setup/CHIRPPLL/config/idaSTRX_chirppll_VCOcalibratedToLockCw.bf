/* idaSTRX_chirppll_VCOcalibratedToLockCw.bf */
// enable MMD

// step 9: Start refence divider (640 MHz)
CHIRPPLL.ANA_PDCP_CTL.REFDIV_PGM=0;
CHIRPPLL.ANA_PDCP_CTL.REFDIV_EN=1;
CHIRPPLL.CHIRP_CTRL.TDC_START=1; // Start TDC when ref divider is enabled
sleep(1);
CHIRPPLL.CHIRP_CTRL.CLK_SEL=1; 	//Switch to PllDiv16Clk

// Step 16:enable MMD and sigma delta modulator
CHIRPPLL.ANA_PDCP_CTL.MMD_EN=1;  	 	
CHIRPPLL.ANA_PDCP_CTL.MMD_EN_PD_OUT=1;
CHIRPPLL.DIVIDE_FORCE_CTL.FORCE_DIVIDER=0; // release sdm divider force

// Step 16:enable CP
CHIRPPLL.ANA_PDCP_CTL.MMD_RX_EN=1; 	
CHIRPPLL.ANA_CP_CTL.CP_EN=1;

// Step 14: release force vtune	and calibration DAC      
CHIRPPLL.ANA_LPF_CTL5.LPF_FORCE_VTUNE_EN=0;
CHIRPPLL.ANA_LPF_CTL5.LPF_EN_VTUNE_VOLTAGE=0;

// PLL is locked or at least it should be; Time to enabled Tracking opamp
CHIRPPLL.ANA_LPF_CTL5.LPF_TRK_OPAMP_EN=1;

// Enable Functional Safety
CHIRPPLL.ANA_VCO_CTL3.LEVEL_VCO_MAX=51; // consider to move to OTP
CHIRPPLL.ANA_VCO_CTL3.LEVEL_VCO_MIN=32; // consider to move to OTP
CHIRPPLL.ANA_VCO_CTL3.LEVEL_VCO_HIGH=48; // consider to move to OTP
CHIRPPLL.ANA_VCO_CTL3.LEVEL_VCO_LOW=33; // consider to move to OTP
CHIRPPLL.ANA_LPF_CTL5.LPF_VTUNE_MONITOR_EN=1;
CHIRPPLL.ANA_MISC_CTL.UNLOCK_DET_EN=1;




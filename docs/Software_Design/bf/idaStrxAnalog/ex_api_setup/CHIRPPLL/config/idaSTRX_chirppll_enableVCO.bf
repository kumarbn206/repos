/* idaSTRX_chirppll_enableVCO.bf */

// Precondindition is thet both VCO and RMS sel are configured in digital and available at the sub-Ip pin (profile load is needed)
// 1) Force Vtune   
CHIRPPLL.ANA_LPF_CTL5.LPF_BIASMIRROR_EN=1;			// enable Bias for CAL DAC
CHIRPPLL.ANA_LPF_CTL5.LPF_EN_VTUNE_VOLTAGE=0;		// set calDAC, note value is buggy in model
CHIRPPLL.ANA_LPF_CTL5.LPF_FORCE_VTUNE_EN=1;			// 
CHIRPPLL.ANA_LPF_CTL5.LPF_PROG_FORCE_VOLTAGE=62;	// model: 62 -> 1.05 V
sleep(30);

// 2) Enable VCOBias 
CHIRPPLL.ANA_VCO_CTL1.R_IBIAS_SET=14;				// Configure bias of resistor
CHIRPPLL.PON_CTL.VCO_BIAS_SPEEDUP=1;				// enable speed up of bias

// 3) : wait for bias enable/current settling
sleep(20);

// 5) enable RMS det
CHIRPPLL.ANA_RMSDET_CTL.RMS_MEAS_IN_OUT=1;
CHIRPPLL.ANA_RMSDET_CTL.RMS_EN=1;

// 11)  enable VCO 
CHIRPPLL.ANA_PDCP_CTL.MMD_EN_PD_OUT=0;				// keep MMD pd out disabled  
CHIRPPLL.ANA_VCO_CTL1.VCO_EN=1;						// enable VCO

CHIRPPLL.ANA_VCO_CTL1.VCO_DRIVER_MMD_EN=1;			// enable driver for caldiv (shared with MMDdriver)
CHIRPPLL.ANA_VCO_CTL1.VCO_DRIVER_LOI_EN=1;			// to consider to move later 
CHIRPPLL.ANA_VCO_CTL1.VCO_AMP_MONITOR_EN=1;			// enable amplitudeDet
sleep(10);

// 6) enable VCO divided frequency to digoutput
CHIRPPLL.ANA_MISC_CTL.SEL_FREQ_CTR_CLK=1;			// set frequency counter clock to vco_div16 (1 or 3)
CHIRPPLL.ANA_PDCP_CTL.DIV16_EN=1;					// enable caldiv by 16

//VCO is now ready to perform AAFC


    


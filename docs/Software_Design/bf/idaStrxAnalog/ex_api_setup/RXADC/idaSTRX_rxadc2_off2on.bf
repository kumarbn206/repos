/* idaSTRX_rxadc2_off2on.bf  */
	

// Note: after powerup, the RXADC needs to be enabled completely, not to a standby mode, but to an ON mode 
// since there is no option to only enable the LDOs without automatically enabling the subIPs.
// Once the LDOs are enabled, current starts being drawn.

RXADC2.PON_CTL.PON_LS=1;        // Enable level shifters - analog pin = pon_ls
RXADC2.PON_CTL.EN_IREF=1;       // Enable current mirror - analog pin = enable_iref_mirror
sleep(5);
RXADC2.CLK_LDO_CTL.LDO_EN_I=1;  //  Enable clock generator LDO, I ADC (provides clock to all the blocks) - analog pin = en_ldo_clk_i
RXADC2.CLK_LDO_CTL.LDO_EN_Q=1;  // Enable clock generator LDO, Q ADC (provides clock to all the blocks) - analog pin = en_ldo_clk_q
sleep(5);
RXADC2.DAC_SERLDO_CTL.LDO_EN_I=1; // Enable DAC series LDO, I ADC (enables clock buffering inside the DAC) - analog pin = en_series_ldo_DAC_i
RXADC2.DAC_SERLDO_CTL.LDO_EN_Q=1; // Enable DAC series LDO, Q ADC - analog pin = en_series_ldo_DAC_q
RXADC2.Q_LDO_CTL.LDO_EN_I=1;      // Enable quantizer LDO, I ADC (enables clock buffering inside the DAC to the DMUX) - analog pin = en_ldo_Q_i
RXADC2.Q_LDO_CTL.LDO_EN_Q=1;      // Enable quantizer LDO, Q ADC - analog pin = en_ldo_Q_q
sleep(5);
RXADC2.DMUX_LDO_CTL.EN_LDO=1;     // Enable DMUX LDO - analog pin = en_ldo_DMUX
RXADC2.DIV_LDO_CTL.LDO_EN_I=1;    // Enable clock divider LDO, I ADC - analog pin = en_ldo_div_i
RXADC2.DIV_LDO_CTL.LDO_EN_Q=1;    // Enable clock divider LDO, Q ADC - analog pin = en_ldo_div_q
RXADC2.LF_LDO_CTL.LDO_EN_LF_I=1;  // Enable loop filter LDO, I ADC - analog pin = en_ldo_LF_i
RXADC2.LF_LDO_CTL.LDO_EN_LF_Q=1;  // Enable loop filter LDO, Q ADC - analog pin = en_ldo_LF_q
RXADC2.LF_LDO_CTL.LDO_EN_CAP_I=1; // Enable loop filter capbank LDO, I ADC - analog pin = en_ldo_capbank_i - disconnected, as per artf894079
RXADC2.LF_LDO_CTL.LDO_EN_CAP_Q=1; // Enable loop filter capbank LDO, Q ADC - analog pin = en_ldo_capbank_q - disconnected, as per artf894079
RXADC2.DAC_SHLDO_CTL.LDO_EN_I=1;  // Enable DAC shunt LDO, I ADC - analog pin = en_ldo_DAC_i
RXADC2.DAC_SHLDO_CTL.LDO_EN_Q=1;  // Enable DAC shunt LDO, Q ADC - analog pin = en_ldo_DAC_q
sleep(10);
RXADC2.DMUX_CTL.RST_SYNC=1;             // Release reset for DMUX synchronization - analog pin = RST_sync
RXADC2.Q_CTL.EN_CMP_I=1;                // Enable quantizer comparator, I ADC - analog pin = en_cmp_i
RXADC2.Q_CTL.EN_CMP_Q=1;                // Enable quantizer comparator, Q ADC - analog pin = en_cmp_q
RXADC2.DITHER_GEN_CTL_I.PRBS_EN1=1;     // Enable PRBS generator for dither, I ADC - analog pin = prbs_en1_i
RXADC2.DITHER_GEN_CTL_Q.PRBS_EN1=1;     // Enable PRBS generator for dither, Q ADC - analog pin = prbs_en1_q
RXADC2.DITHER_GEN_CTL_I.RST_ASYNC_AN=1; // Reset PRBS generator for dither, I ADC - analog pin = prbs_rst_async_an_i
RXADC2.DITHER_GEN_CTL_Q.RST_ASYNC_AN=1; // Reset PRBS generator for dither, Q ADC - analog pin = prbs_rst_async_an_q
RXADC2.DYN_DIT_CTL_I.PON_DETECTOR=1;    // Enable dynamic dithering detector, I ADC - analog pin = pon_dyn_dit_det_i
RXADC2.DYN_DIT_CTL_Q.PON_DETECTOR=1;    // Enable dynamic dithering detector, Q ADC - analog pin = pon_dyn_dit_det_q
RXADC2.OV_DET_CTL_I.EN_CMP=1;           // Enable overload detector comparators, I ADC - analog pin = en_overload_det_cmp_i
RXADC2.OV_DET_CTL_Q.EN_CMP=1;           // Enable overload detector comparators, Q ADC - analog pin = en_overload_det_cmp_q
RXADC2.OV_DET_CTL_I.PON_OVERLOAD_DET=1; // Enable overload detector clock and counter logic, I ADC - analog pin = pon_overload_det_i
RXADC2.OV_DET_CTL_Q.PON_OVERLOAD_DET=1; // Enable overload detector clock and counter logic, Q ADC - analog pin = pon_overload_det_q
RXADC2.OV_DET_CTL_I.EN_OV_RESET_INT=0;  // Disable internal reset of overload detector flag (reset comes from PDC, allows counting number of events), I ADC - analog pin = overload_flag_reset_from_pdc_i
RXADC2.OV_DET_CTL_Q.EN_OV_RESET_INT=0;  // Disable internal reset of overload detector flag (reset comes from PDC, allows counting number of events), Q ADC - analog pin = overload_flag_reset_from_pdc_q
RXADC2.CLK_CTL_I.EN_CHOP_CLK=1;         // Enable chopping clock, I ADC - analog pin = en_chop_clk_i
RXADC2.CLK_CTL_Q.EN_CHOP_CLK=1;         // Enable chopping clock, Q ADC - analog pin = en_chop_clk_q
RXADC2.CLK_CTL_I.CTL_CHOP_FREQ=3;       // Set chopping clock frequency to 2.56GHz, I ADC - analog pin = ctl_chop_freq_i
RXADC2.CLK_CTL_Q.CTL_CHOP_FREQ=3;       // Set chopping clock frequency to 2.56GHz, Q ADC - analog pin = ctl_chop_freq_q
RXADC2.CLK_CTL_I.EN_DC_CORR=1;          // Enable duty cycle correction, I ADC - analog pin = en_dutycyle_corr_i
RXADC2.CLK_CTL_Q.EN_DC_CORR=1;          // Enable duty cycle correction, Q ADC - analog pin = en_dutycyle_corr_q
RXADC2.OV_DET_CTL_I.LF_RESET_EN=3;      // Enable reset of both biquad1 and biquad2, I ADC - analog pin = lf_reset_en_bq1_i, lf_reset_en_bq2_i
RXADC2.OV_DET_CTL_Q.LF_RESET_EN=3;      // Enable reset of both biquad1 and biquad2, I ADC - analog pin = lf_reset_en_bq1_q, lf_reset_en_bq2_q
//
// RCOSC_RES = result from RC calibration, as calculated in SW using the N and M values from the RCOSC.
// to be added for the SW init sequence:
//RXADC2.LF_LPF_CTL.CLPF_I=RCOSC_RES;    // Use capbank setting from RC calibration - analog pin = ctl_lpf_i
//RXADC2.LF_LPF_CTL.CLPF_Q=RCOSC_RES;    // Use capbank setting from RC calibration - analog pin = ctl_lpf_q
//RXADC2.LF_BQ1_FB_CTL.C1_I=RCOSC_RES;   // Use capbank setting from RC calibration - analog pin = ctl_bq1_C1_i
//RXADC2.LF_BQ1_FB_CTL.C2_I=RCOSC_RES;   // Use capbank setting from RC calibration - analog pin = ctl_bq1_C2_i
//RXADC2.LF_BQ1_FB_CTL.C1_Q=RCOSC_RES;   // Use capbank setting from RC calibration - analog pin = ctl_bq1_C1_q
//RXADC2.LF_BQ1_FB_CTL.C2_Q=RCOSC_RES;   // Use capbank setting from RC calibration - analog pin = ctl_bq1_C2_q
//RXADC2.LF_BQ2_FB_CTL.C1_I=RCOSC_RES;   // Use capbank setting from RC calibration - analog pin = ctl_bq2_C1_i
//RXADC2.LF_BQ2_FB_CTL.C2_I=RCOSC_RES;   // Use capbank setting from RC calibration - analog pin = ctl_bq2_C2_i
//RXADC2.LF_BQ2_FB_CTL.C1_Q=RCOSC_RES;   // Use capbank setting from RC calibration - analog pin = ctl_bq2_C1_q
//RXADC2.LF_BQ2_FB_CTL.C2_Q=RCOSC_RES;   // Use capbank setting from RC calibration - analog pin = ctl_bq2_C2_q
//RXADC2.LF_BQ2_IN1_CTL.CIN1_I=RCOSC_RES;   // Use capbank setting from RC calibration - analog pin = ctl_bq2_Cin1_i
//RXADC2.LF_BQ2_IN1_CTL.CX1_I=RCOSC_RES;    // Use capbank setting from RC calibration - analog pin = ctl_bq2_CX1_i
//RXADC2.LF_BQ2_IN1_CTL.CIN1_Q=RCOSC_RES;   // Use capbank setting from RC calibration - analog pin = ctl_bq2_Cin1_q
//RXADC2.LF_BQ2_IN1_CTL.CX1_Q=RCOSC_RES;    // Use capbank setting from RC calibration - analog pin = ctl_bq2_CX1_q
//RXADC2.LF_BQ2_IN2_CTL.CIN2_I=RCOSC_RES;   // Use capbank setting from RC calibration - analog pin = ctl_bq2_Cin2_i
//RXADC2.LF_BQ2_IN2_CTL.CX2_I=RCOSC_RES;    // Use capbank setting from RC calibration - analog pin = ctl_bq2_CX2_i
//RXADC2.LF_BQ2_IN2_CTL.CIN2_Q=RCOSC_RES;   // Use capbank setting from RC calibration - analog pin = ctl_bq2_Cin2_q
//RXADC2.LF_BQ2_IN2_CTL.CX2_Q=RCOSC_RES;    // Use capbank setting from RC calibration - analog pin = ctl_bq2_CX2_q

RXADC2.OV_DET_CTL_I.LF_RESET=1;    //  Apply reset pulse to loop filter, I ADC - analog pin = lf_reset_i
RXADC2.OV_DET_CTL_Q.LF_RESET=1;    // Apply reset pulse to loop filter, Q ADC - analog pin = lf_reset_q
sleep(1);
RXADC2.OV_DET_CTL_I.LF_RESET=0;    // Release reset pulse to loop filter, I ADC - analog pin = lf_reset_i
RXADC2.OV_DET_CTL_Q.LF_RESET=0;    // Release reset pulse to loop filter, Q ADC - analog pin = lf_reset_q

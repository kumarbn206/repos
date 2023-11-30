/* idaSTRX_rxadc2_stdby2off.bf  */
	

// Note: after powerup, the RXADC needs to be enabled completely, not to a standby mode, but to an ON mode 
// since there is no option to only enable the LDOs without automatically enabling the subIPs.
// Once the LDOs are enabled, current starts being drawn.
// When using the Timing Engine for dynamic controls, certain LDOs will be powered down in standby mode.
// When not using the Timing Engine, this can be done manually, as described below.
// LDOs that are dynamically controllable are: DAC_SHLDO (I and Q), LF_LDO (I and Q), DIV_LDO (I and Q)
// so, when in stabdby, these LDOs are already OFF, and do not need to be disabled.


RXADC2.Q_CTL.EN_CMP_I=0;                // Disable quantizer comparator, I ADC - analog pin = en_cmp_i
RXADC2.Q_CTL.EN_CMP_Q=0;                // Disable quantizer comparator, Q ADC - analog pin = en_cmp_q
RXADC2.DITHER_GEN_CTL_I.PRBS_EN1=0;     // Disable PRBS generator for dither, I ADC - analog pin = prbs_en1_i
RXADC2.DITHER_GEN_CTL_Q.PRBS_EN1=0;     // Disable PRBS generator for dither, Q ADC - analog pin = prbs_en1_q
RXADC2.DYN_DIT_CTL_I.PON_DETECTOR=0;    // Disable dynamic dithering detector, I ADC - analog pin = pon_dyn_dit_det_i
RXADC2.DYN_DIT_CTL_Q.PON_DETECTOR=0;    // Disable dynamic dithering detector, Q ADC - analog pin = pon_dyn_dit_det_q
RXADC2.OV_DET_CTL_I.EN_CMP=0;           // Disable overload detector comparators, I ADC - analog pin = en_overload_det_cmp_i
RXADC2.OV_DET_CTL_Q.EN_CMP=0;           // Disable overload detector comparators, Q ADC - analog pin = en_overload_det_cmp_q
RXADC2.OV_DET_CTL_I.PON_OVERLOAD_DET=0; // Disable dynamic dithering detector, I ADC - analog pin = pon_dyn_dit_det_i
RXADC2.OV_DET_CTL_Q.PON_OVERLOAD_DET=0; // Disable dynamic dithering detector, Q ADC - analog pin = pon_dyn_dit_det_q
RXADC2.OV_DET_CTL_I.EN_OV_RESET_INT=1;  // Back to the reset value: overload counter is reset internally
RXADC2.OV_DET_CTL_Q.EN_OV_RESET_INT=1;  // Back to the reset value: overload counter is reset internally
RXADC2.CLK_CTL_I.EN_CHOP_CLK=0;         // Disable chopping clock, I ADC - analog pin = en_chop_clk_i
RXADC2.CLK_CTL_Q.EN_CHOP_CLK=0;         // Disable chopping clock, Q ADC - analog pin = en_chop_clk_q
RXADC2.CLK_CTL_I.CTL_CHOP_FREQ=0;       // Back to the reset value: 320MHz
RXADC2.CLK_CTL_Q.CTL_CHOP_FREQ=0;       // Back to the reset value: 320MHz
RXADC2.CLK_CTL_I.EN_DC_CORR=0;          // Disable duty cycle correction, I ADC - analog pin = en_dutycyle_corr_i
RXADC2.CLK_CTL_Q.EN_DC_CORR=0;          // Disable duty cycle correction, Q ADC - analog pin = en_dutycyle_corr_q
RXADC2.OV_DET_CTL_I.LF_RESET_EN=0;      // Back to the reset value: no reset
RXADC2.OV_DET_CTL_Q.LF_RESET_EN=0;      // Back to the reset value: no reset

RXADC2.DMUX_CTL.RST_SYNC=0;             // ACTIVE_LOW reset enabled - analog pin = RST_sync

RXADC2.CLK_LDO_CTL.LDO_EN_I=0;    // Disable clock generator LDO, I ADC (provides clock to all the blocks) - analog pin = en_ldo_clk_i
RXADC2.CLK_LDO_CTL.LDO_EN_Q=0;    // Disable clock generator LDO, Q ADC (provides clock to all the blocks) - analog pin = en_ldo_clk_q
RXADC2.DAC_SERLDO_CTL.LDO_EN_I=0; // Disable DAC series LDO, I ADC (Disables clock buffering inside the DAC) - analog pin = en_series_ldo_DAC_i
RXADC2.DAC_SERLDO_CTL.LDO_EN_Q=0; // Disable DAC series LDO, Q ADC - analog pin = en_series_ldo_DAC_q
sleep(5);
RXADC2.Q_LDO_CTL.LDO_EN_I=0;      // Disable quantizer LDO, I ADC (Disables clock buffering inside the DAC to the DMUX) - analog pin = en_ldo_Q_i
RXADC2.Q_LDO_CTL.LDO_EN_Q=0;      // Disable quantizer LDO, Q ADC - analog pin = en_ldo_Q_q
RXADC2.DMUX_LDO_CTL.EN_LDO=0;     // Disable DMUX LDO - analog pin = en_ldo_DMUX
RXADC2.DIV_LDO_CTL.LDO_EN_I=0;    // Disable clock divider LDO, I ADC - analog pin = en_ldo_div_i
RXADC2.DIV_LDO_CTL.LDO_EN_Q=0;    // Disable clock divider LDO, Q ADC - analog pin = en_ldo_div_q
RXADC2.PON_CTL.EN_IREF=0;         // Disable current mirror - analog pin = Disable_iref_mirror
RXADC2.PON_CTL.PON_LS=0;          // Disable level shifters - analog pin = pon_ls

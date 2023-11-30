/* idaSTRX_rxadc2_stdby2on.bf  */
	

// Note: after powerup, the RXADC needs to be enabled completely, not to a standby mode, but to an ON mode 
// since there is no option to only enable the LDOs without automatically enabling the subIPs.
// Once the LDOs are enabled, current starts being drawn.
// When using the Timing Engine for dynamic controls, certain LDOs will be powered down in standby mode.
// When not using the Timing Engine, this can be done manually, as described below.
// LDOs that are dynamically controllable are: DAC_SHLDO (I and Q), LF_LDO (I and Q), DIV_LDO (I and Q)
// LDOs that will remain ON are: DAC_SERLDO (I and Q), Q_LDO (quantizer, I and Q), CLK_LDO (I and Q), DMUX_LDO
// when re-enabling the LDOs, we need a pulse of at least 1microsec on the BW controls, to ensure the LDOs can settle fast enough


RXADC2.DIV_LDO_CTL.LDO_EN_I=1;    // Enable clock divider LDO, I ADC - analog pin = en_ldo_div_i
RXADC2.DIV_LDO_CTL.LDO_EN_Q=1;    // Enable clock divider LDO, Q ADC - analog pin = en_ldo_div_q
RXADC2.DIV_LDO_CTL.LDO_BW_I=1;    // enable the fast-startup for the LDO. Pulse of 1us is needed
RXADC2.DIV_LDO_CTL.LDO_BW_Q=1;    // enable the fast-startup for the LDO. Pulse of 1us is needed
RXADC2.LF_LDO_CTL.LDO_EN_LF_I=1;  // Enable loop filter LDO, I ADC - analog pin = en_ldo_LF_i
RXADC2.LF_LDO_CTL.LDO_EN_LF_Q=1;  // Enable loop filter LDO, Q ADC - analog pin = en_ldo_LF_q
RXADC2.LF_LDO_CTL.LDO_BW_LF_I=1;  // enable the fast-startup for the LDO. Pulse of 1us is needed
RXADC2.LF_LDO_CTL.LDO_BW_LF_Q=1;  // enable the fast-startup for the LDO. Pulse of 1us is needed
RXADC2.DAC_SHLDO_CTL.LDO_EN_I=1;  // Enable DAC shunt LDO, I ADC - analog pin = en_ldo_DAC_i
RXADC2.DAC_SHLDO_CTL.LDO_EN_Q=1;  // Enable DAC shunt LDO, Q ADC - analog pin = en_ldo_DAC_q
RXADC2.DAC_SHLDO_CTL.LDO_BW_I=1;  // enable the fast-startup for the LDO. Pulse of 1us is needed
RXADC2.DAC_SHLDO_CTL.LDO_BW_Q=1;  // enable the fast-startup for the LDO. Pulse of 1us is needed
RXADC2.OV_DET_CTL_I.LF_RESET=1;   // Apply reset pulse to loop filter, I ADC - analog pin = lf_reset_i
RXADC2.OV_DET_CTL_Q.LF_RESET=1;   // Apply reset pulse to loop filter, Q ADC - analog pin = lf_reset_q
sleep(1);
RXADC2.DIV_LDO_CTL.LDO_BW_I=1;    // disable the BW setting, to get the low-noise LDO behaviour
RXADC2.DIV_LDO_CTL.LDO_BW_Q=1;    // disable the BW setting, to get the low-noise LDO behaviour
RXADC2.LF_LDO_CTL.LDO_BW_LF_I=1;  // disable the BW setting, to get the low-noise LDO behaviour
RXADC2.LF_LDO_CTL.LDO_BW_LF_Q=1;  // disable the BW setting, to get the low-noise LDO behaviour
RXADC2.DAC_SHLDO_CTL.LDO_BW_I=1;  // disable the BW setting, to get the low-noise LDO behaviour
RXADC2.DAC_SHLDO_CTL.LDO_BW_Q=1;  // disable the BW setting, to get the low-noise LDO behaviour
RXADC2.OV_DET_CTL_I.LF_RESET=0;   // Release reset pulse to loop filter, I ADC - analog pin = lf_reset_i
RXADC2.OV_DET_CTL_Q.LF_RESET=0;   // Release reset pulse to loop filter, Q ADC - analog pin = lf_reset_q



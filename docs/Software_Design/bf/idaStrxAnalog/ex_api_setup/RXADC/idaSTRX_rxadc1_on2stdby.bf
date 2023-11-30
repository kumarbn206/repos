/* idaSTRX_rxadc1_on2stdby.bf  */
	

// Note: after powerup, the RXADC needs to be enabled completely, not to a standby mode, but to an ON mode 
// since there is no option to only enable the LDOs without automatically enabling the subIPs.
// Once the LDOs are enabled, current starts being drawn.
// When using the Timing Engine for dynamic controls, certain LDOs will be powered down in standby mode.
// When not using the Timing Engine, this can be done manually, as described below.
// LDOs that are dynamically controllable are: DAC_SHLDO (I and Q), LF_LDO (I and Q), DIV_LDO (I and Q)
// LDOs that will remain ON are: DAC_SERLDO (I and Q), Q_LDO (quantizer, I and Q), CLK_LDO (I and Q), DMUX_LDO


RXADC1.DIV_LDO_CTL.LDO_EN_I=0;    // Disable clock divider LDO, I ADC - analog pin = en_ldo_div_i
RXADC1.DIV_LDO_CTL.LDO_EN_Q=0;    // Disable clock divider LDO, Q ADC - analog pin = en_ldo_div_q
RXADC1.LF_LDO_CTL.LDO_EN_LF_I=0;  // Disable loop filter LDO, I ADC - analog pin = en_ldo_LF_i
RXADC1.LF_LDO_CTL.LDO_EN_LF_Q=0;  // Disable loop filter LDO, Q ADC - analog pin = en_ldo_LF_q
RXADC1.DAC_SHLDO_CTL.LDO_EN_I=0;  // Disable DAC shunt LDO, I ADC - analog pin = en_ldo_DAC_i
RXADC1.DAC_SHLDO_CTL.LDO_EN_Q=0;  // Disable DAC shunt LDO, Q ADC - analog pin = en_ldo_DAC_q

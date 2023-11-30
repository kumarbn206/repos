/* idaSTRX_lldopdc_off2stdby.bf */

#include ./idaSTRX_lldopdc_OTPchange.bf  

LLDOPDC.PON_CTL.PON_LS=1;                  // Enable level-shifters - analog pin = pon_ls

// Ensure that the LLDOPDC1 & 2 are not in bypass mode
// LLDOPDC.LLDO_BYPASS.LDO_PDC1_BYP = 0;       // LLDO-PDC1 is not in bypass mode
// LLDOPDC.LLDO_BYPASS.LDO_PDC2_BYP = 0;       // LLDO-PDC2 is not in bypass mode

LLDOPDC.LDO_PDC_CTL_1.BYP_ACT_RC=1;             // Bypass the LLDOPDC1 low-noise bypass filter to reduce settling time
LLDOPDC.LDO_PDC_CTL_2.BYP_ACT_RC=1;             // Bypass the LLDOPDC2 low-noise bypass filter to reduce settling time

// Gbias must be trimmed before these bits are set
LLDOPDC.PON_CTL.BIAS_OK_1=1; // LDO PDC 1 bias current from Gbias is OK
LLDOPDC.PON_CTL.BIAS_OK_2=1; // LDO PDC 2 bias current from Gbias is OK

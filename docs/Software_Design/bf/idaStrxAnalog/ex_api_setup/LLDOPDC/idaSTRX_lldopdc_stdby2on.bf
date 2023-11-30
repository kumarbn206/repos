//sleep (5); // wait for minimum 5us after BIAS_OK =1

LLDOPDC.PON_CTL.LDO_EN_1 = 1; //enable LLDO-PDC 1
LLDOPDC.PON_CTL.LDO_EN_2 = 1; //enable LLDO-PDC 2
sleep(20);  //wait for 20us before entering the low-noise mode
LLDOPDC.LDO_PDC_CTL_1.BYP_ACT_RC=0;             // Remove the bypass of the LLDOPDC1 low-noise bypass filter to reduce settling time
LLDOPDC.LDO_PDC_CTL_2.BYP_ACT_RC=0;             // Remove the bypass of the LLDOPDC2 low-noise bypass filter to reduce settling time

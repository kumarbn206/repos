/* idaSTRX_gldo_stdby2on.bf */

// Note: the GLDO is self-starting 
// this means that after boot, it is already in STANDBY state.
// GLDO digital is a self-start up IP, that does not require initialization and is automatically enabled during power-up.
// However, the following steps are neccessary after power-up, to meet specified requirements.

GLDO.PON_CTL.PON_LS=1;                  // Enable level-shifters - analog pin = pon_ls
//enable BG RC-filter bypass mode to reduce the settling time
GLDO.BG_CTL.BG_RES_GLD1V45 = 1;  //Bypass of GLDO1v4 BG
GLDO.BG_CTL.BG_RES_GLD1V3 = 1;   //Bypass of GLDO1v3 BG
GLDO.BG_CTL.BG_RES_HLD1V8 = 1;   //Bypass of HVLDO1V8 BG 
GLDO.BG_CTL.BG_RES_OVUV = 1;   //Bypass of OVUV BG 

// #include ./idaSTRX_gldo_OTPchange.bf     // Initialize the registers from the OTP
                                            // As agreed with Artur: This will be done at toplevel

GLDO.PON_CTL.ENA_GLD1V3=1;              // Optional: enables the gldo1v3 that supplies the TX

sleep(170); 
GLDO.BG_CTL.BG_RES_GLD1V45 = 0;  //Disable bypass of GLDO1v4 BG
GLDO.BG_CTL.BG_RES_GLD1V3 = 0;   //Disable bypass of GLDO1v3 BG
GLDO.BG_CTL.BG_RES_HLD1V8 = 0;   //Disable bypass of HVLDO1V8 BG 
GLDO.BG_CTL.BG_RES_OVUV = 0;   //Disable bypass of OVUV BG 
 //Change over-/undervoltage threshold from +/-10% of nominal voltage to +/-5%.
GLDO.OVUV_GLD1V45.PK_SEL_GLD1V45 = 2; 
GLDO.OVUV_GLD1V45.DIP_SEL_GLD1V45 = 2; 
GLDO.OVUV_GLD1V3.PK_SEL_GLD1V3 = 2; 
GLDO.OVUV_GLD1V3.DIP_SEL_GLD1V3 = 2; 
GLDO.OVUV_HLD1V8.PK_SEL_HLD1V8 = 2; 
GLDO.OVUV_HLD1V8.DIP_SEL_HLD1V8 = 2; 
GLDO.OVUV_PMIC1V8.PK_SEL_PMC1V8 = 2; 
GLDO.OVUV_PMIC1V8.DIP_SEL_PMC1V8 = 2; 
GLDO.GLD_HLD_PROG.DRV_CUR_GLD1V3 = 3;  //base current limiter increased after start-up
GLDO.GLD_HLD_PROG.DRV_CUR_GLD1V45 = 3; //base current limiter increased after start-up 

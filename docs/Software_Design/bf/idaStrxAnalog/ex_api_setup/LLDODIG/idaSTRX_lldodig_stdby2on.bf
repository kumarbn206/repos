/* idaSTRX_lldodig_stdby2on.bf */

// Note: the LLDODIG cannot be switched off.
// this means that after boot, it is already in STANDBY state.
// LLDO digital is a self-start up IP, that does not require initialization and is automatically enabled during power-up.
// However, the following steps are neccessary after power-up, to meet specified requirements.

//	

LLDODIG.PON_CTL.PON_LS=1;                  // Enable level-shifters - analog pin = pon_ls
LLDODIG.PON_CTL.LLDO_BP_FLT=1;             // Enable LLDO low-noise bypass filter to reduce settling time - analog pin = lldo_byp
LLDODIG.BG_OVUV_LLDO_CTL.BG_RES_LLDO=1; // Enable bandgap RC-filter bypass mode to reduce settling time - analog pin = byp_rc_bg_ovuv

// #include ./idaSTRX_lldodig_OTPchange.bf   // As agreed with Artur: This will be done at toplevel

// IMPORTANT: GBIAS trim values need to be loaded from OTP for LLDO digital reference currents before the following steps
// As agreed with Artur: GBIAS will be trimmed before LLDODIG is switched ON
		
sleep(20);				
LLDODIG.BG_OVUV_LLDO_CTL.BG_RES_LLDO=0;   // Disable bandgap RC-filter bypass mode to ensure low-noise performance
LLDODIG.PON_CTL.LLDO_BP_FLT=0;               // Disable LLDO low-noise bypass filter

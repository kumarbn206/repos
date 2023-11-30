/* idaSTRX_chirppll_enableAnaLS.bf */

// Before enabling the level shifter make sure that all the settings including the profile0 (default are loaded correctly).
TIMING_ENGINE.PROFILE_SEL_CW_MODE.USE_PROFILE_FOR_CW_MODE    = 0;  // use profile #0
TIMING_ENGINE.PROFILE_SEL_CW_MODE.SW_LD_PROFILE_FOR_CW_MODE  = 1;
TIMING_ENGINE.PROFILE_SEL_CW_MODE.EN_PROFILE_FOR_CW_MODE     = 1;

CHIRPPLL.PON_CTL.PON_LS_DANA                                 = 1; //Enable DigCore->AnaLS
CHIRPPLL.PON_CTL.PON_LS_ANA                                  = 1; //Enable RFE->AnaLS
sleep(10);



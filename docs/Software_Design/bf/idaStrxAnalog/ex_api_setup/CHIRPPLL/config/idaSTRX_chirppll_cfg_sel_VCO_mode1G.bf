
/* idaSTRX_chirppll_cfg_sel_VCO_mode1G.bf */

CHIRPPLL.P0_ANA_VCO_CTL1.VCO_SEL		= 1; // Selects VCO default: 1 --> 1G, 0 --> 4G
CHIRPPLL.ANA_RMSDET_CTL.RMS_SEL			= 1; // Selects RMS DET default: 1 --> 1G, 2 --> 4G

// TO check:
TIMING_ENGINE.PROFILE_SEL_CW_MODE.USE_PROFILE_FOR_CW_MODE	=0; //select profile 0
TIMING_ENGINE.PROFILE_SEL_CW_MODE.EN_PROFILE_FOR_CW_MODE	=1;
TIMING_ENGINE.PROFILE_SEL_CW_MODE.SW_LD_PROFILE_FOR_CW_MODE	=1;


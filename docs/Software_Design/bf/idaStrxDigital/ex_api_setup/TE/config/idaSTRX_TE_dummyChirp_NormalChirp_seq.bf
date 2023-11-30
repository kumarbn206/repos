include "../idaSTRX_TE_initRegisters.bf"
include "../idaSTRX_TE_dummy_Chirp_p0.bf"
TIMING_ENGINE.CHIRP_GLOBAL_CTL.CHIRP_PROFILE_SELECT=0x09;#Controls the profile to be used in the given sequence (dummy_chirp - Normal_chirp configuration)
include "../idaSTRX_TE_Chirp_enable.bf"
include "../idaSTRX_TE_int_triggerChirp.bf"

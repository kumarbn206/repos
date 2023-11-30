include "../idaSTRX_TE_initRegisters.bf"
include "../idaSTRX_TE_TX_TXN_EN_p0.bf"
include "../idaSTRX_TE_TX_TXN_EN_p1.bf"
include "../idaSTRX_TE_TX_TXN_EN_p2.bf"
include "../idaSTRX_TE_pr_phase_p0.bf"
include "../idaSTRX_TE_pr_phase_p1.bf"
include "../idaSTRX_TE_pr_phase_p2.bf"
TIMING_ENGINE.CHIRP_GLOBAL_CTL.CHIRP_PROFILE_SELECT=0x1f;#Controls the profile to be used in the given sequence (Profile_list entry selection)
TIMING_ENGINE.CHIRP_PROFILE_LIST.PROFILE_LIST_ENTRY_0=0x0;#Profile 0 entry
TIMING_ENGINE.CHIRP_PROFILE_LIST.PROFILE_LIST_ENTRY_1=0x1;#Profile 1 entry
TIMING_ENGINE.CHIRP_PROFILE_LIST.PROFILE_LIST_ENTRY_2=0x2;#Profile 2 entry
include "../idaSTRX_TE_Chirp_enable.bf"
include "../idaSTRX_TE_int_triggerChirp.bf"



include "../idaSTRX_TE_initRegisters.bf"
include "../idaSTRX_TE_TX_TXN_EN_p0.bf"
include "../idaSTRX_TE_TX_TXN_EN_p1.bf"
include "../idaSTRX_TE_TX_TXN_EN_p2.bf"
include "../idaSTRX_TE_pr_phase_p0.bf"
include "../idaSTRX_TE_pr_phase_p1.bf"
include "../idaSTRX_TE_pr_phase_p2.bf"
TIMING_ENGINE.CHIRP_GLOBAL_CTL.CHIRP_PROFILE_SELECT=0x0a;#Controls the profile to be used in the given sequence (Round-Robin 0-1-2-0 config)
include "../idaSTRX_TE_Chirp_enable.bf"
include "../idaSTRX_TE_int_triggerChirp.bf"



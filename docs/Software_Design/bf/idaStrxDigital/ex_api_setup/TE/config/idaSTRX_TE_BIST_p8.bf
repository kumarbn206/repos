include "../idaSTRX_TE_initRegisters.bf"
TIMING_ENGINE.BIST_CTRL_REG.BIST_ACTIVE_DP_EN=0x1; # Enable for BIST active data_packer assertion logic
TIMING_ENGINE.BIST_CTRL_REG.START_RXBIST_TRIG_EN=0x1; # Enable for start_rxbist assertion logic
TIMING_ENGINE.CHIRP_GLOBAL_CTL.CHIRP_PROFILE_SELECT=0x08; #Controls the profile to be used in the given sequence Profile 8 is configured for BIST
include "../idaSTRX_TE_Chirp_enable.bf"
include "../idaSTRX_TE_int_triggerChirp.bf"




include "../idaSTRX_TE_initRegisters.bf"
TIMING_ENGINE.TX_PR_CHIRP_CTL_MODES.TX1_PR_PHASE_CONTROL=0x1;# Control is configured to set TX phase change from DDMA
TIMING_ENGINE.TX_PR_CHIRP_CTL_MODES.TX2_PR_PHASE_CONTROL=0x1;# Control is configured to set TX phase change from DDMA
TIMING_ENGINE.TX_PR_CHIRP_CTL_MODES.TX3_PR_PHASE_CONTROL=0x1;# Control is configured to set TX phase change from DDMA
TIMING_ENGINE.TX_PR_CHIRP_CTL_MODES.TX4_PR_PHASE_CONTROL=0x1;# Control is configured to set TX phase change from DDMA
TIMING_ENGINE.TX_PR_CHIRP_CTL_MODES.DDMA_MODE_CONTROL=0x1; # Functional Mode configuration
include "../idaSTRX_TE_ddma_init_phase.bf"
include "../idaSTRX_TE_ddma_step_phase.bf"
TIMING_ENGINE.TX_PR_CHIRP_CTL_MODES.RESET_DDMA=0x1;#Reset/Reload the DDMA accumulator. The values after reset will be from register TX_PR_DDMA_INIT_PHASE (Init)
include "../idaSTRX_TE_Chirp_enable.bf"
include "../idaSTRX_TE_int_triggerChirp.bf"


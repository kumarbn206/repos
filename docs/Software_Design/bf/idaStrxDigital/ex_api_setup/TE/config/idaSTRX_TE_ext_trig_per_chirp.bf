include "../idaSTRX_TE_initRegisters.bf"
TIMING_ENGINE.CHIRP_TRIGGER_MODE_CTL.CHIRP_TRIGGER_MODE=0x3;# External Trigger Mode with trigger every chirp case (Triggered directly via chirpstart_in from TE interface)
#TIMING_ENGINE.CHIRP_TRIGGER_MODE_CTL.MCUINT_CHIRPSTART_PAD_OUT_FUNC_SEL=0x2; # can be configured to 0x1 to get the chirp_start_out
# Sequence interval timer should include idle time between trigger to trigger
#TIMING_ENGINE.CHIRP_SEQUENCE_INTERVAL.CHIRP_SEQUENCE_INTERVAL_TIMER=0x00003500;
#DDMA ext_trig control Case
#TIMING_ENGINE.TX_PR_CHIRP_CTL_MODES.TX1_PR_PHASE_CONTROL=0x1;
#TIMING_ENGINE.TX_PR_CHIRP_CTL_MODES.TX2_PR_PHASE_CONTROL=0x1;
#TIMING_ENGINE.TX_PR_CHIRP_CTL_MODES.TX3_PR_PHASE_CONTROL=0x1;
#TIMING_ENGINE.TX_PR_CHIRP_CTL_MODES.TX4_PR_PHASE_CONTROL=0x1;
#TIMING_ENGINE.TX_PR_CHIRP_CTL_MODES.DDMA_MODE_CONTROL=0x1;
#include "../idaSTRX_TE_ddma_init_phase.bf"
#include "../idaSTRX_TE_ddma_step_phase.bf"
#TIMING_ENGINE.TX_PR_CHIRP_CTL_MODES.RESET_DDMA=0x1;
include "../idaSTRX_TE_Chirp_enable.bf"



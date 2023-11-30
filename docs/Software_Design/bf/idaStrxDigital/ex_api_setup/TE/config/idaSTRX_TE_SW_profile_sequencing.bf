include "../idaSTRX_TE_initRegisters.bf"
include "../idaSTRX_TE_Interrupt.bf"
TIMING_ENGINE.CHIRP_GLOBAL_CTL.CHIRP_PROFILE_SELECT=0x1f; #Controls the profile to be used in the given sequence (Profile_list entry selection)
TIMING_ENGINE.CHIRP_PROFILE_LIST.PROFILE_LIST_ENTRY_0=0x7;# Profile 0 entry 
TIMING_ENGINE.CHIRP_PROFILE_LIST.PROFILE_LIST_ENTRY_1=0x6;# Profile 1 entry
include "../idaSTRX_TE_Chirp_enable.bf"
include "../idaSTRX_TE_int_triggerChirp.bf"
# 8 Chirps are set by default as reset value
sleep_bv(TIMING_ENGINE.TE_FUNC_INT_RAW_STATUS.TE_ACQ_END_INT_RAW_STATUS,0x1); # To detect to acquisition end of the chirp
TIMING_ENGINE.CHIRP_PROFILE_LIST.PROFILE_LIST_ENTRY_0=0x5; # SW dynamically load profile value for profile_list_entry_0
sleep_bv(TIMING_ENGINE.TE_FUNC_INT_RAW_STATUS.TE_ACQ_END_INT_RAW_STATUS,0x1); # To detect to acquisition end of the chirp
TIMING_ENGINE.CHIRP_PROFILE_LIST.PROFILE_LIST_ENTRY_1=0x4; # SW dynamically load profile value for profile_list_entry_1
sleep_bv(TIMING_ENGINE.TE_FUNC_INT_RAW_STATUS.TE_ACQ_END_INT_RAW_STATUS,0x1); # To detect to acquisition end of the chirp
TIMING_ENGINE.CHIRP_PROFILE_LIST.PROFILE_LIST_ENTRY_0=0x3; # SW dynamically load profile value for profile_list_entry_0
sleep_bv(TIMING_ENGINE.TE_FUNC_INT_RAW_STATUS.TE_ACQ_END_INT_RAW_STATUS,0x1); # To detect to acquisition end of the chirp
TIMING_ENGINE.CHIRP_PROFILE_LIST.PROFILE_LIST_ENTRY_1=0x2; # SW dynamically load profile value for profile_list_entry_1
sleep_bv(TIMING_ENGINE.TE_FUNC_INT_RAW_STATUS.TE_ACQ_END_INT_RAW_STATUS,0x1); # To detect to acquisition end of the chirp
TIMING_ENGINE.CHIRP_PROFILE_LIST.PROFILE_LIST_ENTRY_0=0x1; # SW dynamically load profile value for profile_list_entry_0
sleep_bv(TIMING_ENGINE.TE_FUNC_INT_RAW_STATUS.TE_ACQ_END_INT_RAW_STATUS,0x1); # To detect to acquisition end of the chirp
TIMING_ENGINE.CHIRP_PROFILE_LIST.PROFILE_LIST_ENTRY_1=0x0; # SW dynamically load profile value for profile_list_entry_1
sleep_bv(TIMING_ENGINE.TE_FUNC_INT_RAW_STATUS.TE_ACQ_END_INT_RAW_STATUS,0x1); # To detect to acquisition end of the chirp
TIMING_ENGINE.CHIRP_PROFILE_LIST.PROFILE_LIST_ENTRY_0=0x3; # SW dynamically load profile value for profile_list_entry_0
sleep_bv(TIMING_ENGINE.TE_FUNC_INT_RAW_STATUS.TE_ACQ_END_INT_RAW_STATUS,0x1); # To detect to acquisition end of the chirp
TIMING_ENGINE.CHIRP_PROFILE_LIST.PROFILE_LIST_ENTRY_1=0x1; # SW dynamically load profile value for profile_list_entry_1





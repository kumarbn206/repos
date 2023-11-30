include "../idaSTRX_TE_int_triggerCW.bf"
include "../idaSTRX_TE_TX_pr_calib.bf"
sleep(1200); # Wait for tx_pr_calibration timeout  (1.2 ms) 
sleep_bv(TIMING_ENGINE.TX_PR_CALIB_CHECK_STATUS.TX_PR_CALIB_STATUS,0x1); # to check the calibration status

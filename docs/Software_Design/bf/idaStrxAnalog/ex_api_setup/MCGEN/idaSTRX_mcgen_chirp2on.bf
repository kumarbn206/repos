//
// Script to switch from on mode to chrip mode
// This avoids triggering of drift compensation during chirp operation
//
ADPLL.DPLL_TEST_CONFIG.DRIFT_THRESHOLD_H=0x2E8;
ADPLL.DATA_STROBE.STROBE=1;

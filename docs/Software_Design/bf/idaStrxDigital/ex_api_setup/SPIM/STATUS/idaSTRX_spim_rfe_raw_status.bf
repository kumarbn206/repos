//read the analog RFE Status
//commented because pon programming is required
//sleep_bv(SPIM.RFE_RAW_STATUS.GBIAS_BG_STATUS_BG_OK_FLAG,1); 
//read the analog RFE Status
sleep_bv(SPIM.RFE_RAW_STATUS.MCGEN_STATUS_MCGEN_0V9_ANA_OK,1); 
//read the analog RFE Status
sleep_bv(SPIM.RFE_RAW_STATUS.PORCONST_RAW_STATUS,1); 
//read the analog RFE Status
sleep_bv(SPIM.RFE_RAW_STATUS.PORTAP_RAW_STATUS,1); 

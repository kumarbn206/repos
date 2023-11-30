
//  Transmitter from standby to off mode, GLDO1 & GLDO2 enabled
TX2.PON.PON_TX_LS = 0;
TX2.PON.PON_LDO_LO = 0;
TX2.PON.PON_LDO_PR = 0;
TX2.TXDIG_DFT.CLK_FREE_RUN = 0;  // Disable the clock locally instead from TE (later in API it will move to power management)

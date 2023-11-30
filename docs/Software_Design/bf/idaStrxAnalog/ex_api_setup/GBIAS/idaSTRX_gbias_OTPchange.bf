// format: <IP>.<register name>.<field name>[INDEX] = <value>
// Where, [INDEX] refers to the bit index @ENUM (if applicable)

// wk2147: correct OTP values of the trim vectors are not known yet, and are only known after full trim cycle.
// Initial trim values are presented for convenience of bring up.

GBIAS.BG_REF.TR_BG_SETDC = 0x8;          // bandgap, DC value trim bits
GBIAS.BG_REF.TR_BG_SETCUR = 0x4;         // bandgap, curvature trim bits
GBIAS.V2I_CONV.TR_V2I = 0x20;            // trim 24uA CTAT reference current by trimming its V/I resistor
GBIAS.V2I_CONV.TR_V2I_PT_SPARE = 0x20;   // trim 24uA PTAT reference current by trimming its V/I resistor
GBIAS.V2I_CONV.SET_TR_V2I_BGR = 0x0;     // enable trimming 20uA BGR current. Only applicable for TEST
GBIAS.V2I_CONV.TR_V2I_BGR = 0x0;         // trim 20uA BGR current. Only applicable for TEST
GBIAS.IBIAS_ADC.TR_LDO_FT = 0x4;         // trim 20uA 3 bit flat (LDO)
GBIAS.IBIAS_TX_1.TR_DBLR_FT = 0x10;      // trim 90uA 5 bit flat (Doubler)
GBIAS.IBIAS_TX_1.TR_PT_FT = 0x10;        // trim 90uA 5 bit flat (Phase Rotator)
GBIAS.IBIAS_TX_1.TR_PA_FT = 0x10;        // trim 90uA 5 bit flat (PA)
GBIAS.IBIAS_TX_2.TR_DBLR_PT = 0x10;      // trim 90uA 5 bit PTAT (Doubler)
GBIAS.IBIAS_TX_2.TR_PR_PT = 0x10;        // trim 90uA 5 bit PTAT (Phase Rotator)
GBIAS.IBIAS_TX_2.TR_BUF_PT = 0x10;       // trim 90uA 5 bit PTAT (Buffer)
GBIAS.IBIAS_TX_2.TR_PA_PT = 0x10;        // trim 90uA 5 bit PTAT (PA)
GBIAS.IBIAS_TX_3.TR_PR1_FT = 0x10;       // trim 20uA 5 bit flat (Phase Rotator)
GBIAS.IBIAS_TX_3.TR_PR2_FT = 0x10;       // trim 20uA 5 bit flat (Phase Rotator)
GBIAS.IBIAS_TX_3.TR_BUF_FT = 0x10;       // trim 20uA 5 bit flat (Buffer)
GBIAS.IBIAS_TX_3.TR_PA_FT = 0x10;        // trim 20uA 5 bit flat (PA)
GBIAS.IBIAS_TX_4.TR_LDO_0V9_FT = 0x4;    // trim 20uA 3 bit flat (LDO_0V9)
GBIAS.IBIAS_TX_4.TR_LDO_1V1_FT = 0x4;    // trim 20uA 3 bit flat (LDO_1V1)
GBIAS.IBIAS_RX_1.TR_PT = 0x10;           // trim 90uA 5 bit PTAT
GBIAS.IBIAS_RX_1.TR_FT = 0x4;            // trim 90uA 3 bit flat
GBIAS.IBIAS_RX_1.TR_FT_20UA = 0x4;       // trim 20uA 3 bit flat
GBIAS.IBIAS_RX_2.TR_LDO_LNA_FT = 0x4;    // trim 20uA 3 bit flat (LDO_LNA)
GBIAS.IBIAS_RX_2.TR_LDO_LOI_FT = 0x4;    // trim 20uA 3 bit flat (LDO_LOI)
GBIAS.IBIAS_RX_2.TR_LDO_LPFI_PT = 0x10;  // trim 30uA 5 bit PTAT (LPF_I)
GBIAS.IBIAS_RX_2.TR_LDO_LPFQ_PT = 0x10;  // trim 30uA 5 bit PTAT (LPF_Q)
GBIAS.IBIAS_RX_2.TR_LDO_LPFI_FT = 0x4;   // trim 20uA 3 bit flat (LPF_I)
GBIAS.IBIAS_RX_2.TR_LDO_LPFQ_FT = 0x4;   // trim 20uA 3 bit flat (LPF_Q)
GBIAS.IBIAS_LOIF_1.TR_PT = 0x10;         // trim 90uA 5 bit PTAT
GBIAS.IBIAS_LOIF_1.TR_FT = 0x10;         // trim 90uA 5 bit flat
GBIAS.IBIAS_LOIF_1.TR_FUSA_FT = 0x4;     // trim 90uA 3 bit flat
GBIAS.IBIAS_LOIF_2.TR_LDO_PA_FT = 0x4;   // trim 20uA 3 bit flat (LDO_PA)
GBIAS.IBIAS_LOIF_2.TR_LDO_LNA_FT = 0x4;  // trim 20uA 3 bit flat (LDO_LNA)
GBIAS.IBIAS_LOIF_2.TR_LDO_DRV_FT = 0x4;  // trim 20uA 3 bit flat (LDO_DRIVER)
GBIAS.IBIAS_LOIF_2.TR_LDO_LOX4_FT = 0x4; // trim 20uA 3 bit flat (LDO_LOX4)
GBIAS.IBIAS_XO.TR_LDO_CORE_PT = 0x10;    // trim 30uA 5 bit PTAT (LDO_CORE)
GBIAS.IBIAS_XO.TR_FT = 0x10;             // trim 20uA 5 bit flat
GBIAS.IBIAS_XO.TR_LDO_BUF_FT = 0x10;     // trim 20uA 5 bit flat (LDO_BUFFER)
GBIAS.IBIAS_XO.TR_LDO_MCG_FT = 0x10;     // trim 20uA 5 bit flat (LDO_MCGEN)
GBIAS.IBIAS_TXBIST.TR_FT = 0x10;         // trim 90uA 5 bit flat
GBIAS.IBIAS_RXBIST_1.TR_LO_PT = 0x10;    // trim 90uA 5 bit PTAT (LO)
GBIAS.IBIAS_RXBIST_1.TR_BUF_PT = 0x10;   // trim 90uA 5 bit PTAT (Buffer)
GBIAS.IBIAS_RXBIST_1.TR_LO_FT = 0x10;    // trim 90uA 5 bit flat (LO)
GBIAS.IBIAS_RXBIST_2.TR_BUF_FT = 0x10;   // trim 90uA 5 bit flat (Buffer)
GBIAS.IBIAS_RXBIST_2.TR_PSDAC_FT= 0x10;  // trim 90uA 5 bit flat (PS DAC)
GBIAS.IBIAS_RXBIST_2.TR_BBB_I_FT= 0x10;  // trim 90uA 5 bit flat (BBB_I)
GBIAS.IBIAS_RXBIST_2.TR_BBB_Q_FT= 0x10;  // trim 90uA 5 bit flat (BBB_Q)
GBIAS.IBIAS_RXBIST_3.TR_LDO_LO_FT = 0x4; // trim 20uA 3 bit flat (LDO_LO)
GBIAS.IBIAS_RXBIST_3.TR_LDO_RF_FT = 0x4; // trim 20uA 3 bit flat (LDO_RF)
GBIAS.IBIAS_RXBIST_3.TR_LDO_DIG_FT = 0x4;// trim 20uA 3 bit flat (LDO_DIG)
GBIAS.IBIAS_LLDO.TR_LDO_CORE_FT = 0x4;   // trim 20uA 3 bit flat (LDO CORE)
GBIAS.IBIAS_LLDO.TR_LDO_PDC_FT = 0x4;    // trim 20uA 3 bit flat (LDO PDC)
GBIAS.FUSA_MONITOR.TR_FUSA_FT = 0x4;     // trim 90uA 3 bit flat (current for monitoring MasterDiode flat @GBias)
GBIAS.FUSA_MONITOR.TR_FUSA_FT_0P2 = 0x4; // trim 90uA 3 bit flat (current for monitoring MasterDiode 0p2uA/K PTAT @GBias)
GBIAS.FUSA_MONITOR.TR_FUSA_FT_0P3 = 0x4; // trim 90uA 3 bit flat (current for monitoring MasterDiode 0p3uA/K PTAT @GBias)








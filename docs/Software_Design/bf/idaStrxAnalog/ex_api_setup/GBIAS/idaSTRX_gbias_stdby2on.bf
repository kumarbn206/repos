// Sequence to make the reference bias current go from 'off' to 'on'
// format: <IP>.<register name>.<field name>[INDEX] = <value>
// Where, [INDEX] refers to the bit index @ENUM (if applicable)
  

//GBIAS.IBIAS_ALWAYS_ON.EN_CORE = 0x1;        // enable ibias outputs @LLDODIG (ALWAYS_ON!)
//GBIAS.IBIAS_ALWAYS_ON.EN_XO = 0x1;          // enable ibias outputs @MCGEN (ALWAYS_ON!)
GBIAS.IBIAS_LOIF_1.EN_LOIF = 0x1;           // enable ibias outputs @LOIF
GBIAS.IBIAS_RX_1.EN_RX = 0xF;               // enable ibias outputs @RX (4#4)
GBIAS.IBIAS_ADC.EN_ADC = 0xF;               // enable ibias outputs @ADC (4#4)
GBIAS.IBIAS_LLDO.EN_PDC = 0x1;              // enable ibias outputs @PDC
GBIAS.IBIAS_TX_1.EN_TX = 0xF;               // enable ibias outputs @TX1 (4#4)
GBIAS.IBIAS_RXBIST_1.EN_RXBIST = 0x1;       // enable ibias outputs @RXBIST
GBIAS.IBIAS_TXBIST.EN_TXBIST = 0x7;         // enable ibias outputs @TXBIST (3#3)
GBIAS.IBIAS_ATB.EN_ATB = 0x1;               // enable ibias outputs @ATB











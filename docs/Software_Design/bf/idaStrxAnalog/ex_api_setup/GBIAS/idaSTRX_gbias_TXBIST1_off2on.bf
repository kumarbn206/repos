// Sequence to make the reference bias current go from 'off' to 'on'
// format: <IP>.<register name>.<field name>[INDEX] = <value>
// Where, [INDEX] refers to the bit index @ENUM

GBIAS.IBIAS_TXBIST.EN_TXBIST[2] = 0x1;        // enable ibias outputs @TXBIST1. (1#3) Remark: ENUM==b'100
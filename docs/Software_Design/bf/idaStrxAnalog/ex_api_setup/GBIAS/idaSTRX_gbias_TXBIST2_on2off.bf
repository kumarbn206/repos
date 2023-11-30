// Sequence to make the reference bias current go from 'on' to 'off'
// format: <IP>.<register name>.<field name>[INDEX] = <value>
// Where, [INDEX] refers to the bit index @ENUM

GBIAS.IBIAS_TXBIST.EN_TXBIST[1] = 0x0;        // disable ibias outputs @TXBIST2. (2#3) Remark: ENUM==b'010
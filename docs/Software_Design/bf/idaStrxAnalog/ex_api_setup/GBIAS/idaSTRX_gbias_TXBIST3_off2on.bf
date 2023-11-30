// Sequence to make the reference bias current go from 'off' to 'on'
// format: <IP>.<register name>.<field name>[INDEX] = <value>
// Where, [INDEX] refers to the bit index @ENUM

GBIAS.IBIAS_TXBIST.EN_TXBIST[0] = 0x1;        // enable ibias outputs @TXBIST3. (3#3) Remark: ENUM==b'001
// Sequence to make the reference bias current go from 'on' to 'off'
// format: <IP>.<register name>.<field name>[INDEX] = <value>
// Where, [INDEX] refers to the bit index @ENUM

GBIAS.IBIAS_TXBIST.EN_TXBIST[0] = 0x0;        // disable ibias outputs @TXBIST3. (3#3) Remark: ENUM==b'001
// Sequence to make the reference bias current go from 'off' to 'on'
// format: <IP>.<register name>.<field name>[INDEX] = <value>
// Where, [INDEX] refers to the bit index @ENUM

GBIAS.IBIAS_TX_1.EN_TX[2] = 0x1;        //	enable ibias outputs @TX2. (2#4) Remark: ENUM==b'0100

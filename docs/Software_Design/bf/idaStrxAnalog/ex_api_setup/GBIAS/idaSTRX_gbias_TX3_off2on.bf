// Sequence to make the reference bias current go from 'off' to 'on'
// format: <IP>.<register name>.<field name>[INDEX] = <value>
// Where, [INDEX] refers to the bit index @ENUM

GBIAS.IBIAS_TX_1.EN_TX[1] = 0x1;        //	enable ibias outputs @TX3. (3#4) Remark: ENUM==b'0010

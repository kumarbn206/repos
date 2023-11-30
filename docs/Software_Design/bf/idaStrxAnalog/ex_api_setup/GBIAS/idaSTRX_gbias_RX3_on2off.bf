/ Sequence to make the reference bias current go from 'on' to 'off'
// format: <IP>.<register name>.<field name>[INDEX] = <value>
// Where, [INDEX] refers to the bit index @ENUM

GBIAS.IBIAS_RX_1.EN_RX[1] = 0x0;        // disable ibias outputs @RX3. (3#4) Remark: ENUM==b'0010
// Sequence to make the reference bias current go from 'on' to 'off'
// format: <IP>.<register name>.<field name>[INDEX] = <value>
// Where, [INDEX] refers to the bit index @ENUM (if applicable)

GBIAS.IBIAS_ATB.EN_ATB = 0x0;        //	disable ibias outputs @ATB
// Sequence to make the reference bias current go from 'on' to 'off'
// format: <IP>.<register name>.<field name>[INDEX] = <value>
// Where, [INDEX] refers to the bit index @ENUM (if applicable)

GBIAS.IBIAS_ALWAYS_ON.EN_XO = 0x1;        // enable ibias outputs @MCGEN
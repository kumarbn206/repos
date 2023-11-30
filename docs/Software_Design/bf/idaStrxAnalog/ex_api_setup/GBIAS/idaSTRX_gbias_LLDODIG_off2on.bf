// Sequence to make the reference bias current go from 'on' to 'off'
// format: <IP>.<register name>.<field name>[INDEX] = <value>
// Where, [INDEX] refers to the bit index @ENUM (if applicable)

GBIAS.IBIAS_ALWAYS_ON.EN_CORE = 0x1;        // disable ibias outputs @LLDODIG
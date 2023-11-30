// Sequence to make the reference bias current go from 'on' to 'off'
// format: <IP>.<register name>.<field name>[INDEX] = <value>
// Where, [INDEX] refers to the bit index @ENUM (if applicable)

//Disclaimer: switching off the bias currents @LLDODIG will shutdown the LLDODIG as well. (critical to RFE system)

GBIAS.IBIAS_ALWAYS_ON.EN_CORE = 0x0;        // disable ibias outputs @LLDODIG
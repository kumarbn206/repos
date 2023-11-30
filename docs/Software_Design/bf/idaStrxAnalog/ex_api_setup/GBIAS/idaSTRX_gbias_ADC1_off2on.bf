// Sequence to make the reference bias current go from 'off' to 'on'
// format: <IP>.<register name>.<field name>[INDEX] = <value>
// Where, [INDEX] refers to the bit index @ENUM (if applicable)
  
GBIAS.IBIAS_ADC.EN_ADC[3] = 0x1;        // enable ibias outputs @ADC1. (1#4) Remark: ENUM==b'1000
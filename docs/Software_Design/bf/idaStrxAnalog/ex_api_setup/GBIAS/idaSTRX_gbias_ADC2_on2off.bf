// Sequence to make the reference bias current go from 'on' to 'off'
// format: <IP>.<register name>.<field name>[INDEX] = <value>
// Where, [INDEX] refers to the bit index @ENUM
  
GBIAS.IBIAS_ADC.EN_ADC[2] = 0x0;        // disable ibias outputs @ADC2. (2#4) Remark: ENUM==b'0100


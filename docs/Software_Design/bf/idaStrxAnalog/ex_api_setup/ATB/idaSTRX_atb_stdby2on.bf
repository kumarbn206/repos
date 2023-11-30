// ATB into RefBIST + DCATB enabled mode ( from off mode )-

// Sequence to make the reference bias current go from 'off' to 'on'
// format: <IP>.<register name>.<field name>[INDEX] = <value>
// Where, [INDEX] refers to the bit index @ENUM (if applicable)

//Enable BG 

ATB.PVT_REF_GEN_BIST_0.ENA_BG= 1;

//ENABLE BG Buffer

ATB.PVT_REF_GEN_BIST_0.BYPASS_BG_RC=1; // bypass RC filter to speed up BG startup
ATB.PVT_REF_GEN_BIST_0.ENA_BG_BUF=1; 
sleep(200) ; // wait 200us for BG to come up
ATB.PVT_REF_GEN_BIST_0.BYPASS_BG_RC=0; // disable bypass of RC filter


// ATB1,2 ADC enables

ATB.PVT_REF_GEN_BIST_1.ENA_ADC_ATB1=1;
ATB.PVT_REF_GEN_BIST_1.ENA_ADC_ATB1=1;
sleep(15) ; // wait time of 15us for ADC startup





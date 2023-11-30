// Switch OFF ATB level shifters
<ATB>.<PON_CTL>.<PON_LS_ATB> = 0x0; 
 
//Switch OFF ADC1,2 level shifters
<ATB>.<PON_CTL>.<PON_LS_ADC_ATB1>= 0x0;
<ATB>.<PON_CTL>.<PON_LS_ADC_ATB2>= 0x0; 

// Enable ATB1,2 DC pulldowns
<ATB>.<ATB_PULLDOWN>.<ENA_DC_PULLDOWN>[1:0} = 0x11 ;
	
//Enable AC pulldowns
<ATB>.<ATB_PULLDOWN>.<ENA_AC_PULLDOWN>[17:0] = 0x1FFFF;


//Enable DEBUG inout pulldowns 
<ATB>.<ATB_PULLDOWN>.<ENA_DC_PULLDOWN>[3:2} = 0x11 ;

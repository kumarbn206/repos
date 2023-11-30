// ATB into standby mode ( from off mode )

// Sequence to make the reference bias current go from 'off' to 'on'
// format: <IP>.<register name>.<field name>[INDEX] = <value>
// Where, [INDEX] refers to the bit index @ENUM (if applicable)


// Switch ON ATB level shifters
ATB.PON_CTL.PON_LS_ATB = 0x1; 
 
//Switch ON ADC1,2 level shifters
ATB.PON_CTL.PON_LS_ADC_ATB1= 0x1;
ATB.PON_CTL.PON_LS_ADC_ATB2= 0x1; 

// Disable ATB1,2 DC pulldowns
ATB.ATB_PULLDOWN.ENA_DC_PULLDOWN = 0 ;
	
//Disable AC pulldowns
ATB.ATB_PULLDOWN.ENA_AC_PULLDOWN = 0;


//Disable DEBUG inout pulldowns 
ATB.ATB_PULLDOWN.ENA_DC_PULLDOWN = 0 ;

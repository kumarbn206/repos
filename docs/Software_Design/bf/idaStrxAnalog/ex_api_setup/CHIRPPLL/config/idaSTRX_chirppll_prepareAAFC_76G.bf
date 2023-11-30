/* idaSTRX_chirppll_prepareAAFC_76G.bf */


// set TE_40MHz as baseline clock 0 TE 1 is XTAL
CHIRPPLL.CHIRP_CTRL.CLK_SEL=0;							


// AAFC "golden settings" (recommened values):
CHIRPPLL.AAC_CTL2.AAC_FREF_SEL                       = 1;
CHIRPPLL.AAC_CTL2.AAC_KI                             = 3;
CHIRPPLL.ANA_VCO_CTL3.LEVEL_VCO_MAX                  = 49;	// Set detector trip level for AAC (ADES)

CHIRPPLL.AFC_CTL2.AFC_FREF_SEL                       = 4;
CHIRPPLL.AFC_CTL2.AFC_KI_CTRL1                       = 5;
CHIRPPLL.AFC_CTL2.AFC_KI_CTRL2                       = 4;
CHIRPPLL.AFC_CTL1.AFC_MDES                           = 475;	// mdes=475 : value for 9.5 GHz with AFC_FREF_SEL=4

// assert AFC & AAC enables   
CHIRPPLL.AFC_CTL2.AFC_ENABLE                         = 1;  
CHIRPPLL.AAC_CTL2.AAC_ENABLE                         = 1;


// == AAFC FSM is now configured ==


				

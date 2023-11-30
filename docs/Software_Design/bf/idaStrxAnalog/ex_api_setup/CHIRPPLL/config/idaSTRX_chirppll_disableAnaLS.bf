/* idaSTRX_chirppll_disableAnaLS.bf */

CHIRPPLL.PON_CTL.PON_LS_DANA=0;         //Disable DigCore->AnaLS
CHIRPPLL.PON_CTL.PON_LS_ANA=0;			//Disable RFE->AnaLS
CHIRPPLL.SPARE_CTL.ANA_SPARE1=0; 		//Disable pgmt Levelshifters (spare register b0, to be changed)



// Power-down Sequence in reverse to below
// ATB
// ChirpPll
// LOI
// RX1-4
// RXBIST 
// ADC1-4
// PDC1+PDC2
// PDC3-PDC4
// TX1-TX4

// Excluding ADC and RCOSC, since ADC can be switched ON only after LLDOPDC ON, and RCOSC used only once

// TX1-4
#include "../idaStrxAnalog/ex_api_setup/TX/idaSTRX_tx1_stdby2off.bf" 
#include "../idaStrxAnalog/ex_api_setup/TX/idaSTRX_tx2_stdby2off.bf"
#include "../idaStrxAnalog/ex_api_setup/TX/idaSTRX_tx3_stdby2off.bf"
#include "../idaStrxAnalog/ex_api_setup/TX/idaSTRX_tx4_stdby2off.bf"
// RX Bist
#include "../idaStrxAnalog/ex_api_setup/RXBIST/idaSTRX_rxbist_stdby2off.bf" 
// RX1-4
#include "../idaStrxAnalog/ex_api_setup/RX/idaSTRX_RX1_stdby2off.bf" 
#include "../idaStrxAnalog/ex_api_setup/RX/idaSTRX_RX2_stdby2off.bf"
#include "../idaStrxAnalog/ex_api_setup/RX/idaSTRX_RX3_stdby2off.bf"
#include "../idaStrxAnalog/ex_api_setup/RX/idaSTRX_RX4_stdby2off.bf"
// LOI
#include "../idaStrxAnalog/ex_api_setup/LOIF/idaSTRX_loif_stdby2off.bf" 
// CHIRPPLL
#include "../idaStrxAnalog/ex_api_setup/CHIRPPLL/idaSTRX_chirppll_stdby2off.bf"
// ATB
#include "../idaStrxAnalog/ex_api_setup/ATB/idaSTRX_atb_stdby2off.bf"

// PDC OFF2STBY in top level sequence using LLDOPDC

// Tsense
//#include "../idaStrxAnalog/ex_api_setup/TSENSE/idaSTRX_tsense_stdby2off.bf"  // empty use per Tsense
#include "../idaStrxAnalog/ex_api_setup/TSENSE/idaSTRX_tsense1_stdby2off.bf"
#include "../idaStrxAnalog/ex_api_setup/TSENSE/idaSTRX_tsense2_stdby2off.bf"
#include "../idaStrxAnalog/ex_api_setup/TSENSE/idaSTRX_tsense3_stdby2off.bf"
#include "../idaStrxAnalog/ex_api_setup/TSENSE/idaSTRX_tsense4_stdby2off.bf"
#include "../idaStrxAnalog/ex_api_setup/TSENSE/idaSTRX_tsense1_stdby2off.bf"
#include "../idaStrxAnalog/ex_api_setup/TSENSE/idaSTRX_tsense2_stdby2off.bf"
#include "../idaStrxAnalog/ex_api_setup/TSENSE/idaSTRX_tsense3_stdby2off.bf"
#include "../idaStrxAnalog/ex_api_setup/TSENSE/idaSTRX_tsense4_stdby2off.bf"

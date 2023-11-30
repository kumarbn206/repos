// Power-up Sequence
// ATB
// ChirpPll
// LOI
// RX1-4
// RXBIST 
// ADC1-4
// PDC1+PDC2
// PDC3-PDC4
// TX1-TX4


sleep(1);

// Excluding ADC and RCOSC, since ADC can be switched ON only after LLDOPDC ON, and RCOSC used only once

#include "../idaStrxAnalog/ex_api_setup/LLDODIG/idaSTRX_lldodig_stdby2on.bf"
sleep(1);
#include "../idaStrxAnalog/ex_api_setup/MCGEN/idaSTRX_mcgen_off2stdby.bf" 
sleep(1);

// Tsense is ON in STBY and ON
//#include "../idaStrxAnalog/ex_api_setup/TSENSE/idaSTRX_tsense_off2stdby.bf"  // empty use per Tsense
#include "../idaStrxAnalog/ex_api_setup/TSENSE/idaSTRX_tsense1_off2stdby.bf"
sleep(1);
#include "../idaStrxAnalog/ex_api_setup/TSENSE/idaSTRX_tsense2_off2stdby.bf"
sleep(1);
#include "../idaStrxAnalog/ex_api_setup/TSENSE/idaSTRX_tsense3_off2stdby.bf"
sleep(1);
#include "../idaStrxAnalog/ex_api_setup/TSENSE/idaSTRX_tsense4_off2stdby.bf"
sleep(1);
#include "../idaStrxAnalog/ex_api_setup/TSENSE/idaSTRX_tsense1_stdby2on.bf"
sleep(1);
#include "../idaStrxAnalog/ex_api_setup/TSENSE/idaSTRX_tsense2_stdby2on.bf"
sleep(1);
#include "../idaStrxAnalog/ex_api_setup/TSENSE/idaSTRX_tsense3_stdby2on.bf"
sleep(1);
#include "../idaStrxAnalog/ex_api_setup/TSENSE/idaSTRX_tsense4_stdby2on.bf"
sleep(1);

// PDC OFF2STBY in top level sequence using LLDOPDC

// ATB
#include "../idaStrxAnalog/ex_api_setup/ATB/idaSTRX_atb_off2stdby.bf"
sleep(1);

// CHIRPPLL
#include "../idaStrxAnalog/ex_api_setup/CHIRPPLL/idaSTRX_chirppll_off2stdby.bf"
sleep(1);

// LOI
#include "../idaStrxAnalog/ex_api_setup/LOIF/idaSTRX_loif_off2stdby.bf" 
sleep(1);

// RX1-4
#include "../idaStrxAnalog/ex_api_setup/RX/idaSTRX_RX1_off2stdby.bf" 
sleep(1);
#include "../idaStrxAnalog/ex_api_setup/RX/idaSTRX_RX2_off2stdby.bf"
sleep(1);
#include "../idaStrxAnalog/ex_api_setup/RX/idaSTRX_RX3_off2stdby.bf"
sleep(1);
#include "../idaStrxAnalog/ex_api_setup/RX/idaSTRX_RX4_off2stdby.bf"
sleep(1);

// RX Bist
#include "../idaStrxAnalog/ex_api_setup/RXBIST/idaSTRX_rxbist_off2stdby.bf" 
sleep(1);

// TX1-4
#include "../idaStrxAnalog/ex_api_setup/TX/idaSTRX_tx1_off2stdby.bf" 
sleep(1);
#include "../idaStrxAnalog/ex_api_setup/TX/idaSTRX_tx2_off2stdby.bf"
sleep(1);
#include "../idaStrxAnalog/ex_api_setup/TX/idaSTRX_tx3_off2stdby.bf"
sleep(1);
#include "../idaStrxAnalog/ex_api_setup/TX/idaSTRX_tx4_off2stdby.bf"
sleep(1);

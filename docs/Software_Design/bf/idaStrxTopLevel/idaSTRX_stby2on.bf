// Activation Sequence
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

// ATB
#include "../idaStrxAnalog/ex_api_setup/ATB/idaSTRX_atb_stdby2on.bf"
sleep(1);

// ChirpPLL
#include "../idaStrxAnalog/ex_api_setup/CHIRPPLL/idaSTRX_chirppll_stdby2on_76G_mode1G_CW.bf"
sleep(1);

// LOIF
#include "../idaStrxAnalog/ex_api_setup/LOIF/idaSTRX_loif_stdby2on.bf"
sleep(1);

// RX1-4
#include "../idaStrxAnalog/ex_api_setup/RX/idaSTRX_RX1_stdby2on.bf" 
sleep(1);
#include "../idaStrxAnalog/ex_api_setup/RX/idaSTRX_RX2_stdby2on.bf"
sleep(1);
#include "../idaStrxAnalog/ex_api_setup/RX/idaSTRX_RX3_stdby2on.bf"
sleep(1);
#include "../idaStrxAnalog/ex_api_setup/RX/idaSTRX_RX4_stdby2on.bf"
sleep(1);

// RXBIST
//#include "../idaStrxAnalog/ex_api_setup/RXBIST/idaSTRX_rxbist_stdby2on.bf"  //not available
sleep(1);

// ADCs have only OFF and ON state
#include "../idaStrxAnalog/ex_api_setup/RXADC/idaSTRX_rxadc1_off2on.bf"
sleep(1);
#include "../idaStrxAnalog/ex_api_setup/RXADC/idaSTRX_rxadc2_off2on.bf"
sleep(1);
#include "../idaStrxAnalog/ex_api_setup/RXADC/idaSTRX_rxadc3_off2on.bf"
sleep(1);
#include "../idaStrxAnalog/ex_api_setup/RXADC/idaSTRX_rxadc4_off2on.bf"
sleep(1);

// SYNC all ADCs
#include "../idaStrxAnalog/ex_api_setup/RXADC/idaSTRX_rxadc1234_sync.bf"
sleep(1);

// TX1-4
#include "../idaStrxAnalog/ex_api_setup/TX/idaSTRX_tx1_stdby2on.bf" 
sleep(1);
#include "../idaStrxAnalog/ex_api_setup/TX/idaSTRX_tx2_stdby2on.bf"
sleep(1);
#include "../idaStrxAnalog/ex_api_setup/TX/idaSTRX_tx3_stdby2on.bf"
sleep(1);
#include "../idaStrxAnalog/ex_api_setup/TX/idaSTRX_tx4_stdby2on.bf"
sleep(1);

// How about TX clocks managed by TE, part of STBY2ON BF?

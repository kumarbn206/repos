
// DeActivation Sequence in reverse to below
// ATB
// ChirpPll
// LOI
// RX1-4
// RXBIST 
// ADC1-4
// PDC1+PDC2
// PDC3-PDC4
// TX1-TX4

// How about TX clocks managed by TE, part of ON2STBY BF?

// TX1-4
#include "../idaStrxAnalog/ex_api_setup/TX/idaSTRX_tx1_on2stby.bf" 
#include "../idaStrxAnalog/ex_api_setup/TX/idaSTRX_tx2_on2stby.bf"
#include "../idaStrxAnalog/ex_api_setup/TX/idaSTRX_tx3_on2stby.bf"
#include "../idaStrxAnalog/ex_api_setup/TX/idaSTRX_tx4_on2stby.bf"

// ADCs have only OFF and ON state
#include "../idaStrxAnalog/ex_api_setup/RXADC/idaSTRX_rxadc1_on2stby.bf"
#include "../idaStrxAnalog/ex_api_setup/RXADC/idaSTRX_rxadc2_on2stby.bf"
#include "../idaStrxAnalog/ex_api_setup/RXADC/idaSTRX_rxadc3_on2stby.bf"
#include "../idaStrxAnalog/ex_api_setup/RXADC/idaSTRX_rxadc4_on2stby.bf"

// RXBIST
#include "../idaStrxAnalog/ex_api_setup/RXBIST/idaSTRX_rxbist_on2stby.bf" 

// RX1-4
#include "../idaStrxAnalog/ex_api_setup/RX/idaSTRX_RX1_on2stby.bf" 
#include "../idaStrxAnalog/ex_api_setup/RX/idaSTRX_RX2_on2stby.bf"
#include "../idaStrxAnalog/ex_api_setup/RX/idaSTRX_RX3_on2stby.bf"
#include "../idaStrxAnalog/ex_api_setup/RX/idaSTRX_RX4_on2stby.bf"

// LOIF
#include "../idaStrxAnalog/ex_api_setup/LOIF/idaSTRX_loif_on2stby.bf" 

// ChirpPLL
#include "../idaStrxAnalog/ex_api_setup/CHIRPPLL/idaSTRX_chirppll_on2stby.bf"

// ATB
#include "../idaStrxAnalog/ex_api_setup/ATB/idaSTRX_atb_on2stby.bf"

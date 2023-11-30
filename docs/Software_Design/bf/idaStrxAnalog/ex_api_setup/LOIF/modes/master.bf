/**************************************************
 *                                                *
 * Owner: Maarten Lont                            *
 * Creation date: 23-Nov-2021                     *
 **************************************************
 *                                                *
 * Changelog [dd-mm-yyyy]: notes                  *
 *                                                *
 **************************************************/
 
// To be used before the LOIF is truned from off->standby
// Enable all PPD
// Enable the BBD
// All sub-IP that are neeed for the master mode are enabled
// - LOx4 = on
// - Driver = on
// - PA = on
// - LNA = on
// - Route signal from LOx4 -> PA / LNA -> Driver
// - No loopback

// LDO's
LOIF.LDO_PA.EN = 1;
LOIF.LDO_LNA.EN = 1;
LOIF.LDO_LOX4.EN = 1;
LOIF.LDO_DRIVER.EN = 1;

// ROUTE LOx4 -> PA
LOIF.DRIVER_CTL.MUX = 1; // EXTERNAL
LOIF.LOX4_CTL.SWITCH = 1; // EXTERNAL

// PA
LOIF.PA_CTL.LOOPBACK = 0;
LOIF.PA_CTL.EN_STG1 = 1;
LOIF.PA_CTL.EN_STG2 = 1;

// LNA
LOIF.LNA_CTL.EN_STG1 = 1;
LOIF.LNA_CTL.EN_STG2 = 1;

// LOX4
LOIF.LOX4_CTL.EN_RF = 1;
LOIF.LOX4_CTL.EN_DLL = 1;
LOIF.LOX4_CTL.EN_INPUT = 1;
LOIF.LOX4_CTL.EN_LOX4 = 1;

// Driver
LOIF.DRIVER_CTL.EN_DRIVER_STG1 = 1;
LOIF.DRIVER_CTL.EN_TX = 1;
LOIF.DRIVER_CTL.EN_RX = 1;

// PPD / BBD
LOIF.PPD_CTL.EN = 1;
LOIF.BBD_CTL.EN = 1; // Can only be used in Slave and Master mode


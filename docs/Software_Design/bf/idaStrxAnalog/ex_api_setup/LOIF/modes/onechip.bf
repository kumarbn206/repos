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
// Disable the BBD
// All sub-IP that are neeed for the onechip mode are enabled
// - LOx4 = on
// - Driver = on
// - PA = off
// - LNA = off
// - Route signal from LOx4 -> Driver
// - No loopback

// LDO's
LOIF.LDO_PA.EN = 0;
LOIF.LDO_LNA.EN = 0;
LOIF.LDO_LOX4.EN = 1;
LOIF.LDO_DRIVER.EN = 1;

// ROUTE LOx4 -> Driver
LOIF.DRIVER_CTL.MUX = 0; // INTERNAL
LOIF.LOX4_CTL.SWITCH = 0; // INTERNAL

// PA
LOIF.PA_CTL.LOOPBACK = 0;
LOIF.PA_CTL.EN_STG1 = 0;
LOIF.PA_CTL.EN_STG2 = 0;

// LNA
LOIF.LNA_CTL.EN_STG1 = 0;
LOIF.LNA_CTL.EN_STG2 = 0;

// LOX4
LOIF.LOX4_CTL.EN_RF = 1;
LOIF.LOX4_CTL.EN_DLL = 1;
LOIF.LOX4_CTL.EN_INPUT = 1;
LOIF.LOX4_CTL.EN_LOX4 = 1;

// Driver
LOIF.DRIVER_CTL.EN_DRIVER_STG1 = 1;
LOIF.DRIVER_CTL.EN_DRIVER_TX = 1;
LOIF.DRIVER_CTL.EN_DRIVER_RX = 1;

// PPD / BBD
LOIF.PPD_CTL.EN = 1;
LOIF.BBD_CTL.EN = 0; // Can only be used in Slave and Master mode


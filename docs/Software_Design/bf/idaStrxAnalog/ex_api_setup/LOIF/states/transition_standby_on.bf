/**************************************************
 *                                                *
 * Owner: Maarten Lont                            *
 * Creation date: 23-Nov-2021                     *
 **************************************************
 *                                                *
 * Changelog [dd-mm-yyyy]: notes                  *
 *                                                *
 **************************************************/
 
// Transition the IP from Standby->On (assume we start from standby)
// - Dont touch the pon_ls
// - Toggle the main enable
// - Raise the fast LDO start-up for 1us

// Toggle LS + bypass the LLDO
LOIF.PON_CTL.PON_LS = 1;
LOIF.PON_CTL.FAST_ENABLE_M7 = 1;	// Short
LOIF.PON_CTL.LOI_IP_EN = 1;

// Wait for 1us
sleep(1);

// Release LLDO bypass
LOIF.PON_CTL.FAST_ENABLE_M7 = 0;	// FILTER


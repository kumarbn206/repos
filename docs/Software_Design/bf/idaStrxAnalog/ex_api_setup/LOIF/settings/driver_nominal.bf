/**************************************************
 *                                                *
 * Owner: Maarten Lont                            *
 * Creation date: 23-Nov-2021                     *
 **************************************************
 *                                                *
 * Changelog [dd-mm-yyyy]: notes                  *
 *                                                *
 **************************************************/
 
// Set nominal PA settings
LOIF.DRIVER_CTL.GAIN_TX = 0xF;      // Max gain -> LOx2 will always work
LOIF.DRIVER_CTL.GAIN_RX = 0xF;      // Max gain -> LOx2 will always work
LOIF.DRIVER_CTL.PPD_TX_GAIN = 0x1;  // GAIN_3x
LOIF.DRIVER_CTL.PPD_RX_GAIN = 0x1;  // GAIN_3x

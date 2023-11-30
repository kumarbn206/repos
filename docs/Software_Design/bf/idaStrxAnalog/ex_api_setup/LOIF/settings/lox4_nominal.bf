/**************************************************
 *                                                *
 * Owner: Maarten Lont                            *
 * Creation date: 23-Nov-2021                     *
 **************************************************
 *                                                *
 * Changelog [dd-mm-yyyy]: notes                  *
 *                                                *
 **************************************************/
 
// Set nominal LOX4 settings
LOIF.LOX4_CTL.REF_CTRL = 0x8; // - DLL_REF = mid setting (duty cycle control)
LOIF.LOX4_CTL.TUNE_FREQ = 0x3; // Set PPF corner frequency 64fF - Used for TT/FF
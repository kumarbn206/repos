/**************************************************
 *                                                *
 * Owner: Maarten Lont                            *
 * Creation date: 23-Nov-2021                     *
 **************************************************
 *                                                *
 * Changelog [dd-mm-yyyy]: notes                  *
 *                                                *
 **************************************************/

// Setup the LOIF in Slave mode and activate

// All off
#include "states/state_off.bf"

// Setup + choose mode
#include "settings/nominal.bf"
#include "modes/slave.bf"

// Move towards on state
#include "states/transition_off_standby.bf"
#include "states/transition_standby_on.bf"
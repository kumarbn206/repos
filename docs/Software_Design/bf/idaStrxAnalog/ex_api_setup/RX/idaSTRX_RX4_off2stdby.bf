

//  Turn the circuit off. Notice that this can only be done after standby
RX4.PON_CTL = 1;

// Staggered 1us appart (can be reduced if the GLDO can handle it)
RX4.LDO_RF_CTL.LDO_LNA_EN = 1;  // Take around 8us to start 
sleep(1);
RX4.LDO_RF_CTL.LDO_LO_EN = 1; // take around 8us to start
sleep(1);
RX4.LDO_IF_CTL.LDO_EN = 1; // Take around 8us to start
sleep(8);
//Broadcast/multicast to be done by software to sync all ADCs whenever ADCs are configured
// Please use multicast address
ADC_MC.DMUX_CTL.RST_SYNC = 0x0;
sleep(1);
ADC_MC.DMUX_CTL.RST_SYNC = 0x1;


// Sequence to make the circuit go from standby to zero
RX3.LDO_IF_CTL.LDO_LS_1V35_EN = 1; //	Enable overvoltage LDO 1us
// This can be group in a single regiter write
RX3.PWR_CTL.FAST_ENABLE = 1;      // Fast Enable
RX3.PWR_CTL.IBIAS_EN = 1;         //	enable Ibias
RX3.PWR_CTL.LO_LOX2_EN = 1;       //	Enable the lox2
RX3.PWR_CTL.LO_IQBI_EN = 1;       //	enable the iqbuffers
RX3.PWR_CTL.LO_IQBQ_EN = 1;       //	enable the iqbuffers
RX3.PWR_CTL.LO_LDI_EN = 1;        //	enable lo level detectors
RX3.PWR_CTL.LO_LDQ_EN = 1;        //	enable lo level detectors
RX3.PWR_CTL.LNA_EN = 1;           //	enable Lna
RX3.PWR_CTL.MIXER_EN = 1;         //	enable mixer 
RX3.PWR_CTL.SAT_DET_ST1_EN = 1;   //	enable saturation detector
RX3.PWR_CTL.SAT_DET_ST2_EN = 1;   //	enable saturation detector
sleep(5); 						  //    Wait 5us
RX3.PWR_CTL.FAST_ENABLE = 0;      // 	Disable fast enable
			
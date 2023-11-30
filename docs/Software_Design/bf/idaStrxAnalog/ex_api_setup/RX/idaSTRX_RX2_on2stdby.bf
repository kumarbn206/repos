

// Sequence to make the circuit go from standby to zero
RX2.LDO_IF_CTL.LDO_LS_1V35_EN = 0; //	Enable overvoltage LDO 1us
// This can be group in a single regiter write
RX2.PWR_CTL.IBIAS_EN = 0;        //	enable Ibias
RX2.PWR_CTL.LO_LOX2_EN = 0;      //	Enable the lox2
RX2.PWR_CTL.LO_IQBI_EN = 0;      //	enable the iqbuffers
RX2.PWR_CTL.LO_IQBQ_EN = 0;      //	enable the iqbuffers
RX2.PWR_CTL.LO_LDI_EN = 0;       //	enable lo level detectors
RX2.PWR_CTL.LO_LDQ_EN = 0;       //	enable lo level detectors
RX2.PWR_CTL.LNA_EN = 0;          //	enable Lna
RX2.PWR_CTL.MIXER_EN = 0;        //	enable mixer 
RX2.PWR_CTL.SAT_DET_ST1_EN = 0;  //	enable saturation detector
RX2.PWR_CTL.SAT_DET_ST2_EN = 0;  //	enable saturation detector
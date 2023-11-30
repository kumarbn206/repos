

// Sequence to make the circuit go from standby to zero
RX3.LDO_IF_CTL.LDO_LS_1V35_EN = 0; //	Enable overvoltage LDO 1us
// This can be group in a single regiter write
RX3.PWR_CTL.IBIAS_EN = 0;        //	enable Ibias
RX3.PWR_CTL.LO_LOX2_EN = 0;      //	Enable the lox2
RX3.PWR_CTL.LO_IQBI_EN = 0;      //	enable the iqbuffers
RX3.PWR_CTL.LO_IQBQ_EN = 0;      //	enable the iqbuffers
RX3.PWR_CTL.LO_LDI_EN = 0;       //	enable lo level detectors
RX3.PWR_CTL.LO_LDQ_EN = 0;       //	enable lo level detectors
RX3.PWR_CTL.LNA_EN = 0;          //	enable Lna
RX3.PWR_CTL.MIXER_EN = 0;        //	enable mixer 
RX3.PWR_CTL.SAT_DET_ST1_EN = 0;  //	enable saturation detector
RX3.PWR_CTL.SAT_DET_ST2_EN = 0;  //	enable saturation detector
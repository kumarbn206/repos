/* idaSTRX_chirppll_cfg_ChirpGenerator.bf */

//-----------------------------------------------------------------------------------
CHIRPPLL.CHIRP_CTRL.FREQ_LOAD_MODE                                  = 1;          // progressive mode
//-----------------------------------------------------------------------------------
CHIRPPLL.P0_STEP_CHIRP.TICS                                         = 800;        //80+720
CHIRPPLL.P0_STEP_JUMPBACK.TICS                                      = 4;
CHIRPPLL.P0_STEP_RESET.TICS                                         = 40;
TIMING_ENGINE.TIMING_CTL_1_PROF0.SETTLE_TIME_PROFILE0               = 80;         // TSETTLE Delay of ADC in clock tick
TIMING_ENGINE.TX_PHASE_ACQ_CTL_PROF0.ACQUISITION_TIME_PROFILE0      = 720;        // AQUISITION interval of ADC in clock tics
TIMING_ENGINE.TIMING_CTL_1_PROF0.DWELL_TIME_PROFILE0                = 40;
TIMING_ENGINE.TIMING_CTL_2_PROF0.CHIRP_INTERVAL_TIMER_PROFILE0      = 884;        // CIT=4+40+80+720+40
CHIRPPLL.P0_START_FREQ.INT                                          = 29;         // 76G ;VCO 9.5G 
CHIRPPLL.P0_START_FREQ.FRAC                                         = 46137344;   // 76G ;VCO 9.5G
CHIRPPLL.P0_CHIRP.SLOPE                                             = 32768;      // 1G
CHIRPPLL.P0_RESET.SLOPE                                             = 133562368;
//-----------------------------------------------------------------------------------
TIMING_ENGINE.DC_POWER_ON_DELAY_CTL.DC_POWERON_DELAY                = 6000;       //Defines time to start up and calibrate
TIMING_ENGINE.CHIRP_SEQUENCE_CTL.NO_OF_CHIRP_IN_A_SEQUENCE          = 8;          //Defines how many chirps per sequences
TIMING_ENGINE.CHIRP_SEQUENCE_INTERVAL.CHIRP_SEQUENCE_INTERVAL_TIMER = 13872;      //Defines Sequence Idle time; 6000+8*884+20e-6/25e-9(idle_time = 20e-6)
//-----------------------------------------------------------------------------------
CHIRPPLL.GEAR2_CTL.DELAY                                            = 7;          //gear2_del
CHIRPPLL.GEAR2_CTL.DURATION                                         = 80;         //gear2_wdth: treset_period+tdwell_period
CHIRPPLL.ANA_PDCP_CTL.CLUTCH_EN                                     = 0;
//-----------------------------------------------------------------------------------
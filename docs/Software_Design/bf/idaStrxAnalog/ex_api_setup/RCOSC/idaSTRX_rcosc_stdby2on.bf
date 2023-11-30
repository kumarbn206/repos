//  
RCOSC.CAL_CTL.EN_RCCAL=1;               // Enable the RC OSC calibration FSM (edge detector inside the FSM, so 0-->1 transition is required to start the calibration)
                                        // Note: biasing, LDO, etc inside the analog IP are all enabled via the FSM.
sleep(210);                             // wait for at least 210 microseconds. FSM will go through all the states.
sleep_bv(RCOSC.CAL_STATUS.CAL_READY,1); // poll for the cal_ready status

//print(RCOSC.CAL_RESULT1.COUNT_VALUE_N);  // Should be non-zero and larger than COUNT_VALUE_M
//print(RCOSC.CAL_RESULT2.COUNT_VALUE_M);  // Should be non-zero and smaller than COUNT_VALUE_N
//print(RCOSC.CAL_STATUS.CAL_FAILED);      // check if the FAILED=0

// SW should use the N and M values to calculate the capacitor values for the RX-ADC.
// in case of a failed calibration run, TBD if one extra run can be attempted, or if a failure needs to be flagged to FuSa.


	


// SET Fit force error register. Keep it asserted for atleast 5us

ISM.ISM_FIT_TEST_REG.ISM_TEST_FORCE_ERROR=0x1;
sleep(5);

function clkResetRfe(InputStruct)

%% Only use this test if you need clock retuning. This parameter enables/disables retuning of the clock PLL to prevent it to go out-of-lock 
rfeabstract.rfe_testSetParam( 2, 1 );
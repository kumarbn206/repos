function fsw_spectrum_mode_init(fsw_address, meas_type,center_freq,count)

instrreset;

analyzer_handle = visadev(fsw_address);


write(analyzer_handle, '*RST');
write(analyzer_handle, '*CLS');

if contains(meas_type,'OBW')==1

    writeline(analyzer_handle, ':INIT:CONT ON');
    writeline(analyzer_handle, string(strcat(':SENS:FREQ:CENT ',{' '}, num2str(center_freq*1e9))));
    writeline(analyzer_handle,':SENS:FREQ:SPAN 2000000000');
    writeline(analyzer_handle,':SENS:BAND:RES 1000000');
    writeline(analyzer_handle,':DISP:WIND:SUBW:TRAC:Y:SCAL:RLEV 10');
    writeline(analyzer_handle,':INP:ATT:AUTO OFF');
    writeline(analyzer_handle,':INP:ATT 10');
    writeline(analyzer_handle,':DISP:WIND1:SUBW:TRAC1:MODE MAXH');
elseif contains(meas_type,'MCGEN')==1

    writeline(analyzer_handle, ':INIT:CONT ON');
    writeline(analyzer_handle, string(strcat(':SENS:FREQ:CENT ',{' '}, num2str(center_freq*1e9))));
    writeline(analyzer_handle,':SENS:FREQ:SPAN 5000000');
    writeline(analyzer_handle,':SENS:BAND:RES 5000');
    writeline(analyzer_handle,':SENS:BAND:VID 100');
    writeline(analyzer_handle,':DISP:WIND:SUBW:TRAC:Y:SCAL:RLEV 10');
    writeline(analyzer_handle,':INP:ATT:AUTO OFF');
    writeline(analyzer_handle,':INP:ATT 10');
    writeline(analyzer_handle,':DISP:WIND1:SUBW:TRAC1:MODE MAXH');


end 










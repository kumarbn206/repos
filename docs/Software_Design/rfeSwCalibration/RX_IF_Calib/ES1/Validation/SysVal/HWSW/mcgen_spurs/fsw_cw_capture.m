function [trace_data_x1,trace_data_y1]=fsw_cw_capture(Center_Freq, address)

instrreset;
% MATLAB script created by FSW: 25:01:2022 09:18:59
if class(Center_Freq)~='double'
    Center_Freq=str2double(Center_Freq);
else
    Center_Freq=Center_Freq;
end 
% connect to analyzer
analyzer_handle = visadev(address);



write(analyzer_handle, '*RST');
write(analyzer_handle, '*CLS');

write(analyzer_handle, ':INST:SEL ''Spectrum''');
pause(1);
write(analyzer_handle, [':SENS:FREQ:CENT ', num2str(Center_Freq)]);
% write(analyzer_handle, [':SENS:FREQ:CENT ', num2str(center_freq)]);
write(analyzer_handle, 'DISP:TRAC:Y:SCAL:RLEV 10');
pause(1)
write(analyzer_handle,':SENS:FREQ:SPAN 100000000');
pause(2)
write(analyzer_handle,':SENS:BAND:RES 10000');
pause(2)

write(analyzer_handle, ':INIT:CONT OFF');




write(analyzer_handle, ':CALC:MARK1:MAX:PEAK');
pause(1)
write(analyzer_handle, ':CALC:MARK1:FUNC:CENT');
pause(2)




write(analyzer_handle, 'TRAC2:DATA? TRACE1');
pause(1)
trace_data_y1 = readline(analyzer_handle);
trace_data_y1 = strsplit(trace_data_y1, ',');
trace_data_y1=(cellfun(@str2num,trace_data_y1));

write(analyzer_handle, 'TRAC2:DATA:X? TRACE1');
pause(1)
trace_data_x1 = readline(analyzer_handle);
trace_data_x1 = strsplit(trace_data_x1, ',');
trace_data_x1=(cellfun(@str2num,trace_data_x1)/1e9);





delete(analyzer_handle);
clear analyzer_handle;
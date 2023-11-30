function [PN_data_x1,PN_data_y1]=fsw_cw_phase_noise(Center_Freq, address)

instrreset;
% MATLAB script created by FSW: 25:01:2022 09:18:59
if class(Center_Freq)~='double'
    Center_Freq=str2double(Center_Freq);
else
    Center_Freq=Center_Freq;
end 
% connect to analyzer
analyzer_handle = visadev(address);

% set buffer sizes to 1 MB
% analyzer_handle.OutputBufferSize = 1000000;
% analyzer_handle.InputBufferSize  = 1000000;
% fopen(analyzer_handle);
% write(analyzer_handle, sprintf(':SYST:DISP:UPD ON'));




write(analyzer_handle, sprintf('*RST'));
write(analyzer_handle, sprintf('*CLS'));
write(analyzer_handle, ':INST:SEL ''Spectrum''');
pause(1);
write(analyzer_handle, [':SENS:FREQ:CENT ', num2str(Center_Freq)]);


write(analyzer_handle, sprintf(':SENS:FREQ:SPAN 1000000000'));
write(analyzer_handle, sprintf(':SENS:BAND 1kHz'));
write(analyzer_handle, sprintf(':TRIG:SEQ:SOUR IMM'));
write(analyzer_handle, sprintf(':SENS:POW:NCOR ON'));
write(analyzer_handle, sprintf(':CALC:MARK1:STAT ON'));
pause(1)
write(analyzer_handle, sprintf(':CALC:MARK1:MAX:PEAK'));
pause(0.5)
write(analyzer_handle, sprintf(':CALC:MARK1:FUNC:CENT'));
pause(0.5)
write(analyzer_handle, sprintf(':SENS:FREQ:SPAN 10000000'));
pause(1)
write(analyzer_handle, sprintf(':CALC:MARK1:MAX:PEAK'));
pause(0.5)
write(analyzer_handle, sprintf(':CALC:MARK1:FUNC:CENT'));
pause(0.5)
write(analyzer_handle, sprintf(':CALC:MARK1:X?'));
% center_freq = round(str2double(readline(analyzer_handle)));




center_freq = char(readline(analyzer_handle));
% 
% 
% 
write(analyzer_handle, 'INST:CRE:NEW PNO, "PN Measurement"');

% Set FSW to single-run measurements
write(analyzer_handle, ':INIT:CONT OFF');

% Set the PN measurement center frequency - Initial center frequency before sweeping
write(analyzer_handle, [':SENS:FREQ:CENT %d', center_freq]);

% Set the PN measurement frequency offset start
write(analyzer_handle, ':SENS:FREQ:START 10000');

% Set the PN measurement frequency offset stop
write(analyzer_handle, ':SENS:FREQ:STOP 100000000');

% Set the Resolution BW to 10%
write(analyzer_handle, ':SENS:LIST:BWID:RES:RAT 10'));

% Set the verify frequency to ON
write(analyzer_handle, ':SENS:FREQ:VER:STAT ON');

% Set the input attenuation to Auto
write(analyzer_handle, ':INP:ATT:AUTO AUTO');

% Set the frequency relative tolerance to 20%
write(analyzer_handle, ':SENS:FREQ:VER:TOL:REL 20');

% Set the frequency absolute tolerance to 5kHz
write(analyzer_handle, ':SENS:FREQ:VER:TOL:ABS 5000');

% Set the PN measurement mode to averaged
write(analyzer_handle, ':SENS:LIST:SWE:COUN 22');     %
% operationstatus=0;
% operationstatus= writeread(analyzer_handle,sprintf('*OPC?'));
% 
% while str2double(operationstatus)~=1
%     pause(1)
%     operationstatus= writeread(analyzer_handle,sprintf('*OPC?'));
% end 
% write(analyzer_handle, sprintf(':INIT:CONT OFF'));
% 
% 
% % write(analyzer_handle, sprintf(':DISP:FREQ STAR 100000000'));
% 
% 
% % analyzer_handle.timeout=30;
% 
write(analyzer_handle, 'TRAC1:DATA? TRACE2');
pause(2)
PN_data = readline(analyzer_handle);
pause(2)
PN_data = strsplit(PN_data, ',');
PN_data=(cellfun(@str2num,PN_data));
PN_data_x1=PN_data(1:2:end)/1e3;


PN_data_y1=PN_data(2:2:end);



% PN_data_x1=0;
% PN_data_y1=0;

delete(analyzer_handle);
clear analyzer_handle;



% PN_data_x1 = read(analyzer_handle);
% PN_data_x1 = strsplit(PN_data_x1, ',');
% PN_data_x1=(cellfun(@str2num,PN_data_x1));





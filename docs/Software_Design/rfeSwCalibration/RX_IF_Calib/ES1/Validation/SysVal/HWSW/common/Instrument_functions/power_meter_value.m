function Pmeas= power_meter_value(center_freq,Address)
instrreset;
% pause(1)
% center_freq=center_freq*1000;
% %%%%%%%%%%TX1 and TX3%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Variable declarations
% Tx1 = 0;
% Tx2 = 0;
% ch1 = 1;
% freq = center_freq;
% ch2 = 2;


% Connect steps


PMeter = visadev(Address);
% Commands

writeline(PMeter,string(strcat(':SENS1:FREQ ',{' '}, num2str(center_freq/1e9),'GHz')));
writeline(PMeter,string(strcat(':SENS2:FREQ ',{' '}, num2str(center_freq/1e9),'GHz')));
writeline(PMeter,':INIT:IMM:ALL')

pause(2)
writeline(PMeter, "FETC:SCAL?");


% fprintf(E4419B, sprintf(':SENS%u:FREQ %g', ch1, freq));
Pmeas_CH1 = str2num(readline(PMeter));

writeline(PMeter, "FETC2:SCAL?");
Pmeas_CH2 = str2num(readline(PMeter));


Pmeas=[Pmeas_CH1,Pmeas_CH2];
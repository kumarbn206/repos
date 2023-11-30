function voltage_output=Read_DMM(address)
instrreset;
Vmeas=visadev(address);

writeline(Vmeas, 'MEAS:VOLT:DC? 10,0.003');
voltage_output=str2num(readline(Vmeas));

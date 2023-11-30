function ShutDownRFPowerv2(SigGenAddress)

instrreset;

SigGen = visadev(SigGenAddress);
write(SigGen,':OUTPut1 OFF');
pause(1);

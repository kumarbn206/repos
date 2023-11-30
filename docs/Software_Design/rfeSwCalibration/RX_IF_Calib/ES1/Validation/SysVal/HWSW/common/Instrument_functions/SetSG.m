function SetSG(SetFrequency,SigGenAdress, count,SGPowerLevel)
    

    instrreset;

    SigGen = visadev(SigGenAdress);
    
    if count ==1
        write(SigGen, '*RST');
        writeline(SigGen,'SOURce1:FREQuency:MULTiplier 6');
    end 

    writeline(SigGen, string(strcat('SOURce1:FREQuency:CW ', {' '}, num2str(SetFrequency))));
    writeline(SigGen, string(strcat('POW',{' '},num2str(SGPowerLevel), 'dBm')));

    writeline(SigGen,':OUTPut1 ON');
    pause(1);

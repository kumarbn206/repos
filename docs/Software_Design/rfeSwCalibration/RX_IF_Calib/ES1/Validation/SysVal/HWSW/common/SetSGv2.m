function SetSGv2(SetFrequency,SigGenAdress, count,SGPowerLevel,onOrOff)
    

    instrreset;

    SigGen = visadev(SigGenAdress);
    
    if count ==1
        write(SigGen, '*RST');
        writeline(SigGen,'SOURce1:FREQuency:MULTiplier 1');
    end 

    writeline(SigGen, string(strcat('SOURce1:FREQuency:CW ', {' '}, num2str(SetFrequency))));
    writeline(SigGen, string(strcat('POW',{' '},num2str(SGPowerLevel), 'dBm')));
   
    if(strcmp(onOrOff,'On'))
        writeline(SigGen,':OUTPut1 ON');
    elseif(strcmp(onOrOff,'Off'))
        writeline(SigGen,':OUTPut1 Off');
    end
    pause(1);

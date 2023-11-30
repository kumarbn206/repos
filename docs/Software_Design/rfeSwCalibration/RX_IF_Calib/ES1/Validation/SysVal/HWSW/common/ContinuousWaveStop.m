function OutputStruct=ContinuousWaveStop(InputStruct)


[ error ] = rfeabstract.rfe_testContinuousWaveTransmissionStop;


if (~error)
    disp('CW mode Stop');
    
    
else
    try
        errorsRfe.ThrowError(error)
    catch ME
        disp( ME.identifier + " Error Occured " + ME.message)
    end
end 

OutputStruct.error=error;
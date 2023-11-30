function [OutputStruct] = ContinuousWaveStart(InputStruct)

profile_index = str2num(InputStruct.profile_index);

[ error ] = rfeabstract.rfe_testContinuousWaveTransmissionStart( profile_index );

OutputStruct.error = error;

if (~error)
    disp('CW mode Started');
else
    try
        errorsRfe.ThrowError(error)
    catch ME
        disp( ME.identifier + " Error Occured " + ME.message)
    end
end 

function [OutputStruct]=RadarCycleStartRfe(InputStruct)

num_cycle= InputStruct.num_of_radar_cycle;

[error ] = rfeabstract.rfe_radarCycleStart(num_cycle , 0, 0);


OutputStruct.error=error;

if (~error)
    disp('Radar Cycle Started');
    
    
else
    try
        errorsRfe.ThrowError(error)
    catch ME
        disp( ME.identifier + " Error Occured " + ME.message)
    end
    
    
end


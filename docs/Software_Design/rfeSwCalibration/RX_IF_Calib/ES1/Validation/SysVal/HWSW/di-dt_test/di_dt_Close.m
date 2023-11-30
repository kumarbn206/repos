function [OutputStruct] = di_dt_close(InputStruct)

phase='calibrate';
[OutputStruct]=post_processing_di_dt(InputStruct.result_path,phase);
phase='recalibrate';
[OutputStruct]=post_processing_di_dt(InputStruct.result_path,phase);

%% [OutputStruct] = ContinuousWaveStop(InputStruct);

end
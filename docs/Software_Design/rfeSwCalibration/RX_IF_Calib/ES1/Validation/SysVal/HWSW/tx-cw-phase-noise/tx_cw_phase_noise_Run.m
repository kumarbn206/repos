function [OutputStruct] = tx_cw_phase_noise_Run(InputStruct)

[OutputStruct] = ConfigureRfe(InputStruct);
[OutputStruct] = ContinuousWaveStart(InputStruct);

end
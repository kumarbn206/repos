function [OutputStruct] = rx_attn_over_distance_Init(InputStruct)

basepath = InputStruct.basepath; % this is the path the \Matlab folder
addpath(genpath(basepath));

StartProxyRfe(InputStruct);
ResetRfe();
LoadFwRfe(InputStruct);
SyncRfe();
OutputStruct = GetVersionRfe(InputStruct);

end
function [OutputStruct] = rx_data_loss_Init(InputStruct)

basepath = InputStruct.basepath; % this is the path the \Matlab folder
addpath(genpath(basepath));

StartProxyRfe(InputStruct);
ResetRfe();
LoadFwRfe(InputStruct);
SyncRfe();
OutputStruct = GetVersionRfe(InputStruct);

end
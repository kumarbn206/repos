% All rights are reserved. Reproduction in whole or in part is prohibited
% without the prior written consent of the copy-right owner.
% This source code and any compilation or derivative thereof is the sole
% property of NXP B.V. and is provided pursuant to a Software License
% Agreement. This code is the proprietary information of NXP B.V. and
% is confidential in nature. Its use and dissemination by any party other
% than NXP B.V. is strictly limited by the confidential information
% provisions of the agreement referenced above
%
% NXP reserves the right to make changes without notice at any time.
% NXP makes no warranty, expressed, implied or statutory, including but
% not limited to any implied warranty of merchantability or fitness for any
% particular purpose, or that the use will not infringe any third party patent,
% copyright or trademark. NXP must not be liable for any loss or damage
% arising from its use.
%
% File Name		: limited_load.m
% Author		: Dominik Huber
% Date Creation	: 09/February/2022
%
% Purpose: 
% helper function to load only certain variables from a whole workspace
% dump

function [samples, currentSystemSetting] = limited_load(filename)
    load(filename);
    %if(exist Tchirp)
    %currentSystemSetting.Tchirp = Tchirp;
    %end
    currentSystemSetting.chirpdirection = -1;
    % clearvars -except samples currentSystemSetting 
end
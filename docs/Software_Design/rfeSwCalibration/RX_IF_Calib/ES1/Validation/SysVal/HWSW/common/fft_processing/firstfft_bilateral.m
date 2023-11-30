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
% File Name		: firstfft_bilateral.m
% Author		: Dominik Huber
% Date Creation	: 09/February/2022
%
% Purpose: 
% function to perform the first fft from radar ADC data. The range plot is
% symmetric around range = 0 (for real-valued ADC input)

function [x1s] = firstfft_bilateral(x)
% fist   dimension of matrix: #sample / #distance bin
% second dimension of matrix: #chirp
% power conservation: 1/N * ||x||^2 = ||x1s||^2






N = size(x,1);
if(mod(N,2))
    fprintf("Number of samples per chirp must be even to apply this processing function");
end
HanWin_Range        = hanning(N,'periodic'); 

x_windowed = x.*HanWin_Range;
x1_ = fft(x_windowed, [], 1);

ScaleHanWin_Range   = sqrt(1/(N*sum(HanWin_Range.*HanWin_Range))); 

x1s = ScaleHanWin_Range * circshift( x1_, floor(N/2), 1 );




end
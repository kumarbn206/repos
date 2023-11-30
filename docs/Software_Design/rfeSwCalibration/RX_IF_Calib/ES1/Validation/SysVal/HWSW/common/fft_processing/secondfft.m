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
% File Name		: secondfft.m
% Author		: Dominik Huber
% Date Creation	: 09/February/2022
%
% Purpose: 
% function calculating the velocity FFT after the first FFT is already
% applied. Velocity axis can be inverted if required due to up- / downchirp

function [x2s] = secondfft(x1, invertVelocities)
% velocity FFT => only bilateral 
% power is conserved
% boolean invertVelocities  -> 'false' = no inversion
%                           -> 'true'  = inversion of the velocity FFT

% fist   dimension of matrix: #distance bin
% second dimension of matrix: #chirp / #velocity bin
% power conservation: 1/M * ||x1||^2 = ||x2s||^2


M = size(x1,2);
% if(mod(M,2))
%     fprintf("");
% end
HanWin_Velocity        = (hanning(M,'periodic'))'; 

x1_windowed = x1.*HanWin_Velocity;
x2_ = fft(x1_windowed, [], 2);

ScaleHanWin_Velocity   = sqrt(1/(M*sum(HanWin_Velocity.*HanWin_Velocity))); 

x2s = ScaleHanWin_Velocity * circshift( x2_, floor(M/2), 2 );
if(invertVelocities)
    x2s = flip(x2s, 2);
end

end
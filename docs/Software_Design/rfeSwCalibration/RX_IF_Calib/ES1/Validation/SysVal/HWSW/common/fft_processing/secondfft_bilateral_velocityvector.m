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
% File Name		: secondfft_bilateral_velocityvector.m
% Author		: Dominik Huber
% Date Creation	: 09/February/2022
%
% Purpose: 
% function calculating the velocity vector matching the output from
% 'secondfft.m'. Vector can be inverted if required. Just define if a
% up-chirp or a down-chirp is used.

function [velocity_vector] = secondfft_bilateral_velocityvector(c, Chirp_CF, Tchirp, M, chirpdirection)
% chirpdirection = +1 -> up-chirp
% chirpdirection = -1 -> down-chirp
chirpdirection = sign(chirpdirection);

ambiguous_velocity = c/(2 * Chirp_CF * Tchirp); % [meters per second] 
velocity_vector = c/(2 * Chirp_CF * M * Tchirp) * [0:1:M-1]; % [meters per second]  %(-1)*

velocity_vector = circshift(velocity_vector, floor(M/2));
velocity_vector(1:floor(M/2)) = -ambiguous_velocity + velocity_vector(1:floor(M/2)); %centering around zero must lead at pos&neg velocities
velocity_vector = (-1)*chirpdirection*velocity_vector; 

end
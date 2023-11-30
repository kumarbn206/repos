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
% File Name		: fft12processing_bilat_wrapper.m
% Author		: Dominik Huber
% Date Creation	: 09/February/2022
%
% Purpose: 
% wrapper function to calculate the first and second FFT from a given data
% "square". The output is symmetric in terms of range (-> "bilateral")
function [x1_b, x2_b, range_1b, velocities] = fft12processing_bilat_wrapper(x, currentSystemSetting)
        %% recall remaining system settings
        Freq_BW = currentSystemSetting.Freq_BW; %Freq_BW = 800e6;
        Chirp_CF = currentSystemSetting.ChirpCF; %Chirp_CF = 76.5e9;
        Tchirp = currentSystemSetting.Tchirp; %Tchirp = 30e-6;
        chirpdirection = currentSystemSetting.chirpdirection; %chirpdirection = -1;

        c=3e8;

        N = size(x,1);
        NFFT1 = N;
        M = size(x,2);
        NFFT2 = M;


        %% data processing
        x1_b = firstfft_bilateral(x);
        range_1b = firstfft_bilateral_rangevector(c, Freq_BW, N, NFFT1);

        x2_b = secondfft(x1_b, 0);
        velocities = secondfft_bilateral_velocityvector(c, Chirp_CF, Tchirp, M, chirpdirection);
end
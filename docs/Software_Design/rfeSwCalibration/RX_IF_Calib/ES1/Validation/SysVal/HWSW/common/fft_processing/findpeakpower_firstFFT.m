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
% File Name		: findpeakpower_firstFFT.m
% Author		: Dominik Huber
% Date Creation	: 09/February/2022
%
% Purpose: 
% helper function to search for a peak in the first FFT within an 
% externally defined search interval on the range axis. Only to be used in
% combination with the unilateral FFT

function [peak_pwr_1d_log, peak_idx] = findpeakpower_firstFFT(x1_u, range_1u, expected_distance_peak_center, expected_distance_peak_tolerance)
% find the peak power in the first FFT (averaged first FFT powers per range bin)    
    peak_search_bins = find(abs(range_1u - expected_distance_peak_center) < expected_distance_peak_tolerance);
    windowed_x1_u = x1_u(peak_search_bins, :);
    averaged_windowed_x1_u = mean((abs(windowed_x1_u).^2), 2);
    [peak_pwr_1D_lin, peak_idx_withinsearchrange] = max(averaged_windowed_x1_u); %linear power
    peak_pwr_1d_log = 10*log10(peak_pwr_1D_lin); %power of the peak bin in dBFs
    peak_idx = peak_search_bins(peak_idx_withinsearchrange); %bin of range_1u where the peak is located
end
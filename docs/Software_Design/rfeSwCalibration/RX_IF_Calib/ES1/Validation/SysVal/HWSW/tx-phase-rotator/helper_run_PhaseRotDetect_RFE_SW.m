% All rights are reserved. Reproduction in whole or in part is prohibited8
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
% File Name		: helper_run_PhaseRotDetect_RFE_SW.m
% Author		: Dominik Huber
% Date Creation	: 04/August/2022

% originating from:
% M:\15_STRX\8_Software\RFE_Integration_Test\rfeFW_Integration_test_RX_att 
% enuation_over_distance_editDominik.m
%
% Purpose: TX phase rotator test in loopback mode. Checks for difference 
% in set and measured phase



% close all
clear all
input_struct.Proxy_loc   = 'C:\STRX\RFEProxy\RFEProxy_V0_5_18_Modified_Dongyu\bin'; %'C:\STRX\RFEProxy\RFEProxy_V0_5_21\bin'; %'C:\STRX\RFEProxy\RFEProxy_V0_5_20\bin'; % 'C:\STRX\RFEProxy\RFEProxy_V0_5_18_Modified_Dongyu\bin';
input_struct.elfFileLoc  = 'C:\STRX\RFE_FW\SAF85xx_RFE_SW_CD_0_8_9_D220715\SAF85xx_RFE_SW_CD_0_8_9_D220715\rfe\rfeFw\bin'; %'C:\STRX\RFE_FW\SAF85xx_RFE_SW_CD_0_8_9_D220715\rfe\rfeFw\bin'; %'C:\STRX\RFE_FW\SAF85xx_RFE_SW_CD_0_8_9_D220715\rfe\rfeFw\bin'; %'C:\STRX\RFE_FW\SAF85xx_RFE_SW_EAR_0.8.8_D220624_internal\rfe\rfeFw\bin'; %'C:\STRX\RFE_FW\SAF85xx_RFE_SW_CD_0_8_9_D220715\rfe\rfeFw\bin';
input_struct.elfFileName = 'rfeFw_hw101_release_armclang';



input_struct.CODE_DATA_FILE_Path = input_struct.elfFileLoc; %'C:\STRX\RFE_FW\SAF85xx_RFE_SW_EAR_0.8.8_D220624_internal\rfe\rfeFw\bin'; %'C:\STRX\RFE_FW\SAF85xx_RFE_SW_CD_0_8_9_D220715\rfe\rfeFw\bin';
%% config file path (if you do not explicitely need then do not change the values)
CONFIG_filenames = {'C:\git\mrta-tests-strx-sysval\Matlab\HWSW\tx-phase-rotator\phase_rotator_test_RFE_FW_0_8_9\rfeConfig_PhaseRotator_Test.bin'};  %{'C:\git\mrta-tests-strx-sysval\Matlab\TestProcedures\TP_3_1\DDMA_Test\DDMA.bin'};
input_struct.dynamic_table = 'C:\git\mrta-tests-strx-sysval\Matlab\HWSW\tx-phase-rotator\phase_rotator_test_RFE_FW_0_8_9\rfeDynamicTables_PhaseRotator_Test.bin'; %'C:\git\mrta-tests-strx-sysval\Matlab\TestProcedures\TP_3_1\DDMA_Test\DDMA_dynamic_table.bin';

result_path='C:\STRX\Test_output\';
input_struct.proxy_dump_path='M:\15_STRX\10_HWSW_integration\release_testing_0_8_8\RX_attenuation_over_distance\';
% CONFIG_filename='C:\STRX\New\RFE_Integration_Test\rfeConfig_G5_G20_MR.bin';
%% for prost processing plots
%CHIRPS = 224;
%SAMPLES = 1024;


input_struct.samples = num2str(1024);
input_struct.chirps = num2str(128);
input_struct.Freq_BW = num2str(800e6);
input_struct.ChirpCF = num2str(76.5e9); %Chirp_CF = 76.5e9;
input_struct.Tchirp = num2str(38.175e-6); %Tchirp = 30e-6;
input_struct.chirpdirection = num2str(-1); %chirpdirection = -1;
input_struct.Data_bit_length = num2str(16); % pdc bit width
input_struct.sampleFreq = num2str(40e6);
input_struct.numRX = num2str(4);
input_struct.Sequences = num2str(2);

temperature_int = input("please type the current temperature as an integer number:    ");
temperature = num2str(temperature_int);

date_now = datetime(now, 'ConvertFrom', 'datenum');
date_now = string(datestr(date_now));
date_now = replace(date_now,{'-',' ',':'},'_' );
date_now = convertStringsToChars(date_now);

for k = 1:size(CONFIG_filenames, 2)
    CONFIG_filename = CONFIG_filenames{k};
    input_struct.CONFIG_filename = CONFIG_filename;
    input_struct.running_index = num2str(k);
    input_struct.save_filepath = ['M:\15_STRX\10_HWSW_integration\tx_phase_rotator_testing\', 'temp_', temperature, 'deg_', date_now, '_index_', input_struct.running_index, '.mat'];
    output_struct = run_TP_txphaserot_RFE_SW(input_struct);
end
    
%     % instant evaluation - can be skipped and done only in postprocessing
%     % phase
%     TP_6_1_postprocessing_evaluation(output_struct.save_filepath);




for k = 1:size(CONFIG_filenames, 2)


    input_struct.running_index = num2str(k);
    save_filepath = ['M:\15_STRX\10_HWSW_integration\tx_phase_rotator_testing\', 'temp_', temperature, 'deg_', date_now, '_index_', input_struct.running_index, '.mat'];
    load(save_filepath)

    peak_powers=helper_plot_all4Rx_1stFFTavg(samples, currentSystemSetting);
    sgtitle(input_struct.CONFIG_filename);
    set(gcf,'Color','w');
    set(gcf, 'Position', [100 100  1800 900]);
    print([save_filepath, '1.png'], '-dpng');

    helper_plot_all4Rx_2ndFFT(samples, currentSystemSetting, input_struct.CONFIG_filename);
    set(gcf,'Color','w');
    set(gcf, 'Position', [100 100  1800 900]);
    print([save_filepath, '2.png'], '-dpng');


    %% plot detected phase per chirp
    expected_distance_peak_center = 1.3;   %meter
    expected_distance_peak_tolerance = 0.5; %meter
    [peak_powers_integrated, phases_per_chirp, peak_idcs] = find_peak_phases(samples,currentSystemSetting, expected_distance_peak_center, expected_distance_peak_tolerance);
    
    Rx_no_for_phase_detection = 1;
    figure()
    chirp_no_of_groups = 1;
    for chirp_no_group = 1:chirp_no_of_groups   
        matrix = reshape(1:currentSystemSetting.CHIRPS, chirp_no_of_groups, []);
        relevant_chirps = matrix(chirp_no_group, :);
        subplot(1, chirp_no_of_groups, chirp_no_group)

        phase_points = 180/pi()*phases_per_chirp(relevant_chirps, Rx_no_for_phase_detection);
%         if(max(phase_points) - min(phase_points) > pi)
%             if(mean(phase_points > 0))
%                 %unwrap phase, i.e. add 360° to all negative values
%                 phase_points = phase_points + 360*(phase_points<-90);
%             else
%                 %unwrap phase, i.e. substract 360° from all positive values
%                 phase_points = phase_points - 360*(phase_points>90);
%             end
%         end

        set_phases = 360/currentSystemSetting.CHIRPS * (0:(currentSystemSetting.CHIRPS/chirp_no_of_groups - 1));
        scatter(set_phases, phase_points, 'filled');
        title({['Phase rotator test - set vs measured phases']})
        ylim([-200, +200]);
        if(chirp_no_group ==1)
            ylabel("detected phase [deg]")
        end
        xlabel("set phase [deg]");
    end

    sgtitle({"Detected phases at the receiver"; input_struct.CONFIG_filename});
    set(gcf,'Color','w');
    set(gcf, 'Position', [100 100  1600 500]);
    print([save_filepath, '_detected_phases.png'], '-dpng');



    %% plot also normalized phase. Normalization = phase of first chirp is zero

    phase_points_unwrapped = (180/pi * unwrap(pi/180 * phase_points))';
    phase_points_unwrapped_normalized = phase_points_unwrapped - phase_points_unwrapped(1);
    up_or_down_movement = sign(phase_points_unwrapped_normalized(end)); % if slope of the phase progression is either +1 or -1
    set_phases = 360/currentSystemSetting.CHIRPS * (0:(currentSystemSetting.CHIRPS/chirp_no_of_groups - 1));
    

    figure()
    scatter(set_phases, phase_points_unwrapped_normalized, 'filled');
    xlabel('set phase [deg]')
    ylabel('measured - set phase (zero-mean) [deg]')
    title('Phase rotator test - set vs measured phases (Normalized)');
    if(up_or_down_movement > 0)
        ylim([-50, 400]);
    else
        ylim([-400, 50]);
    end

    set(gcf,'Color','w');
    set(gcf, 'Position', [100 100  1600 500]);
    print([save_filepath, '_detected_phases_normalized.png'], '-dpng');



    %% plot the deviation from wished phase

    phase_points_unwrapped = (180/pi * unwrap(pi/180 * phase_points))';

    set_phases = 360/currentSystemSetting.CHIRPS * (0:(currentSystemSetting.CHIRPS/chirp_no_of_groups - 1));
    offset_of_linear_fit = mean(phase_points_unwrapped - sign(up_or_down_movement)*set_phases);
    difference_set_vs_measured = phase_points_unwrapped - sign(up_or_down_movement)*set_phases - offset_of_linear_fit;

    figure()
    scatter(set_phases, difference_set_vs_measured, 'filled');
    xlabel('set phase [deg]')
    ylabel('measured - set phase (zero-mean) [deg]')
    title('Difference (Measured - Set Phase)');

    set(gcf,'Color','w');
    set(gcf, 'Position', [100 100  1600 500]);
    print([save_filepath, '_offset_of_phases.png'], '-dpng');
end




function [peak_powers_integrated, phases_per_chirp, peak_idcs] = find_peak_phases(samples,currentSystemSetting, expected_distance_peak_center, expected_distance_peak_tolerance) 

    Tx = ' ';
    if exist('TX')
        Tx = TX;
    end
    
    
    % evaluation: peak power at expected distance
    % expected_distance_peak_center %[meters]
    % expected_distance_peak_tolerance  %[meters] ; plus/minus tolerance

    integration_depth = 1;
    
    for RxNum = 1:4
        x = samples(:, : , RxNum); %1st dim = samples, 2nd dim = chirps, 3rd dim = rx
        [x1_u, x2_u, range_1u, velocities] = fft12processing_unilat_wrapper(x, currentSystemSetting);
    
    
        [peak_pwr_1d_integrated_log, peak_idx] = findpeakpower_firstFFT_integrated(x1_u, range_1u, expected_distance_peak_center, expected_distance_peak_tolerance, integration_depth);
        peak_range = range_1u(peak_idx);
    
        peak_powers_allRx_integrated_log(RxNum) = peak_pwr_1d_integrated_log;
        peak_ranges_allRx(RxNum) = peak_range;
    
        peak_idcs(RxNum) = peak_idx;
    
        x1_u_allRx(:,:,RxNum) = x1_u;
        x2_u_allRx(:,:,RxNum) = x2_u;
    end
    %average for the peak_idx for all Rx 
    peak_idx_allRx = round(mean(peak_idcs));
    peak_powers_integrated = peak_powers_allRx_integrated_log;
    phases_per_chirp = angle(squeeze(x1_u_allRx(peak_idx_allRx, :, :)));
end


function [peak_pwr_1d_integrated_log, peak_idx] = findpeakpower_firstFFT_integrated(x1_u, range_1u, expected_distance_peak_center, expected_distance_peak_tolerance, integration_depth)
% find the peak power in the first FFT (averaged first FFT powers per range bin)   
% integration depth must be >= 0 (to select how many bins left and right of
% the peak need to be integrated)
    peak_search_bins = find(abs(range_1u - expected_distance_peak_center) < expected_distance_peak_tolerance);
    windowed_x1_u = x1_u(peak_search_bins, :);
    averaged_windowed_x1_u = mean((abs(windowed_x1_u).^2), 2);
    averaged_x1_u = mean((abs(x1_u).^2), 2);
    [peak_pwr_1D_lin, peak_idx_withinsearchrange] = max(averaged_windowed_x1_u); %linear power
    peak_pwr_1D_integrated_lin = sum(averaged_x1_u((peak_idx_withinsearchrange - integration_depth) : (peak_idx_withinsearchrange + integration_depth)));
    peak_pwr_1d_integrated_log = 10*log10(peak_pwr_1D_integrated_lin); %power of the peak bin in dBFs
    peak_idx = peak_search_bins(peak_idx_withinsearchrange); %bin of range_1u where the peak is located
end

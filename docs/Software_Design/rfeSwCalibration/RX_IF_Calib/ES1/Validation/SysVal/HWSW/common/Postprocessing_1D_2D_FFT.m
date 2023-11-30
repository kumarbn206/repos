function [D1FFT_dB,D2FFT_dB,D1FFT_complex,D2FFT_complex, peak_powers_allRx_log,range_vector,velocity_vector,phases_per_chirp,peak_idcs] = Postprocessing_1D_2D_FFT(samples,currentSystemSetting)

%%%%helper variables

exp_peak= 10; % [meter]
exp_peak_width= 5; %[meters]
integration_depth =1;

%evaluation: peak power at expected distance
expected_distance_peak_center = exp_peak; %[meters]
expected_distance_peak_tolerance = exp_peak_width; %[meters] ; plus/minus tolerance


for RxNum = 1:4
    %     D1FFT_dB{idx_ADC},D1FFT_average{idx_ADC},D2FFT_dB{idx_ADC},DFFT_complex{idx_ADC}
    samples_1RX = samples(:, : , RxNum); %1st dim = samples, 2nd dim = chirps, 3rd dim = rx
    [D1FFT_complex(:,:,RxNum) , D2FFT_complex(:,:,RxNum) , range_vector, velocity_vector] = fft12processing_unilat_wrapper(samples_1RX, currentSystemSetting);
    D1FFT_dB = 10*log10(abs(D1FFT_complex(:,1,RxNum)).^2)';
    D2FFT_dB = 20*log10((abs(D2FFT_complex(:,:,RxNum)))');
%% Find peak power
   [peak_pwr_1d_log, peak_idx] = findpeakpower_firstFFT(D1FFT_complex, range_vector, expected_distance_peak_center, expected_distance_peak_tolerance);
    peak_range = range_vector(peak_idx);

    peak_powers_allRx_log(RxNum) = peak_pwr_1d_log;
    peak_ranges_allRx(RxNum) = peak_range;
%% Integrated Part tbd
%     [peak_pwr_1d_integrated_log, peak_idx] = findpeakpower_firstFFT_integrated(D1FFT_complex, range_vector, expected_distance_peak_center, expected_distance_peak_tolerance, integration_depth);
%     peak_range = range_vector(peak_idx);
% 
%     peak_powers_allRx_integrated_log(RxNum) = peak_pwr_1d_integrated_log;
%     peak_ranges_allRx(RxNum) = peak_range;

    peak_idcs(RxNum) = peak_idx;
%% Phase

    peak_idx_allRx = round(mean(peak_idcs));
end
for RxNum = 1:4
%     peak_powers_integrated = peak_powers_allRx_integrated_log;
    phases_per_chirp(:,:,RxNum) = angle(squeeze(D1FFT_complex(peak_idx_allRx, :, RxNum)));
    
end

end
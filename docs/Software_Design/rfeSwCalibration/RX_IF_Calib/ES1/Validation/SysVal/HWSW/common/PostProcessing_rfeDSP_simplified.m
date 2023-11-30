

% function [peakloc,peak,SNR,SFDR]=PostProcessing_rfeDSP_simplified(samples, currentSystemSetting, idx_win,unit_output,start_bin,end_bin,filename_fig_1DFFT, filename_fig_2DFFT,filename_fig_1DFFT_range,Tx)

function [OutputStruct]=PostProcessing_rfeDSP_simplified(samples,currentSystemSetting,InputStruct)
%Just to make sure the variables are correct (Maybe double)
SampleNum = currentSystemSetting.samples;
ChirpNum = currentSystemSetting.CHIRPS;
Data_bit_length = currentSystemSetting.Data_bit_length;% 12bits data
SampleFreq = currentSystemSetting.sampleFreq; %Hz
Freq_Center = currentSystemSetting.ChirpCF; %hz
tChirp = currentSystemSetting.Tchirp;%us

if currentSystemSetting.Freq_BW~=0
    fSlope = currentSystemSetting.Freq_BW /currentSystemSetting.Tchirp;
end
numRX = currentSystemSetting.numRX;

exp_peak = str2double(InputStruct.exp_peak);

idx_win = str2double(InputStruct.idx_win);
unit_output = str2double(InputStruct.unit_output);
start_bin = str2double(InputStruct.start_bin);
end_bin = str2double(InputStruct.end_bin);
result_path = InputStruct.result_path;


    lpf = str2double(InputStruct.lpf) ;
    hpf = str2double(InputStruct.hpf) ;
    rxgain = str2double(InputStruct.rxgain);

% if exist(currentSystemSetting.Temperature)
    TX_temp= currentSystemSetting.Temperature;
% end




peak=[];
peakloc=[];

center_freq=Freq_Center/1e9;
if contains(num2str(center_freq), '.') == 1
    center_freq=replace(num2str(center_freq),'.','_');
end
%% Gating peak search

frequency_gates = (1:SampleNum/2)* (SampleFreq/SampleNum);
%
% freq_FFT= ((1:SampleNum/2)/SampleNum)*40e6;
% peak_area= (freq_FFT(:)< (end_bin)&(start_bin)<freq_FFT(:));
% start_bin = find  (peak_area, 1, 'first');
% end_bin =  find  (peak_area, 1, 'last');
%% FFT
for idx_ADC = 1:numRX
    Data_RawADC_all = samples';
    data2process = Data_RawADC_all(idx_ADC,:);
    % Normalize data by full scale
    Data_bit_length =12;
    Data_norm = (double(data2process)-2^(Data_bit_length-1))/2^(Data_bit_length-1);
    
    % Process data with 1stFFT and 2ndFFT
    [D1FFT_dB{idx_ADC},D1FFT_average{idx_ADC},D2FFT_dB{idx_ADC},DFFT_phase{idx_ADC}] = ...
        fft_1chn(Data_norm,SampleNum,ChirpNum,idx_win,unit_output);
    
    %% Peak search
    
    %     act_peak_bin=find (D1FFT_dB{1,idx_ADC}(1,:) == max(D1FFT_dB{1,idx_ADC}(1,start_bin:end_bin)));
    %     max_peak_search = max(D1FFT_dB{1,idx_ADC}(1,act_peak_bin));
    
    %     peakloc=[peakloc, act_peak_bin];
    %     peak=[peak,max_peak_search];
    %
    %         OT_Peak_data.Peak(cnt_loop_Temperature,idx_ADC)= [max_peak_search];
    %         OT_Peak_data.index_peak(cnt_loop_Temperature,idx_ADC)= [act_peak_bin];
    % %         OT_Peak_data.temp(cnt_loop_Temperature,idx_ADC) = temperature_immediately1 / RFE_TEMPERATURE_1_DEG_CELSIUS;
end
%     cnt_loop_Temperature= cnt_loop_Temperature+1;
%     pause (30)

%% Plotting (In future in own mat file)
f1=figure(1)

for idx_ADC = 1:numRX
    subplot (2,2,idx_ADC)
    data2plot = Data_RawADC_all(idx_ADC,:);
    data2plot = data2plot(1:SampleNum);
    plot(data2plot)
    
    grid on;grid minor; axis tight;
    dispstr=strcat('ADC',num2str(idx_ADC));
    xlabel("Sample Index");ylabel("ADC Raw Value");
    title(dispstr);
    %         hold on
end
sgtitle("Time Domain");
f1.WindowState = 'maximized';

% 1st FFT
f2=figure(2)
values_peak=[];
values_3_peak=[];
for idx_ADC = 1:numRX
    subplot(2,2,idx_ADC)
    data2plot = D1FFT_average{idx_ADC};
    plot(frequency_gates/1e6,data2plot)
    
    
    if unit_output==1
        xlabel("Frequency[MHz]");ylabel("Spectrum[dBm]");
    else
        xlabel("Frequency[MHz]");ylabel("Spectrum[dBFs]");
    end
    grid on;grid minor; axis tight;
    dispstr= strcat('RX',num2str(idx_ADC));
    title(dispstr);
end

dispstr=strcat('IF Frequency vs Peak power Center freq',(center_freq), 'GHz') ;
dispstr = 'Averaged FFT';
sgtitle(dispstr);

% if exist(InputStruct.lpf)
%     if exist(currentSystemSetting.Temperature)
%         TX_temp= currentSystemSetting.Temperature;
        filename_fig_1DFFT= strcat(result_path,'IF_Frequency_over_peak_power_',(center_freq),'_GHz_exp_peak_',num2str(exp_peak),'m_lpf_',num2str(lpf),'MHz_hpf',num2str(hpf),'_rxgain_',num2str(rxgain),'dB_temperature',num2str(TX_temp));
        
%     else
%         filename_fig_1DFFT= strcat(result_path,'IF_Frequency_over_peak_power_',(center_freq),'_GHz_exp_peak_',num2str(exp_peak),'m_lpf_',num2str(lpf),'MHz_hpf',num2str(hpf),'_rxgain_',num2str(rxgain),'dB' );
%     end
% else
%     if exist(currentSystemSetting.Temperature)
%         TX_temp= currentSystemSetting.Temperature;
%         filename_fig_1DFFT= strcat(result_path,'IF_Frequency_over_peak_power_',(center_freq),'_GHz_temperature',num2str(TX_temp));
%     else
%         filename_fig_1DFFT= strcat(result_path,'IF_Frequency_over_peak_power_',(center_freq),'_GHz');
%     end
%     
% end
% 
f2.WindowState='maximized';
saveas(f2,filename_fig_1DFFT,'fig');

if currentSystemSetting.Freq_BW ~=0
    % Generate Coodination
    [distance_gates,velocity_gates,frequency_gates] = ...
        generate_coordination(SampleFreq,SampleNum,ChirpNum,Freq_Center,tChirp,fSlope);
    
    
    [X, Y] = meshgrid(distance_gates, velocity_gates);
    
    f3=figure(3)
    values_peak=[];
    values_3_peak=[];
    for idx_ADC = 1:numRX
        subplot(2,2,idx_ADC)
        data2plot = D1FFT_average{idx_ADC};
        plot(distance_gates,data2plot)
        
        
        if unit_output==1
            xlabel("Distance[m]");ylabel("Spectrum[dBm]");
        else
            xlabel("Distance[m]");ylabel("Spectrum[dBFs]");
        end
        grid on;grid minor; axis tight;
        dispstr= strcat('RX',num2str(idx_ADC));
        title(dispstr);
    end
    
    %sgtitle('Average FFT')
    f3.WindowState='maximized';
    dispstr=strcat('Distance vs Peak power Center freq',(center_freq), 'GHz');
    sgtitle(['Average FFT', dispstr]);
%     if exist(InputStruct.lpf)
%         if exist(currentSystemSetting.Temperature)
%             TX_temp= currentSystemSetting.Temperature;
            filename_fig_1DFFT_range= strcat(result_path,'Distance_over_peak_power_',(center_freq),'_GHz_exp_peak_',num2str(exp_peak),'m_lpf_',num2str(lpf),'MHz_hpf',num2str(hpf),'_rxgain_',num2str(rxgain),'dB_temperature',num2str(TX_temp));
%         else
%             filename_fig_1DFFT_range= strcat(result_path,'Distance_over_peak_power_',(center_freq),'_GHz_exp_peak_',num2str(exp_peak),'m_lpf_',num2str(lpf),'MHz_hpf',num2str(hpf),'_rxgain_',num2str(rxgain),'dB');
%         end
%     else
%         if exist(currentSystemSetting.Temperature)
%             TX_temp= currentSystemSetting.Temperature;
%             filename_fig_1DFFT_range= strcat(result_path,'Distance_over_peak_power_',(center_freq),'_GHz_temperature',num2str(TX_temp) );
%             
%         else
%             filename_fig_1DFFT_range= strcat(result_path,'Distance_over_peak_power_',(center_freq),'_GHz' );
%         end
%     end
%     
    
    saveas(gcf,filename_fig_1DFFT_range);
    
    
    
    % Velocity vs Distance
    f4=figure(4)
    clf();
    for idx_ADC = 1:numRX
        subplot(2,2,idx_ADC)
        
        data2plot = D2FFT_dB{idx_ADC};
        %     h = pcolor(X, Y, data2plot);
        %      imagesc(Y,data2plot)
        
        h = surf(X, Y, data2plot)';
        h.EdgeColor = 'none';
        caxis([-120 0]);
        colormap turbo
        c = colorbar;
        c.Location = 'eastoutside';
        c.Label.String = 'signal amplitude [dBFs / bin]';
        xlabel("range [m]")
        ylabel("velocity [m/s]")
        zlabel("signal amplitude [dBFs / bin]");
        title(['Rx', num2str(idx_ADC)]);
        view(0,90);
        axis tight
    end
    grid on;grid minor; axis tight;
    
%     if exist(currentSystemSetting.Temperature)
%         TX_temp= currentSystemSetting.Temperature;
        dispstr=strcat('Distance Vs Radial Velocity Center freq',(center_freq), 'GHz\_Temperature',TX_temp, '°C');
%     else
%         
%         dispstr=strcat('Distance Vs Radial Velocity Center freq',(center_freq), 'GHz');
%         
%     end
%     
    sgtitle(dispstr);
    f4.WindowState='maximized';
%     if exist(InputStruct.lpf)
%         if exist(currentSystemSetting.Temperature)
%             TX_temp= currentSystemSetting.Temperature;
            filename_fig_2DFFT=strcat(result_path,'Doppler_',(center_freq),'_GHz_exp_peak_',num2str(exp_peak),'m_lpf_',num2str(lpf),'MHz_hpf',num2str(hpf),'_rxgain_',num2str(rxgain),'dB_Temperature',num2str(TX_temp));
            
%         else
%             filename_fig_2DFFT=strcat(result_path,'Doppler_',(center_freq),'_GHz_exp_peak_',num2str(exp_peak),'m_lpf_',num2str(lpf),'MHz_hpf',num2str(hpf),'_rxgain_',num2str(rxgain),'dB');
%         end
%     else
%         if exist(currentSystemSetting.Temperature)
%             TX_temp= currentSystemSetting.Temperature;
%             
%             filename_fig_2DFFT=strcat(result_path,'Doppler_',(center_freq),'_GHz_Temperature',num2str(TX_temp));
%         else
%             filename_fig_2DFFT=strcat(result_path,'Doppler_',(center_freq),'_GHz');
%             
%         end
%         
        
        saveas(f4,filename_fig_2DFFT,'fig')
        saveas(f4,filename_fig_2DFFT,'png')
%     end
end 
    
    for idx_ADC=1: numRX
        
        start_noise_calc =1e6; %frequency in MHz
        end_noise_calc = 15e6;
        
        
        
        %% Peaksearch
        
        freq_FFT= ((1:SampleNum/2)/SampleNum)*40e6;
        peak_area= (freq_FFT(:)< (end_bin)&(start_bin)<freq_FFT(:));
        start_bin_peak = find  (peak_area, 1, 'first');
        end_bin_peak =  find  (peak_area, 1, 'last');
        
        act_peak_bin=find (D1FFT_average{1,1}(1,:) == max(D1FFT_average{1,1}(1,start_bin_peak:end_bin_peak)));
        max_peak = max(D1FFT_average{1,1}(1,act_peak_bin));
        
        %% Noise Calc
        peak_area_noise= (freq_FFT(:)< (end_noise_calc)&(start_noise_calc)<freq_FFT(:));
        start_bin_noise = find  (peak_area_noise, 1, 'first');
        end_bin_noise =  find  (peak_area_noise, 1, 'last');
        
        if start_noise_calc < start_bin
            
            D1FFT_noise_floor_average_1{idx_ADC} =sum ( D1FFT_average{idx_ADC}(start_bin_noise:(act_peak_bin-5)))/length(D1FFT_average{idx_ADC}(start_bin_noise:(act_peak_bin-5)));
            D1FFT_noise_floor_average_2{idx_ADC} =sum ( D1FFT_average{idx_ADC}((act_peak_bin+5):end_bin_noise))/length(D1FFT_average{idx_ADC}((act_peak_bin+5):end_bin_noise));
            D1FFT_noise_floor_average{idx_ADC} = (D1FFT_noise_floor_average_1{idx_ADC} +D1FFT_noise_floor_average_2{idx_ADC}) /2
            
            D1FFT_noise_peak1{idx_ADC} = max ( D1FFT_average{idx_ADC}(start_bin_noise:(act_peak_bin-5)))/length(D1FFT_average{idx_ADC}(start_bin_noise:(act_peak_bin-5)))
            D1FFT_noise_peak2{idx_ADC} =sum ( D1FFT_average{idx_ADC}((act_peak_bin+5):end_bin_noise))/length(D1FFT_average{idx_ADC}((act_peak_bin+5):end_bin_noise));
            D1FFT_noise_peak{idx_ADC} =max (or (D1FFT_noise_peak1{idx_ADC} , D1FFT_noise_peak2{idx_ADC}  ));
        else
            D1FFT_noise_floor_average{idx_ADC} =sum ( D1FFT_average{idx_ADC}(start_bin_noise:end_bin_noise))/length(D1FFT_average{idx_ADC}(start_bin_noise:end_bin_noise));
            D1FFT_noise_peak{idx_ADC} =max (D1FFT_average{idx_ADC}(start_bin_noise:end_bin_noise));
        end
        
        %% SNR
        
        OutputStruct.peakloc{idx_ADC}=act_peak_bin;
        OutputStruct.peak{idx_ADC}=max_peak;
        OutputStruct.SNR{idx_ADC} = max_peak-D1FFT_noise_floor_average{idx_ADC};
        OutputStruct.SFDR{idx_ADC} = max_peak-D1FFT_noise_peak{idx_ADC};
        
    end
    
    

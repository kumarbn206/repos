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
% File Name		:StandardProcessing.m
% Author		:Sudarsh Suresh Mallaya
% Date Creation	:2/June/2022
% Last Modify	:2/June/2022
% Purpose: 
% 1. TO postprocess raw adc data obtained from RFEproxy capture
%
% Revision History:
% 0.1 20/May/2022 Create the file & name with StandardProcessing.m 
% 0.2 01/September/2022 
% load params

samplesPerChirp=currentSystemSetting.samples;
effectiveSamplingFrequency=currentSystemSetting.sampleFreq;
Deci=currentSystemSetting.Deci;
Freq_BW=currentSystemSetting.chirpBW;

tAcq=currentSystemSetting.Tacq;
Freq_Center=currentSystemSetting.ChirpCF;
tChirp= currentSystemSetting.Tchirp;
chirpCount=currentSystemSetting.CHIRPS;
c=3e8;
Controls.start_bin=4;


fd_xaxis = (1:samplesPerChirp/2)* ((effectiveSamplingFrequency/Deci)/samplesPerChirp) ;
% chirp slope
fSlope = Freq_BW/(tAcq*1E-6);

% Coordiation Values
distance_gates = c* effectiveSamplingFrequency/2/fSlope/2 * (0:samplesPerChirp/2-1)/(samplesPerChirp/2);
velocity_gates = 3.6* c/(Freq_Center*2*tChirp*1E-6)  * ((-chirpCount/2:chirpCount/2-1)/chirpCount); %km/h

%grid corrdinates points.
[X,Y] = meshgrid(distance_gates,velocity_gates);


% out_file = strcat(path_all.save_folder,path_all.save_folder_name,'_',string(Loop_Info.num_repeat-1),'.bin');

% outfile= 'C:/STRX/temp/out.bin'
% f = fopen(out_file);
% data = fread(f, 'int16');
% fclose(f);
% data = double(data)/2^15;

rawdata_1 = data';
rawdata = reshape(rawdata_1, samplesPerChirp, chirpCount, 4);

figure('Renderer', 'painters', 'Position', [10 10 1600 900])
clf();
subplot(2,2,1)
%rawdata - 
plot(rawdata(:,end,1)); hold on;
plot(rawdata(:,end,2));
plot(rawdata(:,end,3));
plot(rawdata(:,end,4));
hold off; grid on; axis tight;
legend(["ADC1","ADC2","ADC3","ADC4"]);
title("Time Domain"); xlabel("SamplesNum"); ylabel("Amplitude in Digital Number");

subplot(2,2,2);

window1 = repmat(hann(samplesPerChirp),1,chirpCount,4);
window2 = repmat(hann(chirpCount)',samplesPerChirp/2,1,4);


firstFftOut = fft(rawdata.*window1, samplesPerChirp, 1)/samplesPerChirp;
firstFftOut = firstFftOut(1:floor(end/2),:,:);
firstFftOutPower = 20*log10(abs(firstFftOut) + 10^(-10));

%findpeak val
[pks,pks_bin,w,p_snr] = findpeaks(firstFftOutPower(:,1,1),'MinPeakProminence',30); 
[pkval,pkidx] = max(pks);
targetpk_bin = pks_bin(pkidx);

p = plot(fd_xaxis/1e6,firstFftOutPower(:,end,1)); hold on;
plot(fd_xaxis/1e6,firstFftOutPower(:,end,2));
plot(fd_xaxis/1e6,firstFftOutPower(:,end,3));
plot(fd_xaxis/1e6,firstFftOutPower(:,end,4));

hold off; grid on; axis tight;
legend(["ADC1","ADC2","ADC3","ADC4"]);
title(['range spectrum, target pk: ',num2str(round(pkval)),' dBFs, SNR: ',num2str(round(p_snr(pkidx))),' dB']);
xlabel("IF freq (MHz)");
ylabel("dbFS");

dt = datatip(p,pkval,fd_xaxis(targetpk_bin));
datatip(p,pks(2),fd_xaxis(pks_bin(2)));

subplot(2,2,3)
spectrum = fftshift(fft(firstFftOut.*window2, chirpCount, 2),2)/chirpCount;
power_spectrum = 20*log10(abs(spectrum + 10^(-10)));

% Plot 2nd FFT ( range doppler spectrum )
subplot(2,2,3)
h = pcolor(X,Y,transpose(power_spectrum(:,:,1)));
colormap(jet);
colorbar;
set(h, 'EdgeColor', 'none');
xlabel("Distance [m]");
ylabel("Radial Velocity [km/h]")
title("Distance vs Velocity");

% Plot 2nd FFT ( doppler slice at peak target range bin )
subplot(2,2,4);
bin_num = find(firstFftOutPower==max(firstFftOutPower(Controls.start_bin:end,1,1)));
plot(velocity_gates,power_spectrum(firstFftOutPower==max(firstFftOutPower(Controls.start_bin:end,1,1)),:,1));

title(char(strcat('Doppler Spectrum at:  ',num2str(distance_gates(firstFftOutPower==max(firstFftOutPower(Controls.start_bin:end,1,1)))),'m bin:',num2str(bin_num))));
grid on; grid minor; xlabel('Velocity [km/h]'); ylabel('Amplitude [dBFs]'); axis tight;

% filename = char(strcat(path_all.LoopInfo_folder,'StandardProcessing.png'));
% saveas(gcf,filename);

fprintf('\n[Info] Complete Cascaded Standard Processing \n');

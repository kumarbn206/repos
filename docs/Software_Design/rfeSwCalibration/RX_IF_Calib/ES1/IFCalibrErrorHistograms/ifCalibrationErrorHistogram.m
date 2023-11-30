user = 'MG';

hpf1_tgt = 400000;
hpf2_tgt = 1183000;
hpf_tgt  = 800000;
gain1_tgt = 10.000000;
gain2_tgt = 7.079458;
gain_tgt = 70.79458;
lpf_tgt  = 25000000;

if strcmp(user,'MG')
    dataNameLocation =  'Z:\STRX\';
else
%     dataNameLocation = '\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-4294\'
end

hpf1Str  = readMemToWords([dataNameLocation 'hpf1.txt']);
hpf1     = double(hex2dec(hpf1Str));
hpf2Str  = readMemToWords([dataNameLocation 'hpf2.txt']);
hpf2     = double(hex2dec(hpf2Str));
gain1Str = readMemToWords([dataNameLocation 'gain1.txt']);
gain1    = typecast(hex2num(gain1Str),'single');
gain1    = gain1(2:2:end);
gain2Str = readMemToWords([dataNameLocation 'gain2.txt']);
gain2    = typecast(hex2num(gain2Str),'single');
gain2    = gain2(2:2:end);
ifLpfStr = readMemToWords([dataNameLocation 'lpf.txt']);
ifLpf    = double(hex2dec(ifLpfStr));
mixStr   = readMemToWords([dataNameLocation 'mix.txt']);
mix      = double(hex2dec(mixStr));
    
%% DERIVATIVE COMBINED RESULTS
gainTot  = gain1 .* gain2;
hpfTot   = hpf_est(hpf1, hpf2);
lpfTot   = lpf_est(ifLpf, mix);

%% LOAD THE STORED DATA IF NEEDED

err_hpf1 = (hpf1 - hpf1_tgt)/hpf1_tgt * 100;
err_hpf2 = (hpf2 - hpf2_tgt)/hpf2_tgt * 100;
err_hpf  = (hpfTot - hpf_tgt)/hpf_tgt * 100;

% err_ifLpf  = (ifLpf - mean(ifLpf))/mean(ifLpf) * 100;
% err_mix  = (mix - mean(mix))/mean(mix) * 100;
err_lpf  = (lpfTot - mean(lpf_tgt))/mean(lpf_tgt) * 100;

err_gain1 = 20*log10(gain1/gain1_tgt);
err_gain2 = 20*log10(gain2/gain2_tgt);
err_gain  = 20*log10(gainTot/gain_tgt);

figure
histogram(err_hpf1, 'NumBins', 40, 'BinLimits', [-12 12]);
title('Stage1 HPF error histogram');
xlabel('Error [%]')
std(err_hpf1)
figure
histogram(err_hpf2, 'NumBins', 40, 'BinLimits', [-12 12]);
title('Stage2 HPF error histogram');
xlabel('Error [%]')
std(err_hpf2)
figure
histogram(err_hpf, 'NumBins', 40, 'BinLimits', [-12 12]);
title('Combined HPF error histogram');
xlabel('Error [%]')
std(err_hpf)
figure
histogram(err_gain1, 'NumBins', 40, 'BinLimits', [-1 1]);
title('Stage1 Gain error histogram');
xlabel('Error [dB]')
std(err_gain1)
figure
histogram(err_gain2, 'NumBins', 40, 'BinLimits', [-1 1]);
title('Stage2 Gain error histogram');
xlabel('Error [dB]')
std(err_gain2)
figure
histogram(err_gain, 'NumBins', 40, 'BinLimits', [-1 1]);
title('Combined Gain error histogram');
xlabel('Error [dB]')
std(err_gain)
figure
histogram(ifLpf, 'NumBins', 40);
title('IF LPF histogram');
xlabel('IF LPF [Hz]')
std(ifLpf)
figure
histogram(mix, 'NumBins', 40);
title('Mixer pole histogram');
xlabel('Mixer pole [Hz]')
std(mix)
figure
histogram(err_lpf, 'NumBins', 40, 'BinLimits', [-10 10]);
title('Combined LPF error histogram');
xlabel('Error [%]')
std(err_lpf)



function words = readMemToWords( filepath )
    rawDataBytes = importfileFromInput(filepath);
    rawDataBytes = reshape(rawDataBytes', [size(rawDataBytes,2)*size(rawDataBytes,1) 1]);
    words = strcat(rawDataBytes(4:4:end), rawDataBytes(3:4:end), rawDataBytes(2:4:end), rawDataBytes(1:4:end));
end

function hpf_val = hpf_est(hpf1, hpf2)
    hpf1_sq = hpf1.^2;
    hpf2_sq = hpf2.^2;
    a       = 3;
    b       = - (hpf1_sq + hpf2_sq);
    c       = - hpf1_sq .* hpf2_sq;
    det     = b.^2 - 4*a*c;
    hpf_val_sq ...
            = .5*(-b + sqrt(det))/a;
    hpf_val = sqrt(hpf_val_sq);
end

function lpf_val = lpf_est(lpf1, lpf2)
    lpf1_sq = lpf1.^2;
    lpf2_sq = lpf2.^2;
    a       = 1;
    b       = lpf1_sq + lpf2_sq;
    c       = - lpf1_sq .* lpf2_sq;
    det     = b.^2 - 4*a*c;
    lpf_val_sq ...
            = .5*(-b + sqrt(det))/a;
    lpf_val = sqrt(lpf_val_sq);
end
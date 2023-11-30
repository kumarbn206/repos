function [D1_out,D1_avg,D2_out,D1_phase] = fft_1chn(Data_in,Num_sample,Num_chirp,idx_window,unit)
% This function calculate the 1st FFT and 2nd FFT
% Input: Data_in is the Normallized Full Scale raw data in vector
% Value Range[-1,1] Vector Length:Num_sample*Num_chirp
% Input: Num_sample is the number of samples in a chirp
% Value Range[0,~]
% Input: Num_chirp is the number of chirps in a sequence
% Value Range[0,~]
% Input: idx_window Windowing function index 0
% Value Range[0,8]
% 0-None;1-flattop;2-kaiser;3-hamming;4-blackman;5-bartlett
% 6-chebshev;7-rectangular;8-hanning window
% Input: unit is the unit of FFT result 1: dBm, 2: dBFs
% Output: D1_out is first FFT result in [dBm/dBFs],
%         size [Num_sample/2,Num_chirp]
% Output: D1_avg is the average output of 1st FFT in [dBm/dBFs]
%         size [Num_sample/2, 1]
% Output: D1_phase is the phase info of first FFT result in deg.
% Output: D2_out is second FFT result in [dBm/dBFs],
%         size [Num_sample/2,Num_chirp]
switch unit
    case 1
        % Full scale to voltage factor
        f_fs2v = 1.2;

        % Normalization to voltage [V]
        Data_norm = Data_in * (f_fs2v/2);

    case 2

        % Normalization to voltage [V]
        Data_norm = Data_in;
end

% Reshape data from vector to array
Data_arr = reshape(Data_norm,Num_sample,Num_chirp).';


% Create Windowing vector for 1st FFT
switch idx_window
    case 0
        single_win = 1;
        v_win_single = 1;
    case 1
        single_win = flattopwin(Num_sample);
        v_win_single = flattopwin(Num_chirp);
    case 2
        single_win = kaiser(Num_sample,9);
        v_win_single = kaiser(Num_chirp,9);
    case 3
        single_win = hamming(Num_sample);
        v_win_single = hamming(Num_chirp);
    case 4
        single_win = blackman(Num_sample);
        v_win_single = blackman(Num_chirp);
    case 5
        single_win = bartlett(Num_sample);
        v_win_single = bartlettn(Num_chirp);
    case 6
        single_win = chebwin(Num_sample,60);
        v_win_single = chebwin(Num_chirp,60);
    case 7
        single_win =  rectwin(Num_sample);
        v_win_single = rectwin(Num_chirp);
    case 8
        single_win =  hann(Num_sample);
        v_win_single = hann(Num_chirp);
end

dWin = kron(ones(Num_chirp,1),transpose(single_win));

% Window compensation ratio
dComp = mean(single_win);

% Windowed input signal
Data_1win = Data_arr .* dWin;

% 1st FFT and normalize

D_1fft = fft(Data_1win.',Num_sample) / Num_sample / dComp;

switch unit
    case 1
        % Take half of the 1st FFT spectrum
        % Num_saple/2 samples in total. Multiply with 2 to get the full power
        D_1fft = D_1fft.';
        D_1fft(:,2:Num_sample/2) = 2 * D_1fft(:,2:Num_sample/2);
        D_1fft = D_1fft(:,1:Num_sample/2);
        % Convert to Power [W]
        D_1fft_W = (abs(D_1fft).^2)/100;

        % Get Average Value of Chirps
        D_1fft_avg = mean(D_1fft,1);
        D_1fft_avg = (abs(D_1fft_avg).^2)/100; % into power

        dbm_compensate = 30;

    case 2
        % Take half of the 1st FFT spectrum
        % Num_saple/2 samples in total. Multiply with 2 to get the full power
        D_1fft = D_1fft.';
        D_1fft(:,2:Num_sample/2) =2 * D_1fft(:,2:Num_sample/2);
        D_1fft = D_1fft(:,1:Num_sample/2);
        % Convert to squared volatage
        D_1fft_W = (abs(D_1fft).^2);

        % Get Average Value of Chirps
        D_1fft_avg = mean(D_1fft,1);
        D_1fft_avg = (abs(D_1fft_avg).^2); % into power

        dbm_compensate = 0;

end
D1_phase = angle(D_1fft)*180/pi;

% Convert to [dBm]
D1_out = 10 * log10(D_1fft_W) + dbm_compensate;
D1_avg = 10 * log10(D_1fft_avg) + dbm_compensate;

% Create Windowing vector for 2nd FFT
vWin = kron(ones(1,Num_sample/2),v_win_single);

% Window compensation ratio
vComp = mean(v_win_single);

% Windowed 1fft result
D_2win = D_1fft .* vWin;

%fftshift(in,1) does shift on each column, and normalize
D_2fft = fftshift(fft(D_2win,Num_chirp)/double(Num_chirp)/vComp, 1);

switch unit
    case 1
        % Convert to Power [W]
        D_2fft_W = (abs(D_2fft).^2)/100;
    case 2
        D_2fft_W = (abs(D_2fft).^2);
end

% Convert 2nd FFT to dBm
D2_out = 10 * log10(abs(D_2fft_W)) + dbm_compensate;

end

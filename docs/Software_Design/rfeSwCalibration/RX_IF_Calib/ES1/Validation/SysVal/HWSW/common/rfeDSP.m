% All rights are reserved. Reproduction in whole or in part is prohibited
% without the prior written consent of the copy-right owner.
% This source code and any compilation or derivative thereof is the sole
% property of NXP B.V. and is provided pursuant to a Software License
% Agreement. This code is the proprietary information of NXP B.V. and
% is confidential in natrue. Its use and dissemination by any party other
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
% File Name		:rfeDSP.m
% Author		:Dongyu Gao
% Date Creation	:07/Jan/2022
% Last Modify	:07/Jan/2022
% Purpose: A class of functions for Radar RFE Digital Signal Processing 
%
% Revision History:
% 07/Jan/2022 Init the file


classdef rfeDSP
   methods
       function [Data_norm] = norm2fs(obj,Data_in,Data_bit_length)
           % This function normalize the Raw ADC data with data full scale
           % Input: Data_in is the raw data from PDC, 0~2^(Data_bit_length)
           % Input: Data_bit_length is the raw data bit
           % length,e.g.12bits,14bits, 16bits...
           % Ouput: Data_norm is the data that normalized by full scale
           Data_norm = (double(Data_in)-2^(Data_bit_length-1))/2^(Data_bit_length-1);
       end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

       function [D1_out,D1_avg,D2_out,D1_phase] = fft_1chn(obj,Data_in,Num_sample,Num_chirp,idx_window,unit)
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
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
       function [distance_gates,velocity_gates,frequency_gates] = generate_coordination(obj,SampleFreq,SampleNum,ChirpNum,Freq_Center,tChirp,fSlope)
           % This function generate distance, velocity and frequency
           % coordinations for ploting
           % Input: SampleFreq, (ADC) sample frequency in Hz
           % Input: SampleNum, Sample per chirp after decimation
           % Input: ChirpNum, Chirp number per sequence
           % Input: Freq_Center, center frequency of the chirp in Hz
           % Input: tChirp, Chirp duration in us
           % Input: fSlope, Chirp aquisition slope in Hz/s
           
           % Output: distance_gates, vector of distance coordination
           % Output: velocity_gates, vector of velocity coordination
           % Output: frequency_gates, vector of frequency coordination
           
           %light Speed
          c = 299792458;
          distance_gates = c * SampleFreq / 2 / fSlope / 2 * (0:SampleNum / 2 - 1) / (SampleNum / 2); %m
          velocity_gates = 3.6 * c / (double(Freq_Center) * 2 * double(tChirp)  * 1E-6) * ((-ChirpNum/ 2:ChirpNum / 2 - 1) / ChirpNum); %km/h
          frequency_gates = (1:SampleNum/2)* (SampleFreq/SampleNum) ;
       end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
       function [ array_out ] = unlimitPhase(obj,array_in)
           % This function is to unlimit the phase info from 2pi, and make
           % the phase value looks continuous.
           % Input: array_in, array of phase of each channel
           % Array size: [channel_num, chirpnum*samplenum*sequencenum*framenum]
           % Output: array_out, unlimited array of phase of each channel
           % Array size: has the same size as input.
           
            array_diff = zeros(size(array_in));
            array_diff(:,2:end) = array_in(:,2:end)-array_in(:,1:end-1); 
            for i = 1:size(array_in,1)
                j = 1;
                while j <= size(array_in,2)
                    if array_diff(i,j) > 180
                        array_in(i,j:end) = array_in(i,j:end)-360;
                        array_diff(i,2:end) = array_in(i,2:end)-array_in(i,1:end-1);
                    elseif array_diff(i,j) < -180
                        array_in(i,j:end) = array_in(i,j:end)+360;
                        array_diff(i,2:end) = array_in(i,2:end)-array_in(i,1:end-1);
                    else
                        j = j + 1;
                    end
                end

            end
               
            array_out = array_in;
        end
    end
end
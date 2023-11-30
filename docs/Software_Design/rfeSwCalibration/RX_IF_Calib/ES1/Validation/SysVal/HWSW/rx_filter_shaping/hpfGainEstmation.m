%% Funciton to estimate HPF cutoff frequency by interpolation
% Authors : Javier Cuadros Linde & Maxim Kulesh
function fc_hpf = hpfGainEstmation(selectedMesurement,chirpSlope,MaxCG,IFFreqSweep,G)
    %% Preallocation
    GainHPF = G;
    % Indexes to search the HPF fc 
    indexLow = 2;
    indexHigh = 1;

    %% Calculations
    if strcmp(chirpSlope,'falling')
        indx = (IFFreqSweep >= 5e6) &  (IFFreqSweep < 10e6);
    else % case for rising
        indx = (IFFreqSweep <= -5e6) &  (IFFreqSweep > -10e6);
    end

    % Average max gain
    G(selectedMesurement) = mean(MaxCG(selectedMesurement,indx));
    % Get Gmax -6dB
    GainHPF(selectedMesurement) = G(selectedMesurement) - 6;
    % Find freq index where Gmax - 6dB occurs
    idxAbove = (MaxCG(selectedMesurement,:) > GainHPF(selectedMesurement) );
    if strcmp(chirpSlope,'rising')
        idxNegAbove = IFFreqSweep <= 0 & idxAbove;
        indxHPF = find(idxNegAbove ==1, 1, 'last');
    else % case for falling
        idxPosAbove = IFFreqSweep >= 0 & idxAbove;
        indxHPF = find(idxPosAbove ==1, 1, 'first');
    end

    % Select subranges of IF sweep and HPF cut off to interpolate in to
    % find HPF real cutoff
    IFFreqSweepHPF = IFFreqSweep(indxHPF-indexLow:indxHPF+indexHigh);
    HPFcg = MaxCG(selectedMesurement,indxHPF-indexLow:indxHPF+indexHigh);

    % Interpolate using MSE 
    M = [ ones(size(IFFreqSweepHPF)) ; IFFreqSweepHPF ; IFFreqSweepHPF.^2 ];
    bCoeffs = M'\ HPFcg';
    
    % GainHPF = b0 + b1 *f + b2*f^2 -> 0 = b0-GainHpf + b1 *f + b2*f^2
    freqFittedPolynom = [ bCoeffs(1)-GainHPF(selectedMesurement), bCoeffs(2), bCoeffs(3) ];
    % f => standard quadratic formula
    fc_hpf = roots(flip(freqFittedPolynom));
    
    % From quadratic we use solution 2 which is closest to zero
    fc_hpf = fc_hpf(2); 


end
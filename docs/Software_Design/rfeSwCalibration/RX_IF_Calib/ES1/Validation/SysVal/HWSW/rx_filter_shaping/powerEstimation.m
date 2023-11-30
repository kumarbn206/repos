%% Function to estimate the power at the RX for setup
% Pin: SMB power level at screen in dBm
% Attenuator: attenuation set in the attenuator in dB
function P_dBm = powerEstimation(Pin,Attenuator)

    % SMB power level at screen
    Psmb_out = Pin; %dBm
    % SMB power level added as output
    Psmb_level = 7;%dBm
    % SMB power added to compensate cable losses
    Psmb_losscompensation = 3;%dBm
    % SMB unknown gain... I don't know where this comes from
    Psmb_x = 3.2;%dBm
    % Attenuator Attenuation
    Att = Attenuator;%dB < 0
    if Att > 0
        % Ensure Att always negative
        Att = -1*Att;
    end
    % Power being delivered by the Signal generator plus mixer (Signal gen + SMB)
    SGPowerLevel = Psmb_out + Psmb_level + Psmb_losscompensation *0 + Psmb_x;
    % Power at the receiver
    Prx = SGPowerLevel + Att - Psmb_losscompensation - Psmb_x - 4;
    
    P_dBm = Prx;
end
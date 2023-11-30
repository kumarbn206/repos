%% house keeping
% clear;
% close all;

%%

figure('Name','stage 1 freq HPF')
min(stage1Hpf)
mean(stage1Hpf)
max(stage1Hpf)
histogram(stage1Hpf)
%%
figure('Name','stage 1 Gain')
min(stage1Gain)
mean(stage1Gain)
max(stage1Gain)
histogram(stage1Gain)
%% 
figure('Name','stage 2 freq HPF')
min(stage2Hpf)
mean(stage2Hpf)
max(stage2Hpf)
histogram(stage2Hpf)

figure('Name','stage 2 Gain')
min(stage2Gain)
mean(stage2Gain)
max(stage2Gain)
histogram(stage2Gain)

figure('Name','freq LPF')
min(ifLpf)
mean(ifLpf)
max(ifLpf)
histogram(ifLpf)

figure('Name','freq mixer pole')
min(mixerPole)
mean(mixerPole)
max(mixerPole)
histogram(mixerPole)

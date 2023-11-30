%% 
clear all;
close all;

shwoIndepent = false;

%%

dataNameLocation = '\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-4294\dmaCheck\'

% Import memory dump of input from Eclipse
wdma = importfileFromInput([dataNameLocation 'wdma0_streams0_x_x_x_Input512_HPF_LPF.txt']);
% Swap bytes from ARM and cast to right integer from input
wdma0{1}.input = swapAndCastInput(wdma);
wdma0{1}.file = 'wdma0_streams0_x_x_x_Input512_HPF_LPF.txt';

% Import memory dump of input from Eclipse
wdmaZero = importfileFromInput([dataNameLocation 'wdma0_streams0_1_x_x_Input512_HPF_LPF.txt']);
% Swap bytes from ARM and cast to right integer from input
wdma01{1}.input = swapAndCastInput(wdmaZero);
wdma01{1}.file = 'wdma0_streams0_1_x_x_Input512_HPF_LPF.txt';
% Import memory dump of input from Eclipse
wdmaOne = importfileFromInput([dataNameLocation 'wdma1_streams0_1_x_x_Input512_HPF_LPF.txt']);
% Swap bytes from ARM and cast to right integer from input
wdma01{2}.input = swapAndCastInput(wdmaOne);
wdma01{2}.file = 'wdma1_streams0_1_x_x_Input512_HPF_LPF.txt';


% Import memory dump of input from Eclipse
wdmaZero = importfileFromInput([dataNameLocation 'wdma0_streams0_1_2_x_Input512_HPF_LPF.txt']);
% Swap bytes from ARM and cast to right integer from input
wdma012{1}.input = swapAndCastInput(wdmaZero);
wdma012{1}.file = 'wdma0_streams0_1_2_x_Input512_HPF_LPF.txt';
% Import memory dump of input from Eclipse
wdmaOne = importfileFromInput([dataNameLocation 'wdma1_streams0_1_2_x_Input512_HPF_LPF.txt']);
% Swap bytes from ARM and cast to right integer from input
wdma012{2}.input = swapAndCastInput(wdmaOne);
wdma012{2}.file = 'wdma1_streams0_1_2_x_Input512_HPF_LPF.txt';
% Import memory dump of input from Eclipse
wdmaTwo = importfileFromInput([dataNameLocation 'wdma2_streams0_1_2_x_Input512_HPF_LPF.txt']);
% Swap bytes from ARM and cast to right integer from input
wdma012{3}.input = swapAndCastInput(wdmaTwo);
wdma012{3}.file = 'wdma2_streams0_1_2_x_Input512_HPF_LPF.txt';

% Import memory dump of input from Eclipse
wdmaZero = importfileFromInput([dataNameLocation 'wdma0_streams0_1_2_3_Input512_HPF_LPF.txt']);
% Swap bytes from ARM and cast to right integer from input
wdma0123{1}.input = swapAndCastInput(wdmaZero);
wdma0123{3}.file = 'wdma0_streams0_1_2_3_Input512_HPF_LPF.txt';
% Import memory dump of input from Eclipse
wdmaOne = importfileFromInput([dataNameLocation 'wdma1_streams0_1_2_3_Input512_HPF_LPF.txt']);
% Swap bytes from ARM and cast to right integer from input
wdma0123{2}.input = swapAndCastInput(wdmaOne);
wdma0123{3}.file = 'wdma1_streams0_1_2_3_Input512_HPF_LPF.txt';
% Import memory dump of input from Eclipse
wdmaTwo = importfileFromInput([dataNameLocation 'wdma2_streams0_1_2_3_Input512_HPF_LPF.txt']);
% Swap bytes from ARM and cast to right integer from input
wdma0123{3}.input = swapAndCastInput(wdmaTwo);
wdma0123{3}.file = 'wdma2_streams0_1_2_3_Input512_HPF_LPF.txt';
% Import memory dump of input from Eclipse
wdmaThree = importfileFromInput([dataNameLocation 'wdma2_streams0_1_2_3_Input512_HPF_LPF.txt']);
% Swap bytes from ARM and cast to right integer from input
wdma0123{4}.input = swapAndCastInput(wdmaThree);
wdma0123{4}.file = 'wdma2_streams0_1_2_3_Input512_HPF_LPF.txt';


%% Plots

subplot(4,1,1); hold on; grid on;
    plot(wdma0{1}.input./max(wdma0{1}.input));
    title('Normalized DMA Streams active 0')
    legend({'stream0'})
    hold off;
subplot(4,1,2); hold on; grid on;
    plot(wdma01{1}.input./max(wdma01{1}.input));
    plot(wdma01{2}.input./max(wdma01{2}.input));
    title('Normalized DMA Streams active 0,1')
    legend({'stream0','stream1'})
    hold off;
subplot(4,1,3); hold on; grid on;
    plot(wdma012{1}.input./max(wdma012{1}.input));
    plot(wdma012{2}.input./max(wdma012{2}.input));
    plot(wdma012{3}.input./max(wdma012{3}.input));
    title('Normalized DMA Streams active 0,1,2')
    legend({'stream0','stream1','stream2'})
    hold off;
subplot(4,1,4); hold on; grid on;
    p(1)=plot(wdma0123{1}.input./max(wdma0123{1}.input));
    p(2)=plot(wdma0123{2}.input./max(wdma0123{2}.input));
    p(3)=plot(wdma0123{3}.input./max(wdma0123{3}.input));
    p(4)=plot(wdma0123{4}.input./max(wdma0123{4}.input));
    title('Normalized DMA Streams active 0,1,2,3')
    legend({'stream0','stream1','stream2','stream3'})
    hold off;

%% Plotting each stream independently captured
if(shwoIndepent)

dataNameLocation = '\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-4294\dmaCheck\indepent\'

% Import memory dump of input from Eclipse
wdma0{1}.input  = swapAndCastInput(importfileFromInput([dataNameLocation 'wdma0_streams0_x_x_x_Input512_HPF_LPF.txt']));
wdma0{1}.file = 'wdma0_streams0_x_x_x_Input512_HPF_LPF.txt';
% Import memory dump of input from Eclipse
wdma1{2}.input  = swapAndCastInput(importfileFromInput([dataNameLocation 'wdma1_streamsx_1_x_x_Input512_HPF_LPF.txt']));
wdma1{2}.file = 'wdma1_streamsx_1_x_x_Input512_HPF_LPF.txt';
% Import memory dump of input from Eclipse
wdma2{3}.input  = swapAndCastInput(importfileFromInput([dataNameLocation 'wdma2_streamsx_x_2_x_Input512_HPF_LPF.txt']));
wdma2{3}.file = 'wdma2_streamsx_x_2_x_Input512_HPF_LPF.txt';
% Import memory dump of input from Eclipse
wdma3{4}.input  = swapAndCastInput(importfileFromInput([dataNameLocation 'wdma3_streamsx_x_x_3_Input512_HPF_LPF.txt']));
wdma3{4}.file = 'wdma3_streamsx_x_x_3_Input512_HPF_LPF.txt';
figure();
    subplot(4,1,1); 
        plot(wdma0{1}.input./max(wdma0{1}.input),'Color',p(1).Color);grid on;
        title('Normalized DMA Streams active 0 - Rx1')
        legend({'stream0'})
    subplot(4,1,2);
        plot(wdma1{2}.input./max(wdma1{2}.input),'Color',p(2).Color);grid on;
        title('Normalized DMA Streams active 1 - Rx2')
        legend({'stream1'})
    subplot(4,1,3);
        plot(wdma2{3}.input./max(wdma2{3}.input),'Color',p(3).Color);grid on;
        title('Normalized DMA Streams active 2 - Rx3')
        legend({'stream2'})
    subplot(4,1,4);
        plot(wdma3{4}.input./max(wdma3{4}.input),'Color',p(4).Color);grid on;
        title('Normalized DMA Streams active 3 - Rx4')
        legend({'stream3'})
end
%% Functions
function inputSignal = swapAndCastInput(memoryDump)
% col = 32;
% row = 32;
% mem_dump = zeros(col*row/2,1);
% arr = reshape(memoryDumpSinWave',[col*row,1]);
% for i = 1:length(mem_dump)
% idx = (i - 1) * 2 + 1;
% mem_dump(i) = hex2dec(arr(idx)) + 256*hex2dec(arr(idx + 1));
% end
% neg_idx = mem_dump > 2^15-1;
% mem_dump(neg_idx) = -1*(2^16 - mem_dump(neg_idx));

    % Get even columns with MSB
    evenIndx = memoryDump(:,2:2:end);
    % Get odd colums with LSB
    oddIndx = memoryDump(:,1:2:end);
    % Swap ARM format big endian to little endian into new matrix
    swappedMemoryDumpSinWave = strcat(evenIndx,oddIndx);
    % Get size of matrix
    [row,col] = size(swappedMemoryDumpSinWave);
    % Convert matrix into an hex array
    hexArray = reshape(swappedMemoryDumpSinWave',[row*col,1]);
    % Convert hex array to decimal array but it will be uint16 and we want
    % signed data
    intArray = hex2dec(hexArray);
    % Get values that are signed and convert them to int16
    neg_idx = intArray > 2^15-1;
    intArray(neg_idx) = -1*(2^16 - intArray(neg_idx));
    inputSignal = intArray;
end

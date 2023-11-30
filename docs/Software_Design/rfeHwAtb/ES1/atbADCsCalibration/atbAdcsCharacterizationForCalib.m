%% Load data
load('\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3362\adcCalib.mat')
load('\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3362\adcSwappedCalib.mat')

%% Variables

myLegend = {'ADC1@0.4V','ADC2@0.4V','ADC1@0.6V','ADC2@0.6V'};
%% Plots for none swapped measurements
figure('Name','Original Inputs to ATB ADCs');
subplot(3,2,1); hold on; grid on;
    p(1)=plot(str2num(cell2mat(adc1MeasurementsBG0V4.bandGapVoltage)),'-o','Color',[0.4940 0.1840 0.5560]);
    p(2)=plot(str2num(cell2mat(adc2MeasurementsBG0V4.bandGapVoltage)),'-o','Color',[0.9290 0.6940 0.1250]);
    p(3)=plot(str2num(cell2mat(adc1MeasurementsBG0V6.bandGapVoltage)),'-*','Color',p(1).Color);
    p(4)=plot(str2num(cell2mat(adc2MeasurementsBG0V6.bandGapVoltage)),'-*','Color',p(2).Color);
    title('Bandgap voltage measured with average 2 samples in ATB ADCs');
    legend(myLegend,'location','best');
    ylabel('Voltage[mV]');xlabel('sample')
    hold off;
subplot(3,2,3); hold on; grid on;
    p(5)=plot(hex2dec(cell2mat(adc1MeasurementsBG0V4.averagedATB1ADCSample)),'-o','Color',p(1).Color);
    p(6)=plot(hex2dec(cell2mat(adc2MeasurementsBG0V4.averagedATB1ADCSample)),'-oy','Color',p(2).Color);
    p(7)=plot(hex2dec(cell2mat(adc1MeasurementsBG0V6.averagedATB1ADCSample)),'-*','Color',p(1).Color);
    p(8)=plot(hex2dec(cell2mat(adc2MeasurementsBG0V6.averagedATB1ADCSample)),'-*','Color',p(2).Color);    
    title('Register value of ATB ADCs with average 2 samples in ATB ADCs');
    legend(myLegend,'location','best');
    xlabel('sample')
    hold off;
subplot(3,2,2); hold on; grid on;
    p(9)=plot(str2num(cell2mat(adc1MeasurementsBG0V4.bandgapFromAdcObs1Data)),'-o','Color',p(1).Color);
    p(10)=plot(str2num(cell2mat(adc2MeasurementsBG0V4.bandgapFromAdcObs1Data)),'-oy','Color',p(2).Color);
    p(11)=plot(str2num(cell2mat(adc1MeasurementsBG0V6.bandgapFromAdcObs1Data)),'-*','Color',p(1).Color);
    p(12)=plot(str2num(cell2mat(adc2MeasurementsBG0V6.bandgapFromAdcObs1Data)),'-*','Color',p(2).Color);    
    title('Bandgap voltage measured without average(1sample) in ATB ADCs');
    legend(myLegend,'location','best');
    ylabel('Voltage[mV]');xlabel('sample')
    hold off;
subplot(3,2,4); hold on; grid on;
    p(13)=plot(hex2dec(cell2mat(adc1MeasurementsBG0V4.adcObs1Data)),'-o','Color',p(1).Color);
    p(14)=plot(hex2dec(cell2mat(adc2MeasurementsBG0V4.adcObs1Data)),'-oy','Color',p(2).Color);
    p(15)=plot(hex2dec(cell2mat(adc1MeasurementsBG0V6.adcObs1Data)),'-*','Color',p(1).Color);
    p(16)=plot(hex2dec(cell2mat(adc2MeasurementsBG0V6.adcObs1Data)),'-*','Color',p(2).Color);    
    title('Register value of ATB ADCs without average(1sample) in ATB ADCs');
    legend(myLegend,'location','best');
    xlabel('sample');ylabel('Voltage[mV]')
    hold off;
subplot(3,2,5); hold on; grid on;
    p(17)=plot(abs(str2num(cell2mat(adc1MeasurementsBG0V4.bandGapVoltage))-str2num(cell2mat(adc2MeasurementsBG0V4.bandGapVoltage))),'-ok');
    p(18)=plot(abs(str2num(cell2mat(adc1MeasurementsBG0V6.bandGapVoltage))-str2num(cell2mat(adc2MeasurementsBG0V6.bandGapVoltage))),'-*k');
    title('Absolute error with average 2 samples in ATB ADCs ');
    legend({'Err_{abs}@0.4V','Err_{abs}@0.6V'},'location','best');
    xlabel('sample');ylabel('ADC1-ADC2[mV]')
    hold off;
subplot(3,2,6); hold on; grid on;
    p(19)=plot(abs(hex2dec(cell2mat(adc1MeasurementsBG0V4.adcObs1Data))-hex2dec(cell2mat(adc2MeasurementsBG0V4.adcObs1Data))),'-ok');
    p(20)=plot(abs(hex2dec(cell2mat(adc1MeasurementsBG0V6.adcObs1Data))-hex2dec(cell2mat(adc2MeasurementsBG0V6.adcObs1Data))),'-*k');
    title('Absolute error without average(1sample) in ATB ADCs ');
    legend({'Err_{abs}@0.4V','Err_{abs}@0.6V'},'location','best');
    xlabel('sample');ylabel('ADC1-ADC2[mV]')
    hold off;    
%% Plots for swapped measurements
figure('Name','Swapped Inputs to ATB ADCs');
subplot(3,2,1); hold on; grid on;
    ps(1)=plot(str2num(cell2mat(adc1MeasurementsBG0V4Swapped.bandGapVoltage)),'-o','Color',[0.9290 0.6940 0.1250]);
    ps(2)=plot(str2num(cell2mat(adc2MeasurementsBG0V4Swapped.bandGapVoltage)),'-o','Color',[0.4940 0.1840 0.5560]);
    ps(3)=plot(str2num(cell2mat(adc1MeasurementsBG0V6Swapped.bandGapVoltage)),'-*','Color',ps(1).Color);
    ps(4)=plot(str2num(cell2mat(adc2MeasurementsBG0V6Swapped.bandGapVoltage)),'-*','Color',ps(2).Color);
    title('Bandgap voltage measured with average 2 samples in ATB ADCs Swapped Inputs');
    legend(myLegend,'location','best');
    ylabel('Voltage[mV]');xlabel('sample')
    hold off;
subplot(3,2,3); hold on; grid on;
    ps(5)=plot(str2num(cell2mat(adc1MeasurementsBG0V4Swapped.averagedATB1ADCSample)),'-o','Color',ps(1).Color);
    ps(6)=plot(str2num(cell2mat(adc2MeasurementsBG0V4Swapped.averagedATB1ADCSample)),'-oy','Color',ps(2).Color);
    ps(7)=plot(str2num(cell2mat(adc1MeasurementsBG0V6Swapped.averagedATB1ADCSample)),'-*','Color',ps(1).Color);
    ps(8)=plot(str2num(cell2mat(adc2MeasurementsBG0V6Swapped.averagedATB1ADCSample)),'-*','Color',ps(2).Color);    
    title('Register value of ATB ADCs with average 2 samples in ATB ADCs Swapped Inputs');
    legend(myLegend,'location','best');
    xlabel('sample')
    hold off;
subplot(3,2,2); hold on; grid on;
    ps(9)=plot(str2num(cell2mat(adc1MeasurementsBG0V4Swapped.bandgapFromAdcObs1Data)),'-o','Color',ps(1).Color);
    ps(10)=plot(str2num(cell2mat(adc2MeasurementsBG0V4Swapped.bandgapFromAdcObs1Data)),'-oy','Color',ps(2).Color);
    ps(11)=plot(str2num(cell2mat(adc1MeasurementsBG0V6Swapped.bandgapFromAdcObs1Data)),'-*','Color',ps(1).Color);
    ps(12)=plot(str2num(cell2mat(adc2MeasurementsBG0V6Swapped.bandgapFromAdcObs1Data)),'-*','Color',ps(2).Color);    
    title('Bandgap voltage measured  without average(1sample) in ATB ADCs Swapped Inputs ');
    legend(myLegend,'location','best');
    ylabel('Voltage[mV]');xlabel('sample')
    hold off;
subplot(3,2,4); hold on; grid on;
    ps(13)=plot(hex2dec(cell2mat(adc1MeasurementsBG0V4Swapped.adcObs1Data)),'-o','Color',ps(1).Color);
    ps(14)=plot(hex2dec(cell2mat(adc2MeasurementsBG0V4Swapped.adcObs1Data)),'-oy','Color',ps(2).Color);
    ps(15)=plot(hex2dec(cell2mat(adc1MeasurementsBG0V6Swapped.adcObs1Data)),'-*','Color',ps(1).Color);
    ps(16)=plot(hex2dec(cell2mat(adc2MeasurementsBG0V6Swapped.adcObs1Data)),'-*','Color',ps(2).Color);    
    title('Register value of ATB ADCs without average(1sample) in ATB ADCs Swapped Inputs');
    legend(myLegend,'location','best');
    xlabel('sample');ylabel('Voltage[mV]')
    hold off;
subplot(3,2,5); hold on; grid on;
    ps(17)=plot(abs(str2num(cell2mat(adc1MeasurementsBG0V4Swapped.bandGapVoltage))-str2num(cell2mat(adc2MeasurementsBG0V4Swapped.bandGapVoltage))),'-ok');
    ps(18)=plot(abs(str2num(cell2mat(adc1MeasurementsBG0V6Swapped.bandGapVoltage))-str2num(cell2mat(adc2MeasurementsBG0V6Swapped.bandGapVoltage))),'-*k');
    title('Absolute error with average 2 samples in ATB ADCs Swapped Inputs ');
    legend({'Err_{abs}@0.4V','Err_{abs}@0.6V'},'location','best');
    xlabel('sample');ylabel('ADC1-ADC2[mV]')
    hold off;
subplot(3,2,6); hold on; grid on;
    ps(19)=plot(abs(hex2dec(cell2mat(adc1MeasurementsBG0V4Swapped.adcObs1Data))-hex2dec(cell2mat(adc2MeasurementsBG0V4Swapped.adcObs1Data))),'-ok');
    ps(20)=plot(abs(hex2dec(cell2mat(adc1MeasurementsBG0V6Swapped.adcObs1Data))-hex2dec(cell2mat(adc2MeasurementsBG0V6Swapped.adcObs1Data))),'-*k');
    title('Absolute error without average(1sample) in ATB ADCs Swapped Inputs');
    legend({'Err_{abs}@0.4V','Err_{abs}@0.6V'},'location','best');
    xlabel('sample');ylabel('ADC1-ADC2[mV]')
    hold off;      
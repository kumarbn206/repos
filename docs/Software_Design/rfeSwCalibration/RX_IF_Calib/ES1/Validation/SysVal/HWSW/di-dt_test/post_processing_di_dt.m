function [OutputStruct]=post_processing_di_dt(folder_loc, phase)

TARGETSAMPLINGRATE = 10e6; % samplerate to resample the data too 
clc;
%rawdata=csvread('trialnew.csv');
% rawdata=csvread("Z:\Users\Public\Documents\Infiniium\Waveforms\data\RFE_0_8_9\inductor\lars_28_07_2022\moveTxPaAndBufferEnableAfterBufferCalib\recalibration.csv");
% rawdata_V=csvread("Z:\Users\Public\Documents\Infiniium\Waveforms\data\RFE_0_8_9\inductor\lars_28_07_2022\moveTxPaAndBufferEnableAfterBufferCalib\recalibration_V.csv");

rawdata=csvread(strcat(folder_loc, '\', phase,'.csv'));
rawdata_V=csvread(strcat(folder_loc, '\', phase,'_V.csv'));


x=rawdata(:,1);
fs = 1/mean(diff(x));  % Sample rate from the capturing in units of Hz
y=resample(rawdata(:,2), TARGETSAMPLINGRATE, round(fs));
x = linspace(x(1), x(end), length(y));
y_V=resample(rawdata_V(:,2), TARGETSAMPLINGRATE, round(fs));
%rawdata=downsample(rawdata1,10);
figure
yyaxis left
plot(x.*1000, y);
hold on;
plot(x.*1000,y_V,'-g','LineWidth',2.0);
ylabel('Ampere')
hold on;
dy=diff(y)*10;
dy(abs(dy(:,1))<=0.2)=NaN;
dy = [dy;NaN];
yyaxis right
ylabel('A/us')  
plot(x.*1000, dy,'*');
title('I and dI over time');
xlabel('time [ms]');
x_ = [x(1) x(end)];
y_ = [0.7 0.7];
plot(x_.*1000, y_, 'r:', 'linewidth', 3)
y_ = [-0.7 -0.7];
plot(x_.*1000, y_, 'r:', 'linewidth', 3)
hold off;
legend('1V3\_current [A]','1V3\_V', 'di/dt[A/us]', 'limit line (0.7A/us)');
grid on;
maxdidt = ['Max abs(dI/dt): ' num2str(max(abs(dy))) 'A/us' ];
text(y(1), min(dy), maxdidt)
if max(abs(dy)) > 0.7
    disp(['Testcase FAILED (max dI/dt measured as ' num2str(max(abs(dy))) 'A/us)'])
else
    disp('Testcase PASSED')
end
f1=gcf;

f1.WindowState='maximized';


output_filename_fig= strcat(folder_loc,'\',phase,'.fig');
output_filename_png= strcat(folder_loc,'\',phase,'.png');

saveas(f1,output_filename_fig,'fig');
saveas(f1,output_filename_png,'png');


% --------- Create pptx ---------------
result_ppt_name = 'didt.pptx';
filename_png = strcat(phase, '.png');

if (phase == "calibrate")
    template_path = strcat(folder_loc,'\', 'didt_template.pptx');
    cf_status = copyfile("didt_template.pptx", template_path);
else
    template_path = strcat(folder_loc,'\', result_ppt_name);
end

export(folder_loc, filename_png, template_path, result_ppt_name);
% -------------------------------------


OutputStruct.output_filename_fig = output_filename_fig;
OutputStruct.output_filename_png = output_filename_png;

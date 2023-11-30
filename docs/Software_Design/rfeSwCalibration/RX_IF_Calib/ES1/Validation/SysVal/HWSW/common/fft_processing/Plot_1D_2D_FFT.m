%% Plot function
%%% First and second FFT Plots

function Plot_1D_2D_FFT(D1FFT_dB,D2FFT_dB,range_vector,velocity_vector)
%% Calc in dBm
global tp_env;


RxNum =4;
close all

figure()
for idx_gen_cnt= 1:RxNum
    %%% First FFT
    %     D_1FFT_dB = 10*log10(abs(D1FFT_dB(:,1,idx_gen_cnt)).^2)';


    subplot(2,2,idx_gen_cnt)
    plot(range_vector, D1FFT_dB);
    hold on
    % scatter(peak_range, peak_pwr_1d_log, 'filled');  %only required if red dot shall mark the signal peak
    xlabel('Distance [m]');
    ylabel('Signal power [dBFs / bin]');
    title(['RX', num2str(idx_gen_cnt)]);
    ylim([-100, -30]);
%     axis tight
    grid on
end
% saveas(gcf,strcat(tp_env.loop_info_obj.path_config.path_results,'\1DFFT.fig' ))
% saveas(gcf,strcat(tp_env.loop_info_obj.path_config.path_results,'\1DFFT.jpg' ))
%% Second FFT
figure()
for idx_gen_cnt= 1:RxNum

    subplot(2,2, idx_gen_cnt)
    %     D2_FFT_dB = 20*log10((abs(D2FFT_dB(:,:,idx_gen_cnt)))');

    h = surf(range_vector, velocity_vector, D2FFT_dB);
    h.EdgeColor = 'none';
    colormap turbo
    c = colorbar;
    c.Location = 'eastoutside';
    c.Label.String = 'signal amplitude [dBFs / bin]';
    xlabel("range [m]")
    ylabel("velocity [m/s]")
    zlabel("signal amplitude [dBFs / bin]");
    title(['Rx', num2str(idx_gen_cnt)]);
    sgtitle('2DFFT', 'interpreter', 'none');
    view(0,90);
    axis tight

end
% saveas(gcf,strcat(tp_env.loop_info_obj.path_config.path_results,'\2DFFT.fig' ))
% saveas(gcf,strcat(tp_env.loop_info_obj.path_config.path_results,'\2DFFT.jpg' ))
end


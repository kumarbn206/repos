%% Plot function
%%% Plots regarding phase

function Plot_Phase(phases_per_chirp,range_vector,velocity_vector,peak_idcs,currentSystemSetting)
global tp_env;

%%%For dynamic table check
%     path_rfe_config_file = tp_env.loop_info_obj.path_config.path_rfe_config_file;
%     rfe_config_filename = tp_env.loop_info_obj.general_tp_control.rfe_config_filename;
%     dyn_table_filename= tp_env.loop_info_obj.general_tp_control.dyn_table_filename;

%     rfe_config_file_and_path=strcat(path_rfe_config_file,'\',rfe_config_filename);
%     dynamic_table_file_and_path =strcat(path_rfe_config_file,'\',dyn_table_filename);

%%%

figure()
for RxNum =1:4 
chirp_no_of_groups=1;

for chirp_no_group = 1:chirp_no_of_groups
    matrix = reshape(1:currentSystemSetting.CHIRPS, chirp_no_of_groups, []);
    relevant_chirps = matrix(chirp_no_group, :);
    subplot(2,2, RxNum)

    phase_points(RxNum,:) = 180/pi()*phases_per_chirp(:,:,RxNum);
    if(max(phase_points(RxNum,:)) - min(phase_points(RxNum,:)) > pi)
        if(mean(phase_points(RxNum,:) > 0))
            %unwrap phase, i.e. add 360° to all negative values
            phase_points(RxNum,:) = phase_points(RxNum,:) + 360*(phase_points(RxNum,:)<-90);
        else
            %unwrap phase, i.e. substract 360° from all positive values
            phase_points(RxNum,:) = phase_points(RxNum,:) - 360*(phase_points(RxNum,:)>90);
        end
    end

phase_points_unwrapped(RxNum,:)= (180/pi * unwrap(pi/180 * phase_points(RxNum,:)));
up_or_down_movement = -1; % if slope of the phase progression is either +1 or -1;

%%% Setting the phase compare  to either 2.8152 deg  steps or 0
if isfile(dynamic_table_file_and_path)
set_phases = 360/currentSystemSetting.CHIRPS * (0:(currentSystemSetting.CHIRPS/chirp_no_of_groups - 1));
else
set_phases =zeros(1,currentSystemSetting.CHIRPS);
end 

for idx_cnt_ph= 2:128
    difference_set_vs_measured(RxNum,idx_cnt_ph) = phase_points_unwrapped(RxNum,idx_cnt_ph) + set_phases(idx_cnt_ph) -phase_points_unwrapped(RxNum, 1) ;
end
 

for idx_cnt_ph= 2:127
    difference_chirp2chirp(RxNum,idx_cnt_ph) = phase_points_unwrapped(RxNum,idx_cnt_ph-1) - phase_points_unwrapped(RxNum,idx_cnt_ph)-set_phases(2);
end
%     set_phases = 360/currentSystemSetting.CHIRPS * (0:(currentSystemSetting.CHIRPS/chirp_no_of_groups - 1));
    array_nu_chirps =1:currentSystemSetting.CHIRPS;
    plot(array_nu_chirps,phase_points(RxNum,:));

end 
    title({['RX 1']});
    ylabel("detected phase [deg]")
    xlabel("Chirp");
    grid on

end
sgtitle("Phase rotator test: Absolute phase of RX");
set(gcf,'Color','w');
set(gcf, 'Position', [100 100  1600 500]);

% saveas(gcf,strcat(tp_env.loop_info_obj.path_config.path_results,'\Phase_absolute.fig' ))
% saveas(gcf,strcat(tp_env.loop_info_obj.path_config.path_results,'\Phase_absolute.jpg' ))

%plot the deviation from wished phase

figure()
for RxNum =1:4

 subplot(2,2, RxNum)
plot(difference_set_vs_measured(RxNum,:));
    title(['Rx', num2str(RxNum)]);
    ylabel("detected phase [deg]")
    xlabel("Chirp");
    grid on

end
xlabel('set phase [deg]')
ylabel('measured - set phase (zero-mean) [deg]')
sgtitle('Difference (Measured - Set Phase)');
grid on
set(gcf,'Color','w');
set(gcf, 'Position', [100 100  1600 500]);
% saveas(gcf,strcat(tp_env.loop_info_obj.path_config.path_results,'\Phase_set2meas.fig' ))
% saveas(gcf,strcat(tp_env.loop_info_obj.path_config.path_results,'\Phase_set2meas.jpg' ))
%% Phase to phase dev

figure()
for RxNum =1:4
 subplot(2,2, RxNum)
plot( difference_chirp2chirp(RxNum,2:127));
    title(['Rx', num2str(RxNum)]);
    ylabel("Phase difference [deg]")
    xlabel("Chirp to Chirp");
    grid on
ylim([-1 1]);
xlim ([1 currentSystemSetting.CHIRPS])

end
xlabel('chirp number')
ylabel('phase difference [deg]')
sgtitle('Difference from chirp to chirp');
grid on        
set(gcf,'Color','w');
set(gcf, 'Position', [100 100  1600 500]);
% saveas(gcf,strcat(tp_env.loop_info_obj.path_config.path_results,'\Phase_diff.fig' ))
% saveas(gcf,strcat(tp_env.loop_info_obj.path_config.path_results,'\Phase_diff.jpg' ))


end
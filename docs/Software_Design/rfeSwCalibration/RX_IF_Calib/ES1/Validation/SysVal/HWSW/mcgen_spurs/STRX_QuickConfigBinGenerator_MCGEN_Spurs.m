%% Constand path definitions in repository
clear all;
folderloc='M:\15_STRX\10_HWSW_integration\release_testing_0_8_8\MCGEN_SPURS\RC3\'
fsw_address='TCPIP::192.168.0.21::INSTR';
power_cycle;

run_caption='customer_release_0_8_8_RC3';



addpath(genpath(pwd))

Proxy_loc='C:\STRX\RFE_Proxy\RFEProxy_V0_5_18\bin';
elfFileLoc='M:\15_STRX\8_Software\RFE_FW\SAF85xx_RFE_SW_EAR_0_8_8_D220624_RC2\SAF85xx_RFE_SW_EAR_0_8_8_D220624\rfe\rfeFw\bin';
elfFileName='rfeFw_hw101_release_armclang';
result_path='M:\15_STRX\10_HWSW_integration\release_testing_0_8_8\MCGEN_SPURS\RC3\';


%% config file path (if you do not explicitely need then do not change the values)

%% are you using CODE and DATA files for fw Load
CODE_DATA_CHECK='yes';
% if yes then the path
CODE_DATA_FILE_Path='M:\15_STRX\8_Software\RFE_FW\SAF85xx_RFE_SW_EAR_0_8_8_D220624_RC3\rfe\rfeFw\bin';

%% python wrapper configuration
xml_folder = 'C:\\git\\mrta-tests-strx-sysval\\TestStand\\ConfigFiles\\';
xml_file = 'base_rfeConfig_v0_88.xml';
path_config_python_wrapper = "C:\git\mrta-tests-strx-sysval\TestStand\Common\Parameter2ConfigWrapper";

addpath(genpath('M:\15_STRX\8_Software\RFE_Integration_Test'));

addpath(genpath(pwd));
base_path_matlab = pwd;

loop_variable=read_mcgen_check_input("C:\STRX\RFE_Integration_Test\MCGEN_check.xlsx");
register_value=[];
count=0;
[row,col]=size(loop_variable);

for ii = 1: row
    
    pause(5)
    %% Variable path and parameter definitions
    center_freq = num2str(loop_variable{ii,2}*1e6);
    tx_power = num2str(loop_variable{ii,3});
    tx1_enable=(loop_variable{ii,4});
    tx2_enable=(loop_variable{ii,5});
    tx3_enable=(loop_variable{ii,6});
    tx4_enable=(loop_variable{ii,7});
    tx1_enable=(loop_variable{ii,8});
    tx2_enable=(loop_variable{ii,9});
    tx3_enable=(loop_variable{ii,10});
    tx4_enable=(loop_variable{ii,11});
    pll_bw=num2str(loop_variable{ii,12});
    
    
    
    
    %% Simple test script
    addpath(genpath(pwd));
    base_path_matlab = pwd;
    
    name_array = {"chirpProfiles__chirpProfile0__chirpGenerator__center___frequency___kHz", ...
        "chirpProfiles__chirpProfile0__txPower__dBm",...
        "chirpProfiles__chirpProfile0__txTransmissionEnable__tx___1",...
        "chirpProfiles__chirpProfile0__txTransmissionEnable__tx___2",...
        "chirpProfiles__chirpProfile0__txTransmissionEnable__tx___3",...
        "chirpProfiles__chirpProfile0__txTransmissionEnable__tx___4",...
        "chirpSequenceConfigs__chirpSequenceConfig0__txEnable__tx___1",...
        "chirpSequenceConfigs__chirpSequenceConfig0__txEnable__tx___2",...
        "chirpSequenceConfigs__chirpSequenceConfig0__txEnable__tx___3",...
        "chirpSequenceConfigs__chirpSequenceConfig0__txEnable__tx___4",...
        "chirpProfiles__chirpProfile0__ pll___loop___filter___bandwidth"
        };
    
    
    value_array = {center_freq, ...
        tx_power, ...
        tx1_enable,...
        tx2_enable,...
        tx3_enable,...
        tx4_enable,...
        tx1_enable,...
        tx2_enable,...
        tx3_enable,...
        tx4_enable,...
        pll_bw
        };
    
    cd(path_config_python_wrapper);
    
    % Script 1: Modify RFE Config file
    res = pyrunfile("RunConfigWrapper.py", "out", xml_folder = xml_folder, xml_file = xml_file, name_array = name_array, value_array = value_array);
    
    %%
    register_value=[];
    
    rfeIntegrationTestCWmode
    %     rfeIntegrationTestCWmode;
    
    
    tx1_enable_1={tx1_enable};
    tx1_enable_num1=strcat(tx1_enable_1{:});
    
    tx2_enable_1={tx2_enable};
    tx2_enable_num1=strcat(tx2_enable_1{:});
    
    
    tx3_enable_1={tx3_enable};
    tx3_enable_num1=strcat(tx3_enable_1{:});
    
    tx4_enable_1={tx4_enable};
    tx4_enable_num1=strcat(tx4_enable_1{:});
    
    
    tx={tx1_enable_num1,tx2_enable_num1,tx3_enable_num1,tx4_enable_num1};
    findEnabledTX=num2str(find(contains(tx,'enabled')));
    tx_enabled=strcat('TX',findEnabledTX);
    
    Center_freq=str2double(center_freq)*1e3;
    
    
    
    [trace_data_x1,trace_data_y1]=fsw_cw_capture(Center_freq, fsw_address)
    
    %         [PN_data_x1,PN_data_y1]=fsw_cw_phase_noise(Center_freq, fsw_address);
    
    msg1=strcat('CW\_Mode\_',tx_enabled,'\_',num2str(Center_freq/1e9),'\_GHz');
    msg2=strcat('Phase\_Noise\_',tx_enabled,'\_',num2str(Center_freq/1e9),'\_GHz');
    
    
    %         Center_Freq=num2str(Center_Freq);
    
    filename_CW=strcat(folderloc,run_caption,'_CW_freq_',num2str(center_freq),'_pllbw_',pll_bw,'kHz_',tx_enabled,'_count_',num2str(count));
    
    plot(trace_data_x1,trace_data_y1);
    xlabel('Frequency[GHz]');
    ylabel('RF Power[dBm]')
    title(msg1);
    grid on;
    axis tight
    saveas(gcf,filename_CW,'png');
    
    
    
    [PN_data_x1,PN_data_y1]=fsw_cw_phase_noise(Center_Freq, fsw_address);
    filename_PN=strcat(folderloc,run_caption,'_PN_freq_',num2str(center_freq),'_pllbw_','_',tx_enabled,'_count_',num2str(count));
    
    
    semilogx(PN_data_x1,PN_data_y1);
    xlabel('Frequency Offset[kHz]');
    ylabel('Phase Noise[dBc/Hz]')
    title(msg2);
    grid on;
    axis tight
    saveas(gcf,filename_PN,'png');
    
    
    
    %         filename_PN=strcat(folderloc,run_caption,'_PN_freq_',num2str(Center_Freq),'_pllbw_',num2str(pll_loop_filter_bw),'_',tx_enabled,'_count_',num2str(count));
    %         semilogx(PN_data_x1,PN_data_y1);
    %         xlabel('Offset Frequency[Hz]');
    %         ylabel('Phase Noise[dBc/Hz]')
    %         title(msg2);
    %         grid on;
    %         saveas(gcf,filename_PN,'png');
    %         register_value=[register_value;center_Freq,pll_loop_filter_bw,tx_power,tx1_enable,tx2_enable,tx3_enable,tx4_enable,count,Loss_of_lock1, value1,Loss_of_lock, value ];
    rfeabstract.rfe_testContinuousWaveTransmissionStop;
end

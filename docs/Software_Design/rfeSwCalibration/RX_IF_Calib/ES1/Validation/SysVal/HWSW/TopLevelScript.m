% Top Level Script
% clear all
%% Define Input Parameters

% Option 1 (Default): name_array and value_array as also provided by
%                     TestStand (xml_folder and xml_file also required)

% xml_folder = 'C:\\git\\mrta-tests-strx-sysval\\TestStand\\ConfigFiles\\';
% xml_file = 'base_rfeConfig_v0_810.xml'; %'rfeConfig_general_Denso_Profile.xml';
% var_configfile = 'C:\\git\\mrta-tests-strx-sysval\\TestStand\\ConfigFiles\\VariableConfig4Transformation.xml'; %'C:\\git\\mrta-tests-strx-sysval\\TestStand\\ConfigFiles\\VariableConfig4Transformation_untilv087.xml';
% path_config_python_wrapper = "C:\git\mrta-tests-strx-sysval\TestStand\Common\Parameter2ConfigWrapper";

% Option 2: define input_struct as it is expected to be available after the
%           data conversion by the mandatory Python scrips serving as a
%           bridge between TestStand and Python
% input_struct.chirp_prof0_center_freq = 76e9;
% input_struct.init_uut = 1;
% input_struct.power_mode = 'dynamic';

rfe_config_filepath = 'C:\LocalData\Projects\STRX\tools\rfeConfigGenerator\release\rfeConfig.bin';

% %% Running TestStand-Matlab Bridge (Python scripts)
% 
% %res = pyrunfile("Parameter2ConfigWrapper.py", Param2ConfigBin(xml_folder, xml_file, name_array, value_array)
% 
% cd(path_config_python_wrapper);
% % cd ..\..\TestStand\Common;
% 
% % Script 1: Modify RFE Config file
% res = pyrunfile("RunConfigWrapper.py", "out", xml_folder = xml_folder, xml_file = xml_file, name_array = name_array, value_array = value_array);
% 
% % Script 2: Transform xml-adressing strings to single and simple fieldnames
% % for a Matlab struct
% name_array_out = pyrunfile("RunRenameArrayElementsForMatlab.py", "name_array_out", var_configfile = var_configfile, name_array = name_array);
% 
% % Transformation of Python list into Matlab variables
% name_array_out = cell(name_array_out);
% for i_array = 1:length(name_array_out)
%     name_array_converted{i_array} = string(name_array_out{i_array});
% end
% name_array = name_array_converted;
% 
% input_dict = pyrunfile("RunArray2Dict.py", "input_dict", name_array = name_array, value_array = value_array);
% % Transformation of Python dict into Matlab variables
% input_dict = struct(input_dict);
% dict_fields = fieldnames(input_dict);
% for i_field = 1:length(dict_fields)
%     input_struct.(dict_fields{i_field}) = string(input_dict.(dict_fields{i_field}));
% end
% 
% cd(base_path_matlab);
%% Test running three Matlab functions using class
[result_init, loop_info] = test_class_init(input_struct, rfe_config_filepath);


try
    InitTP(input_struct);
%     [input_struct] = InitTP(input_struct);

    ConfigTP();
%     [output_struct] = ConfigTP();

    % leaving Matlab in between, but Matlab client remains
    % Instrument Routines running usually in LabView
    loop_count = 1;
    switch test_procedure
        case {"TP_1_1_InterleavedSequence", "TP_1_1_ProgressiveChirp"}
            global tp_env;
            if tp_env.stdvars.general_tp_control.init_instruments
                %             ContinuousWave_StartStop(0, "start");
                temp_time = tp_env.non_stdvars.speci_meas_time;
                tp_env.non_stdvars.speci_meas_time = 0.007;
                FSW_InitTransient_Freq_RTAB(input_struct);
                %             FSW_InitTransient_Freq_Power(input_struct);
%                 ContinuousWave_StartStop(0, "stop");
                tp_env.non_stdvars.speci_meas_time = temp_time;
                tp_env.stdvars.general_tp_control.init_instruments = 0;
            else
                FSW_ChangeCenterFreq(input_struct);
            end
            %         chirp_seq_conf0_chirpCount = double(tp_env.stdvars.chirp_sequence_configs.chirp_seq_conf0_chirpCount);
            %         loop_count = floor(30/chirp_seq_conf0_chirpCount);
            loop_count = 1;
            pause(2);

        case "TP_1_1_ChirpCount"
            global tp_env;
            if tp_env.stdvars.general_tp_control.init_instruments
                FSW_InitTransient_Freq_RTAB(input_struct);
                tp_env.stdvars.general_tp_control.init_instruments = 0;
            else
                FSW_ChangeCenterFreq(input_struct);
            end

            loop_count = 1;
            pause(2);

        case "TP_1_2"
            global tp_env;
            if tp_env.stdvars.general_tp_control.init_instruments
                %             [output_struct] = RunTP();
%                 ContinuousWave_StartStop(0, "start");
                FSW_InitTransient_Freq_FreqDeviation();
%                 ContinuousWave_StartStop(0, "stop");
                tp_env.stdvars.general_tp_control.init_instruments = 0;
            else
                FSW_ChangeFMvideoBW();
                FSW_ChangeCenterFreq();
            end
            chirp_seq_conf0_chirpCount = double(tp_env.stdvars.chirp_sequence_configs.chirp_seq_conf0_chirpCount);
            %         loop_count = 2 * 100/chirp_seq_conf0_chirpCount;
            loop_count = 2 * floor(10/chirp_seq_conf0_chirpCount);
            pause(2);

    end

    for i_loop = 1:loop_count
        RunTP();
        pause(2)
        switch test_procedure
            case {"TP_1_1_InterleavedSequence"}
                if i_loop == 1
                    tp_env.non_stdvars.store_xydata_as = "result_data_chirptiming";
                end
                %             FSW_GetTransientFreqAndPowerData(input_struct);
                FSW_GetTransientFreqAndTableData(input_struct);

            case {"TP_1_1_ProgressiveChirp"}

                tp_env.non_stdvars.store_xydata_as = "result_data_progressivechirp_long";

                %             FSW_GetTransientFreqAndPowerData(input_struct);
                FSW_GetTransientFreqAndTableData(input_struct);

                FSW_ChangeMeasurementTime(input_struct)
                RunTP();
                tp_env.non_stdvars.store_xydata_as = "result_data_progressivechirp_short";
                FSW_GetTransientFreqAndTableData(input_struct);

            case "TP_1_1_ChirpCount"
                if i_loop == 1
                    tp_env.non_stdvars.store_xydata_as = "result_data_maxchirpcount";
                end
                %             FSW_GetTransientFreqAndPowerData(input_struct);
                FSW_GetTransientFreqAndTableData(input_struct);

            case "TP_1_2"
                if i_loop == 1
                    tp_env.non_stdvars.store_xydata_as = "result_data_chirplin";
                    %                 tp_env.non_stdvars.speci_fm_video_bw = "LP01";
                    %                 FSW_ChangeFMvideoBW(input_struct)
                    [output_struct] = RunTP();
                end

                if i_loop == (0.5 * loop_count) + 1 %11
                    tp_env.non_stdvars.store_xydata_as = "result_data_chirppn";
                    tp_env.non_stdvars.speci_fm_video_bw = "LP10";
                    FSW_ChangeFMvideoBW(input_struct)
                    [output_struct] = RunTP();
                    pause(2)
                    [output_struct] = RunTP();
                end
                if strcmpi(tp_env.non_stdvars.store_xydata_as, "result_data_chirplin")
                    FSW_GetTransientFreqData(input_struct);
                else
                    FSW_GetTransientFreqAndPowerData(input_struct);
                end


        end
    end

    % leaving Matlab in between, but Matlab client remains
    % Instrument Routines running usually in LabView
    CloseTP();

catch
    disp('Error while running test! Skipping current sweep');

end




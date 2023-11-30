input_table= table2cell(readtable('C:\git\mrta-tests-strx-sysval\TestStand\HWSW\tx-output-power\tx-output-power_chirp_profiles.csv'));

[table_row,~]=size(input_table);


basepath = InputStruct.basepath; % this is the path the \Matlab folder
addpath(genpath(basepath));
addpath(InputStruct.Proxy_loc);


load WgLossesUncertainty.mat;



StartProxyRfe(InputStruct);

Output=[];


for ii = 1 : table_row
    ResetRfe();
    LoadFwRfe(InputStruct);
    SyncRfe();
    OutputStruct = GetVersionRfe(InputStruct);



    center_freq = num2str(input_table{ii,2});
    tx_power_profile1 = num2str(input_table{ii,3});
    tx_power_profile2 = num2str(input_table{ii,4});
    tx_power_profile3 = num2str(input_table{ii,5});
    tx_power_profile4  = num2str(input_table{ii,6});


    tx1_enable=num2str(input_table{ii,7});
    tx2_enable=num2str(input_table{ii,8});
    tx3_enable=num2str(input_table{ii,9});
    tx4_enable=num2str(input_table{ii,10});
    tx1_enable=num2str(input_table{ii,11});
    tx2_enable=num2str(input_table{ii,12});
    tx3_enable=num2str(input_table{ii,13});
    tx4_enable=num2str(input_table{ii,14});

    name_array = {"chirpProfiles__chirpProfile0__chirpGenerator__center___frequency___kHz", ...
        "chirpProfiles__chirpProfile0__txPower__dBm",...
        "chirpProfiles__chirpProfile1__txPower__dBm",...
        "chirpProfiles__chirpProfile2__txPower__dBm",...
        "chirpProfiles__chirpProfile3__txPower__dBm",...
        "chirpProfiles__chirpProfile0__txTransmissionEnable__tx___1",...
        "chirpProfiles__chirpProfile0__txTransmissionEnable__tx___2",...
        "chirpProfiles__chirpProfile0__txTransmissionEnable__tx___3",...
        "chirpProfiles__chirpProfile0__txTransmissionEnable__tx___4",...
        "chirpSequenceConfigs__chirpSequenceConfig0__txEnable__tx___1",...
        "chirpSequenceConfigs__chirpSequenceConfig0__txEnable__tx___2",...
        "chirpSequenceConfigs__chirpSequenceConfig0__txEnable__tx___3",...
        "chirpSequenceConfigs__chirpSequenceConfig0__txEnable__tx___4"
        };


    value_array = {center_freq, ...
        tx_power_profile1, ...
        tx_power_profile2, ...
        tx_power_profile3, ...
        tx_power_profile4, ...
        tx1_enable,...
        tx2_enable,...
        tx3_enable,...
        tx4_enable,...
        tx1_enable,...
        tx2_enable,...
        tx3_enable,...
        tx4_enable
        };

    cd(path_config_python_wrapper);

    % Script 1: Modify RFE Config file
    res = pyrunfile("RunConfigWrapper.py", "out", xml_folder = xml_folder, xml_file = xml_file, name_array = name_array, value_array = value_array);

    %    CONFIG_filename= 'C:\git\mrta-tests-strx-sysval\TestStand\ConfigFiles\rfeConfig.bin'
    %    dynamic_table='C:\git\mrta-tests-strx-sysval\TestStand\ConfigFiles\rfeDynamicTables.bin'
    %     pause(2)
    [RX1PLossRow, RX1PLossCol] = PCBLossSel(input_table{ii,2}/1e6, "TXRX1");
    [RX2PLossRow, RX2PLossCol] = PCBLossSel(input_table{ii,2}/1e6, "TXRX2");
    [RX3PLossRow, RX3PLossCol] = PCBLossSel(input_table{ii,2}/1e6, "TXRX3");
    [RX4PLossRow, RX4PLossCol] = PCBLossSel(input_table{ii,2}/1e6, "TXRX4");

    % Load PCB losses and uncertainty from WgLossesUncertainty.mat cell.

    % PCB Losses are extracted from WgLossesUncertainty.mat cell
    PLossRX1                   = WgLossesUncertainty{RX1PLossRow, RX1PLossCol};
    PLossRX2                   = WgLossesUncertainty{RX2PLossRow, RX2PLossCol};
    PLossRX3                   = WgLossesUncertainty{RX3PLossRow, RX3PLossCol};
    PLossRX4                   = WgLossesUncertainty{RX4PLossRow, RX4PLossCol};

    % Combine all losses in one array
    PLossRX14                  = [PLossRX1 PLossRX2 PLossRX3 PLossRX4];


    if contains(tx1_enable,'enabled')==1
        [RXChSel] = RXSel("RX1 ");

    elseif contains(tx2_enable,'enabled')==1
        [RXChSel] = RXSel("RX2 ");
    elseif contains(tx3_enable,'enabled')==1
        [RXChSel] = RXSel("RX3 ");
    elseif contains(tx4_enable,'enabled')==1
        [RXChSel] = RXSel("RX4 ");

    end

    InputStruct.config_filename= 'C:\git\mrta-tests-strx-sysval\TestStand\ConfigFiles\rfeConfig.bin';
    InputStruct.dynamic_table_filename='';



    [OutputStruct] = ConfigureRfe(InputStruct);
    InputStruct.profile_index='0';

    [OutputStruct] = ContinuousWaveStart(InputStruct);
    pause(3);

    PowerValue= power_meter_value(str2num(center_freq)*1e3,Powermeter2_Address);
    %     pause(2);
    InputStruct.monitor_select=hex2dec('0x1FF');

    [OutputStruct]= MonitorReadRfe(InputStruct);

    deembedded_power=PowerValue+PLossRX14(RXChSel);

    temp_struct.TxPower = reshape(OutputStruct.TxPower, 1,32);
    temp_struct.Temperature = reshape(OutputStruct.Temperature,1,4);
    voltage_output=Read_DMM(DMM1_Address);


    [OutputStruct] = ContinuousWaveStop(InputStruct);

    Output=[Output; PowerValue,temp_struct.TxPower,temp_struct.Temperature,voltage_output,deembedded_power];




end

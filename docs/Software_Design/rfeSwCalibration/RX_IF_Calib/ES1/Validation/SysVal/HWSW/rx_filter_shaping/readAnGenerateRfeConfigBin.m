%% Function to read, copy and generate its associated .bin from a specified source rfeConfig.xml
function rfeConfigStruct = readAnGenerateRfeConfigBin(pathTorfeConfig,rfeConfigFileName,pathToConfigGenerator)
    rfeConfigOffName = 'rfeConfig.xml';
    status = copyfile([pathTorfeConfig rfeConfigFileName],[pathToConfigGenerator rfeConfigOffName]);
    disp(['Copying ' rfeConfigFileName  ' from ' pathTorfeConfig ' to ' pathToConfigGenerator rfeConfigOffName ]);
    % Save current dir
    topFolderPath = cd;
    % Go to dir where the rfe config generator is in
    cd(pathToConfigGenerator);
    % Launch the generation of rfeConfig.bin
    toExecute = 'rfeConfigGenerator.bat';
    status = system(toExecute);
    % Return to orignal directory
    cd(topFolderPath); 
    % Read the xml and put into a struct
    rfeConfigStruct = readstruct([pathTorfeConfig rfeConfigFileName]);
end
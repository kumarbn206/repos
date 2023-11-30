function LoadFwRfe(InputStruct)


CODE_DATA_CHECK = InputStruct.CodeDataCheck;
CODE_DATA_FILE_Path = InputStruct.CodeDataFilePath;

elfFileNamewithLoc = [InputStruct.elfFileLoc, '\', InputStruct.elfFileName,'.elf'];

ll.t32_startelf(elfFileNamewithLoc);
pause(10)

disp('Selecting Lauterbach');
ll.select(1)

if strcmpi(CODE_DATA_CHECK,'yes')
    ll.t32_cmd(['Data.Load.binary ' CODE_DATA_FILE_Path '\CODE 0x0'])
    ll.t32_cmd(['Data.Load.binary ' CODE_DATA_FILE_Path '\DATA 0x20000000'])
    ll.t32_cmd('Register.Init') 
end

disp('Starting rfeFw');
ll.t32_cmd('go');

end
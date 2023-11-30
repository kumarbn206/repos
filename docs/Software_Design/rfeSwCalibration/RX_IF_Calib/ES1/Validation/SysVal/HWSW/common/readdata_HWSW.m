function data = readdata_HWSW(DATA_ADDRESS, currentSystemSettings,outputFile)

startaddr=DATA_ADDRESS;
samplecount = currentSystemSettings.samples * currentSystemSettings.CHIRPS;
bytecount = samplecount * 4 * 2;
endaddr = startaddr + bytecount - 1;
% readout binary sample data and write it to a file
cmd = sprintf(['Data.SAVE.Binary ' replace(outputFile,'\','\\') ' SD:0x%08x--0x%08x'], startaddr, endaddr);
ll.t32_cmd(cmd);

% read the file
en_conversion=0;
f = fopen(outputFile);
data = fread(f, 'int16');
fclose(f);
if en_conversion==1
    data = double(data) / 2^15;
else
    data=double(data);
end

data = reshape(data, 4, samplecount)';
end

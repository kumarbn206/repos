%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate real data FFT test vectors, ie. int16 input data and FFT spectrum 
% output data, for FFT size [8,16384]
%     - int16 input and output in both int16 & single floating-point formats
%     - Create file to store the test vector
%     - Print out Hex value of vectors in int16 and the 32-bit float values
%
%  Note that the FFT is implemented for STRX M7 core with
%     - Input amplitude range within 16 bits
%     - Output is scaled down by 1/fftSize
%     - The spectrum bin fftSize/2 is put as the imaginary of bin 0 of the
%     FFT frame in the output file and in the printed FFT output results
%     to save memory.
%
% Hong Li 
% 29-03-2021
%

function [dataC16, dataF32] = rfeDspMath_getLogAndAngleTestVectors(arraySizeExpoBits, inRangeExpoBitCount)
  inRange = 2^inRangeExpoBitCount;
  arraySize = 2^arraySizeExpoBits;
  
  %%
  % Create random input data and convert to int16 value
  %
  dataIn = (rand(1,arraySize*2)-0.5)*2*inRange;
  dataIn_I16 = int16(dataIn);
  
  % Save input data
  fileName=sprintf('data%d_C16R%d.dat',arraySize,inRangeExpoBitCount);
  fidIn = fopen(fileName, 'w');
  fwrite(fidIn,dataIn_I16,'int16');
  fclose(fidIn);
  
  %% Print C16 input
  fileName=sprintf('data%d_C16R%d.dat',arraySize,inRangeExpoBitCount);
  fidIn = fopen(fileName, 'r');
  dataC16 = fread(fidIn, arraySize,'uint32');
  fclose(fidIn);
  fprintf('const uint32_t rfeDspMath_data%d_C16R%d[%d] = {\n',arraySize,inRangeExpoBitCount,arraySize);
  for i=1:8:arraySize
      fprintf('    0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL,\n', ...
               dataC16(i),dataC16(i+1),dataC16(i+2),dataC16(i+3),dataC16(i+4),dataC16(i+5),dataC16(i+6),dataC16(i+7));
  end
  fprintf('};\n\n');

  %% 
  % Get C16 ener_dB and angle
  %
  dData = double(dataIn_I16);
  dC16 = dData(1:2:end) + 1j * dData(2:2:end);
  ener = dC16 .* conj(dC16);
  ener_dB = 10 * log10(ener);
  angleF32 = atan2(imag(dC16), real(dC16));

  % Save ener_dB output files
  fileName=sprintf('dBF32Out%d_C16R%d.dat',arraySize,inRangeExpoBitCount);
  fid_dBF32 = fopen(fileName, 'w');

  outF32 = single(ener_dB);
  fwrite(fid_dBF32,outF32,'single');
  fclose(fid_dBF32);
  
  % Save angle output files
  fileName=sprintf('angleF32Out%d_C16R%d.dat',arraySize,inRangeExpoBitCount);
  fid_angleF32 = fopen(fileName, 'w');
  outF32 = single(angleF32);
  fwrite(fid_angleF32,outF32,'single');
  fclose(fid_angleF32);
  
  % Print dB values in 32-bit IEEE754 format
  fileName=sprintf('dBF32Out%d_C16R%d.dat',arraySize,inRangeExpoBitCount);
  fidOutCf32 = fopen(fileName, 'r');
  dBOut_Cf32 = fread(fidOutCf32, arraySize, 'uint32');
  fclose(fidOutCf32);
  
  fprintf('const uint32_t rfeDspMath_cAbs%ddBF32Out_C16R%d[%d] = {\n',arraySize,inRangeExpoBitCount,arraySize);
  for i=1:8:arraySize
      fprintf('    0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL,\n', ...
                   dBOut_Cf32(i),dBOut_Cf32(i+1),dBOut_Cf32(i+2), dBOut_Cf32(i+3),...
                   dBOut_Cf32(i+4),dBOut_Cf32(i+5),dBOut_Cf32(i+6),dBOut_Cf32(i+7));
  end
  fprintf('};\n\n');
  
  % Print angle values in 32-bit IEEE754 format
  fileName=sprintf('angleF32Out%d_C16R%d.dat',arraySize,inRangeExpoBitCount);
  fidOutCf32 = fopen(fileName, 'r');
  dBOut_Cf32 = fread(fidOutCf32, arraySize*2, 'uint32');
  fclose(fidOutCf32);
  
  fprintf('const uint32_t rfeDspMath_cAngle%dF32Out_C16R%d[%d] = {\n',arraySize,inRangeExpoBitCount,arraySize);
  for i=1:8:arraySize
      fprintf('    0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL,\n', ...
                   dBOut_Cf32(i),dBOut_Cf32(i+1),dBOut_Cf32(i+2), dBOut_Cf32(i+3),...
                   dBOut_Cf32(i+4),dBOut_Cf32(i+5),dBOut_Cf32(i+6),dBOut_Cf32(i+7));
  end
  fprintf('};\n\n');
  
  %% 
  % Get F32 input and their ener_dB and angle
  %
  dataF32 = fft(dC16);  % Take spectrum as single precesion floating-point input 
    
  % Save single-float results
  fileName=sprintf('data%d_CF32.dat',arraySize);
  fidIn = fopen(fileName, 'w');
  outF32 = single(dataF32);
  outF32w(1:2:(arraySize*2)) = real(outF32);
  outF32w(2:2:(arraySize*2)) = imag(outF32);
  fwrite(fidIn,outF32w,'single');
 
  % Print F32 values in 32-bit IEEE754 format
  fileName=sprintf('data%d_CF32.dat',arraySize);
  fidOutCf32 = fopen(fileName, 'r');
  dataCf32 = fread(fidOutCf32, arraySize*2, 'uint32');
  fclose(fidOutCf32);
  
  fprintf('const uint32_t rfeDspMath_data%d_Cf32[%d * 2] = {\n',arraySize,arraySize);
  for i=1:8:(arraySize*2)
    fprintf('    0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL,\n', ...
                   dataCf32(i),dataCf32(i+1),dataCf32(i+2), dataCf32(i+3),...
                   dataCf32(i+4),dataCf32(i+5),dataCf32(i+6),dataCf32(i+7));
  end
  fprintf('};\n\n');
      
  %% Calculate and save complex ABS dB and angle values
  dData = double(outF32);
  ener = dData .* conj(dData);
  ener_dB = 10 * log10(ener);
  angleF32 = angle(dData);

  % Save CABS dB output
  fileName=sprintf('dBF32Out%d_CF32.dat',arraySize);
  fidOutCf32 = fopen(fileName, 'w');
  outF32 = single(ener_dB);
  fwrite(fidOutCf32,outF32,'single');
  fclose(fidOutCf32);
  
  % Save angle output
  fileName=sprintf('angleF32Out%d_CF32.dat',arraySize);
  fidOutCf32 = fopen(fileName, 'w');
  outF32 = single(angleF32);
  fwrite(fidOutCf32,outF32,'single');
  fclose(fidOutCf32);

  % Print dB values in 32-bit IEEE754 format
  fileName=sprintf('dBF32Out%d_CF32.dat',arraySize);
  fidOutCf32 = fopen(fileName, 'r');
  dBOut_Cf32 = fread(fidOutCf32, arraySize, 'uint32');
  fclose(fidOutCf32);
  
  fprintf('const uint32_t rfeDspMath_cAbs%ddBF32Out_CF32[%d] = {\n',arraySize,arraySize);
  for i=1:8:arraySize
      fprintf('    0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL,\n', ...
                   dBOut_Cf32(i),dBOut_Cf32(i+1),dBOut_Cf32(i+2), dBOut_Cf32(i+3),...
                   dBOut_Cf32(i+4),dBOut_Cf32(i+5),dBOut_Cf32(i+6),dBOut_Cf32(i+7));
  end
  fprintf('};\n\n');
  
  % Print angle values in 32-bit IEEE754 format
  fileName=sprintf('angleF32Out%d_CF32.dat',arraySize);
  fidOutCf32 = fopen(fileName, 'r');
  dBOut_Cf32 = fread(fidOutCf32, arraySize*2, 'uint32');
  fclose(fidOutCf32);
  
  fprintf('const uint32_t rfeDspMath_cAngle%dF32Out_CF32[%d] = {\n',arraySize,arraySize);
  for i=1:8:arraySize
      fprintf('    0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL,\n', ...
                   dBOut_Cf32(i),dBOut_Cf32(i+1),dBOut_Cf32(i+2), dBOut_Cf32(i+3),...
                   dBOut_Cf32(i+4),dBOut_Cf32(i+5),dBOut_Cf32(i+6),dBOut_Cf32(i+7));
  end
  fprintf('};\n\n');
end
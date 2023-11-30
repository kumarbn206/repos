function rfeDspMath_printComplexToHexString(nameString, complexData)
  outF32 = single(complexData);
  nF32 = length(outF32) .* 2;
  outF32w(1:2:nF32) = real(outF32);
  outF32w(2:2:nF32) = imag(outF32);
  outC16w = int16(outF32w);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Save Complex float data in a temple file
  fileName=sprintf('temp.dat');
  fidOutCf32 = fopen(fileName, 'w');
  fwrite(fidOutCf32,outF32w,'single');
  fclose(fidOutCf32);
  
  % Load float array as uint32 data in IEEE754 format and print out
  fidOutCf32 = fopen(fileName, 'r');
  fftOut_Cf32 = fread(fidOutCf32, nF32, 'uint32');
  fclose(fidOutCf32);
  
  n8Elems = 8 * floor(nF32 / 8);
  fprintf('%s_CF32 = {\n', nameString);
  for i = 1:8:n8Elems
      fprintf(' 0x%08Xul, 0x%08Xul, 0x%08Xul, 0x%08Xul, 0x%08Xul, 0x%08Xul, 0x%08Xul, 0x%08Xul,\n', ...
               fftOut_Cf32(i),fftOut_Cf32(i+1),fftOut_Cf32(i+2), fftOut_Cf32(i+3),...
               fftOut_Cf32(i+4),fftOut_Cf32(i+5),fftOut_Cf32(i+6),fftOut_Cf32(i+7));
  end
  
  for i = (n8Elems+1):nF32
       fprintf(' 0x%08Xul,', fftOut_Cf32(i));
  end
  fprintf('};\n\n');

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Save Complex int16 data in a temple file
  fileName=sprintf('temp.dat');
  fidOutC16 = fopen(fileName, 'w');
  fwrite(fidOutC16,outC16w,'int16');
  fclose(fidOutC16);
  
  % Load float array as uint32 data in IEEE754 format and print out
  nI16 = nF32/2;
  fidOutC16 = fopen(fileName, 'r');
  fftOut_C16 = fread(fidOutC16, nI16, 'uint32');
  fclose(fidOutC16);
  
  n8Elems = 8 * floor(nI16 / 8);
  fprintf('%s_C16 = {\n', nameString);
  for i = 1:8:n8Elems
      fprintf(' 0x%08Xul, 0x%08Xul, 0x%08Xul, 0x%08Xul, 0x%08Xul, 0x%08Xul, 0x%08Xul, 0x%08Xul,\n', ...
               fftOut_C16(i),fftOut_C16(i+1),fftOut_C16(i+2), fftOut_C16(i+3),...
               fftOut_C16(i+4),fftOut_C16(i+5),fftOut_C16(i+6),fftOut_C16(i+7));
  end
  
  for i = (n8Elems+1):nI16
       fprintf(' 0x%08Xul,', fftOut_C16(i));
  end
  fprintf('};\n\n');

end
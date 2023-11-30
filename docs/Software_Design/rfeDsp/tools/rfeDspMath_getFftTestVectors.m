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

function [fftIn_I16, fftOutH1_C16, fftOutH1_Cf32] = rfeDspMath_getFftTestVectors(fftSizeExpoBitCount, nFrames, inRangeExpoBitCount)
  fftSize = 2^fftSizeExpoBitCount;
  inRange = 2^inRangeExpoBitCount;
  
  % Create random input data and convert to int16 value
  fftIn = (rand(1,fftSize*nFrames)-0.5)*2*inRange;
  fftIn_I16 = int16(fftIn);
  
  % Remove DC 
  dc2 = sum(fftIn_I16)./(fftSize*nFrames)
  fftIn_I16 = fftIn_I16 - int16(dc2);
  dc3 = sum(fftIn_I16)./(fftSize*nFrames)
  
  % Save input data
  fileName=sprintf('fft%dIn_I16R%dnFrame%d.dat',fftSize,inRangeExpoBitCount,nFrames);
  fidIn = fopen(fileName, 'w');
  fwrite(fidIn,fftIn_I16,'int16');
  fclose(fidIn);
  
  % Open output files
  fileName=sprintf('fft%dOutH1_Cf32R%dnFrame%d.dat',fftSize,inRangeExpoBitCount,nFrames);
  fidOutCf32 = fopen(fileName, 'w');
  
  fileName=sprintf('fft%dOutH1_C16R%dnFrame%d.dat',fftSize,inRangeExpoBitCount,nFrames);
  fidOutC16 = fopen(fileName, 'w');
  
  % Calculate and save FFT results
  offset = 0;
  for i = 1:nFrames
      dIn = double(fftIn_I16(offset+(1:fftSize)));
      dataOut = fft(dIn) ./ fftSize;  % STRX M7 FFT implementation scales results down by 1/fftSize 
      offset = offset + fftSize;
      
      % Put bin fftSize+1 at the imaginary of bin 1
      dataOut(fftSize/2 + 1)
      dataOut(1) = dataOut(1) + 1j * dataOut(fftSize/2 + 1);
      
      % Save single-float results
      outF32 = single(dataOut(1:fftSize/2));
      outF32w(1:2:fftSize) = real(outF32);
      outF32w(2:2:fftSize) = imag(outF32);
      fwrite(fidOutCf32,outF32w,'single');
      
      % Save int16 results
      outI16w = int16(outF32w);
      fwrite(fidOutC16,outI16w,'int16');
  end
  fclose(fidOutCf32);
  fclose(fidOutC16);

  % Print I16 input in int16x2 format
  fileName=sprintf('fft%dIn_I16R%dnFrame%d.dat',fftSize,inRangeExpoBitCount,nFrames);
  fidIn = fopen(fileName, 'r');
  fftIn_I16x2 = fread(fidIn, fftSize*nFrames/2,'uint32');
  fclose(fidIn);
  fprintf('int16x2_t rfeDspMath_fft%dIn_I16R%dnFrame%d[%d * %d / 2] = {\n',fftSize,inRangeExpoBitCount,nFrames,fftSize,nFrames);
  if (fftSize * nFrames >= 16)
    for i=1:8:(fftSize*nFrames/2)
      fprintf('    0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL,\n', ...
               fftIn_I16x2(i),fftIn_I16x2(i+1),fftIn_I16x2(i+2), fftIn_I16x2(i+3), ...
               fftIn_I16x2(i+4),fftIn_I16x2(i+5),fftIn_I16x2(i+6),fftIn_I16x2(i+7));
    end
  else
    fprintf('   0x%08XUL', fftIn_I16x2(1)); 
    for i=2:(fftSize*nFrames/2)
       fprintf(', 0x%08XUL', fftIn_I16x2(i));
    end
  end
  fprintf('};\n\n');

  
  % Print C16 output for half of the spectrum
  fileName=sprintf('fft%dOutH1_C16R%dnFrame%d.dat',fftSize,inRangeExpoBitCount,nFrames);
  fidOutC16 = fopen(fileName, 'r');
  fftOutH1_C16 = fread(fidOutC16, fftSize*nFrames/2, 'uint32');
  fclose(fidOutC16);
  
  fprintf('int16x2_t rfeDspMath_fft%dOutH1_C16R%dnFrame%d[%d/2 * %d] = {\n',fftSize,inRangeExpoBitCount,nFrames,fftSize,nFrames);
  if (fftSize * nFrames >= 16)
    for i=1:8:(fftSize*nFrames/2)
      fprintf('    0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL,\n', ...
               fftOutH1_C16(i),fftOutH1_C16(i+1),fftOutH1_C16(i+2), fftOutH1_C16(i+3),...
               fftOutH1_C16(i+4),fftOutH1_C16(i+5),fftOutH1_C16(i+6),fftOutH1_C16(i+7));
    end
  else
    fprintf('   0x%08XUL', fftOutH1_C16(1)); 
    for i=2:(fftSize*nFrames/2)
       fprintf(', 0x%08XUL', fftOutH1_C16(i));
    end
  end
  fprintf('};\n\n');
  
  % Print 32-bit Cf32 values in IEEE754 format
  fileName=sprintf('fft%dOutH1_Cf32R%dnFrame%d.dat',fftSize,inRangeExpoBitCount,nFrames);
  fidOutCf32 = fopen(fileName, 'r');
  fftOutH1_Cf32 = fread(fidOutCf32, fftSize*nFrames, 'uint32');
  fclose(fidOutCf32);
  
  fprintf('uint32_t rfeDspMath_fft%dOutH1_Cf32R%dnFrame%d[%d * %d] = {\n',fftSize,inRangeExpoBitCount,nFrames,fftSize,nFrames);
  if (fftSize * nFrames >= 16)
    for i=1:8:(fftSize*nFrames)
      fprintf('    0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL, 0x%08XUL,\n', ...
               fftOutH1_Cf32(i),fftOutH1_Cf32(i+1),fftOutH1_Cf32(i+2), fftOutH1_Cf32(i+3),...
               fftOutH1_Cf32(i+4),fftOutH1_Cf32(i+5),fftOutH1_Cf32(i+6),fftOutH1_Cf32(i+7));
    end
  else
    fprintf('   0x%08XUL', fftOutH1_Cf32(1)); 
    for i=2:(fftSize*nFrames)
       fprintf(', 0x%08XUL', fftOutH1_Cf32(i));
    end
  end
  
  w64 = exp(-j*2*pi/512 * 64);
  w64_2 = w64 .* w64;
  X64=dIn(512)*w64d + dIn(511);
  for k=510:-2:1
      X64 = dIn(k-1) + dIn(k)*w64d + X64*w64_2d; 
  end
  fprintf('};\n\n');
  
end
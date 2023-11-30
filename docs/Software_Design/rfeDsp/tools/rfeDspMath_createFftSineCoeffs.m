%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create a quator of sine table, i.e. in [0, pi/2] for FFT
%     - In int16 and in single floating-point format
%     - Create file to store the sine coeffecients
%     - Print out Hex value of coefficients in int16 and the 32-bit float
%     value
%
% Hong Li 
% 27-03-2021
%
function [sin1Q_I16, sin1Q_f32] = rfeDspMath_createFftSineCoeffs(expoBitCount)
  fftSize = 2^expoBitCount;
  qSize = fftSize/4;
  sin1Q = sin(2*pi*(0:qSize)/fftSize);
  sin1Q_f32 = single(sin1Q);
  sin1Q_I16 = int16(sin1Q .* 32768);
  
  % Save table to files
  fileName=sprintf('sineTable%dQ1_I16.dat',fftSize);
  fid = fopen(fileName, 'w');
  fwrite(fid,sin1Q_I16,'int16');
  fclose(fid);
  
  fileName=sprintf('sineTable%dQ1_f32.dat',fftSize);
  fid = fopen(fileName, 'w');
  fwrite(fid,sin1Q_f32,'single');
  fclose(fid);
  
  % Print out int16_t values of sin1k1q_I16
  fprintf('  int16_t rfeDspMat_sine%dQ1_I16[%d/4+1] = {\n',fftSize,fftSize);
  for i=1:8:qSize
      fprintf('    0x%04X, 0x%04X, 0x%04X, 0x%04X, 0x%04X, 0x%04X, 0x%04X, 0x%04X,\n', ...
                sin1Q_I16(i),sin1Q_I16(i+1),sin1Q_I16(i+2),sin1Q_I16(i+3), ...
                sin1Q_I16(i+4),sin1Q_I16(i+5),sin1Q_I16(i+6),sin1Q_I16(i+7));
  end
  fprintf('    0x%04X\n  };\n\n',sin1Q_I16(i+8));
  
  % Print out float values in IEEE754 code Hex value
  fid = fopen(fileName, 'r');
  sin1Q_f32 = fread(fid, qSize+1, 'uint32');
  fclose(fid);
  
  fprintf('  uint32_t rfeDspMat_sine%dQ1_f32[%d/4+1] = {\n',fftSize,fftSize);
  for i=1:8:qSize
      fprintf('    0x%08Xul, 0x%08Xul, 0x%08Xul, 0x%08Xul, 0x%08Xul, 0x%08Xul, 0x%08Xul, 0x%08Xul,\n', ...
                sin1Q_f32(i),sin1Q_f32(i+1),sin1Q_f32(i+2),sin1Q_f32(i+3), ...
                sin1Q_f32(i+4),sin1Q_f32(i+5),sin1Q_f32(i+6),sin1Q_f32(i+7));
  end
  fprintf('    0x%08Xul\n  };\n',sin1Q_f32(i+8));
  
end
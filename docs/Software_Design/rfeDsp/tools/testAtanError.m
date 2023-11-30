%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testAtanError
%
% History
%   10-03-2021   Hong Li   First implementation
%

function testAtanError()

nErrors = 4; 
Errors = 0.02 * (2.^(-[0:(nErrors-1)]));
maxE_deg = zeros(nErrors);

% Test int16 range error 
a=[0:0.01:200];
aDeg = 180/pi;
for i16=1:nErrors
  b= a + a.* Errors(i16);
  delta = (atan(b) - atan(a)).*aDeg;
  [maxDelta, idx] = max(abs(delta));
  
  if maxDelta>maxE_deg(i16)
      maxE_deg(i16) = maxDelta;
  end
  
  figure;
  fprintf('Max atan(x) result error = %e degree for relative input error %e at input %d\n',maxE_deg(i16), Errors(i16), a(idx));
  plot(a,delta);grid on; grid minor;drawnow;
  titleStrH = sprintf('Atan(x) angle error if x reletive error=%f\n', Errors(i16));
  title(titleStrH);    
  xlabel('Input x'); ylabel('Angle error (degree)');

end

figure;
plot(Errors,maxE_deg);

% Test cint16 range error 
a=[0:(2^15)];
for i16=1:nErrors
  b= a + a.* Errors(i16);
  delta = (atan(b) - atan(a))*180/pi;
  [maxDelta, idx] = max(abs(delta));
  
  if maxDelta>maxE_deg(i16)
      maxE_deg(i16) = maxDelta;
  end
  
  figure;
  fprintf('Max atan(x) result error = %e degree for relative input error %e at input %d\n',maxE_deg(i16), Errors(i16), a(idx));
  plot(a,delta);grid on; grid minor;drawnow;
  titleStrH = sprintf('Atan(x) angle error if x reletive error=%1.4f\n', Errors(i16));
  title(titleStrH);    
  xlabel('Input x'); ylabel('Angle error (degree)');

end

figure;
plot(Errors,maxE_deg);
end
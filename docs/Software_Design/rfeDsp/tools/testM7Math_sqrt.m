function testM7Math_sqrt()
%TESTM7MATH_SQRT Summary of this function goes here
%   Detailed explanation goes here
    iter= 10;
    
    % test int16_t input
    data = [-1 : 32767];
    accu= 1e-9;
    [root, maxLoop] = m7Math_sqrt(data,10, accu, 0);
    fprintf('Test SQRT-Bakhshali int16_t input: need max %d iterations for reletive accu=%e \n',maxLoop, accu);
    
    [root1, maxLoop1] = m7Math_sqrt(data,50, accu, 1);
    fprintf('Test SQRT-Newton int16_t input: need max %d iterations for reletive accu=%e \n',maxLoop1, accu);
   
    %test float input
    data = rand(10000) *(10^10);
    [root, maxLoop] = m7Math_sqrt(data,10, accu, 0);
    fprintf('Test SQRT-Bakhshali float32_t input: need max %d iterations for reletive accu=%e \n',maxLoop, accu);
    
    [root1, maxLoop1] = m7Math_sqrt(data,50, accu, 1);
    fprintf('Test SQRT-Newton int16_t input: need max %d iterations for reletive accu=%e \n',maxLoop1, accu);
    
end

function [srootF16, maxLoop] = m7Math_sqrt(dataF16_array,iter,accu,newton)
  maxLoop = 0;
  nElem = length(dataF16_array);
  srootF16 = zeros(nElem,1);
  for i16=1:nElem
     vf = dataF16_array(i16);
     if vf <= 0
         if 0 == vf
             srootF16(i16) = 0;
         else
             srootF16(i16) = -1;
         end
      else
         
         % find initial value
         if vf < 1
           % find leading bit of vf
           for jj16=1:32
             if (vf*(2^jj16) > 1) break; end
           end
           res = 2^(-(jj16/2));
         else
           % find leading bit of vf
           for jj16=1:32
              if (vf/(2^jj16) < 1) break; end
           end
           res = 2^(jj16/2);
         end
         
         if newton
             for jj16=0:iter
                res0=res;
                res = (res0 + vf/res0)/2;
                if 1
                   ref= sqrt(vf); delta=ref-res;
                   fprintf('Test SQRT(%e,%d)=%e ref=%e delta=%e \n',vf,jj16,res,ref,delta);
                end
                if(abs(res-res0) < res*accu) 
                    break;
                end
             end
         else
             for jj16=0:iter
                res0=res;
                a = (vf-res0*res0)/(res0*2);
                b = res0+a;
                res = b - (a*a)/(2*b);
                if 0
                   fprintf('Test SQRT(%e,%d)=%e ref=%e \n',vf,jj16,res,sqrt(vf));
                end
                if(abs(res-res0) < res*accu) 
                    break;
                end
             end
         end
         if jj16>maxLoop
             maxLoop = jj16;
             fprintf('Test SQRT(%e)=%e maxLoop=%d, ref=%e \n',vf,res,jj16,sqrt(vf));
         end
         srootF16(i16) = res;
      end
  end
end

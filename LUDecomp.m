function M = LUDecomp()
  A = [2 -3 1; 1 1 -1; -1 1 -3];
  B = [-1 0 0];
  C = [A B'];
  [L, U] = LUD(A, B);
  M = [L U];
end

function [L, U] = LUD(A, B)
  
  C = [A B'];
  P = zeros(size(A))
  L = zeros(size(A))
  
  
  [cols rows] = size(A)
  for k = 1:cols
    [t p] = max(abs(C(k:cols, k)));
    p = p + k-1; % Convert to matrix
    C([k p], :) = C([p k], :);
    P([k p], :) = P([p k], :);
    for r = k+1:cols
      % Get the multiplier
      mult = C(r,k) / C(k,k);
      % Multiply the row by this thing
      C(r,:) -= C(k,:) * mult;
    end
  end
  
  % Loop down the columns
  % for c = 1:cols
  %   for r = c:rows
  %     
  %     C(r,c)
  %   end
  % end
  % 
  L = tril(A);
  U = triu(A);
end

function M = swap(M, r1, r2)
  [rows cols] = size(M);
  if ( r1 == r2 )
    return;
  end
  if ( r1 < 1 || r1 > rows || r2 < 1 | r2 > rows )
    return;
  end;
  temp = M(r1,:);
  M(r1,:) = M(r2,:);
  M(r2,:) = temp;
end




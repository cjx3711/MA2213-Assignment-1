function M = LUDecomp()
  % A = [2 -3 1; 1 1 -1; -1 1 -3] 
  % B = [-1 0 0];
  A = [0 1 -1 1; 1 1 -1 2; -1 -1 1 0; 1 2 0 2 ]
  B = [3 4 -4 5];
  C = [A B'];
  [L, U] = LUD(A, B);
  M = [L U];
end

function [L, U] = LUD(A, B)
  
  C = [A B'];
  P = eye(size(A));
  L = eye(size(A));
  
  
  [cols rows] = size(A);
  for k = 1:cols
    [t p] = max(abs(C(k:cols, k)));
    p = p + k-1; % Convert to matrix
    if p ~= k
      C([k p], :) = C([p k], :);
      P([k p], :) = P([p k], :);
      L([k,p],:) = L([p,k],:);
    end
    for r = k+1:cols
      % Get the multiplier
      mult = C(r,k) / C(k,k);
      L(r, k) = mult;
      % Multiply the row by this thing
      C(r,k:cols) -= C(k,k:cols) * mult;
    end
  end
  L * C
  L
  
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




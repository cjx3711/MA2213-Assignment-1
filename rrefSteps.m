function M = rrefSteps(M)
%refSteps
%Generate the Row Echelon form of a matrix showing each step in the process
mSize = size(M);
sizeX = mSize(1,2);
sizeY = mSize(1,1);

if ( sizeX == 1 || sizeY == 1 ) 
   M = ['Error: Cannot calculate Row Echelon Form of a ' num2str(sizeX) 'x' num2str(sizeY) ' matrix'];
   return;
end

disp ('Calculating Reduced Row Echelon form of ');
disp(M);
disp(' ');

M = organise0 (M);
M = RowEchelonForm( M, 1, 1 );
disp ( 'Row Echelon Form is:' );
disp (M);

disp (' ');

M = ReducedRowEchelonForm( M, 1, 1 );
disp ( 'ReducedRow Echelon Form is:' );
disp (M);

end


function M = ReducedRowEchelonForm ( M , startX, startY ) 
    mSize = size(M);
    sizeX = mSize(1,2);
    sizeY = mSize(1,1);
    
    if ( startX > sizeX || startY > sizeY ) return; end
     
    %Work on first column
    pivotEntry = M(startY, startX);
    
     if ( pivotEntry == 0 ) 
		%Move to next col
		M = ReducedRowEchelonForm ( M, startX + 1, startY );
		return;
    end
    
    if ( pivotEntry ~= 1 ) 
        %Make topLeftVal 1
        M = multRow(M, 1/pivotEntry, startY);
        pivotEntry = M(startY, startX);
    end
    
    %Check all other rows in this col to ensure they are 0
    for y = 1 : sizeY
       if ( y == startY ) continue; end
       
       val = M(y,startX);
       if ( val ~= 0 )
          %Do addition to make it 0
          multiple = -val/pivotEntry;
          M = addRow ( M, multiple, startY, y );
       end
    end
    
    %Move to next row and col
	M = ReducedRowEchelonForm( M, startX+1, startY+1 );

end

function M = RowEchelonForm ( M, startX, startY )
    mSize = size(M);
    sizeX = mSize(1,2);
    sizeY = mSize(1,1);
    
    if ( startX > sizeX || startY > sizeY ) return; end
    
    %Work on first column
    pivotEntry = M(startY, startX);
    
    if ( pivotEntry == 0 ) 
		%Move to next col
		M = RowEchelonForm ( M, startX + 1, startY );
		return;
    end
    
    
	%Make the rows 0
	for y = startY+1:sizeY 
		val = M ( y, startX );
		if ( val == 0 ) break; end
		
		multiple = -val/pivotEntry;
		M = addRow ( M, multiple, startY, y );
    end
	
	%Move to next row and col
	M = RowEchelonForm( M, startX+1, startY+1 );
end

% Will arrange the matrix to as close to REF as possible
function M = organise0 ( M ) 
    mSize = size(M);
    sizeX = mSize(1,2);
    sizeY = mSize(1,1);
    
    %Count number of leading 0s for each row
    leading0 = zeros(sizeY,1);
    for y = 1:sizeY
        count = 0;
        for x = 1:sizeX
            if ( M(y,x) == 0 ) count = count + 1;
            else break; end
        end
        leading0(y,1) = count;
    end

    for y = 1:sizeY
       %Locate smallest number
       smallestRow = y;
       smallestNumber = leading0(y,1);
       for ys = y:sizeY;
          if ( leading0(ys,1) < smallestNumber )
             smallestNumber = leading0(ys,1);
             smallestRow = ys;
          end
       end
       
       if (smallestRow ~= y )
           %Swap this row with smallest number row
           M = swapRows ( M, smallestRow, y );
           leading0 = swapRowsSilent ( leading0, smallestRow, y );
       end
    end
    
end

function M = swapRowsSilent ( M, row1, row2 )
    mSize = size(M);
    sizeX = mSize(1,2);
    
	for i = 1:sizeX
		temp = M(row1, i);
		M(row1,i) = M(row2,i);
		M(row2,i) = temp;
	end;
end

function M = swapRows ( M, row1, row2 )
    M = swapRowsSilent(M, row1, row2);
    disp(['Swapped row ' num2str(row1) ' & ' num2str(row2)]);
    disp(['R' num2str(row1) ' <-> R' num2str(row2)]);
    disp(M);
end

function M = addRowSilent ( M, multiple, from, to )
    mSize = size(M);
    sizeX = mSize(1,2);
    
	for i = 1:sizeX
		M(to,i) = M(to,i) + multiple * M(from,i);
	end;
end

function M = addRow ( M, multiple, from, to )
    M = addRowSilent ( M, multiple, from, to );
    disp(['Added ' num2str(multiple) 'X row ' num2str(from) ' to ' num2str(to)]);
    if ( multiple < 0 )
        disp(['R' num2str(to) ' - ' num2str(abs(multiple)) 'R' num2str(from)]);
    else 
        disp(['R' num2str(to) ' + ' num2str(multiple) 'R' num2str(from)]);
    end
    
    %disp(sprintf('Added %gX row %g to %g ', num2str(rat(multiple)), from, to));
    disp(M);
end

function M = multRowSilent ( M, multiple, row )
    mSize = size(M);
    sizeX = mSize(1,2);
    
	for i = 1:sizeX
		M(row,i) = M(row,i) * multiple;
	end;
end

function M = multRow ( M, multiple, row )
    M = multRowSilent( M, multiple, row );
    disp(['Multiplied row ' num2str(row) ' by ' num2str(multiple)]);
    disp([num2str(multiple) 'R' num2str(row)]);
    disp(M);
end
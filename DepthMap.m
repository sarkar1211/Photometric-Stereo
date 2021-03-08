function [z] = DepthMap(surfaceNormals, maskImage )

   z = [];
   mask_conv = rgb2gray(imread(maskImage));
   rows = size(mask_conv, 1);
   cols = size(mask_conv, 2);
   
   
   [obj_PixelRow obj_PixelCol] = find(mask_conv);
   obj_Pixels = [obj_PixelRow obj_PixelCol]; 

% Creating the index matrix to quickly retrieve the index number of the object pixel.

  index_matrix = zeros(rows, cols);

% Total number of Pixels within the mask;
  Pixels =  size(obj_Pixels, 1);

  for k = 1:Pixels
      Row = obj_Pixels(k, 1);
      Col = obj_Pixels(k, 2);
      index_matrix(Row, Col) = k;
  end



  S_matrix = sparse(2*Pixels, Pixels);
  b = zeros(2*Pixels, 1);

  for d = 1: Pixels
      Row = obj_Pixels(d, 1);
      Col = obj_Pixels(d, 2);
      nx = surfaceNormals(Row, Col, 1);
      ny = surfaceNormals(Row, Col, 2);
      nz = surfaceNormals(Row, Col, 3);      
      % Looking for all the pixel values that are within or on the
      % bourndary of the sample object
      if (index_matrix(Row, Col+1) > 0) && (index_matrix(Row-1, Col) > 0)     
          % Both the (X+1, Y) and (X, Y+1) are still inside the object.
          S_matrix(2*d-1, index_matrix(Row, Col))   = 1;
          S_matrix(2*d-1, index_matrix(Row, Col+1)) = -1;   % (X+1, Y)
          b(2*d-1, 1) = nx / nz;   

          S_matrix(2*d, index_matrix(Row, Col))     = 1;
          S_matrix(2*d, index_matrix(Row-1, Col))   = -1;     % (X, Y+1)
          b(2*d, 1) = ny / nz;  

      elseif (index_matrix(Row-1, Col) > 0)     
          % The coordinate (X, Y+1) is still inside the object, but (X+1,
          % Y) is outside.
          f = -1;
          if (index_matrix(Row, Col+f) > 0)
              S_matrix(2*d-1, index_matrix(Row, Col)) = 1;
              S_matrix(2*d-1, index_matrix(Row, Col+f)) = -1;   % (X+f, Y)
              b(2*d-1, 1) = f * nx / nz;    
          end
          S_matrix(2*d, index_matrix(Row, Col)) = 1;
          S_matrix(2*d, index_matrix(Row-1, Col)) = -1;     % (X, Y+1)
          b(2*d, 1) = ny / nz;      

      elseif (index_matrix(Row, Col+1) > 0)     
          % The coordinate (X+1, Y) is still inside the object, but (X, Y+1) is outside.
          f = -1;
          if (index_matrix(Row-f, Col) > 0)
              S_matrix(2*d, index_matrix(Row, Col)) = 1;
              S_matrix(2*d, index_matrix(Row-f, Col)) = -1;     % (X, Y+f)
              N(2*d, 1) = f*ny / nz;               
          end
          S_matrix(2*d-1, index_matrix(Row, Col)) = 1;
          S_matrix(2*d-1, index_matrix(Row, Col+1)) = -1;   % (X+1, Y)
          N(2*d-1, 1) = nx / nz; 

      else     % Both the values (X+1) and (Y+1) are outside the object.
          f = -1;
          if (index_matrix(Row, Col+f) > 0)
              S_matrix(2*d-1, index_matrix(Row, Col)) = 1;
              % (X+f, Y)
              S_matrix(2*d-1, index_matrix(Row, Col+f)) = -1;   
              N(2*d-1, 1) = f * nx / nz;           
          end
          f = -1;
          if (index_matrix(Row-f, Col) > 0)
              S_matrix(2*d, index_matrix(Row, Col)) = 1;
              % (X, Y+f)
              S_matrix(2*d, index_matrix(Row-f, Col)) = -1;     
              b(2*d, 1) = f*ny / nz;              
          end
      end
  end

  x = S_matrix \ b;
  x = x - min(x);

  tempShape = zeros(rows, cols);
  for d = 1:Pixels
      Row = obj_Pixels(d, 1);
      Col = obj_Pixels(d, 2);
      tempShape(Row, Col) = x(d, 1);
  end

  z  = zeros( rows, cols);
  for i = 1:rows
      for j = 1:cols
          z(i, j) = tempShape(rows-i+1, j);
      end
  end

end
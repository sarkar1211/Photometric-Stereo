function I = imread_pfm(filename)

Gin1 = Tiff(filename);
imageData = read(Gin1);

I = imageData;
% Displaying image 1 and getting pixel info from the image
imshow(I); 
%imfinfo('C:\Users\Surojit\Desktop\Photommetric _Stereo\Assignment_1\image001.tif'); impixelinfo;

close(Gin1);
end



% I         : Floating point image in the range [0,1]
% filename  : Name of the raw file to convert
% 
% To compile, run:
%  mex imread_pfm.cpp

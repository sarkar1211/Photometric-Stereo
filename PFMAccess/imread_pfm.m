close all; clear all; clc
function I = imread_pfm(filename)

Gin1 = PBM(filename)
imageData = read(Gin1)
I = imageData;

close(Gin1)
end

%
% I         : Floating point image in the range [0,1]
% filename  : Name of the raw file to convert

% To compile, run:
%  mex imread_pfm.cpp

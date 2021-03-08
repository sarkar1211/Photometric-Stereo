function L_magnitude = calc_L_mag(maskimage, imagesList)

disp('Calculating the light intensity...');

% Calculating the center and radius of the sphere
imgMask = rgb2gray(imread(maskimage));

% alloc
L_magnitude = zeros(length(imagesList),1);

% find light intensity
for i=1:length(imagesList(:,1))
	imgGray = rgb2gray(imread_pfm(imagesList(i,:)));
	imgGray(~imgMask) = 0;
	L_magnitude(i,:) =  max(imgGray(:));
end


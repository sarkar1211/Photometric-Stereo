function hlPos = calc_Highlight(imageTIFF, imageMask)
% this function is used to find the highlight region within the mask image
% return the coordinate of the highlight region

	img = rgb2gray(imread_pfm(imageTIFF));

	% Masking all the other regions
	img(~imageMask) = 0;

	% Finding the hightlighted region
	[y x]= find(img >= 0.9);

	% Calculatiung the position
	startX = min(x);
	startY = min(y);
	offsetX = (max(x) - startX)/2;
	offsetY = (max(y) - startY)/2;
	xPos = round(startX + offsetX);
	yPos = round(startY + offsetY);
	hlPos = [xPos yPos];
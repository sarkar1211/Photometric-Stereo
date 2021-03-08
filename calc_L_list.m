function L_vec = calc_L_list(mask_img, imagesList)
fprintf('Calibrating the  illumination direction with %s...\n',mask_img);

sphereMaskImage = rgb2gray(imread(mask_img));

% Taking the shpere's pixels
[y x]= find(sphereMaskImage>250);

% Calculating the sphere's radius
width = max(x) - min(x);
height = max(y) - min(y);
radius = (width+height)/4;	%average value

% Calculating the sphere's center
centerX = round(min(x) + radius);
centerY = round(min(y) + radius);
center = [centerX centerY];

% Initializing the matrix for illumunitation directions
L_vec = zeros(length(imagesList),3);

% find L of all images
for i=1:length(imagesList(:,1))
	highlight = calc_Highlight(imagesList(i,:), sphereMaskImage);
	if isempty(highlight)	% cannot find highlight
		continue;
	end
	L_vec(i,:) = calc_L(highlight, center, radius);
end
function [normalmap albedo] = calc_normal_albedo(mask_object, imagesList, L_vec_1, L_vec_2, L_magnitude)

imask_object = rgb2gray(imread(mask_object));

% Finding all the object's pixels
[objectY objectX] = find(imask_object > 127);

% Initializing all the vectors
imageHeight = length(imask_object(:,1));
imageWidth = length(imask_object(1,:));
imageListSize = length(imagesList(:,1));
IL1 = zeros(imageListSize,3);
IL2 = zeros(imageListSize,3);
I = zeros(imageListSize,1);
I_squared = zeros(imageListSize*2,1);
normalmap = zeros(imageHeight, imageWidth, 3);
images = zeros( length(imagesList(:,1)), imageHeight, imageWidth );
albedo = zeros(imageHeight, imageWidth);

% Normalizing the light intensity
disp('  - Normalizing light intensity...');
[min_mag min_ind] = min(L_magnitude);
coefficient = min_mag./L_magnitude;


for i=1:imageListSize
	
	img = rgb2gray(imread_pfm(imagesList(i,:)));
	images(i,:,:) = img.*coefficient(i);
end

disp('  - Estimating normals...');

% iterating over all X Y's of the sample object
% here the formula I=G*L is used for computing albedo and surface normals
for j=1:length(objectX(:))	
	
	for i=1:imageListSize
		I(i) = images(i, objectY(j), objectX(j));
        
		% multiplying both sides with I
		IL1(i,:) = I(i) .* L_vec_1(i,:);
		IL2(i,:) = I(i) .* L_vec_2(i,:);
		I(i) = I(i).^2;
	end
	
	% Using Linear Least square method for computing albedo and surface
	% normals
	IL = [IL1; IL2];
	I_squared = [I; I];
    
    % removing zero entires
	I_squared(all(IL==0,2),:)=[];	
    
    % removing zero entires
	IL(all(IL==0,2),:)=[];
    
	% using Singular Value Decomposition
	[U,S,V] = svd(IL,'econ');
	s = diag(S);
	d = U'*I_squared;
	G = V*(d./s);	% G
    % The length of G is k_d
	k_d = norm(G);	
	surfacenormal = G/k_d;
	% Saving the result into normalmap and albedo matrix
	normalmap(objectY(j), objectX(j), :) = surfacenormal;
	albedo(objectY(j), objectX(j)) = k_d;
end
% shifting and scaling the normals to rgb
normalmapRGB = (normalmap + 1) ./ 2;	
imwrite(normalmapRGB, 'NormalMap.png');

figure;
title('Normal Map');
imshow(normalmapRGB);
pause(0.5);

% normalizing the albedo image
maxalbedo = max(max(albedo));
albedo = albedo ./ maxalbedo;
imwrite(albedo,'Albedo.png');

end
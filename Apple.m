close all; clear; clc; pause on;

% Taking the list of images for calculation and 3D object reconstruction
images = char('Apple/image001.tif','Apple/image002.tif','Apple/image003.tif','Apple/image004.tif','Apple/image005.tif','Apple/image006.tif','Apple/image007.tif','Apple/image008.tif','Apple/image009.tif','Apple/image010.tif','Apple/image011.tif','Apple/image012.tif','Apple/image013.tif','Apple/image014.tif','Apple/image015.tif','Apple/image016.tif','Apple/image017.tif','Apple/image018.tif','Apple/image019.tif','Apple/image020.tif','Apple/image021.tif');

% Mask sphere images
sphere_mask_1 = 'Apple/mask_dir_1.png';
sphere_mask_2 = 'Apple/mask_dir_2.png';

% Lambertian sphere mask image
Lambertian_sphere_mask = 'Apple/mask_I.png';

% Apple mask image
mask_obj = 'Apple/applemask.png';

% Calibration of illumunitation direction
L_vec_1 = calc_L_list(sphere_mask_1, images);
L_vec_2 = calc_L_list(sphere_mask_2, images);

% Illumination intensity
L_magnitude = calc_L_mag(Lambertian_sphere_mask, images);

% Calculating surface normals and albedo
[surfacenormal albedo] = calc_normal_albedo(mask_obj, images, L_vec_1, L_vec_2, L_magnitude);

% Calculating depth from normals
Z = DepthMap(surfacenormal, mask_obj);


figure;
title('Albedo Map');
imshow(albedo);


rerendered_img = render_img( surfacenormal, albedo, mask_obj );
figure;imshow(rerendered_img);
title('Rerendered Image');
imwrite(rerendered_img,'RerenderedImage.png');

figure;
title('Depth Map');
surfl(Z); shading interp; colormap gray;
% imshow(Z)


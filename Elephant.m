close all; clear; clc; pause on;

% Taking the list of images for calculation and 3D object reconstruction
images = char('Elephant/image001.tif','Elephant/image002.tif','Elephant/image003.tif','Elephant/image004.tif','Elephant/image005.tif','Elephant/image006.tif','Elephant/image007.tif','Elephant/image008.tif','Elephant/image009.tif','Elephant/image010.tif','Elephant/image011.tif','Elephant/image012.tif','Elephant/image013.tif','Elephant/image014.tif','Elephant/image015.tif','Elephant/image016.tif','Elephant/image017.tif','Elephant/image018.tif','Elephant/image019.tif','Elephant/image020.tif','Elephant/image021.tif');

% Mask sphere images
sphere_mask_1 = 'Elephant/mask_dir_1.png';
sphere_mask_2 = 'Elephant/mask_dir_2.png';

% Lambertian sphere mask image
Lambertian_sphere_mask = 'Elephant/mask_I.png';

% Elephant mask image
mask_obj = 'Elephant/mask.png';

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
surfl(Z); shading interp; colormap gray



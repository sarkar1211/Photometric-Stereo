close all; clear; clc; pause on;

% Taking the list of images for calculation and 3D object reconstruction
images = char('Pear/image001.tif','Pear/image002.tif','Pear/image003.tif','Pear/image004.tif','Pear/image005.tif','Pear/image006.tif','Pear/image007.tif','Pear/image008.tif','Pear/image009.tif','Pear/image010.tif','Pear/image011.tif','Pear/image012.tif','Pear/image013.tif','Pear/image014.tif','Pear/image015.tif','Pear/image016.tif','Pear/image017.tif','Pear/image018.tif','Pear/image019.tif','Pear/image020.tif','Pear/image021.tif');

% Mask sphere images
sphere_mask_1 = 'Pear/mask_dir_1.png';
sphere_mask_2 = 'Pear/mask_dir_2.png';

% Lambertian sphere mask image
Lambertian_sphere_mask = 'Pear/mask_I.png';

% Pear mask image
mask_obj = 'Pear/pearmask.png';

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

# Photometric Stereo Algorithm
The project implements a basic photometric stereo algorithm that uses linear
least squares method. Given a list of photometric images of a sample object with
two metal spheres and a white matte Lambertian sphere illuminated under
different positions of the same light source, the implementation computes the
following items:
- The illumination direction that is computed from the highlighted portion
on the metal spheres
- The illumination intensity computed using Lambertian sphere
- The surface normals of the sample object as an overdetermined linear system. Since the pixel intensity is proportional to the dot product of the light direction and surface normal at that pixel, the method uses least squares to compute the albedo and surface normals
- A re-rendered picture of the object using surface normals and albedo under illumination direction, same as viewing direction
- Z values are computed based the normals, using method 2 discussed in the lectures and a grey level image of the object is obtained

# Results
- Apple

![Results](https://raw.githubusercontent.com/sarkar1211/Photometric-Stereo/master/Results/Apple_1.png)
![Results](https://raw.githubusercontent.com/sarkar1211/Photometric-Stereo/master/Results/Apple_2.png)

- Pear

![Results](https://raw.githubusercontent.com/sarkar1211/Photometric-Stereo/master/Results/Pear.png)


- Elephant

![Results](https://raw.githubusercontent.com/sarkar1211/Photometric-Stereo/master/Results/Elephant.png)


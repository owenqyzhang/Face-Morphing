clear
clc

im1 = imread('me.JPG');
im2 = imread('donaldtrump.jpg');

[im1_pts, im2_pts] = click_correspondences(im1, im2);

save('sample_set.mat')

clear
clc

im1 = imread('Picture1.jpg');
im2 = imread('Picture2.jpg');

[im1_pts, im2_pts] = click_correspondences(im1, im2);

save('test_set.mat')

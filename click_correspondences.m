function [ im1_pts, im2_pts ] = click_correspondences( im1, im2 )
%click_correspondences define pairs of corresponding points on the two 
% images by hand (the more points, the better the morph, generally).
% (INPUT) im1: H1xW1x3 matrix representing the first image.
% (INPUT) im2: H2xW2x3 matrix representing the second image.
% (OUTPUT) im1_pts: Nx2 matrix representing correspondences coordinates in 
% first image.
% (OUTPUT) im2_pts: Nx2 matrix representing correspondences coordinates in 
% second image.

[im1_pts, im2_pts] = cpselect(im1, im2, 'Wait', true);

end

function [ morphed_im ] = morph( im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac )
%morph produces a warp between your two images using point correspondences
% (INPUT) im1: H1×W1×3 matrix representing the first image.
% (INPUT) im2: H2×W2×3 matrix representing the second image.
% (INPUT) im1_pts: N×2 matrix representing correspondences in the first 
% image.
% (INPUT) im2_pts: N×2 matrix representing correspondences in the second 
% image.
% (INPUT) tri: M×3 matrix representing the triangulation structure, each 
% row are the indices of the three vertices in a triangle.
% (INPUT) warp_frac: 1×M vector representing each frames' shape warping
% parameter. 
% (INPUT) dissolve_frac: 1×M vector representing each frames' 
% cross-dissolve parameter. 
% (OUTPUT) morphed_im: H2×W2×3 matrix representing the morphed image.

morphed_im = cell(length(warp_frac), 1);

im1_pts = [im1_pts; 0, 0; size(im1, 2) + 1, 0; 0, size(im1, 1) + 1; size(im1, 2) + 1, size(im1, 1) + 1];
im2_pts = [im2_pts; 0, 0; size(im2, 2) + 1, 0; 0, size(im2, 1) + 1; size(im2, 2) + 1, size(im2, 1) + 1];

[m1, n1, ~] = size(im1);
[m2, n2, ~] = size(im2);

for t = 1: length(warp_frac)
    %% Calculate the size of the intermediate image
    morphed_size = round([m1, n1] + warp_frac(t) * [m2 - m1, n2 - n1]);

    morphed_pts = im1_pts * (1 - warp_frac(t)) + im2_pts * warp_frac(t);

    tri = delaunay(morphed_pts(:, 1), morphed_pts(:, 2));

    %% Store matrices for coordinate transformation in cells
    cood_int_mat = cell(size(tri, 1), 1);
    cood1_mat = cell(size(tri, 1), 1);
    cood2_mat = cell(size(tri, 1), 1);
    for i = 1: size(tri, 1)
        a = [morphed_pts(tri(i, 1), :), 1]';
        b = [morphed_pts(tri(i, 2), :), 1]';
        c = [morphed_pts(tri(i, 3), :), 1]';
        cood_int_mat{i} = [a b c]\eye(3);
        a1 = [im1_pts(tri(i, 1), :), 1]';
        b1 = [im1_pts(tri(i, 2), :), 1]';
        c1 = [im1_pts(tri(i, 3), :), 1]';
        cood1_mat{i} = [a1 b1 c1];
        a2 = [im2_pts(tri(i, 1), :), 1]';
        b2 = [im2_pts(tri(i, 2), :), 1]';
        c2 = [im2_pts(tri(i, 3), :), 1]';
        cood2_mat{i} = [a2 b2 c2];
    end

    [XX, YY] = meshgrid(1: morphed_size(2), 1: morphed_size(1));
    XI = [XX(:), YY(:)];

    T = tsearchn(morphed_pts, tri, XI);

    %% Barycentric coordinate translation
    cood_bary = zeros(size(XI, 1), 3);
    cood1 = zeros(size(XI, 1), 2);
    cood2 = zeros(size(XI, 1), 2);

    for i = 1: size(XI, 1)
        cood_homo = [XI(i, :), 1]';
        tri_idx = T(i);
        cood_bary(i, :) = (cood_int_mat{tri_idx}*cood_homo)';
        cood_homo1 = cood1_mat{tri_idx} * cood_bary(i, :)';
        cood1(i, :) = cood_homo1(1: 2)'/cood_homo1(3);
        cood_homo2 = cood2_mat{tri_idx} * cood_bary(i, :)';
        cood2(i, :) = cood_homo2(1: 2)'/cood_homo2(3);
    end

    %% Generate morphed images and dissolve them together
    cood1_x = reshape(cood1(:, 1), morphed_size(1), morphed_size(2));
    cood1_y = reshape(cood1(:, 2), morphed_size(1), morphed_size(2));
    morphed_im1 = bili_interp( cood1_x, cood1_y, im1 );

    cood2_x = reshape(cood2(:, 1), morphed_size(1), morphed_size(2));
    cood2_y = reshape(cood2(:, 2), morphed_size(1), morphed_size(2));
    morphed_im2 = bili_interp( cood2_x, cood2_y, im2 );

    morphed_im{t} = uint8(morphed_im1 * (1 - dissolve_frac(t)) + morphed_im2 * dissolve_frac(t));

    h1 = linspace(1, morphed_size(1), size(im2, 1));
    w1 = linspace(1, morphed_size(2), size(im2, 2));

    [W1, H1] = meshgrid(w1, h1);

    %% Use bilinear interpolation to resize
    morphed_im{t} = bili_interp(W1, H1, morphed_im{t});

end

end

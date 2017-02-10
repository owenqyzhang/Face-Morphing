function [ morphed_im ] = morph_tps_wrapper( im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac)
%morph_tps_wrapper This is a wrapper for your TPS morphing, in which
% est_tps and morph_tps functions will be called. This function is meant to
% provide a similar interface as that in triangular morphing. It will be
% called by our evaluation script.
% (INPUT) im1: H1×W1×3 matrix representing the first image.
% (INPUT) im2: H2×W2×3 matrix representing the second image.
% (INPUT) im1_pts: N×2 matrix representing correspondences in the first
% image.
% (INPUT) im2_pts: N×2 matrix representing correspondences in the second
% image.
% (INPUT) warp_frac: parameter to control shape warping.
% (INPUT) dissolve_frac: parameter to control cross-dissolve.
% (OUTPUT) morphed_im: H2×W2×3 matrix representing the morphed image.

morphed_im = cell(length(warp_frac), 1);

[h1, w1, ~] = size(im1);
[h2, w2, ~] = size(im2);

for t = 1: length(warp_frac)

    %% Calculate control points in the morphed image
    morphed_pts = im1_pts * (1 - warp_frac(t)) + im2_pts * warp_frac(t);
    morphed_sz = round([h1 w1] * (1 - warp_frac(t)) + [h2 w2] * warp_frac(t));
    
    %% Estimate tps parameters for image 1 and 2 in x, y
    [a1_x1, ax_x1, ay_x1, w_x1] = est_tps(morphed_pts, im1_pts(:,1));
    [a1_y1, ax_y1, ay_y1, w_y1] = est_tps(morphed_pts, im1_pts(:,2));
    
    [a1_x2, ax_x2, ay_x2, w_x2] = est_tps(morphed_pts, im2_pts(:,1));
    [a1_y2, ax_y2, ay_y2, w_y2] = est_tps(morphed_pts, im2_pts(:,2));
    
    %% Generate morphed image 1, 2 and dissolve into morphed image
    morphed_im1 = morph_tps(im1, a1_x1, ax_x1, ay_x1, w_x1,...
        a1_y1, ax_y1, ay_y1, w_y1, morphed_pts, morphed_sz);
    morphed_im2 = morph_tps(im2, a1_x2, ax_x2, ay_x2, w_x2,...
        a1_y2, ax_y2, ay_y2, w_y2, morphed_pts, morphed_sz);
    
    morphed_im{t} = morphed_im1 * (1 - dissolve_frac(t)) + ...
        morphed_im2 * dissolve_frac(t);
    
    %% Use bilinear interpolation to resize morphed image
    h = linspace(1, morphed_sz(1), size(im2, 1));
    w = linspace(1, morphed_sz(2), size(im2, 2));
    
    [W1, H1] = meshgrid(w, h);
    
    morphed_im{t} = bili_interp(W1, H1, morphed_im{t});
    
end

end

function [ morphed_im ] = morph_tps( im_source, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y, w_y, ctr_pts, sz )
%morph_tps transform all the pixels in image (B) by the TPS model, and
% read back the pixel value in image (A) directly.
% (INPUT) im_source: HsxWsx3 matrix representing the source image.
% (INPUT) a1_x, ax_x, ay_x, w_x: the parameters solved when doing est tps
% in the x direction.
% (INPUT) a1_y, ax_y, ay_y, w_y: the parameters solved when doing est tps
% in the y direction.
% (INPUT) ctr_pts: Nx2 matrix, each row representing corresponding point
% position (x; y) in target image.
% (INPUT) sz: 1x2 vector representing the target image size (Ht;Wt).
% (OUTPUT) morphed_im: HtxWtx3 matrix representing the morphed image.

%% Initialize output image
morphed_im = zeros(sz(1), sz(2), 3);

%% Form the coordinates in a meshgrid matrix
[XX, YY] = meshgrid(1: sz(2), 1: sz(1));
X = XX(:);
Y = YY(:);
N = length(X);

p = size(ctr_pts, 1);
ctr_x = ctr_pts(:, 1)';
ctr_y = ctr_pts(:, 2)';

param = [w_x, w_y; ax_x, ax_y; ay_x, ay_y; a1_x, a1_y];

%% Calculate U(||(xi, yi) - (x, y)||)
diff_x = repmat(X, 1, p) - repmat(ctr_x, N, 1);
diff_y = repmat(Y, 1, p) - repmat(ctr_y, N, 1);
 
l2_norm_sqr = diff_x.^2 + diff_y.^2;
l2_norm_sqr(l2_norm_sqr==0)=realmin;
K = -l2_norm_sqr .* log(l2_norm_sqr);
K = [K X Y ones(N, 1)];

%% Calculate the corresponding points and reshape into matrices
V = K * param;
idx_x = reshape(V(:, 1), sz(1), sz(2));
idx_y = reshape(V(:, 2), sz(1), sz(2));

idx_x(idx_x<1) = 1;
idx_x(idx_x>size(im_source, 2)) = size(im_source, 2);

idx_y(idx_y<1) = 1;
idx_y(idx_y>size(im_source, 1)) = size(im_source, 1);

morphed_im(:, :, 1) = interp2(double(im_source(:, :, 1)), idx_x, idx_y);
morphed_im(:, :, 2) = interp2(double(im_source(:, :, 2)), idx_x, idx_y);
morphed_im(:, :, 3) = interp2(double(im_source(:, :, 3)), idx_x, idx_y);
morphed_im = uint8(morphed_im);

end

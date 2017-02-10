function [ a1, ax, ay, w ] = est_tps( ctr_pts, target_value )
%est_tps Thin-plate parameter estimation
% (INPUT) ctr_pts: Nx2 matrix, each row representing corresponding point
% position (x; y) in second image.
% (INPUT) target_value: Nx1 vector representing corresponding point position
% x or y in first image.
% (OUTPUT) a1: double, TPS parameters.
% (OUTPUT) ax: double, TPS parameters.
% (OUTPUT) ay: double, TPS parameters.
% (OUTPUT) w: Nx1 vector, TPS parameters.

%% Shape control points in original image and target image into a vector
V = [target_value; zeros(3, 1)];
P = [ctr_pts ones(length(target_value), 1)];

%% Calculate ||(xi, yi) - (x, y)||
ctr_xh = repmat(ctr_pts(:, 1)', length(target_value), 1);
ctr_xv = repmat(ctr_pts(:, 1), 1, length(target_value));
ctr_xd = ctr_xh - ctr_xv;

ctr_yh = repmat(ctr_pts(:, 2)', length(target_value), 1);
ctr_yv = repmat(ctr_pts(:, 2), 1, length(target_value));
ctr_yd = ctr_yh - ctr_yv;

%% Put U(||(xi, yi)-(x, y)||) into a matrix
ctr_diff_sqr = ctr_xd.^2 + ctr_yd.^2;
ctr_diff_sqr(ctr_diff_sqr==0)=realmin;
K = -ctr_diff_sqr .* log(ctr_diff_sqr);

%% Calculate parameters and extract them from the vector
A = [K P; P' zeros(3)];
param = pinv(A)*V;

a1 = param(end);
ay = param(end - 1);
ax = param(end - 2);
w = param(1: end-3);

end

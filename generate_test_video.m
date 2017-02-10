%% Initialization
clear
clc

%% Load Images, Generate Corresponding Points

% load('corresponding_points.mat');

load('test_set.mat');

%% Image Morphing
t = linspace(0, 1, 60);
% morphed_imgs = morph(im1, im2, im1_pts, im2_pts, t, t);
tps_morphed_imgs = morph_tps_wrapper(im1, im2, im1_pts, im2_pts, t, t);

%% Generate Video
v3 = VideoWriter('Project2_test_trig.avi','Uncompressed AVI');
v4 = VideoWriter('Project2_test_tps.avi', 'Uncompressed AVI');
v3.FrameRate = 60;
v4.FrameRate = 60;
% secsPerImage = ones(1, 60)/60;

open(v3);
open(v4);

for i = 1: 60
    writeVideo(v3,im2frame(morphed_imgs{i}));
    writeVideo(v4,im2frame(tps_morphed_imgs{i}));
end

close(v3);
close(v4);

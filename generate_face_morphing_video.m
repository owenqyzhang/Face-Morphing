%% Initialization
clear
clc

%% Load Images, Generate Corresponding Points
load('sample_set.mat');

%% Image Morphing
t = linspace(0, 1, 60);
% morphed_imgs = morph(im1, im2, im1_pts, im2_pts, t, t);
tps_morphed_imgs = morph_tps_wrapper(im1, im2, im1_pts, im2_pts, t, t);

%% Generate Video
v1 = VideoWriter('Project2_sample_trig.avi','Uncompressed AVI');
v2 = VideoWriter('Project2_sample_tps.avi', 'Uncompressed AVI');
v1.FrameRate = 60;
v2.FrameRate = 60;

open(v1);
open(v2);

for i = 1: 60
    writeVideo(v1,im2frame(morphed_imgs{i}));
    writeVideo(v2,im2frame(tps_morphed_imgs{i}));
end

close(v1);
close(v2);

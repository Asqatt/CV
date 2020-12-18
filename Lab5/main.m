%% สนำร
clear;clc;close all;


img=imread('tajmahal.jpg');


img =rgb2gray(img);

res0 =harrisCornerDetector(img,500000000);
figure;
subplot(1,2,1);
imshow(res0);


tform = affine2d([1 0 0;0.5 1 0;0 0 1]);
J = imwarp(img,tform);
res1 = harrisCornerDetector(J, 500000000);
subplot(1,2,2);
imshow(res1);

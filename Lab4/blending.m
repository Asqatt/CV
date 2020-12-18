clear;clc;

B = im2double(imread('target.jpg'));
A = im2double(imread('source.jpg'));



% 设置融合区域

%R = zeros(512,512); R(:,257:512)=1;

R=logical(imread('mask.jpg'));

depth =6 ;


LA = laplacianpyr(A,depth);
LB = laplacianpyr(B,depth);


GR = gausspyr(R,depth); 

% 通过mask的高斯金字塔融合两个拉普拉斯金字�?
[LS] = combine(LA, LB, GR);

% 复原图像
Ib = collapse(LS);


imshow(Ib);
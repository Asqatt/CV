
clear;clc;
%% Reading the image:
I = imread("home.jpg");

fprintf('Original image showed\n')

% show the original image
figure();
imshow(I)
title('Original Image');


%% RGB Image to Gray Level Image
% extract the three color channel
r=I(:,:,1);
g=I(:,:,2);
b=I(:,:,3);

%convert RGB to gray level image :

[Rows,Cols,ColorChannels]=size(I);

GrayIm =ones(Rows,Cols,1);
 
GrayIm =r * 0.3 + g * 0.59 + b* 0.11;
 
fprintf('Gray Level image showed\n')

figure();
imshow(GrayIm)
title('Gray Level Image');

pause();

%% Compute  Histogram
NumPixel=zeros(256,1);

for row = 1:Rows
    for col=1:Cols
        NumPixel(I(row,col)+1)=NumPixel(I(row,col)+1)+1;
    end
end

figure();
histogram(I);
title("Original Gray Level Histogram");
fprintf('Gray Level Histogram\n')
pause();

%% Clipping


T = round(Rows * Cols / 256);


NumPixel=clipping(NumPixel,T);


%% Computing PDF

PDF = zeros(1,256);

Total =Rows * Cols;

for i = 1:256
    PDF(i) = NumPixel(i) / ( Total* 1.0);
end

fprintf('Probablity Distribution Function \n')
figure();
stairs(PDF);
pause();
%% Computing CDF

CDF = zeros(1,256);

CDF(1)=PDF(1);

for i=2:256
    CDF(i)=CDF(i-1)+PDF(i);
end


fprintf('Cumulative Distribution Function \n')
figure();
stairs(0:255,CDF(1,:));
pause();

CDF = round(255*CDF);

%% Mapping

Map  = zeros(1,256);

for i=1:256
    Map(i)=round(CDF(i)+0.5);
end

J=uint8(zeros(size(GrayIm)));

for i=1:Rows
    for j=1:Cols
        J(i,j)=Map(GrayIm(i,j)+1);
    end
end

%% Show Results

figure();
imhist(J);
title("Equalized Gray Level Histogram");
fprintf('Gray Level Histogram\n')


figure();
imshow(J);
title('Equalized Gray Level Image')

%% Convert to RGB Image

RGB_J =uint8(zeros(size(I)));



for i = 1:Rows
    for j = 1:Cols
        coef=double(J(i,j))/double(I(i,j));
        RGB_J(i,j,:) = round(coef * I(i,j,:));
    end
end



figure();
imshow(RGB_J);
title('Equalized Color Image')

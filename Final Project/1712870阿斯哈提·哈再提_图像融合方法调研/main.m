
tic;
source='source.jpg';
target='target.jpg';
mask ='mask.jpg';

result='new_image_mixed.jpg';

I1 = imread(source);            % SOURCE IMAGE
I2 = imread(target);        % DESTINATION IMAGE
Mask =logical(imread(mask));



newI = blending( I2,I1,Mask,1,0); %

imwrite(newI,result);
toc;

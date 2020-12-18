%
% T3 Demo code
%

tic;
source='source.jpg';
target='target.jpg';

mask ='mask.jpg';
result='result_normal_cloning_boilled.jpg';

I1 = imread(source);            % SOURCE IMAGE
I2 = imread(target);        % DESTINATION IMAGE
Mask =logical(imread(mask));

%PIE_Gui(I1,I2,result,0,0);

newI = PIE( I2,I1,Mask,1,0);

imwrite(newI,"new_image_mixed.jpg");
toc;

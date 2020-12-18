function [Ib] = lapblend(img1, img2, perc, depth)

% Load the images for blending:
A = im2double(img1);B = im2double(img2);

% Create the mask that defines the blending region:
c = size(A,1);
perc = perc/100;
R = zeros(c,c); R(:,perc*c:c)=1;

% Depth of the pyramids

% Build the Laplacian pyramids of the two images:
LA = laplacianpyr(A,depth);
LB = laplacianpyr(B,depth);

% Build the Gaussian pyramid of theselected region:
GR = gausspyr(R,depth); 

% Combine the two pyramids using the nodes of GR as weights:
[LS] = combine(LA, LB, GR);

% Colaps the output pyrapid for final blended output:
Ib = collapse(LS);

% Visualize the result
imshow(Ib);
end


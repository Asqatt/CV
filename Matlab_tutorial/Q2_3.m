A = imread('grizzlypeak.jpg');
[m1,n1] =size(A);

tic;



  B = A<=10;

  A(B)=0;

toc;
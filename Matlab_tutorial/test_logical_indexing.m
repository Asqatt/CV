
A = imread('grizzlypeakg.jpg');
[m1,n1] =size(A);

tic;

for k=1:1000

  B = A<=10;

  A(B)=0;
end

toc;
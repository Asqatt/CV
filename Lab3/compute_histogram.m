function can=compute_histogram(img,n)

min=0;
max=255;

z=0;                         %counts zero value pixels !initialize a variable for number of pixels with value zero
a=(max-min)/(n-1); 

a=ceil(a);
ca=zeros(1,n-1);             %initialize counter array to zero

for i=1:1:length(img(:,1))*length(img(1,:));
    b=(img(i)/a);
    b=floor(b);
    if(b==0);
        z=z+1;               %increment z if pixel has value zero
    else
        ca(b)=ca(b)+1;       %increment value of corresponding value of counter array
    end
end

 can=[z,ca];                  % new counter array







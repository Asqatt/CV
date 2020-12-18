clear;
clc;

I= imread('home.jpg');
%%

%% RGB Image to Gray Level Image


GrayIm =rgb2gray(I);
 

figure()
imshow(GrayIm)
title('Gray Level Image');


figure()
imhist(GrayIm);
title("Original Gray Level Histogram");
fprintf('Gray Level Histogram\n')
pause;


%%

bins= 256;
ws=[100 100];

[r, c]=size(GrayIm);        % size of image



J=uint8(zeros(r,c));      %最终结果

xreg=ceil(r/ws(1));        %x轴上区域数目
yreg=ceil(c/ws(2));        %y...


cdfs=zeros(xreg,yreg,bins);  % 初始化cdfs

minx=1;                     
maxx=ws(1);

%% 求每个Window 的CDF
for i=1:1:xreg
    miny=1;                   % min and max value corresponding to the initial Y co-ordinates of the window
    maxy=ws(2);
    for j=1:1:yreg           
        if maxx>r             %restrict window if going outside image
            maxx=r;
        end
        if maxy>c
            maxy=c;
        end
         h=compute_histogram(GrayIm(minx:maxx,miny:maxy),bins);      %generate the histogram for each window
         for k=1:1:bins
             cdfs(i,j,k)=sum(h(1:k))/(ws(1)*ws(2));             %generate CDF for each window 
         end
         
         miny=miny+ws(2);                                       %move window to next region
         maxy=maxy+ws(2);
    end
    minx=minx+ws(1);
    maxx=maxx+ws(1);
end

a=(255)/(bins-1);


for i=1:1:r
    for j=1:1:c
        pv=(GrayIm(i,j));
        
        bin=floor(pv/a);
        
        x=(i/ws(1));                    
        xl=floor(x);                       %X region of the pixel
        xr=xl+1;                           %region to right of pixel's region
        
        y=(j/ws(2));
        yt=floor(y);                       %Y region of pixel
        yb=yt+1;                           % region below the pixel's region
        
        if(xl<1)
            xl=1;
        end
        if(xr>xreg)
            xr=xreg;                        % boundary condition check
        end
        if(yt<1)
            yt=1;
        end
        if(yb>yreg)
            yb=yreg;
        end
        
        dxl=x-xl;
        dyt=y-yt;                           %distance of pixel from left and top
        
        i11=(cdfs(xl,yt,bin+1));
        i12=(cdfs(xl,yb,bin+1));            %values from the four CDFs that will be used for bilinear interpolation
        i21=(cdfs(xr,yt,bin+1));
        i22=(cdfs(xr,yb,bin+1));
        
        
        
        ipv=(1-dxl)*((1-dyt)*i11+dyt*i12)+dxl*((1-dyt)*i21+dyt*i22);  %双线性插值
       
        ipv=uint8(ipv*255);
       
        J(i,j)=ipv;
       
    end
end


figure
imshow(J);

%% Convert to RGB Image

RGB_J =uint8(zeros(size(I)));



for i =1:1:r
    for j =1:1:c
        coef=double(J(i,j))/double(GrayIm(i,j));
        RGB_J(i,j,:) = round(coef * I(i,j,:));
    end
end



figure();
imshow(RGB_J);
title('Equalized Color Image')

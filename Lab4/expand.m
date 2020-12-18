function g = expand(I)


    %上采样过程：大小上新图是原图的两倍，
    %每行每列上隔�?个空将原图上的�?�插入到新图�?
    
    rows = size(I, 1);
    cols = size(I, 2);
    expout = zeros([2*rows 2*cols 3]);
    
    expout(1:2:2*rows,1:2:2*cols,:) = I;
    

    % 高斯filter
    ker = fspecial('gaussian',5,1);
    
    % 高斯滤波


    expout = imfilter(expout, ker, 'conv');

    % 因为我们行和列上各扩大了两�?�，�?终图像我们需要在高斯滤波的基�?上乘以四
    expout = 4*expout;

    g = expout;

end

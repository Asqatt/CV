function g = reduce(I)

    
    %建造高斯filter (standard deviation is 1)

    ker = fspecial('gaussian',5,1);
    
    % 卷积
    convIm = imfilter(I, ker, 'conv');
    
    % 下采样
    rows = size(I,1);
    cols = size(I,2);

    % Get every other row and column
    %每行每列隔一个取一个
    
    img_blur_rows = convIm(1:2:rows,:,:);

    g = img_blur_rows(:,1:2:cols,:);
    
end

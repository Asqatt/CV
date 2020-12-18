function res = harrisCornerDetector(img, threshold)

   %求偏导
   [Ix, Iy] = calcGradients(img);

   
    [m, n] = size(img);
    IxIx = Ix.*Ix;
    IyIy = Iy.*Iy;
    IxIy = Ix.*Iy;

    w = 5; %窗口宽度
    wIxIx = gaussianFilter(IxIx, 1);
    wIxIy =gaussianFilter(IxIy, 1);
    wIyIy = gaussianFilter(IyIy, 1);

    k = 0.05; %0.04~0.06
    detI = wIxIx.*wIyIy - wIxIy.*wIxIy;
    traceI = wIxIx + wIyIy;
    R = detI - k*traceI.*traceI;% R=det(M)-kTrace(M)^2

    %非极大值抑制:周围有更大的R 要置于0
    for i=(w-1)/2+1:m-(w-1)/2
        for j=(w-1)/2+1:n-(w-1)/2
            if R(i, j)<max(max(R(i-(w-1)/2:i+(w-1)/2,j-(w-1)/2:j+(w-1)/2)))
                R(i, j)=0;
            end
        end
    end

    [row,col] = find(R>threshold);
    radius = 10*ones(size(row));
    res = insertShape(img,'circle',[col row radius], 'LineWidth',2);
end
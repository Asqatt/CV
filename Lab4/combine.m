function [LS] = combine(LA, LB, GR)
    

    %金字塔高度
    depth = numel(LA);

    LS = cell(1,depth);
    


    %融合的每层拉普拉斯金字塔每一层上的每个像素（i,j)是通过如下式子计算得到的：
    % LS(d,i,j) = GR(d,i,j)*LA(d,i,j) + (1-GR(d,i,j))*LB(d,i,j)

    
    for d = 1:depth 
        LS{d} = GR{d}.*LA{d} + (1-GR{d}).*LB{d};
    end
end
function L = laplacianpyr(I,depth)


    
    L = cell(1,depth);
    
    % 计算高斯金字塔
    G = gausspyr(I,depth);


    %Laplaceian金字塔的 每一层是高斯金字塔对应的一层减去上采样得到的下一层的结果，最上一层是高斯金字塔的最上一层
    
    for i = 1:(depth-1)
        tmp = expand(G{i+1});
        rows = size(G{i},1);
        cols = size(G{i},2);
        tmp = tmp(1:rows,1:cols,:);
        L{i} = G{i}-tmp;
    end
    L{end} = G{end};
end

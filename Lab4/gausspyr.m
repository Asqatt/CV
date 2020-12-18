function G = gausspyr(I,depth)


    
    %建造cell 放每层的结果
    G = cell(1,depth);

    

    %高斯金字塔的第一层是原图，接下来的层是通过上一层下采样得到

    for i = 1:depth
        if i == 1
            G{i} = I;
            sub = I;
        else
            sub = reduce(sub);
            G{i} = sub;
        end
    end
end

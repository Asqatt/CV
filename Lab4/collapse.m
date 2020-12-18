function I = collapse(L)

    
    depth = numel(L);


    %恢复图像：每层是上一层上采样得到的图加上本身，
    
    for i = depth-1:-1:1
        L{i} = L{i} + expand(L{i+1});
    end
    
    I = L{1};

end

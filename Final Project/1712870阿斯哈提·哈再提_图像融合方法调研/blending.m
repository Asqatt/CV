function im_out =blending( im_target,im_source,im_mask,m,c )
%%
%初始化



%%判断图片大小是否匹配
if size(im_target,1)~= size(im_source,1) || ...
        size(im_target,1)~= size(im_mask,1) || ...
        size(im_target,2)~= size(im_source,2) || ...
        size(im_target,2)~= size(im_mask,2) || ...
        size(im_target,3)~=size(im_source,3)
    error('Image sizes dont match ');
end


%将source 和target 转化为 double,精确度更高
im_target=double(im_target);
im_source=double(im_source);

%如果图片是彩色的, 设 m=3 若不是, m=1
if c==0 %彩色
    c=3; %PIE 将在三个颜色通道都进行
else %%处理灰度图
    c=1;
    if size(im_source,3)>1
        im_source=rgb2gray(im_source);
    end
    if size(im_target,3)>1
        im_target=rgb2gray(im_target);
    end
    
end


im_out=im_target;


%求得二阶导数用的拉普拉斯算子
laplacian_mask=[0 1 0; 1 -4 1; 0 1 0];

%所需要求的位置pixels(未来线性系统的大小）
n=size(find(im_mask==1),1);

%建立一个 未知区域到一位lookup table的映射，便于后面的计算
map=zeros(size(im_mask));


counter=0;
for x=1:size(map,1)
    for y=1:size(map,2)
        if im_mask(x,y)==1 %遇到未知pixel 
            counter=counter+1;
            map(x,y)=counter;  
        end
    end
end


for i=1:c %对于每个颜色通道
    
    
    %循环mask ： 初始化系数矩阵，等式右边B向量

    
    %若是纯PIE, B= (-) laplacian of im_source,
    
    %混合梯度PIE, B= (-) max(laplacian of im_source, laplacian of im_target)

    
    %每行最多5个系数不为0的像素点。
    coeff_num=5;
    
    %利用稀疏矩阵 （save momory)
    A=spalloc(n,n,n*coeff_num);
    
    %B向量(AX=B)
    B=zeros(n,1);
    
    if m==1  % mixing gradients
        
        %求一阶导用的mask
        grad_mask_x=[-1 1];
        grad_mask_y=[-1;1]; 
        
        %求 target 一阶导数
        g_x_target=conv2(im_target(:,:,i),grad_mask_x, 'same');
        g_y_target=conv2(im_target(:,:,i),grad_mask_y, 'same');
        g_mag_target=sqrt(g_x_target.^2+g_y_target.^2);
        
        %求 source 一阶导数
        g_x_source=conv2(im_source(:,:,i),grad_mask_x, 'same');
        g_y_source=conv2(im_source(:,:,i),grad_mask_y, 'same');
        g_mag_source=sqrt(g_x_source.^2+g_y_source.^2);
        
        %转化为 1-D
        g_mag_target=g_mag_target(:);
        g_mag_source=g_mag_source(:);
        
        %将最终结果初始化（1-D)
        g_x_final=g_x_source(:);
        g_y_final=g_y_source(:);
        
        %B= (-) max(laplacian of im_source, laplacian of im_target)
        g_x_final(abs(g_mag_target)>abs(g_mag_source))=...
            g_x_target(g_mag_target>g_mag_source);
        g_y_final(abs(g_mag_target)>abs(g_mag_source))=...
            g_y_target(g_mag_target>g_mag_source);
        
        %映射到 2-D
        g_x_final=reshape(g_x_final,size(im_source,1),size(im_source,2));
        g_y_final=reshape(g_y_final,size(im_source,1),size(im_source,2));
        
        %计算散度（二阶导）
        %get the final laplacian of the combination between the source and
        %target images lap=second deriv of x + second deriv of y
        lap=conv2(g_x_final,grad_mask_x, 'same');
        lap=lap+conv2(g_y_final,grad_mask_y, 'same');
        
    else
        %纯PIE ,直接计算source 的梯度
        lap=conv2(im_source(:,:,i),laplacian_mask, 'same');
    end
    
    %构造系数矩阵
    counter=0;
    for x=1:size(map,1)
        for y=1:size(map,2)
            if im_mask(x,y)==1
                counter=counter+1;
                A(counter,counter)=4; 
                %检验是否为边界
                if im_mask(x-1,y)==0 
                    B(counter)=im_target(x-1,y,i); 
                else 
                    A(counter,map(x-1,y))=-1;
                end
                if im_mask(x+1,y)==0 
                    B(counter)=B(counter)+im_target(x+1,y,i); 
                else 
                    A(counter,map(x+1,y))=-1; 
                end
                if im_mask(x,y-1)==0 
                    B(counter)=B(counter)+im_target(x,y-1,i);
                else 
                    A(counter,map(x,y-1))=-1; 
                end
                if im_mask(x,y+1)==0 
                    B(counter)=B(counter)+im_target(x,y+1,i);
                else 
                    A(counter,map(x,y+1))=-1; 
                end
                
                %更新B向量
                
                B(counter)=B(counter)-lap(x,y);
                
            end
        end
    end
    
    %解线性方程组
    X=A\B;
    
    
    %	利用解集x代替目标图
    
    
    
    for counter=1:length(X)
        [index_x,index_y]=find(map==counter);
        im_out(index_x,index_y,i)=X(counter);
        
    end
    
    
    %始放内存
    clear A B X lap_source lap_target g_mag_source g_mag_target
end

im_out=uint8(im_out);

end


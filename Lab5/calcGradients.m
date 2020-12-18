function [Ix, Iy] = calcGradients(img)

    [M,N]=size(img);
    B1=[-1 0 1;-2 0 2;-1 0 1];%梯度处理水平方向梯度
    B2=[1 2 1;0 0 0;-1 -2 -1];%梯度处理数值方向梯度
    
    %处理边界
    I1=zeros(M+2,N+2);
    I2=zeros(M+2,N+2);
    I1(2:M+1,2:N+1)=img;
    I2(2:M+1,2:N+1)=img;
    
    temp=zeros(3,3);
    for i=2:M-1
        for j=2:N-1
            temp=img(i-1:i+1,j-1:j+1);
            temp1=double(temp).*B1;
            temp2=double(temp).*B2;
            t=sum(temp1(:));
            p=sum(temp2(:));
            if t < 0 
                t = 0;
            end
            if p < 0
                p = 0;
            end
            I1(i,j)=t;
            I2(i,j)=p;
        end
    end
    Ix = I1;
    Iy = I2;
end

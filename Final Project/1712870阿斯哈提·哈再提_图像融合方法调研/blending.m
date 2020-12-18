function im_out =blending( im_target,im_source,im_mask,m,c )
%%
%��ʼ��



%%�ж�ͼƬ��С�Ƿ�ƥ��
if size(im_target,1)~= size(im_source,1) || ...
        size(im_target,1)~= size(im_mask,1) || ...
        size(im_target,2)~= size(im_source,2) || ...
        size(im_target,2)~= size(im_mask,2) || ...
        size(im_target,3)~=size(im_source,3)
    error('Image sizes dont match ');
end


%��source ��target ת��Ϊ double,��ȷ�ȸ���
im_target=double(im_target);
im_source=double(im_source);

%���ͼƬ�ǲ�ɫ��, �� m=3 ������, m=1
if c==0 %��ɫ
    c=3; %PIE ����������ɫͨ��������
else %%����Ҷ�ͼ
    c=1;
    if size(im_source,3)>1
        im_source=rgb2gray(im_source);
    end
    if size(im_target,3)>1
        im_target=rgb2gray(im_target);
    end
    
end


im_out=im_target;


%��ö��׵����õ�������˹����
laplacian_mask=[0 1 0; 1 -4 1; 0 1 0];

%����Ҫ���λ��pixels(δ������ϵͳ�Ĵ�С��
n=size(find(im_mask==1),1);

%����һ�� δ֪����һλlookup table��ӳ�䣬���ں���ļ���
map=zeros(size(im_mask));


counter=0;
for x=1:size(map,1)
    for y=1:size(map,2)
        if im_mask(x,y)==1 %����δ֪pixel 
            counter=counter+1;
            map(x,y)=counter;  
        end
    end
end


for i=1:c %����ÿ����ɫͨ��
    
    
    %ѭ��mask �� ��ʼ��ϵ�����󣬵�ʽ�ұ�B����

    
    %���Ǵ�PIE, B= (-) laplacian of im_source,
    
    %����ݶ�PIE, B= (-) max(laplacian of im_source, laplacian of im_target)

    
    %ÿ�����5��ϵ����Ϊ0�����ص㡣
    coeff_num=5;
    
    %����ϡ����� ��save momory)
    A=spalloc(n,n,n*coeff_num);
    
    %B����(AX=B)
    B=zeros(n,1);
    
    if m==1  % mixing gradients
        
        %��һ�׵��õ�mask
        grad_mask_x=[-1 1];
        grad_mask_y=[-1;1]; 
        
        %�� target һ�׵���
        g_x_target=conv2(im_target(:,:,i),grad_mask_x, 'same');
        g_y_target=conv2(im_target(:,:,i),grad_mask_y, 'same');
        g_mag_target=sqrt(g_x_target.^2+g_y_target.^2);
        
        %�� source һ�׵���
        g_x_source=conv2(im_source(:,:,i),grad_mask_x, 'same');
        g_y_source=conv2(im_source(:,:,i),grad_mask_y, 'same');
        g_mag_source=sqrt(g_x_source.^2+g_y_source.^2);
        
        %ת��Ϊ 1-D
        g_mag_target=g_mag_target(:);
        g_mag_source=g_mag_source(:);
        
        %�����ս����ʼ����1-D)
        g_x_final=g_x_source(:);
        g_y_final=g_y_source(:);
        
        %B= (-) max(laplacian of im_source, laplacian of im_target)
        g_x_final(abs(g_mag_target)>abs(g_mag_source))=...
            g_x_target(g_mag_target>g_mag_source);
        g_y_final(abs(g_mag_target)>abs(g_mag_source))=...
            g_y_target(g_mag_target>g_mag_source);
        
        %ӳ�䵽 2-D
        g_x_final=reshape(g_x_final,size(im_source,1),size(im_source,2));
        g_y_final=reshape(g_y_final,size(im_source,1),size(im_source,2));
        
        %����ɢ�ȣ����׵���
        %get the final laplacian of the combination between the source and
        %target images lap=second deriv of x + second deriv of y
        lap=conv2(g_x_final,grad_mask_x, 'same');
        lap=lap+conv2(g_y_final,grad_mask_y, 'same');
        
    else
        %��PIE ,ֱ�Ӽ���source ���ݶ�
        lap=conv2(im_source(:,:,i),laplacian_mask, 'same');
    end
    
    %����ϵ������
    counter=0;
    for x=1:size(map,1)
        for y=1:size(map,2)
            if im_mask(x,y)==1
                counter=counter+1;
                A(counter,counter)=4; 
                %�����Ƿ�Ϊ�߽�
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
                
                %����B����
                
                B(counter)=B(counter)-lap(x,y);
                
            end
        end
    end
    
    %�����Է�����
    X=A\B;
    
    
    %	���ý⼯x����Ŀ��ͼ
    
    
    
    for counter=1:length(X)
        [index_x,index_y]=find(map==counter);
        im_out(index_x,index_y,i)=X(counter);
        
    end
    
    
    %ʼ���ڴ�
    clear A B X lap_source lap_target g_mag_source g_mag_target
end

im_out=uint8(im_out);

end


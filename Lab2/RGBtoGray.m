for i = 1:Rows
    for j = 1:Cols
        cr=double(J(i,j))/double(r(i,j));
        cg=double(J(i,j))/double(g(i,j));
        cb=double(J(i,j))/double(b(i,j));
        RGB_J(i,j,:) = [round(cr * GrayIm(i,j)),round(cg * GrayIm(i,j)),round(cb * GrayIm(i,j))];
    end
end
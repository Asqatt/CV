function Clipped = clipping(NumPixel, T)

sum_n=0;
for i = 1:256
    if(NumPixel(i,1) > T)
        sum_n = sum_n + NumPixel(i,1) - T;
        NumPixel(i,1) = T;
    end
end

add1 = round(sum_n / 256);
NumPixel = NumPixel + add1;
Clipped =NumPixel;
figure();bar(NumPixel);
pause();
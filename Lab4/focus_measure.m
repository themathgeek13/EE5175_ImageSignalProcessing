function [fm]=focus_measure(image,i,j, N)

fm=0;
for x = i-N:i+N
    for y=j-N:j+N
        fm=fm+abs(2*image(x,y)-image(x-1,y)-image(x+1,y));
        fm=fm+abs(2*image(x,y)-image(x,y-1)-image(x,y+1));
    end
end
end
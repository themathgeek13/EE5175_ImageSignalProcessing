function [val]=bilinear(i,j,img)
x=floor(i);
y=floor(j);
a=i-x;
b=j-y;
x=min(max(1,x),360);
y=min(max(1,x),640);
val=img(x,y)*(1-a)*(1-b)+img(x,y+1)*(1-a)*b+img(x+1,y)*a*(1-b)+img(x+1,y+1)*a*b;

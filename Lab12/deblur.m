sigb=1.5; sign=15;
lambda=0.01;
f=double(imread('lena.png'));
f1=imgaussfilt(f,sigb);
n = normrnd(0,sign,[277,277]);
g = f1+n;
g = uint8(g);
h = fspecial('gaussian',277,sigb);

[fhat,rms]=blur(f,g,h,lambda);
sigb=1.0; sign=5;
lambda=0.01;
f=double(imread('lena.png'));
f=imgaussfilt(f,sigb);
n = normrnd(0,sign,[277,277]);
g = f+n;
g = uint8(g);
h = fspecial('gaussian',277,sigb);

[fhat,rms]=blur(f,g,h,n,sigb,sign,lambda);
function [out]=dft2(img)
%img=imread('peppers.pgm');
[r,c]=size(img);

rowf=zeros(r,c);
for i = 1:r
    rowf(i,:)=fft(img(i,:));
end

final=zeros(r,c);
for j=1:c
    final(:,j)=fft(rowf(:,j));
end

out=final/r/c;
imshow(abs(fftshift(out)));
end
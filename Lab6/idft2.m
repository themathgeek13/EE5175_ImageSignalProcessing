function [out]=idft2(img)
%img=imread('peppers.pgm');
[r,c]=size(img);

rowf=zeros(r,c);
for i = 1:c
    rowf(:,i)=ifft(img(:,i));
end

final=zeros(r,c);
for j=1:r
    final(j,:)=ifft(rowf(j,:));
end
out=uint8(final*r*c);
%out=fftshift(final)*r*c;
%imshow(abs(out));
end
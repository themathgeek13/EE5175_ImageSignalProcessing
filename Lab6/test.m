function [out]=test(img)
%img=imread('peppers.pgm');
[r,c]=size(img);
rowf=img;
%rowf=zeros(r,c);
%for i = 1:r
%    rowf(i,:)=fft(img(i,:));
%end

final=zeros(r,c);
rowf1=zeros(r,c);
for j=1:c
    final(:,j)=fft(rowf(:,j));
    rowf1(:,j)=ifft(final(:,j));
end

%final1=zeros(r,c);
%for k=1:r
%    final1(k,:)=ifft(rowf1(k,:));
%end
out=rowf1;
imshow(rowf1);
end
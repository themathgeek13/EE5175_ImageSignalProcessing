img1=imread('Beethoven1.png');
img2=imread('Beethoven2.png');
img3=imread('Beethoven3.png');

%lexicographical ordering
i1=reshape(transpose(img1),[256*256,1]);
i2=reshape(transpose(img2),[256*256,1]);
i3=reshape(transpose(img3),[256*256,1]);
I=[i1,i2,i3];
%do the SVD
[U,S,V]=svd(double(I),'econ');
A=importdata('A.mat');
N=U*sqrt(S)*A;
L=inv(A)*sqrt(S)*transpose(V);

%find the albedo
mag=sqrt(N(:,1).^2+N(:,2).^2+N(:,3).^2);
mag256=reshape(mag,[256,256]);
imshow(transpose(mag256),[0 255]);

%generate a new set of images with Lnew
Lnew=importdata('Lnew.mat');
Inew=N*Lnew;
inew1=Inew(:,1);
inew2=Inew(:,2);
inew3=Inew(:,3);
ifinal1=transpose(reshape(inew1,[256,256]));
ifinal2=transpose(reshape(inew2,[256,256]));
ifinal3=transpose(reshape(inew3,[256,256]));
figure();
imshow([ifinal1,ifinal2,ifinal3], [0 255]);
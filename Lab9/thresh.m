img1=imread('palmleaf1.pgm');
img2=imread('palmleaf2.pgm');
figure();
imshow(img1);
figure();
imshow(img2);
[counts1,x]=imhist(img1,256);
[counts2,x]=imhist(img2,256);

level1=otsu(counts1);
level2=otsu(counts2);

b1=imbinarize(img1,level1/256);
b2=imbinarize(img2,level2/256);

figure();
imshow(b1);
figure();
imshow(b2);
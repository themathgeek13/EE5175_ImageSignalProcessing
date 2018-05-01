//load the image read and write commands
exec pgmread.sci
//load the image
im1 = pgmread('lena_translate.pgm');    // NOTE : syntax is im = pgmread('PATH'); where PATH is full location of image file

//print the image size
disp(size(im1),'size(im)=');
[m,n]=size(im1);

//display the original image
scf(); 
xset("colormap",graycolormap(256));
Matplot(im1,strf='046');

//Do the translation with bilinear interpolation for T -> S mapping
for i=1:m
    for j=1:n
        xs=i-10;
        ys=j-5;
        x=floor(xs);
        y=floor(ys);
        a=xs-x;
        b=ys-y;
        x=max(1,x); //for the edge cases
        y=max(1,y); //for the edge cases
        im2(i,j)=im1(x,y)*(1-a)*(1-b)+im1(x,y+1)*(1-a)*b+im1(x+1,y)*a*(1-b)+im1(x+1,y+1)*a*b;
    end
end

//display the translated image
scf(); 
xset("colormap",graycolormap(256));
Matplot(im2,strf='046');

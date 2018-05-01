//load the image read and write commands
exec pgmread.sci

//load the image
im1 = pgmread('IMG1.pgm');    // NOTE : syntax is im = pgmread('PATH'); where PATH is full location of image file

z=pgmread('IMG2.pgm');
[M,N]=size(z);
z=zeros(M,N);

//print the image size
disp(size(im1),'size(im)=');
[m,n]=size(im1);

//display the original image
scf(); 
xset("colormap",graycolormap(256));
Matplot(im1,strf='046');

//Do the translation with bilinear interpolation for T -> S mapping
degrees=30
theta=degrees*%pi/180;
tx=-72.953
ty=137.42
for i=1:M
    for j=1:N
        xs=i*cos(theta)-j*sin(theta)-tx;
        ys=i*sin(theta)+j*cos(theta)-ty;
        x=floor(xs);
        y=floor(ys);
        a=xs-x;
        b=ys-y;
        //x=min(max(1,x),m-1); //for the edge cases
        //y=min(max(1,y),n-1); //for the edge cases
        if(x<0 || x>m-1)
            z(i,j)=0;
        end
        if(y<0 || y>n-1)
            z(i,j)=0;
        end
        if(x>0 && x<m && y>0 && y<n)
        z(i,j)=im1(x,y)*(1-a)*(1-b)+im1(x,y+1)*(1-a)*b+im1(x+1,y)*a*(1-b)+im1(x+1,y+1)*a*b;
        end
    end
end

im2 = pgmread('IMG2.pgm');
z2=z-im2;
//display the translated image
scf(); 
xset("colormap",graycolormap(256));
Matplot(z,strf='046');

scf();
xset("colormap",graycolormap(256));
Matplot(abs(z2),strf='046');


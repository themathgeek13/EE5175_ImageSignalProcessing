// NOTE : pgmread.sci should be in current directory. To change to current directory,use :
// cd 'PATH' ; where PATH is full location of the folder

//load the image read and write commands
exec pgmread.sci

//load the image
im1 = pgmread('lena_translate.pgm');    // NOTE : syntax is im = pgmread('PATH'); where PATH is full location of image file

//print the image size
disp(size(im1),'size(im)=');

//display the image read into the matrix im
scf(); 
xset("colormap",graycolormap(256));
Matplot(im1,strf='046');

//write image matrix to a file
pgmwrite('demo1.pgm',im1);

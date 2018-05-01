function [im,width,height]  = pgmread(path)
  fp = mopen(path,'rb');
  t =   mgetl(fp,1); // 'P2'
  width = mfscanf(1,fp,'%d');
  if isempty(width)
    t =   mgetl(fp,1); // comment this line if there is no comment line in pgm file
    width = mfscanf(1,fp,'%d');
  end  
  height = mfscanf(1,fp,'%d');
  maxval = mfscanf(1,fp,'%d');
  for m = 1:height
    im(m,1:width) = [mfscanf(width,fp,'%d')]';
  end
  mclose(fp);
endfunction

function pgmwrite(path, im)
  maxval = 255; // assuming a 8 bit image
  [height, width] = size(im);
  fp = mopen(path,'wb');
  mfprintf(fp,'P2\n');
  mfprintf(fp, '%d %d\n %d\n', width, height, maxval);
  for m = 1:height
    for k = 1:width
      mfprintf(fp, '%d ', im(m,k));
    end
  end
  mclose(fp);
  disp('finished writing the image');
endfunction

function [out]=siblur(input, sigma)

input=double(input);
sz=ceil(6*sigma+1);
[x,y]=meshgrid(-sz:sz,-sz:sz);
M=size(x,1)-1;
N=size(y,1)-1;
exp_comp=-(x.^2+y.^2)/(2*sigma*sigma);
kernel=exp(exp_comp)/(2*pi*sigma*sigma);
kernel=kernel/sum(sum(kernel));
out=zeros(size(input));
input=padarray(input,[sz sz]);

for i = 1:size(input,1)-M
    for j = 1:size(input,2)-N
        temp = input(i:i+M,j:j+N).*kernel;
        out(i,j)=sum(temp(:));
    end
end
if(sum(sum(isnan(kernel)))>0)
    out=input;
end
out=uint8(out);

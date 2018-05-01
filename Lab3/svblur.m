function [out]=svblur(input)

input=double(input);
out=zeros(size(input));
[K1,K] = size(input);
sigma=zeros(K,K);
h=cell(K,K);
out=zeros(K,K);
sigma(1,1) = 0.01;
sigma(K/2,K/2) = 10.0;
A = 2.0;
B = (K^2/(10*log(A/sigma(1,1))));

% Sigma values for all pixels.

for i = 1:K
    for j = 1:K
        sigma(i,j) = A*exp((-1)*(((i-(K/2))^2+(j-(K/2))^2)/B));
        sz=ceil(6*sigma(i,j)+1);
        %disp(sz);
        if(mod(sz,2)==0)
            sz=sz+1;
        end
        [x,y]=meshgrid(-sz:sz,-sz:sz);
        M=size(x,1)-1;
        N=size(y,1)-1;
        %disp(M); disp(N);
        %disp(sigma(i,j));
        if(sigma(i,j)>=0.1)
            exp_comp=-(x.^2+y.^2)/(2*sigma(i,j)*sigma(i,j));
            kernel=exp(exp_comp)/(2*pi*sigma(i,j)*sigma(i,j));
            kernel=kernel/sum(sum(kernel));
            %disp(kernel);
        end
        if(sigma(i,j)<0.1)
            kernel=zeros(M+1,N+1);
            kernel(M/2+1,N/2+1)=1;
            %disp(kernel);
        end
        h{i,j}=kernel;
        %sigma(i,j)=1.0;
    end
end

for i = 4:256-3
    for j = 4:256-3
        sz=ceil(6*sigma(i,j)+1);
        if(mod(sz,2)==0)
            sz=sz+1;
        end
        %disp(M); disp(N);
        temp = input(i,j)*h{i,j};
        disp(size(temp));
        out(i-sz:i+sz,j-sz:j+sz)= out(i-sz:i+sz,j-sz:j+sz)+ temp;
        %disp(temp);
    end
end

out=uint8(out);

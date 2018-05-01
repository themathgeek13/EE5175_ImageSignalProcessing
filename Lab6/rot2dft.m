function [F]=rot2dft(img,theta)

[r,c]=size(img);
img=double(img);
F=zeros(r,c);
N=double(r);
hr=int16(r/2);
hc=int16(c/2);
ct=cos(theta);
st=sin(theta);
for m = -hr:hr-1
    for n=-hc:hc-1
        for k=-hr:hr-1
            for l=-hc:hc-1
                m=double(m);
                n=double(n);
                k=double(k);
                l=double(l);
                val=[m n]*[ct -st; st ct];
                val=val*[k l]';
                F(k+hr+1,l+hc+1)=F(k+hr+1,l+hc+1)+img(m+hr+1,n+hc+1)*exp(-j*2*pi*val/N);
            end
        end
    end
end
%F=fftshift(F)/r/c;
end
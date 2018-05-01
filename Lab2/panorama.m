function [canvas]=panorama(H21,H23,I1,I2,I3)
    [m,n]=size(I1);
    canvas=zeros(2*m,3*n);
    sums=int16(zeros(2*m,3*n));
    counts=zeros(2*m,3*n);
    for jj=1:3*n
        for ii=1:2*m
            i=ii-floor(m/3);
            j=jj-n;
            tmp=H21*[i;j;1];
            i1=floor(tmp(1)/tmp(3));
            j1=floor(tmp(2)/tmp(3));
            tmp=H23*[i;j;1];
            i3=floor(tmp(1)/tmp(3));
            j3=floor(tmp(2)/tmp(3));
            if(i>0 && i<m && j>0 && j<n)
                sums(ii,jj)=sums(ii,jj)+I2(i,j);
                counts(ii,jj)=counts(ii,jj)+1;
            end
            if(i1>0 && i1<m && j1>0 && j1<n)
                sums(ii,jj)=sums(ii,jj)+I1(i1,j1);
                counts(ii,jj)=counts(ii,jj)+1;
            end
            if(i3>0 && i3<m && j3>0 && j3<n)
                sums(ii,jj)=sums(ii,jj)+I3(i3,j3);
                counts(ii,jj)=counts(ii,jj)+1;
            end
        end
    end

    for ii=1:2*m
        for jj=1:3*n
            if(sums(ii,jj)~=0)
                canvas(ii,jj)=sums(ii,jj)/counts(ii,jj);
            end
        end
    end

end
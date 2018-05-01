function [F]=SML(image,q)

[M,N]=size(image);
image=double(image);
F=zeros(M,N);
image=padarray(image,[q+1 q+1]);
for i = 2+q:M-q
    for j=2+q:N-q
        F(i,j)=focus_measure(image,i,j,q);
    end
end

end
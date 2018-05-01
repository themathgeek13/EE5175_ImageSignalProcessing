function [I3,I4]=swap(I1,I2)

F1=dft2(I1);
F2=dft2(I2);

F3=abs(F1).*(F2./abs(F2));
F4=abs(F2).*(F1./abs(F1));

I3=idft2(F3);
I4=idft2(F4);
end
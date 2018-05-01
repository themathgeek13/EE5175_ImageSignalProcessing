function sd=set_depth(q)
sd=zeros(115,115);
Fmax=zeros(115,115);
for i = 1:100
    img=eval(['frame'+sprintf("%.3d",i)]);
    F=SML(img,q);
    Fmaxprev=Fmax;
    Fmax=max(Fmax,F);
    sd(find((Fmax-Fmaxprev)~=0))=i*50.5;
end
    
end
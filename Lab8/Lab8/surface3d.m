photostereo
mask=importdata('mask.mat');
p=-N(:,2)./(N(:,3)+1e-8);
q=N(:,1)./(N(:,3)+1e-8);

p=transpose(reshape(p,[256,256]));
q=transpose(reshape(q,[256,256]));

u=direct_weighted_poisson(p,q,mask);
figure();
rotate3d on
surfl(u);

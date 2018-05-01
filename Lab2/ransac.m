function [count, H]= ransac(corr1,corr2)

[x1y1,idx]=datasample(corr1,4);
x=x1y1(:,1);
y=x1y1(:,2);
x2y2=corr2(idx,:);
xd=x2y2(:,1);
yd=x2y2(:,2);

A=zeros(8,9);
for i = 1:2:8
    vx=x(ceil(i/2)); vy=y(ceil(i/2)); 
    vxd=xd(ceil(i/2)); vyd=yd(ceil(i/2));
    A(i,:)=[vx,vy,1,0,0,0,-vxd*vx,-vxd*vy,-vxd];
    A(i+1,:)=[0,0,0,vx,vy,1,-vyd*vx,-vyd*vy,-vyd];
end
if(size(null(A))>0)
    H=transpose(reshape(null(A),3,3));  
end
if(size(null(A))==0)
    H=zeros(3,3);
end
[m,n] = size(corr1);
count=0;
for i=1:m
   vec=[corr1(i,1),corr1(i,2),1];
   newcoord=H*transpose(vec);
   newx=newcoord(1)/newcoord(3);
   newy=newcoord(2)/newcoord(3);
   expx=corr2(i,1); expy=corr2(i,2);
   error=sqrt((expx-newx)^2+(expy-newy)^2);
   if(error<10)
       count=count+1;
   end
end
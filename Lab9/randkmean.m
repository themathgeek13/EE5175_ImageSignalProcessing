img1=imread('car.ppm');
temp=imread('car.ppm');
figure();
imshow(img1);

for clus = 1:30
    c1=[unidrnd(256)-1 unidrnd(256)-1 unidrnd(256)-1];
    c2=[unidrnd(256)-1 unidrnd(256)-1 unidrnd(256)-1];
    c3=[unidrnd(256)-1 unidrnd(256)-1 unidrnd(256)-1];
    disp(c1);
    disp(c2);
    disp(c3);
    [w,h,c]=size(img1);
    assigned=zeros(w,h);
    mincost=1e9;
    maxcost=0;
    maxtemp=zeros(size(img1));
    mintemp=zeros(size(img1));
    for N = 1:6
       cost=0;
       for i = 1:w
           for j = 1:h
               d1=reshape(double(img1(i,j,:)),[1,3])-double(c1);
               d2=reshape(double(img1(i,j,:)),[1,3])-double(c2);
               d3=reshape(double(img1(i,j,:)),[1,3])-double(c3);
               d1=sqrt(sum(d1.^2));
               d2=sqrt(sum(d2.^2));
               d3=sqrt(sum(d3.^2));
               [val,pos]=min([d1,d2,d3]);
               means=[c1;c2;c3];
               assigned(i,j)=pos;
               temp(i,j,:)=means(pos,:);
               cost=cost+val;
           end
       end
       count=[0 0 0];
       sum1=[0 0 0];
       sum2=[0 0 0];
       sum3=[0 0 0];
       for i=1:w
           for j=1:h
               if assigned(i,j)==1
                   count(1)=count(1)+1;
                   sum1=sum1+reshape(double(img1(i,j,:)),[1,3]);
               end
               if assigned(i,j)==2
                   count(2)=count(2)+1;
                   sum2=sum2+reshape(double(img1(i,j,:)),[1,3]);
               end
               if assigned(i,j)==3
                   count(3)=count(3)+1;
                   sum3=sum3+reshape(double(img1(i,j,:)),[1,3]);
               end
           end
       end
       c1=sum1./count(1);
       c2=sum2./count(2);
       c3=sum3./count(3);
       %figure();
       %imshow(temp);
       disp(cost);
       if cost>maxcost
           maxcost=cost;
           maxtemp=temp;
       end
       if cost<mincost
           mincost=cost;
           mintemp=temp;
       end
    end
    
end
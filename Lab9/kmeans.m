img1=imread('car.ppm');
temp=imread('car.ppm');
figure();
imshow(img1);
c1=[255 0 0];
c2=[0 0 0];
c3=[255 255 255];
[w,h,c]=size(img1);
assigned=zeros(w,h);
for N = 1:5
   for i = 1:w
       for j = 1:h
           d1=reshape(double(img1(i,j,:)),[1,3])-c1;
           d2=reshape(double(img1(i,j,:)),[1,3])-c2;
           d3=reshape(double(img1(i,j,:)),[1,3])-c3;
           d1=sqrt(sum(d1.^2));
           d2=sqrt(sum(d2.^2));
           d3=sqrt(sum(d3.^2));

           if d1<d2 && d1<d3
               assigned(i,j)=1;
               temp(i,j,:) = c1;
           end
           if d2<d1 && d2<d3
               assigned(i,j)=2;
               temp(i,j,:) = c2;
           end
           if d3<d1 && d3<d2
               assigned(i,j)=3;
               temp(i,j,:) = c3;
           end
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
   figure();
   imshow(temp);
end
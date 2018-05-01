f=1000;
d=1000;
load('cam.mat');
normal=[0,0,1];
I=imread('pillars.jpg');
[m,n,ch]=size(I);
imshow(I);
B1=zeros(floor(1.5*m),floor(1.5*n),ch);
B1=double(B1);
B2=zeros(floor(1.5*m),floor(1.5*n),ch);
B2=double(B2);
K=[f,0,0; 0,f,0; 0,0,1];
t=[tx; ty; tz];
r=[rx; ry; rz];
tr=[tx;ty;tz;rx;ry;rz]';
[~,M]=size(tx);
counts=zeros(M,1);
setposes=[];
trf=[];

for i=1:M
   pos=t(:,i);
   pos=[0;0;0];
   angle=r(:,i);
   %angle=zeros(3);
   Rx=Rotatex(angle(1));
   Ry=Rotatey(angle(2));
   Rz=Rotatez(angle(3));
   R=Ry*Rx;
   
   H=K*((R+pos*normal/d)*inv(K));
   %disp(H);
   T=maketform('projective',H');
   [img2 xdata ydata]=imtransform(I,T,'bicubic');
   %out=homography(m,n,ch,H,I);
   imshow(img2);
   [a,b,c]=size(img2);
   img2=double(img2);
   img2=padarray(img2,[floor(1.5*m)-a floor(1.5*n)-b],'post');
   B1=B1+img2;
   
   if isempty(setposes)
       setposes=[setposes; tr(i,:)];
       trf=[trf; img2];
       counts(1)=counts(1)+1;    
   elseif sum(ismember(setposes,tr(i,:),'rows'))~=0
       p=find(ismember(setposes,tr(i,:),'rows')==1);
       counts(p)=counts(p)+1;
       
       disp('repeat pose');
   elseif sum(ismember(setposes,tr(i,:),'rows'))==0
       setposes=[setposes; tr(i,:)];
       trf=[trf; img2];
       [v1,v2]=size(setposes);
       counts(v1)=counts(v1)+1;
       disp('added new');
   end
end
disp(counts);
[s,~]=size(counts);
[setsize,~]=size(setposes);
for i = 1:setsize
    B2=B2+counts(i)*trf(675*(i-1)+1:675*i,:,:);
end
B1=B1/M;
B1=uint8(B1);
B2=B2/M;
B2=uint8(B2);
figure();
imshow(B1(1:m,1:n));
%figure();
%imshow(B2(1:m,1:n));
function [Rx]=Rotatex(rx)
    Rx=[1,0,0;0,cos(rx),-sin(rx);0,sin(rx),cos(rx)];
end

function [Ry]=Rotatey(ry)
    Ry=[cos(ry),0,sin(ry);0,1,0;-sin(ry),0,cos(ry)];
end

function [Rz]=Rotatez(rz)
    Rz=[cos(rz),-sin(rz),0; sin(rz),cos(rz),0;0,0,1];
end
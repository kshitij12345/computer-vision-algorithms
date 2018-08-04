function [u_img,v_img]=OpticFlow_LK(frame1,frame2,win)

if size(frame1,3)~=1
frame1=rgb2gray(frame1);
frame2=rgb2gray(frame2);
end

[Ix_f1,Iy_f1]=imgradientxy(frame1);
%[Ix_f2,Iy_f2]=imgradientxy(frame2);
It=frame1-frame2;
u_img=zeros(size(frame1));
v_img=zeros(size(frame1));
Ix_f1=Zeropad(Ix_f1,win);
Iy_f1=Zeropad(Iy_f1,win);
It=Zeropad(It,win);

window=[];
Ix=[];
for i=((win-1)/2)+1:size(frame1,1)
    for j=((win-1)/2)+1:size(frame1,2)
        Ix=Ix_f1(i-(win-1)/2:i+(win-1)/2,j-(win-1)/2:j+(win-1)/2);
        Iy=Iy_f1(i-(win-1)/2:i+(win-1)/2,j-(win-1)/2:j+(win-1)/2);
        It_sub=It(i-(win-1)/2:i+(win-1)/2,j-(win-1)/2:j+(win-1)/2);
        A=[Ix(:),Iy(:)];
        ATA=A'*A;
        ATI=A'*(-It_sub(:));
%         bool=CheckSol(ATA);
%         if bool
        direction=pinv(ATA)* ATI;
        u_img(i-(win-1)/2,j-(win-1)/2)=direction(1);
        v_img(i-(win-1)/2,j-(win-1)/2)=direction(2);
%         end
    end
    
end
end

function [temp]=Zeropad(img,win)

temp=zeros(size(img,1)+win-1,size(img,2)+win-1);
temp((((win-1)/2)+1:size(temp,1)-(win-1)/2),(((win-1)/2)+1):size(temp,2)-(win-1)/2)=img;

end

% function [bool]=CheckSol(M)
%     eigen=eig(M);
%     bool=0;
%     if (max(eigen)/min(eigen)>0.5 && max(eigen)/min(eigen)<1.1)
%         bool=1;
%     end
% end

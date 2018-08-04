function Disparity = disparity_ssd(P, Q, win)
    % Compute disparity map D(y, x) such that: L(y, x) = R(y, x + D(y, x))
    %
    % L: Grayscale left image
    % R: Grayscale right image, same size as L
    % D: Output disparity map, same size as L, R

    % TODO: Your code here
    Disparity=zeros(size(P));
    
    L=Zeropad(P,win);
    R=Zeropad(Q,win);
    
    
    for i=((win-1)/2)+1:size(L,1)-(win-1)/2
      tic
      disp(i)
      strip = R(i-(win-1)/2:i+(win-1)/2,1:size(R,2));
      for j=((win-1)/2)+1:size(L,2)-(win-1)/2
          patch=L(i-(win-1)/2:i+(win-1)/2,j-(win-1)/2:j+(win-1)/2);
          best_x=find_best_match(patch,strip,win);
          Disparity(i-(win-1)/2,j-(win-1)/2)=best_x-j;
      end
      toc
      disp('-------------------------------------------')
    end
end

function [temp]=Zeropad(img,win)
temp=zeros(size(img,1)+win-1,size(img,2)+win-1);
temp((((win-1)/2)+1:size(temp,1)-(win-1)/2),(((win-1)/2)+1):size(temp,2)-(win-1)/2)=img;
end

function best_x=find_best_match(patch,strip,win)
    min_diff=Inf;
    best_x=0;
    for x =1:(size(strip,2)-size(patch,2))
        temp_patch=strip(:,x:(x+size(patch,2)-1));
        diff=ssq(patch,temp_patch);
        if diff < min_diff;
            min_diff=diff;
            best_x=x;
        end
    end
    best_x=best_x+(win-1)/2;
end

function val=ssq(patch,temp_patch)
    diff=(patch(:)-temp_patch(:)).^2;
    val=sum(diff);
end

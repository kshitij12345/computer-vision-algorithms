function [H, theta, rho] = hough_lines_acc(BW, varargin)

 % Compute Hough accumulator array for finding lines.
    %
    % BW: Binary (black and white) image containing edge pixels
    % RhoResolution (optional): Difference between successive rho values, in pixels
    % Theta (optional): Vector of theta values to use, in degrees
    %
    % Please see the Matlab documentation for hough():
    % http://www.mathworks.com/help/images/ref/hough.html
    % Your code should imitate the Matlab implementation.
    %
    % Pay close attention to the coordinate system specified in the assignment.
    % Note: Rows of H should correspond to values of rho, columns those of theta.

    %% Parse input arguments
    p = inputParser();
    addParameter(p, 'RhoResolution', 1);
    addParameter(p, 'Theta', linspace(-90, 89, 180));
    parse(p, varargin{:});

    rhoStep = p.Results.RhoResolution;
    theta = p.Results.Theta;
    
    ht=size(BW,1);
    wd=size(BW,2);
    max_size=round((ht^2+wd^2)^0.5);
    H=zeros(round(2*(max_size/rhoStep)),length(theta));
    n_rows=size(H,1);
    
         for i=1:size(BW,1)
           for j=1:size(BW,2)
              if(BW(i,j)==1)

               theta_acc=int64(theta+abs(theta(1))+1);

               d=i.*cosd(theta)+j.*sind(theta);
           
                
               rho_acc=int64((floor(d+max_size)./rhoStep));
               rho_acc=rho_acc+1;
               ind=[(rho_acc')+n_rows.*(theta_acc'-1)];
               %for k=1:length(rho_acc)
                  % H(rho_acc(k),theta_acc(k))=H(rho_acc(k),theta_acc(k))+1;
                   H(ind)=H(ind)+1;
               %end
              end
           end
         end
         
         rho=-max_size:rhoStep:max_size;
   
end

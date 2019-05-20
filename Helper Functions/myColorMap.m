function clrmap = myColorMap(name,m,srt,stp)
%myColorMap   Creates a number of user defined color maps for use in
%             displaying data
%
%   Usage:
%      colormap = myColorMap(name,size)
%
%   Description:
%       Create custom color maps
%
%   Parameters:
%       name            String containing the name of the colormap to generate
%       m               Specifies the number of colors in the map
%       srt             Specifies the color value to start with (0-1)
%       stp             Specifies the color value to stop  at (0-1)
%
%   Return Values:
%       clrmap        M-by-3 matrix containing color values
%
%
%   Copyright (C) 2017 David Klorig
%   Author: David Klorig
%   Last modification: 1/2/2017

if nargin < 3
   srt = 0;
   stp = 1;
end

if nargin < 2
   m = size(get(gcf,'colormap'),1);
end

if nargin < 1
   name = 'red';
end

%Built in examples
%Jet
% n = ceil(m/4);
% u = [(1:1:n)/n ones(1,n-1) (n:-1:1)/n]';
% g = ceil(n/2) - (mod(m,4)==1) + (1:length(u))';
% r = g + n;
% b = g - n;
% g(g>m) = [];
% r(r>m) = [];
% b(b<1) = [];
% J = zeros(m,3);
% J(r,1) = u(1:length(r));
% J(g,2) = u(1:length(g));
% J(b,3) = u(end-length(b)+1:end);

%Winter
% r = (0:m-1)'/max(m-1,1); 
% c = [zeros(m,1) r .5+(1-r)/2];

%Autumn
% r = (0:m-1)'/max(m-1,1);
% c = [ones(m,1) r zeros(m,1)];

switch name
    case 'red'
        srt = 0.6;
        stp = 0.9;
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        %clrmap = [r zeros(m,1) zeros(m,1)];
        clrmap = [r zeros(m,1) ones(m,1)*0.1];
    case 'yellow'
        srt = 0.65;
        stp = 0.95;
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        clrmap = [r (r-0.1) zeros(m,1)];
        clrmap(clrmap<0) = 0;
    case 'green'
        srt = 0.6;
        stp = 0.9;
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        clrmap = [zeros(m,1) r zeros(m,1)];
        clrmap(clrmap<0) = 0;
    case 'magenta'
        srt = 0.7;
        stp = 0.9;
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        clrmap = [r-0.3 zeros(m,1) r];
        clrmap(clrmap<0) = 0;   
    case 'blue'
        srt = 0;
        stp = 0.5;
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        clrmap = [r r ones(m,1)];
    case 'red-black'
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        clrmap = [r zeros(m,1) zeros(m,1)];
    case 'blue-black'
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        clrmap = [zeros(m,1) zeros(m,1) r];
    case 'green-black'
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        clrmap = [zeros(m,1) r zeros(m,1)];
    case 'black-red'
        r = (stp:-(stp-srt)/max(m-1,1):srt)';
        clrmap = [r zeros(m,1) zeros(m,1)];
    case 'black-blue'
        r = (stp:-(stp-srt)/max(m-1,1):srt)';
        clrmap = [zeros(m,1) zeros(m,1) r];
    case 'black-green'
        r = (stp:-(stp-srt)/max(m-1,1):srt)';
        clrmap = [zeros(m,1) r zeros(m,1)];
    case 'pink-green'
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        r2 = (stp:-(stp-srt)/max(m-1,1):srt)';
        clrmap = [r r2 r];
    case 'red-green'
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        r2 = (stp:-(stp-srt)/max(m-1,1):srt)';
        clrmap = [r r2 zeros(m,1)];
    case 'red-orange'
        srt = 0;
        stp = 0.8;
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        r2 = (stp:-(stp-srt)/max(m-1,1):srt)';
        temp2 = norm_curve(r,0.1,0.9);
        r4 = temp2./(max(temp2));
        clrmap = [r4 r2 zeros(m,1)];
    case 'blue-lightblue'
        srt = 0;
        stp = 0.8;
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        r2 = (stp:-(stp-srt)/max(m-1,1):srt)';
        temp2 = norm_curve(r,0.1,0.9);
        r4 = temp2./(max(temp2));
        clrmap = [zeros(m,1) r2 r4 ];
    case 'blue-green'
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        temp1 = norm_curve(r,1,0.5);
        r1 = temp1./(max(temp1));
        temp2 = norm_curve(r,0,0.5);
        r2 = temp2./(max(temp2));
        clrmap = [zeros(m,1) r1 r2];
     case 'blue-magenta'
        srt = 0;
        stp = 0.8;
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        r2 = (stp:-(stp-srt)/max(m-1,1):srt)';
        temp2 = norm_curve(r,0.1,0.9);
        r4 = temp2./(max(temp2));
        clrmap = [r2 zeros(m,1) r4]; %blue-light blue
    case 'blue-lightblue-green'
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        r1 = (srt:(stp-srt)/(max(m-1,1)/2):stp)';
        r2 = (stp:-(stp-srt)/(max(m-1,1)/2):srt)';
        rh1 = [r; ones(m-size(r,1),1)];
        rh2 = [ones(m-size(r2,1),1); r2];
        clrmap = [zeros(m,1) rh2 rh1];
    case 'blue-lightblue-magenta'
        srt = 0;
        stp = 0.9;
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        r2 = (stp:-(stp-srt)/max(m-1,1):srt)';
        temp = norm_curve(r,0.4,0.15);
        r3 = temp./(max(temp)+0.4);
        temp2 = norm_curve(r,0.1,0.9);
        r4 = temp2./(max(temp2));
        clrmap = [r2 r3 r4]; 
     case 'magenta-lightblue-blue'
        srt = 0;
        stp = 0.9;
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        r2 = (stp:-(stp-srt)/max(m-1,1):srt)';
        temp = norm_curve(r,0.4,0.15);
        r3 = temp./(max(temp)+0.4);
        temp2 = norm_curve(r,0.1,0.9);
        r4 = temp2./(max(temp2));
        clrmap = [r r3 r4];   
    case 'blue-magenta-lightblue'
        srt = 0;
        stp = 0.9;
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        r2 = (stp:-(stp-srt)/max(m-1,1):srt)';
        temp = norm_curve(r,0.4,0.15);
        r3 = temp./(max(temp)+0.4);
        temp2 = norm_curve(r,0.1,0.9);
        r4 = temp2./(max(temp2));
        clrmap = [r3 r2 r4];
     case 'red-magenta-yellow'
        srt = 0;
        stp = 0.9;
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        r2 = (stp:-(stp-srt)/max(m-1,1):srt)';
        temp = norm_curve(r,0.4,0.15);
        r3 = temp./(max(temp)+0.4);
        temp2 = norm_curve(r,0.1,0.9);
        r4 = temp2./(max(temp2));
        clrmap = [r4 r2 r3];
    case 'green-lightblue-yellow'
        srt = 0;
        stp = 0.9;
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        r2 = (stp:-(stp-srt)/max(m-1,1):srt)';
        temp = norm_curve(r,0.4,0.15);
        r3 = temp./(max(temp)+0.4);
        temp2 = norm_curve(r,0.1,0.9);
        r4 = temp2./(max(temp2));
        clrmap = [r2 r4 r3]; 
    case 'blue-green-yellow'
        srt = 0;
        stp = 0.8;
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        r2 = (stp:-(stp-srt)/max(m-1,1):srt)';
        temp2 = norm_curve(r,0.1,0.9);
        r4 = temp2./(max(temp2));
        clrmap = [r2 r4 r];
     case 'darker-blue-green-yellow'
        srt = 0;
        stp = 0.9;
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        r2 = (stp:-(stp-srt)/max(m-1,1):srt)';
        temp2 = norm_curve(r,0.2,0.5);
        r4 = temp2./(max(temp2));
        clrmap = [r2 r4 r];
      case 'green-blue-lime'
        srt = 0;
        stp = 0.8;
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        r2 = (stp:-(stp-srt)/max(m-1,1):srt)';
        temp = norm_curve(r,0.4,0.15);
        r3 = temp./(max(temp)+0.4);
        temp2 = norm_curve(r,0.2,0.5);
        r4 = temp2./(max(temp2)+0.1);
        clrmap = [r2 r4 r3];
      case 'green-blue-magenta'
        srt = 0;
        stp = 0.8;
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        r2 = (stp:-(stp-srt)/max(m-1,1):srt)';
        temp2 = norm_curve(r,0.3,0.3);
        r4 = temp2./(max(temp2)+0.1);
        clrmap = [r2 r r4];
      case 'darkblue-lightblue'
          srt = 0;
          stp = 0.8;
          r = (srt:(stp-srt)/max(m-1,1):stp)';
          r2 = (stp:-(stp-srt)/max(m-1,1):srt)';
          temp2 = norm_curve(r,0.1,0.5);
          r4 = temp2./(max(temp2));
          clrmap = [r2*0.9 r2 r4];
     case 'darkgreen-lightgreen'
          srt = 0;
          stp = 0.8;
          r = (srt:(stp-srt)/max(m-1,1):stp)';
          r2 = (stp:-(stp-srt)/max(m-1,1):srt)';
          temp2 = norm_curve(r,0.1,0.5);
          r4 = temp2./(max(temp2));
          clrmap = [r2 r4 r2*0.9];
     case 'darkred-lightred'
          srt = 0;
          stp = 0.8;
          r = (srt:(stp-srt)/max(m-1,1):stp)';
          r2 = (stp:-(stp-srt)/max(m-1,1):srt)';
          temp2 = norm_curve(r,0.1,0.5);
          r4 = temp2./(max(temp2));
          clrmap = [r4 r2*0.9 r2];
    case 'blue-orange-green'
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        r2 = (stp:-(stp-srt)/max(m-1,1):srt)';
        temp = norm_curve(r,0.4,0.2);
        r3 = temp./(max(temp)+0.2);
        clrmap = [r3 r2 r];         %blue-orange-green
    case 'blue-green-black'
        srt = 0;
        stp = 1;
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        temp = norm_curve(r,0.5,0.2);
        r3 = temp./(max(temp)+0.2);
        clrmap = [zeros(m,1) r3 r]; %blue-green-black
    case 'hsv'
        clrmap = hsv(m);
    case 'jet'
        clrmap = jet(m);
    case 'jet2'
        clrmap = jet(m).*0.8;
    case 'jet3'
        scale = 0.04;
        %clrmap = jet(m)-repmat((norm_curve(0:1/m:1-(1/m),0.65,0.05).*scale)',1,3);
        clrmap = jet(m)-vertcat(zeros(1,m),(norm_curve(0:1/m:1-(1/m),0.65,0.07).*scale),zeros(1,m))';
        clrmap(clrmap<0) = 0;
    case 'winter'
        clrmap = winter(m);
    case 'winter2'
        scale = 0.04;
        clrmap = winter(m)-repmat((norm_curve(0:1/m:1-(1/m),0.75,0.05).*scale)',1,3);
        clrmap(clrmap<0) = 0;
    case 'autumn'
        clrmap = autumn(m);
    case 'autumn2'
        scale = 0.06;
        clrmap = autumn(m)-vertcat(zeros(1,m),(norm_curve(0:1/m:1-(1/m),0.8,0.1).*scale),zeros(1,m))';
        clrmap(clrmap<0) = 0;
    case 'parula'
        clrmap = parula(m);
    case 'parula2'
        clrmap = parula(m)*0.8;
    case 'parula3'
        scale = 0.025;
        %clrmap = parula(m)-repmat((norm_curve(0:1/m:1-(1/m),0.65,0.05).*scale)',1,3);
        clrmap = parula(m)-vertcat(zeros(1,m),(norm_curve(0:1/m:1-(1/m),1,0.07).*scale),zeros(1,m))';
        clrmap(clrmap<0) = 0;      
    case 'lines'
        clrmap = lines(m);
    case 'my-grayscale'
        srt = 0;
        stp = 0.8;
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        clrmap = [r r r];
    case 'nonlingrey'
        srt = 0;
        stp = 0.8;
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        temp4 = norm_curve(r,0,0.3);
        r6 = temp4./(max(temp4));
        clrmap = [r6*0.9 r6*0.9 r6*0.9];  %grey
    case 'darker-blue-green-yellow2'
        srt = 0;
        stp = 0.9;
        r = (srt:(stp-srt)/max(m-1,1):stp)';
        r2 = (stp:-(stp-srt)/max(m-1,1):srt)';
        temp2 = norm_curve(r,0.3,0.3);
        r4 = temp2./(max(temp2));
        temp3 = norm_curve(r,1,0.3);
        r5 = temp3./(max(temp3));
        temp4 = norm_curve(r,0,0.2);
        r6 = temp4./(max(temp4));
        clrmap = [r6*0.9 r4*0.9 r5*0.9];  %blue-green-yellow

    otherwise
        disp('Error: Map name not recognized');
        clrmap = [0.5 0.5 0.5];
        
end

end


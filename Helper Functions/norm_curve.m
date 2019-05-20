function y = norm_curve(x,u,s)
%norm_curve   Creates a gaussian curve
%
%   Usage:
%      curve = norm_curve(x,u,s)
%
%   Description:
%       Creates a gaussian curve using 1D array x, mean u, and SD s. 
%
%   Parameters:
%       x            1D array (x-axis)
%       u            mean
%       s            standard deviation
%
%   Return Values:
%       y           gaussian curve (will need to be scaled later if
%                    necessary)
%
%
%   Copyright (C) 2017 David Klorig
%   Author: David Klorig
%   Last modification: 1/2/2017

if nargin < 3
    s = 1;
end

if nargin < 2
    u = 1;
end

if nargin < 1
    fs = 1000;
    x = -3:1/fs:3;
end

y = (1/(s*sqrt(2*pi)))*exp((-(x-u).^2)/(2*s.^2));

end

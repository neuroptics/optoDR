function [ pos_vect2 ] = manual_subplot_tight2( row,column,row_space,col_space )
%manual_subplot_tight Generates position vectors for manual subplotting
%
%   Usage:
%      [ position_vector ] = manual_subplot_tight( row,column,row_space,column_space )
%
%   Description:
%       Makes a subplot position vector with the specified parameters
%       (top left to bottom right, columns in order)
%
%   Parameters:
%       row	        Number of rows
%       columns     Number of columns
%       row_space   Space between rows (usually around 0.02)
%       col_space   Space between columns (usually around 0.02)
%
%   Return Values:
%       pos_vect   A position vector to be used for generating manual subplots
%
%   Usage Example:
%       row_space = 0.02;
%       col_space = 0.02;
%       row = 2;
%       column = 5;
%
%       [pos_vect ] = manual_subplot_tight(row,column,row_space,col_space);
%
%       h(a,1) = subplot('Position',pos_vect{a,1});
%
%
%   Copyright (C) 2015 David Klorig
%   Author: David Klorig
%   Last modification: 12/10/2015
%


% Subplot "tight" position vectors
pos_vect = cell(row,column);
pos_vect2 = cell(row*column,1);

c = 1;
for b = 1:column
    for a = row:-1:1
        pos_vect{a,b} = [((1/column)*b)-(1/column)+col_space/2,((1/row)*a)-(1/row)+row_space/2,(1/column)-col_space,(1/row)-row_space];
        pos_vect2{c,1} = pos_vect{a,b};
        c = c+1;
    end
end

end


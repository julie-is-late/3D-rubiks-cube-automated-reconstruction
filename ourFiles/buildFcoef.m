function [ A ] = buildFcoef( M1, M2 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[~,c] = size(M1);
A = [];

for i = 1:c
    x = M1(1,i);
    y = M1(2,i);
    xp = M2(1,i);
    yp = M2(2,i);
    
    A = [x * xp, x * yp, x, y*xp, y*yp, y, xp, yp, 1; 
         A];
end


end


function [ output ] = normalizePoints(X) 
% normalizePoints returns the normalizing transformation of 3 x n matrix X
%   

[~,c] = size(X);

xavg = 0;
yavg = 0;

for i = 1:c
    xavg = xavg + X(1,i);
    yavg = yavg + X(2,i);
end

xavg = xavg / c;
yavg = yavg / c;

tempSumThing = 0;
for i = 1:c
    tempSumThing = tempSumThing + ((X(1,i) - xavg)^2 + (X(2,i) - yavg)^2);
end

distanceThing = sqrt(tempSumThing / c);
root2 = sqrt(2);

output = [root2 / distanceThing, 0, -(root2 / distanceThing) * xavg; 
          0, root2 / distanceThing, -(root2 / distanceThing) * yavg; 
          0, 0, 1];

end

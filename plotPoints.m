function plotPoints(X);
%
% Function: displays 3D points in a viewer
%
% Usage:  plotPoints(X)
%
% Arguments:
%            X - a 4xn array of 3D points
%

X = 100*X;

clf
hold on
axis('equal')

campos([0 0 0]);
camup([0 -1 0]);

[r,c] = size(X);
for i = 1:c
  [x, y, z] = sphere(10);
  x = x+X(1,i);
  y = y+X(2,i);
  z = z+X(3,i);
  surf(x, y, z);
  view3d rot
end

h = gca;
set(h,'Visible','off')
set(h,'Projection','orthographic');
axis('vis3d')

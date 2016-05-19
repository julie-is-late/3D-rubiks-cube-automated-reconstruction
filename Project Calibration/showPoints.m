% showPoints - displays corresponding points ip1 and ip2 overlaid on
% images i1 and i2.
%
% Usage:  showPoints(i1, i2, ip1, ip2)
% 
% Arguments:
%            i1 - Image 1
%            i2 - Image 2
%            ip1 - Array of points in perspective image 1
%            which correspond to points in perspective image 2.
%			[x1 x2 ... xn
%                        y1 y2 ... yn]
%            ip2 - Array of points in perspective image 2
%            which correspond to points in perspective image 1.
%			[x1 x2 ... xn
%                        y1 y2 ... yn]
%

function showPoints(i1, i2, ip1, ip2);

% make sure the inputs are reasonable
[ip1rows, ip1npts] = size(ip1);
[ip2rows, ip2npts] = size(ip2);

if ip1rows ~= 2 || ip2rows ~= 2 || ip1npts ~= ip2npts
  error('data points must be in the form of an 2xn array');
end

figure(1);
clf;
imshow(i1);
hold on;
zoom off;

h = plot(ip1(1,:), ip1(2,:), 'ro');
set(h, 'MarkerSize', 5);
set(h, 'Color', [0 1 1]);
H = text(ip1(1,:)+4, ip1(2,:)+4, int2str([1:size(ip1, 2)]'));
set(H, 'Color', [0 1 1]);
set(H, 'FontSize', 10);

figure(2);
clf;
imshow(i2);
hold on;
zoom off;

h = plot(ip2(1,:), ip2(2,:), 'ro');
set(h, 'MarkerSize', 5);
set(h, 'Color', [0 1 1]);
H = text(ip2(1,:)+4, ip2(2,:)+4, int2str([1:size(ip2, 2)]'));
set(H, 'Color', [0 1 1]);
set(H, 'FontSize', 10);

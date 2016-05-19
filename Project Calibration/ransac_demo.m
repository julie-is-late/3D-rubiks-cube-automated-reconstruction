close all

im1 = imread('myers3.ppm');
im2 = imread('myers4.ppm');
  
% select a single channel out of the images
im1 = im1(:,:,1);
im2 = im2(:,:,1);

smooth = 2;
thresh = 2000 ;  % Harris corner threshold
nonmaxrad = 10;  % Non-maximal suppression radius
w = 91;         % Window size for correlation matching
dmax = 50;     % Maximum search distance for matching
    
% Find Harris corners in image1 and image2
[cim1, r1, c1] = harris(im1, smooth, thresh, nonmaxrad);
show(im1,1), hold on, plot(c1,r1,'r+', 'LineWidth', 2);

[cim2, r2, c2] = harris(im2, smooth, thresh, nonmaxrad);
show(im2,2), hold on, plot(c2,r2,'r+', 'LineWidth', 2);

drawnow;
pause;

correlation = 0;  % Change this between 1 or 0 to switch between the two
		  % matching functions below
    
if correlation    % Use normalised correlation matching
  [m1,m2] = matchbycorrelation(im1, [r1';c1'], im2, [r2';c2'], w, dmax);
else              % Use monogenic phase matching
  nscale = 2;
  minWaveLength = 10;
  mult = 4;
  sigmaOnf = .2;
  [m1,m2] = matchbymonogenicphase(im1, [r1';c1'], im2, [r2';c2'], w, dmax,...
				  nscale, minWaveLength, mult, sigmaOnf);
end    
    
% Display putative matches
show(double(im1)+double(im2),3), set(3,'name','Putative matches')
for n = 1:length(m1);
  line([m1(2,n) m2(2,n)], [m1(1,n) m2(1,n)], 'LineWidth', 2)
end

pause;

% Assemble homogeneous feature coordinates for fitting of the
% fundamental matrix, note that [x,y] corresponds to [col, row]
x1 = [m1(2,:); m1(1,:); ones(1,length(m1))];
x2 = [m2(2,:); m2(1,:); ones(1,length(m1))];    
    
t = .0001;  % Distance threshold for deciding outliers
% Change the commenting on the lines below to switch between the use
% of 7 or 8 point fundamental matrix solutions, or affine
% fundamental matrix solution.
%[F, inliers] = ransacfitfundmatrix7(x1, x2, t, 1);    
[F, inliers] = ransacfitfundmatrix(x1, x2, t, 1);
%[F, inliers] = ransacfitaffinefund(x1, x2, t, 1);    

fprintf('Number of inliers was %d (%d%%) \n', ...
	length(inliers),round(100*length(inliers)/length(m1)))
fprintf('Number of putative matches was %d \n', length(m1))        
    
% Display both images overlayed with inlying matched feature points
show(double(im1)+double(im2),4), set(4,'name','Inlying matches'), hold on
plot(m1(2,inliers),m1(1,inliers),'r+', 'LineWidth', 2);
plot(m2(2,inliers),m2(1,inliers),'g+', 'LineWidth', 2);

for n = inliers
  line([m1(2,n) m2(2,n)], [m1(1,n) m2(1,n)],'color',[0 0 1], 'LineWidth', 2)
end

response = input('Step through each epipolar line [y/n]?\n','s');
if response == 'y'
    
  % Step through each matched pair of points and display the
  % corresponding epipolar lines on the two images.
    
  l2 = F*x1;    % Epipolar lines in image2
  l1 = F'*x2;   % Epipolar lines in image1
    
  % Solve for epipoles
  [U,D,V] = svd(F);
  e1 = hnormalise(V(:,3));
  e2 = hnormalise(U(:,3));
 
  for n = inliers
    figure(1), clf, imshow(im1), hold on;
    hline(l1(:,n)); plot(e1(1), e1(2), 'g*');
    plot(x1(1,n),x1(2,n),'r+');
    
    figure(2), clf, imshow(im2), hold on;
    hline(l2(:,n)); plot(e2(1), e2(2), 'g*');
    plot(x2(1,n),x2(2,n),'r+');
    fprintf('hit any key to see next point\r'); pause
  end
end    

addpath('/home/mellor/ProfessionalArchives/Teaching/Class/csse461/problem_sets/RHIT_recontruct')
load K;
% The F defined and used above is the transpose of the F defined in
% my scripts.
%F = estimateF(x1(1:2,inliers), x2(1:2,inliers))
F = F';
addpath('/home/mellor/ProfessionalArchives/Teaching/Class/csse461/matlab/reconstruction')
[P1, P2, X] = reconstructScene(F, K, K, x1(1:2,inliers), x2(1:2,inliers));
figure(5)
addpath('/home/mellor/ProfessionalArchives/Teaching/Class/csse461/matlab/utilities')
plotPoints(X)

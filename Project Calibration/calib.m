addpath('TOOLBOX_calib');

clear;


%
% Select: standard mode
%
% Select: Image namescal
%   basename: c3xz
%   image format: t
%
% Select: extract grid corners
%   wintx, winty: defaults
%   automatic counting: defaults
%   select corners (be careful around the big black circle)
%   x squares: 15
%   y squares: 9
%   dx: 0.5
%   dy: 0.5
%
%   repeat for each image
% 
% My corners are saved in "extracted_corners.mat"

load calib_var_1in


% i8 = imread('i8.jpg');
% i9 = imread('i9.jpg');
% i10 = imread('i10.jpg');
% i11 = imread('i11.jpg');
% i12 = imread('i12.jpg');
% i13 = imread('i13.jpg');
% i14 = imread('i14.jpg');
% i15 = imread('i15.jpg');
% 
% showPoints(i8,i9,x_1,x_2);


% showPoints(i1,i2,input_points',base_points')



ip = [x_1 x_2 x_3 x_4 x_5 x_6 x_7 x_8];
X_1 = [X_1(1:2,:);   zeros(1,size(X_1,2))];
X_2 = [X_2(1:2,:); -1*ones(1,size(X_2,2))];
X_3 = [X_3(1:2,:); -2*ones(1,size(X_3,2))];
X_4 = [X_4(1:2,:); -3*ones(1,size(X_4,2))];
X_5 = [X_5(1:2,:); -4*ones(1,size(X_5,2))];
X_6 = [X_6(1:2,:); -5*ones(1,size(X_6,2))];
X_7 = [X_7(1:2,:); -6*ones(1,size(X_7,2))];
X_8 = [X_8(1:2,:); -7*ones(1,size(X_8,2))];
wp = [X_1 X_2 X_3 X_4 X_5 X_6 X_7 X_8];
% ip = [x_1 x_2 x_3 x_4 x_5];
% X_1 = [X_1(1:2,:);   zeros(1,size(X_1,2))];
% X_2 = [X_2(1:2,:); -1*ones(1,size(X_2,2))];
% X_3 = [X_3(1:2,:); -2*ones(1,size(X_3,2))];
% X_4 = [X_4(1:2,:); -3*ones(1,size(X_4,2))];
% X_5 = [X_5(1:2,:); -4*ones(1,size(X_5,2))];
% wp = [X_1 X_2 X_3 X_4 X_5];
n_ima = 1;

x_1 = ip;
X_1 = wp;

% Image size: (may or may not be available)
nx = 4000;
ny = 2992;

% No calibration image is available (only the corner coordinates)
no_image = 1;

% Set the toolbox not to prompt the user (choose default values)
dont_ask = 1;

% Run the main calibration routine:
go_calib_optim;

% Shows the extrinsic parameters:
ext_calib;

% Reprojection on the original images:
reproject_calib;

% Set the toolbox to normal mode of operation again:
dont_ask =  0;

k = [fc(1), 0, cc(1);
    0, fc(2), cc(2);
    0, 0, 1]

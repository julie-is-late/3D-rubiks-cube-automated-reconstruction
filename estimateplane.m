function [ Theta, k ] = estimateplane( X, s )
%3DPLANE Summary of this function goes here
%   Detailed explanation goes here
k = 3;

if (nargin == 0) || isempty(X)
    Theta = [];
    return;
end;

if (nargin == 2) && ~isempty(s)
    X = X(:, s);
end;

% check if we have enough points
N = size(X, 2);
if (N < k)
    error('estimate_plane:inputError', ...
        'At least 3 points are required');
end;

A = [transpose(X(1, :)) transpose(X(2, :)) transpose(X(3, :)) transpose(X(4, :))];
[U S V] = svd(A);
Theta = V(:, 4);

end


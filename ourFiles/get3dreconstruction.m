function [ P1, P2, X ] = get3dreconstruction( ps1, ps2, K )
%GET3DRECONSTRUCTION Summary of this function goes here
%   Detailed explanation goes here
ps1 = [ps1; ones(1, size(ps1, 2))];
ps2 = [ps2; ones(1, size(ps2, 2))];

% build normalization matrices
T1n = normalizePoints(ps1);
T2n = normalizePoints(ps2);

ps1n = T1n * ps1;
ps2n = T2n * ps2;

% Build A
A = buildFcoef(ps1n, ps2n);
[~, ~, v] = svd(A);
Fn = reshape(v(:,9), 3, 3)';
[u, d, v] = svd(Fn);
d(3,3) = 0;
Fn = u*d*v';
F = T1n' * Fn * T2n;


% Verify that xFx' is close to 0
[~,numpoints] = size(ps2);
for i = 1:numpoints
    if (abs(ps1(:,i)' * F * ps2(:,i)) > .005) 
        disp('bad F value')
    end
end

% get E
Ep = K' * F * K;
[u, d, v] = svd(Ep);
dcrossAvg = (d(1,1) + d(2,2)) / 2;
d(1,1) = dcrossAvg;
d(2,2) = dcrossAvg;
d(3,3) = 0;
E = u*d*v';
if (E(3,3) < 0) 
    E = E * -1;
end

W = [0 -1 0; 1 0 0; 0 0 1];

R1 = u*W*v';
R2 = u*W'*v';
T1 = u(:,3);
T2 = -u(:,3);

P2 = K*[eye(3) zeros(3,1)];

% leaving out K so I can pull out R and T inside findp
P1full(:,:,1) = [R1, T1];
P1full(:,:,2) = [R1, T2];
P1full(:,:,3) = [R2, T1];
P1full(:,:,4) = [R2, T2];

if (P1full(3,3,1) < 0)
    disp('p1_1 was negative')
    P1full(:,:,1) = P1full(:,:,1) * -1;
end

if (P1full(3,3,2) < 0)
    disp('p1_2 was negative')
    P1full(:,:,2) = P1full(:,:,2) * -1;
end

if (P1full(3,3,3) < 0)
    disp('p1_3 was negative')
    P1full(:,:,3) = P1full(:,:,3) * -1;
end

if (P1full(3,3,4) < 0)
    disp('p1_4 was negative')
    P1full(:,:,4) = P1full(:,:,4) * -1;
end

[P1, X] = findp(P1full, P2, ps1, ps2, K);

end


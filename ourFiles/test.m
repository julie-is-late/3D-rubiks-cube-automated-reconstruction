load('temp')
[P1, P2, X] = get3dreconstruction(x1(1:2,inliers), x2(1:2,inliers), K);

figure(5)
plotPoints(X)

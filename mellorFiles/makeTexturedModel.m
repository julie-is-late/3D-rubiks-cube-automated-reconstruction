% makeTexturedModel
%
% Creates a textured vrml file.
%
% Usage:  makeTexturedModel(filename, X, polygons, textures, texCoords,
%                           rotation, scale)
% 
% Arguments:
%            filename - name of the vrml file to create.
%            X - Array of 3D points.
%                       [x1 x2 ... xn
%                        y1 y2 ... yn
%                        z1 z2 ... zn
%                        w1 w2 ... wn]
%            polygons - a cell array containing 1 x n arrays which
%                       specifies the vertices of each polygon to be
%                       included to the vrml model.
%            textures - a cell array containing the filenames of
%                       the textures associated with each polygon.
%            texCoords - a cell array containing 2 x n arrays which
%                        specify the texture coordinates associated
%                        with each vertex of each polygon.
%            rotation - a global rotation to be applied to the 3D
%                       points.  [0 0 1 3.14] seems to work well.
%            scale - scale applied to unhomogenized 3D points.
%
% Side effect: writes an asci vrml model file.
%

function makeTexturedModel(filename, X, polygons, textures, texCoords, ...
                           rotation, scale);

[Xrows, Xnpts] = size(X);
npolygons = size(polygons, 2);

fd = fopen(filename, 'w');

fprintf(fd, '#VRML V2.0 utf8\n\n');

fprintf(fd, 'WorldInfo {\n');
fprintf(fd, ' title "Textured model"\n');
fprintf(fd, '}\n\n');

fprintf(fd, 'NavigationInfo {\n');
fprintf(fd, ' headlight TRUE\n');
fprintf(fd, '}\n\n');

fprintf(fd, 'DEF View1 Viewpoint {\n');
fprintf(fd, '  orientation 0 1 0 3.14\n');
fprintf(fd, '  position  0, 0, 0\n');
fprintf(fd, '  fieldOfView 1\n');
fprintf(fd, '  description "View 1 - Observer"\n');
fprintf(fd, '}\n\n');

fprintf(fd, 'Background {\n');
fprintf(fd, '  skyAngle [\n');
fprintf(fd, '    1.39626\n');
fprintf(fd, '    1.51844\n');
fprintf(fd, '  ]\n');
fprintf(fd, '  skyColor [\n');
fprintf(fd, '    0.0 0.0 0.0\n');
fprintf(fd, '    1.0 0.8 0.8\n');
fprintf(fd, '    1.0 1.0 0.0\n');
fprintf(fd, '  ]\n');
fprintf(fd, '  groundAngle [\n');
fprintf(fd, '    1.5708\n');
fprintf(fd, '  ]\n');
fprintf(fd, '  groundColor [\n');
fprintf(fd, '    0.0 0.0 0.0\n');
fprintf(fd, '    0.0 0.50196 0.0\n');
fprintf(fd, '  ]\n');
fprintf(fd, '}\n\n');

fprintf(fd, 'DEF MYPOINTS Coordinate {\n');
fprintf(fd, '  point [\n');
for i = 1:Xnpts-1
  point = scale*X(1:3,i)/X(4,i);
  fprintf(fd, '        %6.2f  %6.2f  %6.2f,\n', point);
end
point = scale*X(1:3,Xnpts)/X(4,Xnpts);
fprintf(fd, '        %6.2f  %6.2f  %6.2f\n', point);
fprintf(fd, '  ]\n');
fprintf(fd, '}\n\n');


fprintf(fd, 'Transform {\n');
fprintf(fd, '   rotation %6.2f  %6.2f  %6.2f  %6.2f\n\n', rotation);
fprintf(fd, '   children [\n\n');
for n = 1:npolygons
  fprintf(fd, '      Shape  {\n');
  fprintf(fd, '         appearance Appearance {\n');
  fprintf(fd, '            texture ImageTexture {\n');
  fprintf(fd, '               url "%s"\n', textures{n});
  fprintf(fd, '            }\n');
  fprintf(fd, '         }\n');
  fprintf(fd, '         geometry IndexedFaceSet {\n');
  fprintf(fd, '            coord USE MYPOINTS\n');
  fprintf(fd, '            coordIndex [ ');
  v = size(polygons{n},2);
  for i = 1:v
    fprintf(fd, '%d, ', polygons{n}(i)-1);
  end
  fprintf(fd, '-1 ]\n');
  fprintf(fd, '            texCoord TextureCoordinate {\n');
  fprintf(fd, '               point [\n');
  for i = 1:v-1
    fprintf(fd,'                   %6.2f  %6.2f,\n', texCoords{n}(:,i)');
  end
  fprintf(fd,'                   %6.2f  %6.2f\n', texCoords{n}(:,v)');
  fprintf(fd, '               ]\n');
  fprintf(fd, '            }\n');
  fprintf(fd, '            texCoordIndex [ ');
  for i = 0:v-1
    fprintf(fd, '%d, ', i);
  end
  fprintf(fd, '-1 ]\n');
  fprintf(fd, '         }\n');
  fprintf(fd, '      }\n\n');
end
fprintf(fd, '   ]\n');
fprintf(fd, '}\n');

fclose(fd);

return

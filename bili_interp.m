function [ interp_im ] = bili_interp( x, y, source_im )
%bili_interp generates the interpolated image using bilinear interpolation.
% (INPUT) x, y: Ht×Wt matrix representing the coordinates of the
% corresponding point in the source image.
% (INPUT) source_im: Hs×Ws×3 matrix representing the source image.
% (OUTPUT) interp_im: Ht×Ht×3 uint8 matrix representing the interpolated 
% image.

fl_x = floor(x);
cl_x = ceil(x);

fl_y = floor(y);
cl_y = ceil(y);

fl_x(fl_x < 1) = 1;
fl_x(fl_x > size(source_im, 2)) = size(source_im, 2);
cl_x(cl_x < 1) = 1;
cl_x(cl_x > size(source_im, 2)) = size(source_im, 2);

fl_y(fl_y < 1) = 1;
fl_y(fl_y > size(source_im, 1)) = size(source_im, 1);
cl_y(cl_y < 1) = 1;
cl_y(cl_y > size(source_im, 1)) = size(source_im, 1);

a = zeros(size(x, 1), size(x, 2), 3);
b = zeros(size(x, 1), size(x, 2), 3);
c = zeros(size(x, 1), size(x, 2), 3);
d = zeros(size(x, 1), size(x, 2), 3);

for i = 1: size(x, 1)
    for j = 1: size(x, 2)
        a(i, j, :) = source_im(fl_y(i, j), fl_x(i, j), :);
        b(i, j, :) = source_im(fl_y(i, j), cl_x(i, j), :);
        c(i, j, :) = source_im(cl_y(i, j), fl_x(i, j), :);
        d(i, j, :) = source_im(cl_y(i, j), cl_x(i, j), :);
    end
end

x1 = x - fl_x;
x1(x1 == 0) = 1;
x1(x1 < 0) = 0;
x2 = cl_x - x;
x2(x2 < 0) = 0;
y1 = y - fl_y;
y1(y1 == 0) = 1;
y1(y1 < 0) = 0;
y2 = cl_y - y;
y2(y2 < 0) = 0;

interp_im = uint8((b.*x1 + a.*x2).*y2 + (d.*x1 + c.* x2).*y1);

end

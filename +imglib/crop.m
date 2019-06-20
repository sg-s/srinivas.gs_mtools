% crop image to bounding box
% allows a 3-pixel buffer
function C = crop(I, padding)

if nargin == 1
	padding = 0;
end

I_orig = I;

if numel(size(I)) == 3
	% make grayscale
	I = sum(I,3)/size(I,3);
end

I = 255-I;

X = sum(I,1);
Y = sum(I,2);

xx = [find(diff(X),1,'first')  find(diff(X),1,'last')];
yy = [find(diff(Y),1,'first')  find(diff(Y),1,'last')];

xx(1) = xx(1) - padding;
xx(2) = xx(2) + padding;

yy(1) = yy(1) - padding;
yy(2) = yy(2) + padding;

if xx(1) < 1
	xx(1) = 1;
end

if xx(2) > length(X)
	xx(2) = length(X);
end

if yy(1) < 1
	yy(1) = 1;
end

if yy(2) > length(Y)
	yy(2) = length(Y);
end

if numel(size(I_orig)) == 3
	C = I_orig(yy(1):yy(2),xx(1):xx(2),:);
else
	C = I_orig(yy(1):yy(2),xx(1):xx(2));
end


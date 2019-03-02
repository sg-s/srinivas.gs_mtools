% crop image to bounding box
function C = crop(I)

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


if numel(size(I_orig)) == 3
	C = I_orig(yy(1):yy(2),xx(1):xx(2),:);
else
	C = I_orig(yy(1):yy(2),xx(1):xx(2));
end


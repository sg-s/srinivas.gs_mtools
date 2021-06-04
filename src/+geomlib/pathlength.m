% measure length of path along 2D line

function D = pathlength(xx,yy)

D = (xx(2:end) - xx(1:end-1)).^2 + (yy(2:end) - yy(1:end-1)).^2;
D = sqrt(D); D = D(:);
D = cumsum([0; D]);
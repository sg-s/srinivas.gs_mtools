function A = findAreas(self,X,Y)

	
DT = self.DT;
% find areas of all triangles
A = zeros(size(DT,1),1);


for i = 1:size(A,1)
	% only if the vertices are different 
	if min(self.R(DT.ConnectivityList(i,:))) == max(self.R(DT.ConnectivityList(i,:)))
		continue
	end

	% OK, at least one different

	x1 = X(DT.ConnectivityList(i,1));
	x2 = X(DT.ConnectivityList(i,2));
	x3 = X(DT.ConnectivityList(i,3));
	y1 = Y(DT.ConnectivityList(i,1));
	y2 = Y(DT.ConnectivityList(i,2));
	y3 = Y(DT.ConnectivityList(i,3));

	A(i) = 1/2*abs((x2-x1)*(y3-y1)-(x3-x1)*(y2-y1));

end


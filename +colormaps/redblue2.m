% a red-blue colormap that goes via black

function RB = redblue2(N)


arguments 
	N (1,1) double = 100
end

C = zeros(200,3);
C(1:100,1) = sqrt(linspace(1,0,100));

C(101:end,3) = sqrt(linspace(0,1,100));


RB = zeros(N,3);
RB(:,1) = interp1(linspace(0,1,200),C(:,1),linspace(0,1,N));
RB(:,3) = interp1(linspace(0,1,200),C(:,3),linspace(0,1,N));

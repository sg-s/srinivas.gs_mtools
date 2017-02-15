% Spearman correlation coefficent, using MATLAB's built in corr function


function rho = spear(x,y)

rho = corr(x(:),y(:),'type','Spearman');
% compute the Gini coefficient 
function cheese=gini(vs, pop)
% FORMAT: gini(values, population)
% Givne these values, this computes the GINI coefficient according to
% footnote 17 of Noorbakhsh

if size(vs,2)~=1 || size(pop,2)~=1 || size(vs,1)~=size(pop,1)
    error('arguments need to be column vectors')
end


P=sum(pop);
mu=sum(vs.*(pop/P));
C=size(vs,1);
total=0;

for i=1:C
    for j=1:C
        total=total+pop(i)*pop(j)/(P^2)*abs(vs(i)-vs(j));
    end
end

cheese=total/mu;
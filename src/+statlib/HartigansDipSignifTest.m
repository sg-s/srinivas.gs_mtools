
function [dip, p_value, xlow,xup]=HartigansDipSignifTest(X,nboot)


arguments
	X (:,1) double
	nboot (1,1) double = 500

end

%  function		[dip,p_value,xlow,xup]=HartigansDipSignifTest(X,nboot)
%
% calculates Hartigan's DIP statistic and its significance for the empirical p.d.f  X (vector of sample values)
% This routine calls the matlab routine 'HartigansDipTest' that actually calculates the DIP
% NBOOT is the user-supplied sample size of boot-strap
% Code by F. Mechler (27 August 2002)

% calculate the DIP statistic from the empirical pdf
[dip,xlow,xup] = statlib.HartigansDipTest(X);
N = length(X);

% calculate a bootstrap sample of size NBOOT of the dip statistic for a uniform pdf of sample size N (the same as empirical pdf)
boot_dip = [];
for i=1:nboot
   unifpdfboot = sort(unifrnd(0,1,1,N));
   [unif_dip] = statlib.HartigansDipTest(unifpdfboot);
   boot_dip = [boot_dip; unif_dip];
end
boot_dip = sort(boot_dip);
p_value = sum(dip<boot_dip)/nboot;



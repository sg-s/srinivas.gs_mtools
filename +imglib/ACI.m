% computes the activity correlated image from a time series of images
% minimal usage:
%
% I = ACI(time,images,stimulus_epoch,pre_stimulus_epoch);   
%
% where time is a 1xN vector 
% images is a AxBxN matrix 
% stimulus_epoch and 
% pre_stimulus_epoch are Mx2 matrices specifying the start
% and end of these epochs in units of time
% 
% Srinivas Gorur-Shandilya 
% 
function [I, I_lo, I_hi] = ACI(time,images,stimulus_epoch,pre_stimulus_epoch,template_image)    

images = double(images);

assert(size(pre_stimulus_epoch,2) == 2, 'pre_stimulus_epoch must be a Mx2 matrix')
assert(size(stimulus_epoch,2) == 2, 'stimulus_epoch must be a Mx2 matrix')
assert(size(pre_stimulus_epoch,1) == size(stimulus_epoch,1),'For every pre_stimulus_epoch, there must be a stimulus_epoch')

A = squeeze(0*images(:,:,1:size(pre_stimulus_epoch,1)));

for mi = 1:size(pre_stimulus_epoch,1)

    a1 = find(time > pre_stimulus_epoch(mi,1),1,'first');
    z1 = find(time > pre_stimulus_epoch(mi,2),1,'first');
    a2 = find(time > stimulus_epoch(mi,1),1,'first');
    z2 = find(time > stimulus_epoch(mi,2),1,'first');
      

    assert(~isempty(z1),'Error in determining epochs')
    assert(~isempty(z2),'Error in determining epochs')
    assert(~isempty(a1),'Error in determining epochs')
    assert(~isempty(z2),'Error in determining epochs')

    images_temp = images;

    for i = 1:size(images,1)
        for j = 1:size(images,2)
            % divide by pre-stimulus flourescence
            baseline = mean(images(i,j,a1:z1));
            images_temp(i,j,:) = images(i,j,:)./baseline;
        end
    end

    for i = 1:size(images,1)
        for j = 1:size(images,2)
            A(i,j,mi) = mean(images_temp(i,j,a2:z2));
        end
    end


end


images = images_temp;

% now average over all the epochs 
A = mean(A,3);


% create a false color image
I = zeros(size(images,1),size(images,2),3);

if nargin < 5
	mI = mean(images,3);
else
	mI = double(template_image);
end
mI = mI - min(min(mI));
mI = mI/max(max(mI));

for i = 1:3
    I(:,:,i) = mI;
end
I = 1-I;

A_lo = A; A_lo(A_lo>1) = 1;
A_hi = A; A_hi(A_hi<1) = 1;
A_hi = A_hi - 1;
A_lo = 1 - A_lo;

norm_max = max([max(max(abs(A_hi))) max(max(abs(A_lo)))]);

% first compute the I_lo and I_hi
I_lo = I; I_hi = I; 

A_hi_temp = A_hi/max(max(A_hi));
A_hi_temp = 1 - A_hi_temp;
I_hi(:,:,3) = I(:,:,3).*A_hi_temp;
I_hi(:,:,2) = I(:,:,2).*A_hi_temp;

A_lo_temp = A_lo/max(max(A_lo));
A_lo_temp = 1 - A_lo_temp;
I_lo(:,:,1) = I(:,:,1).*A_lo_temp;
I_lo(:,:,2) = I(:,:,2).*A_lo_temp;

% now compute the full I
A_hi = A_hi/norm_max;
A_lo = A_lo/norm_max;

A_lo = 1-A_lo;
A_hi = 1-A_hi;

I(:,:,1) = I(:,:,1).*A_lo;
I(:,:,2) = I(:,:,2).*A_lo;
I(:,:,3) = I(:,:,3).*A_hi;
I(:,:,2) = I(:,:,2).*A_hi;







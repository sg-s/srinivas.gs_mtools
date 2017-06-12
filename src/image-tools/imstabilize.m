% stabilizes an grayscale image sequence I
% where the first two dimensions are space and the third dimension is time
% usage:
% stabilized_image = imstabilize(I);

function [sI] = imstabilize(I)

I = single(I);
sI = I;


hVPlayer = vision.VideoPlayer; % Create video viewer

% Process all frames in the video
movMean = I(:,:,1);
movMean = movMean - min(min(movMean)); movMean = movMean/max(max(movMean));
imgB = movMean;
imgBp = imgB;
correctedMean = imgBp;
ii = 2;
Hcumulative = eye(3);

for ii = 2:size(I,3)
    % Read in new frame
    imgA = imgB; 
    imgAp = imgBp; 
    imgB = I(:,:,ii); imgB = imgB - min(min(imgB)); imgB = imgB/max(max(imgB));
    movMean = movMean + imgB;

    % Estimate transform from frame A to frame B, and fit as an s-R-t
    H = cvexEstStabilizationTform(imadjust(imgA),imadjust(imgB));
    HsRt = cvexTformToSRT(H);
    Hcumulative = HsRt * Hcumulative;
    imgBp = imwarp(imgB,affine2d(Hcumulative),'OutputView',imref2d(size(imgB)));

    sI(:,:,ii) = imgBp;

    % display both stabilized and unstabilized movies together
    dispI = zeros(size(I,1),2*size(I,1),3,'uint8');
    dispI(:,1:size(I,1),:) = imfuse(imgAp,imgBp,'ColorChannels','red-cyan');
	dispI(:,size(I,1)+1:end,:) = imfuse(imgA,imgB,'ColorChannels','red-cyan');

    % Display as color composite with last corrected frame
    step(hVPlayer,dispI)
    correctedMean = correctedMean + imgBp;

end
correctedMean = correctedMean/(ii-2);
movMean = movMean/(ii-2);

% Here you call the release method on the objects to close any open files
% and release memory.
release(hVPlayer);




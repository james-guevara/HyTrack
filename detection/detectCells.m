function cellDetections = detectCells(I, radius)
% detectNuclei detect nuclei from a fluorescent image
%
% SYNOPSIS detectCells(I, radius)
%
% INPUT
%   I - input image
%
%   radius - radius of the nuclei (in pixels)
% OUTPUT
%   cellDetections - [amplitude x y]
%
%

ip =inputParser;
ip.addRequired('I', @isnumeric)
ip.addRequired('radius', @isposint)
ip.addParameter('sigma', 2, @isscalar);
ip.addParameter('p', .01, @isscalar);
ip.addParameter('useDblLog', true, @isscalar);
ip.parse(I, radius);

% Round radius value to next odd value
radius = 2 * floor(ip.Results.radius/2) +1;

[rowsOrg, colsOrg]=size(I);
dPix = 0;
Icrop =I((1+dPix):(rowsOrg-dPix),(1+dPix):(colsOrg-dPix));
I = Icrop;
%**********************************************************************
% 2. Step: Preprocessing: gradient subtraction, doublelog, G-filter   *
%**********************************************************************

% calculate the gradient information in the image:
gradmag = zeros(size(I));

% Normalize the gradient according to the magnitude of the image intensity:
gradmag = gradmag*max(I(:))/max(vertcat(eps,gradmag(:)));

minI=min(I(:));
maxI=max(I(:));

numPix=numel(I);
binEdges=linspace(floor(minI),ceil(maxI),1000);
n = histc(I(:),binEdges);

ncum=cumsum(n);
binID=find(ncum>ip.Results.p*numPix,1,'first');
bgVal=binEdges(binID);

% substract the gradient from the original image to enhance the edges:
ImGrad=I-gradmag;
ImGrad(ImGrad<bgVal)=bgVal;  % bring all neg. or very small values back to bg-level!


% Equalize neighboring maxima by applying a double-log:
bgValScaled=log(log(bgVal));
if ip.Results.useDblLog && isreal(bgValScaled) && bgValScaled>-Inf
    ImGrad=log(log(ImGrad));
else
    display('Couldnt use log(log(.)) to suppress large next to small maxima!');
end

% filter with a gaussian:
Iflt = filterGauss2D(ImGrad, radius);

%**********************************************************************
% 4. Step: Find the local maxima in the preprocessed image            *
%**********************************************************************

% Find the local maxima:
se   = strel('disk', radius);
Imax=locmax2d(Iflt,getnhood(se),1);

% cut off the maxima in the noise:

try
    % This only works for significant amount of Bg, but is then more reliable than the above method!
    level1 = thresholdFluorescenceImage(Imax(Imax(:)>0), doPlot, 1);
catch
    % This shouldn't be used anymore. Instead, one should use the
    % algorithm above!
    display('!!!switched to cutFirstHistMode!!!')
    [~, level1]=cutFirstHistMode(Imax(Imax(:)>0),0);
end
if (isempty(level1))
    Imax = 0;
end
Imax(Imax(:)>0)=1;

% Show the first set of maxima:
se   = strel('disk', round(radius/4));
ImaxDil = imdilate(Imax,se);

%**********************************************************************
% 4. Step: Find a second set of max using a simple Gauss-filter       *
%**********************************************************************

% Simply filter the original image with a Gaussian, some of these might
% have been cut-off if they are small in size and have a huge gradient!
IfltSimple = filterGauss2D(Icrop, radius);
ImaxSimple=locmax2d(IfltSimple,getnhood(se),1);
[~, level2]=cutFirstHistMode(ImaxSimple(ImaxSimple(:)>0),0);
ImaxSimple(ImaxSimple(:)<level2)=0;
ImaxSimple(ImaxSimple(:)>0)=1;

se   = strel('disk', radius);
ImaxComb = imdilate(Imax+ImaxSimple,se);
labelsMaxROI = bwlabel(ImaxComb>0, 4);
% label each Imax. Find doubled values. These maxima have been falsely
% merged by regiongrowing:
maxID=find(Imax(:)==1);
maxLabels=labelsMaxROI(maxID);

n = histc(maxLabels,1:max(maxLabels));
dblLables=find(n>1);
falseROI=ismember(labelsMaxROI,dblLables);
% Clean Labels:
labelsMaxROI(falseROI)=0;

% Set the max that we want to keep into the Labels matrix:
dblLabelInd=ismember(maxLabels,dblLables);
maxIdKeep=maxID(dblLabelInd);

maxL=max(labelsMaxROI(:));
% first fill up the Labels and then append at the end:
newLabelList=[dblLables',(maxL+1):(maxL+length(maxIdKeep)-length(dblLables))];
for k=1:length(maxIdKeep)
    labelsMaxROI(maxIdKeep(k))=newLabelList(k);
end


regions = regionprops(labelsMaxROI, 'centroid');

nucPos=round(vertcat((regions(:).Centroid)));
ImaxCombClean=zeros(size(Icrop));
ImaxCombClean(sub2ind(size(Icrop),nucPos(:,2),nucPos(:,1)))=1;



Idspl=Icrop;
se   = strel('disk', round(radius/4));
ImaxCombCleanDil = imdilate(ImaxCombClean,se);


%% Prepare the output
linId=sub2ind(size(I),nucPos(:,2),nucPos(:,1));
pos=nucPos;
cellDetections(:,1) = pos(:,1);
cellDetections(:,2) = pos(:,2);
cellDetections(:,3) = I(linId);


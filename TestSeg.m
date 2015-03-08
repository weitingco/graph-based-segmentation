%% Initialize
% input image
rgb = imread('./0_testImages/lena512color.tiff');

[m,n] = size(rgb(:,:,1));

subplot(1,2,1);
imshow(rgb);

%gaussian filter
sigma = 0.8;
hsize = ceil(4*sigma);

% Tianchen start, 2015/2/25
gaussian = fspecial('gaussian',[hsize,hsize], sigma);
blurred=imfilter(double(rgb), gaussian);
% Tianchen end

%% diff = sqrt(RR+BB+GG)
%build graph
% weight == sqrt(RR+GG+BB)
[edgeWeights, vertices] = buildGraph8N3C(blurred(:,:,1),blurred(:,:,2),blurred(:,:,3),1,1,1);

%convert the array index 0 to 1
vertices = vertices + 1;

edgeWeights = abs(edgeWeights);

[sortedW,sortedIdx] = sort(edgeWeights);

%build segmentation

%convert the array index from 1 to 0
vertices = vertices - 1;
sortedIdx = sortedIdx - 1;

segMap = SegGraph(edgeWeights, vertices(1,:), vertices(2,:),...
                                                m,n,length(edgeWeights), 200);
[mySegR, mySegG, mySegB, numSeg] = Seg2Color(segMap, m,n);
SegImg = zeros(m,n,3);
SegImg(:,:,1) = reshape(mySegB,[m,n]);
SegImg(:,:,2) = reshape(mySegR,[m,n]);
SegImg(:,:,3) = reshape(mySegG,[m,n]);

% Tianchen start, 2015/2/25
subplot(1,2,2);
imshow(SegImg/255);
set(gcf,'OuterPosition',[100,100,1200,600]);
% Tianchen end

%% seg == Intersect(Rseg,Gseg,Bseg)
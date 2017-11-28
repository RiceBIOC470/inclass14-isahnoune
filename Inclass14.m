%Inclass 14
%GB comments
1 100 Could run a loop on the threshold parameters and define the “best” mask
2a 100 
2b 100 


%Work with the image stemcells_dapi.tif in this folder

% (1) Make a binary mask by thresholding as best you can


file1 = 'stemcells_dapi.tif';
reader1 = bfGetReader(file1);
iplane = reader1.getIndex(1-1, 1-1, 1-1)+1;
img11 = bfGetPlane(reader1, iplane);


imshow(img11, [])
binarymask = img11 > 350;
imshow(binarymask,[])

% (2) Try to separate touching objects using watershed. Use two different
% ways to define the basins. 

%(A) With erosion of the mask 

CC = bwconncomp(binarymask);
stats = regionprops(CC, 'Area');
area = (stats.Area);
s = round(1.2*sqrt(mean(area))/pi);
eroded = imerode(binarymask, strel('disk',s));
outside = ~imdilate(binarymask, strel('disk',1));
basin = imcomplement(bwdist(outside));
basin = imimposemin(basin,eroded|outside);
L = watershed(basin);
imshow(L, [])

%(B) with a distance transform. 

D = bwdist(~binarymask);
D = -D;
D(~binarymask) = -Inf;
L2 = watershed(D);
imshow(L2,[])

%Which works better in this case?

%In this case, using the watershed method with erosion of the mask shows a more uniform and
%filled image. The distance transform yields breaks throughout the cells,
%with dark lines separating whole cells.

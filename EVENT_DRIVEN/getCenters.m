function [centers, pixels_all] = getCenters(mask_binary)
[B,conNum] = connectDomain(mask_binary);
% rgb = ind2rgb(gray2ind(mat2gray(B),255),turbo(255));
centers = zeros(conNum,4);
for i = 1:conNum % 遍历每个连通域求解    
    centers(i,1) = i;                                                      % √√ 连通域索引
    tempImg = selecRegion(B,i);
    STATS = regionprops(tempImg,'Centroid');
    center = STATS.Centroid;                                               % √√ 质心坐标（图像坐标系）
    centers(i,2)=center(1);
    centers(i,3)=center(2);
    area = sum(tempImg(:)==1);                                             % √√ 区域面积（除去空洞后）
    centers(i,4)=area;
end

pixels_all = [];
for i = 1:conNum % 遍历每个连通域求解    
    [x, y] = find(B==i);
    temp = [repmat(i, length(x), 1) x y];
    pixels_all = [pixels_all; temp];
end


    


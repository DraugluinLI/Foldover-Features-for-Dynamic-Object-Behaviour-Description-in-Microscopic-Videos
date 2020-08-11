close all;
clear;
clc;
%%  Feature extraction


frames=load('2.mat');
features=struct('Cent',struct,'Area',struct,'Perimeter',struct,'Len_Wid',struct);

for i=36:67

    img=frames.multiobject(i).bwsege;
    I=regionprops(img,'Centroid');
    features(i).Cent=regionprops(img,'Centroid');
    
    features(i).Area=regionprops(img,'Area');
    
    features(i).Perimeter=regionprops(img,'Perimeter');
    
    features(i).Len_Wid=regionprops(img,'Boundingbox');
    
end
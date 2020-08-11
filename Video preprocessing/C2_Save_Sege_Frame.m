clc;
clear; 
close all;
%% Save the Sege framework


videoframes=load('1.mat');
% [a,b]=size(videoframes.s);
% cents=struct('frame',struct('cent',zeros(1,2)));
multiobject = struct('bwsege',zeros(528,698));
% multiobject = struct('bwrect',zeros(528,698,3,'uint8'),...
%     'colormap',[]);
% k=1;
for i=236:238
    tempimg=videoframes.s(i).cdata;
    figure;
    imshow(tempimg)
    
    img1=tempimg;
    % figure(1),imshow(img1)

    img1=rgb2gray(img1);
    
    
    level = graythresh(img1);  
    img2=im2bw(img1,level);
    %figure(1),imshow(img2);
    
    img3=1-img2;
    %figure(2),imshow(img3)


    se=[0 1 0;1 1 1;0 1 0];
    img4=imdilate(img3,se);
    %figure(3),imshow(img4)

    img5=imerode(img4,se);
    %figure(4),imshow(img5)

    img6=imclearborder(img5);
    %figure(5),imshow(img6)

    img7=imfill(img6);
    %figure(6),imshow(img7)

    img8=bwareaopen(img7,45,8);
    figure;
    imshow(img8)
    multiobject(i).bwsege=img8;
    %imwrite(img8,'36֡.png');
        
end

%%Draw Bounding Rectangle%% 

    % figure(8),imshow(img8)
    % % 
%     rect=regionprops(img8,'BoundingBox');
%     [N1,N2]=size(rect);
%     for n3=1:N1
%         a=rect(n3).BoundingBox;
%     
%         x = round(a(2));
%         y = round(a(1));
%         W = round(a(4));
%         H = round(a(3));
%         Line_W = 2; 
% 
%         for i = x:(x+W)
%             for j = y:(y+H)
%                 if i < x + Line_W 
%                 img8(i,j) = 1;
%                 elseif i > x + W - Line_W
%                 img8(i,j) = 1; 
%                 elseif j < y + Line_W
%                 img8(i,j) = 1;    
%                 elseif j > y + H - Line_W
%                 img8(i,j) = 1;    
%                 end
%             end
%         end 
%     end
%     pause(0.033);
%     imshow(img8);
%     img8=double(img8);
%     if sum(sum(img7))>10000&&sum(sum(img7))<20000
%         multiobject(k).bwrect=img8;
%         k=k+1;
%     end


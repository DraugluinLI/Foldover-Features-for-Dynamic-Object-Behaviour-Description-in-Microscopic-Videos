%% The purpose of this folder: to extract and save the shadow of each object in a moving video image
clc;
clear;
close all;


videoframes=load('S_00046_frame.mat');
multiobject = struct('bwsege',zeros(528,698));
for i=128:185
    
    tempimg=videoframes.s(i).cdata;
    %imshow(tempimg)
    
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
%     figure;
%     imshow(img8)
    multiobject(i).bwsege=img8;    
end

features=struct('Cent',struct,'Area',struct,'Perimeter',struct,'Len_Wid',struct);

for i1=128:185

    img=multiobject(i1).bwsege;
    
    features(i1).Cent=regionprops(img,'Centroid');
    
    features(i1).Area=regionprops(img,'Area');
    
    features(i1).Perimeter=regionprops(img,'Perimeter');
    
    features(i1).Len_Wid=regionprops(img,'Boundingbox');
    
end

save('D:\精子显微分析各种数据集\46号视频所有数据集\S_00046_003_features.mat','features');
%3，knn
Match_res=struct('cents',struct('cent1',zeros(1,2),'cent2',zeros(1,2)));
for i2=128:184
    fcents1=features(i2).Cent;
    a=i2+1;
    fcents2=features(a).Cent;
    
    fareas1=features(i2).Area;
    b=i2+1;
    fareas2=features(b).Area;
    

   % [~,a1]=size(fcents1);
   % [~,a2]=size(fcents2);
    
    
    [m1,n1]=size(fcents1);
    [m2,n2]=size(fcents2);


    for j=1:m2
        
        
        x2=fcents2(j).Centroid(1);
        y2=fcents2(j).Centroid(2);
        s=20;
        for k=1:m1
            
            
            x1=fcents1(k).Centroid(1);
            y1=fcents1(k).Centroid(2);
            
            s_new=sqrt((x2-x1)^2+(y2-y1)^2);
            
            if s_new<s && s_new>=0   
              
                s=s_new;
                h2_1=x1;
                w2_1=y1;

            end
            
        
            
        end
        



        
        Match_res(i2).cents(i2).cent2(j,1)=x2;
     	Match_res(i2).cents(i2).cent2(j,2)=y2;
        Match_res(i2).cents(i2).cent1(j,1)=h2_1;
        Match_res(i2).cents(i2).cent1(j,2)=w2_1;
    end
end

x1=0;
y1=0;
x2=0;
y2=0;
for i4=1:29
    general_image_location=zeros(66,2);
    name_flag=0;
    for i3=128:184
        [R,C]=size(Match_res(i3).cents(i3).cent1);
        if i4<R
            if i3==128
                
                x1=Match_res(i3).cents(i3).cent1(i4,1);
                y1=Match_res(i3).cents(i3).cent1(i4,2);
                general_image_location(i3,1)=x1;
                general_image_location(i3,2)=y1;
               
                cents_num=Match_res(i3+1).cents(i3+1).cent1;
                [R_cents,C_cents]=size(cents_num);
                s_distance=25;
                for j=1:R_cents
                   
                    x2_prepare=Match_res(i3+1).cents(i3+1).cent1(j,1);
                    y2_prepare=Match_res(i3+1).cents(i3+1).cent1(j,2);
                    
                    s_true=sqrt(( x2_prepare-x1)^2+( y2_prepare-y1)^2);
                    if s_true<=s_distance
                       s_distance=s_true;
                       x2=x2_prepare;
                       y2=y2_prepare;
                    end
                end
                %==========================================================
                
                [R1,C1]=size(features(i3).Cent);
                for i5=1:R1
                    Centroid_xy=features(i3).Cent(i5,1);
                    Centroid_xy=Centroid_xy.Centroid;
                    compare_x=Centroid_xy(1,1);
                    compare_y=Centroid_xy(1,2);
                    if x1==compare_x && y1==compare_y
                       compare_area_struct1=features(i3).Area;
                       compare_area1=compare_area_struct1(i5).Area;
                       num_Area1=i5;
                    end
                end
                operation_img=multiobject(i3).bwsege;
                
                L = bwlabel(operation_img);
                stats = regionprops(L);
                Ar = cat(1, stats.Area);
                ind = find(Ar ==compare_area1);
                 %========================================================
                
                [R_ind1,C_ind1]=size(ind);
                if R_ind1>1
                   ind=num_Area1;
                end
                %========================================================
                operation_img(find(L~=ind))=0;
             
                if i4<10%
                   imwrite(operation_img,strcat('D:\精子显微分析各种数据集\46号视频所有数据集\s_0046_003\s_0046_003(fake_groundtruth)\00',num2str(i4),'\00',num2str(i4),'_0',num2str(i3),'.png'));
                else
                   imwrite(operation_img,strcat('D:\精子显微分析各种数据集\46号视频所有数据集\s_0046_003\s_0046_003(fake_groundtruth)\0',num2str(i4),'\0',num2str(i4),'_0',num2str(i3),'.png'));
                end
            else 
                
                x11=x2;
                y11=y2;
                general_image_location(i3,1)=x11;
                general_image_location(i3,2)=y11;
               
                if i3+1<=184 && ~isempty(ind)
                   
                    cents_num=Match_res(i3+1).cents(i3+1).cent1;
                    [R_cents,C_cents]=size(cents_num);
                    s_distance=25;
                    s_min=500;
                    for j=1:R_cents
                        
                        x2_prepare=Match_res(i3+1).cents(i3+1).cent1(j,1);
                        y2_prepare=Match_res(i3+1).cents(i3+1).cent1(j,2);
                       
                        s_true=sqrt(( x2_prepare-x11)^2+( y2_prepare-y11)^2);
                        
                        if s_true<s_min
                           s_min=s_true;
                        end
                        if s_true<=s_distance
                           s_distance=s_true;
                           x2=x2_prepare;
                           y2=y2_prepare;
                        end
                    end
                    
                    [R2,C2]=size(features(i3).Cent);
                    for i7=1:R2
                        Centroid_xy=features(i3).Cent(i7,1);
                        Centroid_xy=Centroid_xy.Centroid;
                        compare_x=Centroid_xy(1,1);
                        compare_y=Centroid_xy(1,2);
                        if x11==compare_x && y11==compare_y
                           compare_area_struct2=features(i3).Area;
                           compare_area2=compare_area_struct2(i7).Area;
                           num_Area2=i7;
                        end
                    end
                    operation_img=multiobject(i3).bwsege;
                    
                    L = bwlabel(operation_img);
                    stats = regionprops(L);
                    Ar = cat(1, stats.Area);
                    ind = find(Ar ==compare_area2);
                    
                    [R_ind,C_ind]=size(ind);
                    if R_ind>1
                       ind=num_Area2;
                    end
                   
%                     figure;
%                     imshow(operation_img);
                  
                    if ~isempty(ind)
                       operation_img(find(L~=ind))=0;
                       
                       if i4<10
                          name=strcat('00',num2str(i4),'_0',num2str(i3),'.png');
                       else
                          name=strcat('0',num2str(i4),'_0',num2str(i3),'.png');
                       end
                       
                       pwd='C:\Program Files\MATLAB\R2018a\bin\20181105-Code-Yilin';
                       filepath=pwd;           
                       if i4<10
                          cd(strcat('D:\精子显微分析各种数据集\46号视频所有数据集\s_0046_003\s_0046_003(fake_groundtruth)\00',num2str(i4)));       
                       else
                          cd(strcat('D:\精子显微分析各种数据集\46号视频所有数据集\s_0046_003\s_0046_003(fake_groundtruth)\0',num2str(i4)));      
                       end
                       if exist( 'name', 'file')==1
                          name_flag=name_flag+1;
                          imwrite(operation_img,strcat('D:\精子显微分析各种数据集\46号视频所有数据集\s_0046_003\s_0046_003(fake_groundtruth)\00',num2str(i4),'\和',name,'重名_',name_flag,'.png')); 
                       end
                       if i4<10%
                          imwrite(operation_img,strcat('D:\精子显微分析各种数据集\46号视频所有数据集\s_0046_003\s_0046_003(fake_groundtruth)\00',num2str(i4),'\00',num2str(i4),'_0',num2str(i3),'.png'));
                       else
                          imwrite(operation_img,strcat('D:\精子显微分析各种数据集\46号视频所有数据集\s_0046_003\s_0046_003(fake_groundtruth)\0',num2str(i4),'\0',num2str(i4),'_0',num2str(i3),'.png'));
                       end
                       
                       cd(filepath);
                        
                    end
                end
            end
        end
    
    end
     
    if i4<10
       save(['D:\精子显微分析各种数据集\46号视频所有数据集\s_0046_003\s_0046_003_location(fake_groundtruth)\00' num2str(i4) '.mat'],'general_image_location');
    else
       save(['D:\精子显微分析各种数据集\46号视频所有数据集\s_0046_003\s_0046_003_location(fake_groundtruth)\0' num2str(i4) '.mat'],'general_image_location');
    end
end


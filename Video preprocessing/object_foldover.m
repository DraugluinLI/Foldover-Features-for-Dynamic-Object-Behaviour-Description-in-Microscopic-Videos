 %% The purpose of this file is to create a foldover
clc;
clear;
close all;

%% Read the file, extract the position of each object's pixel block, matting the original image, add a 3d drawing trajectory and a 3d rotating image in the middle

%Read the necessary files
load('groundtruth_feature.mat');%These two files are used to find the starting and ending coordinates
load('begin_end_framenum_shot1.mat');

%Iterate through all the targets
for i=8:46
    
    SUM=zeros(528,698,'uint64');%For adding pictures
    for i1=36:79%Loop into the frame number folder to lock the specific target
        
        b1=1;
        b2=1;
        
        if i<10
           path_name1=strcat('D:\精子显微分析各种数据集\1号视频所有数据集\s_0001_001(groundtruth)\s_0001_001_00',num2str(i1),'\s_0001_001_00',num2str(i1),'_000',num2str(i),'.png');
           b1=exist(path_name1);%Determine if the image exists
           if b1~=0
              img=imread(path_name1);
%               figure;
%               imshow(img);
           end
        else
            path_name2=strcat('D:\精子显微分析各种数据集\1号视频所有数据集\s_0001_001(groundtruth)\s_0001_001_00',num2str(i1),'\s_0001_001_00',num2str(i1),'_00',num2str(i),'.png');
            b2=exist(path_name2);
            if b2~=0
               img=imread(path_name2);
%                figure;
%               imshow(img);
            end
        end
        
        %If the target doesn't exist, then b1 or B2 is equal to zero and then nothing happens
        if b1~=0 && b2~=0
           img_frame=imread(strcat('D:\精子显微分析各种数据集\1号视频所有数据集\s_0001_001_frame\s_0001_001_0',num2str(i1),'.jpg'));%循环读取每一帧图片
%            figure;
%            imshow(img_frame);
           img=rgb2gray(img);%Turn the image to grayscale, in fact, the purpose is to change the image from three-dimensional to one-dimensional
           
           
 %=====================================================================================================================          
           %The following operation is aimed at turning each frame of the original image into grayscale
           img_frame=rgb2gray(img_frame);
           img_frame=uint64(img_frame);
           for i2=1:528
               for i3=1:698
                   if img(i2,i3)~=255
                      img_frame(i2,i3)=0;
%                       figure;
%                       imshow(img_frame);
                   end
               end
           end 
 %=======================================================================================================================         
           %imshow(img_frame);
           
%            %If the black and white image is black, paint the original image black, otherwise keep it
%            for i2=1:528
%                for i3=1:698
%                    if img(i2,i3)~=255
%                       img_frame(i2,i3,1)=0;
%                       img_frame(i2,i3,2)=0;
%                       img_frame(i2,i3,3)=0;
%                    end
%                end
%            end
%         figure;
%         img_frame_done=imshow(img_frame);
          SUM=SUM+img_frame; 
        end
    end
    figure;
    imshow(SUM);
        
    %Find the coordinates of the starting and ending points in the foldover
    %Gets the number of frames where the starting and ending points are
    bg=location.object(i).begin;
    ed=location.object(i).End;
    %Find the coordinates according to the number of frames
    bg_loc=features1(bg).Cent(i).Centroid.Centroid;
    if i==3
       ed_loc=features1(ed).Cent(i-1).Centroid.Centroid;
    else
       ed_loc=features1(ed).Cent(i).Centroid.Centroid;
    end
    x1=uint16(bg_loc(1,1));
    y1=uint16(bg_loc(1,2));
    x2=uint16(ed_loc(1,1));
    y2=uint16(ed_loc(1,2));
    %Calculate the distance between the start and end points to the left and the first non-zero row and column above
    %Find the first column on the left that is not zero
    for i4=1:698
        s_left=sum(SUM(:,i4));
        if s_left~=0
            left_c=i4;
            break;
        end
    end
    %Find the first column of the lower side that is not zero
    for i5=1:528
        s_down=sum(SUM(i5,:));
        if s_down~=0
            down_r=i5;
            break;
        end
    end
    %Calculate the leftmost and downmost distance between the start and end points
%     distance_x1=abs(x1-left_c);
%     distance_x2=abs(x2-left_c);
%     distance_y1=abs(y1-down_r);
%     distance_y2=abs(y2-down_r);
    if x1>left_c
        distance_x1=x1-left_c;
    else
         distance_x1=left_c-x1;
    end
    if x2>left_c
        distance_x2=x2-left_c;
    else
         distance_x2=left_c-x2;
    end
    if y1>down_r
        distance_y1=y1-down_r;
    else
         distance_y1=down_r-y1;
    end
    if y2>down_r
        distance_y2=y2-down_r;
    else
         distance_y2=down_r-y2;
    end%You'll find the starting and ending points in the new diagram based on this distance
    


    %====================================================================================
    %The purpose of this plate is to cut off the excess part of the newly obtained shadow matrix
    new_SUM_r=[];%设置空矩阵
    flag1=0;%Set the counter to ensure that the extracted rows are placed in the new matrix from the first row of the new matrix
    for j=1:528%切行
        %If all of the rows are 0 let's get rid of that row
        s=sum(SUM(j,:));
        if s~=0
            flag1=flag1+1;
            new_SUM_r(flag1,:)=SUM(j,:);
        end
    end
    
    
    new_SUM=[];
    flag2=0;%Set the counter to ensure that the extracted columns are placed in the new matrix from the first column of the new matrix
    for j1=1:698
        s=sum(new_SUM_r(:,j1));
        if s~=0
            flag2=flag2+1;
            new_SUM(:,flag2)=new_SUM_r(:,j1);
        end
    end
    %====================================================================================
    
    %Method of rotation Angle
    %In order to find the long axis and the short axis accurately, binarization is needed
    bw_sum=im2bw(new_SUM);
    STATS = regionprops(bw_sum,'MajorAxisLength' ,'MinorAxisLength','Orientation');
    angle=STATS.Orientation;
    %====================================================================================
    %The purpose of this plate is matrix magnification, first magnification and then rotation
%     [r_new_SUM,c_new_SUM]=size(new_SUM);
%     r_new_SUM=5*r_new_SUM;
%     c_new_SUM=5*c_new_SUM;
%     bigger_new_SUM=imresize(new_SUM,[r_new_SUM,c_new_SUM]);
%     figure;
%     imshow(bigger_new_SUM);
    %====================================================================================
    
    %========================================================%
   
    if isnan(angle)
        angle=0;
    end
    if angle<0
       ori=imrotate(new_SUM,-angle);%The original graph rotates, and the minus sign here is equivalent to rounding off the negative Numbers, so that we can rotate counterclockwise
    else
       ori=imrotate(new_SUM,-angle); %The minus sign here is just to rotate clockwise
    end
    %Restore the size of the rotated graph
%     smallr_new_SUM=r_new_SUM/5;
%     smallc_new_SUM=c_new_SUM/5;
%     smaller_new_SUM=imresize(I1,[smallr_new_SUM,smallc_new_SUM]);
%     
%     figure
%     smaller_new_SUM_3D=bar3(smaller_new_SUM);
%     title(strcat(num2str(i),'号精子旋转再还原尺寸后的叠影三维图'));
%     
%     figure
%     I1_3D=bar3(I1);
%     title(strcat(num2str(i),'号精子旋转放大叠影三维图'));
    %====================================================================================
    %This plate is used to draw three-dimensional pictures
    figure
    new_SUM_3D=bar3(new_SUM);
    title(strcat(num2str(i),'号精子原始叠影三维图'));
    
    figure
    smaller_new_SUM_3D=bar3(ori);
    %title(strcat(num2str(i),'号精子旋转原始尺寸的叠影三维图'));
    
    
    
    aaaaa=0;
    
    
    %====================================================================================
    
    %Save the foldover
    imwrite(ori,strcat('D:\精子显微分析各种数据集\s_0001_001_object_foleover_cutting\使用长轴短轴进行的旋转\',num2str(i),'.png'));
    %Save the original size folding mat file
    %pathname=strcat('D:\\精子显微分析各种数据集\\s_0001_001_object_foleover_mat\\',num2str(i),'.mat');
    if i<10
       save(['D:\精子显微分析各种数据集\s_0001_001_object_foleover_未填充为224的mat文件\00' num2str(i) '.mat'],'ori');
    else
       save(['D:\精子显微分析各种数据集\s_0001_001_object_foleover_未填充为224的mat文件\0' num2str(i) '.mat'],'ori');
    end
    
    
end
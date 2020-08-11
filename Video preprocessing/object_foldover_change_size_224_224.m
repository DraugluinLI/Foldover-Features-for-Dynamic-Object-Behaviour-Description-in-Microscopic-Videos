 %% The purpose of this file is to change the size of the rotated shadow map to 224*224 by adding zeros around it
clc;
clear;
close all;

for i=1:28
    %img=imread(strcat('D:\精子显微分析各种数据集\s_0001_001_object_foleover_cutting\',num2str(i),'.png'));%读图
    if i<10
       load(strcat('D:\精子显微分析各种数据集\46号视频所有数据集\s_0046_003\s_0046_003_object_foleover_未填充为224的mat文件\00',num2str(i),'.mat'));%读取mat文件，因为255的限制，只能保存mat文件
    else
       load(strcat('D:\精子显微分析各种数据集\46号视频所有数据集\s_0046_003\s_0046_003_object_foleover_未填充为224的mat文件\0',num2str(i),'.mat'));
    end
    %img=new_SUM;
    img=ori;
    [r_ori,c_ori]=size(img);
    r_diff=224-r_ori;
    c_diff=224-c_ori;
    
    %We're going to fill the row with zeros
    xx = mod(r_diff,2);
    if xx == 1
       % odd number
       %The top half is zeroed out
       r_paste1=floor(r_diff/2);
       c_paste1=c_ori;
       A=zeros(r_paste1,c_paste1);
       img=[A;img];
       
       %The bottom half is zero
       r_paste2=r_paste1+1;
       c_paste2=c_ori;
       B=zeros(r_paste2,c_paste2);
       img=[img;B];
    else
       %even number
       %The top half is zeroed out
       r_paste1=r_diff/2;
       c_paste1=c_ori;
       A=zeros(r_paste1,c_paste1);
       img=[A;img];
       
       %The bottom half is zero
       r_paste2=r_paste1;
       c_paste2=c_ori;
       B=zeros(r_paste2,c_paste2);
       img=[img;B];
    end
    
    %Zero padding on the column
    yy = mod(c_diff,2);
    [r_new,c_new]=size(img);
    if yy==1
       
       %The left half is zeroed out
       r_paste3=r_new;
       c_paste3=floor(c_diff/2);
       C=zeros(r_paste3,c_paste3);
       img=[C,img];
       
       %The right half of the zero complement operation
       r_paste4=r_new;
       c_paste4=c_paste3+1;
       D=zeros(r_paste4,c_paste4);
       img=[img,D];
    else
       
       %The left half is zeroed out
       r_paste3=r_new;
       c_paste3=c_diff/2;
       C=zeros(r_paste3,c_paste3);
       img=[C,img];
       
       %he right half of the zero complement operation
       r_paste4=r_new;
       c_paste4=c_paste3;
       D=zeros(r_paste4,c_paste4);
       img=[img,D];
    end
    
    %If the size is 224*224, save
    [r,c]=size(img);
    if r==224&&c==224
       imwrite(img,strcat('D:\精子显微分析各种数据集\46号视频所有数据集\s_0046_003\s_0046_003_object_foleover_224_224\pic\',num2str(i),'.png'));
       if i<10
          save(['D:\精子显微分析各种数据集\46号视频所有数据集\s_0046_003\s_0046_003_object_foleover_224_224\00' num2str(i) '.mat'],'img');
       else
          save(['D:\精子显微分析各种数据集\46号视频所有数据集\s_0046_003\s_0046_003_object_foleover_224_224\0' num2str(i) '.mat'],'img');
       end
    end
end
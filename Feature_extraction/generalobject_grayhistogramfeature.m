%% The purpose of this file is to extract the luminance characteristics of general objects
clc;
clear;
close all;


video_number=46;
video_number=num2str(video_number);


fileFolder=fullfile(strcat('D:\精子显微分析各种数据集\筛选目标\location_target\0',video_number));
dirOutput=dir(fullfile(fileFolder,'.'));
fileNames={dirOutput.name}';
num=size(fileNames);
num_file=num(1,1)-2;

for i1=1:num_file
    sub_file_name=fileNames{i1+2,1};
    
    sub_fileFolder=fullfile(strcat('D:\精子显微分析各种数据集\筛选目标\location_target\0',video_number,'\',sub_file_name));
    sub_dirOutput=dir(fullfile(sub_fileFolder,'.'));
    sub_fileNames={sub_dirOutput.name}';
    num_sub_fileNames1=size(sub_fileNames);
    num_sub_fileNames=num_sub_fileNames1(1,1)-2;
    for j1=1:num_sub_fileNames
        object_name=sub_fileNames{j1+2,1};
        
        ob_imageFolder=fullfile(strcat('D:\精子显微分析各种数据集\筛选目标\location_target\0',video_number,'\',sub_file_name,'\',object_name));
        ob_imageOutput=dir(fullfile(ob_imageFolder,'.'));
        ob_imageNames={ob_imageOutput.name}';
        
        
        image_num1=size(ob_imageNames);
        image_num=image_num1(1,1)-2;
        
        for h1=1:image_num
            image_name=ob_imageNames{h1+2,1};
            
            Image=imread(strcat('D:\精子显微分析各种数据集\筛选目标\location_target\0',video_number,'\',sub_file_name,'\',object_name,'\',image_name));
           
            
            %-------------------------------------------------------------------------------------------------------
            
            Image=rgb2gray(Image);
            [count1,x1] = imhist(Image);
            
            %-------------------------------------------------------------------------------------------------------
            
           
           
            judge=exist(strcat('D:\精子显微分析各种数据集\筛选目标\GRAY_feature\0',video_number),'dir');
            if judge==0
                mkdir(strcat('D:\精子显微分析各种数据集\筛选目标\GRAY_feature\0',video_number));
            end
            
           
            judge_object=exist(strcat('D:\精子显微分析各种数据集\筛选目标\GRAY_feature\0',video_number,'\',sub_file_name),'dir');
            if judge_object==0
                mkdir(strcat('D:\精子显微分析各种数据集\筛选目标\GRAY_feature\0',video_number,'\',sub_file_name));
            end
            
            
            judge_object1=exist(strcat('D:\精子显微分析各种数据集\筛选目标\GRAY_feature\0',video_number,'\',sub_file_name,'\',object_name),'dir');
            if judge_object1==0
                mkdir(strcat('D:\精子显微分析各种数据集\筛选目标\GRAY_feature\0',video_number,'\',sub_file_name,'\',object_name));
            end
            
            
            image_real_name1=strsplit(image_name,'.');
            image_real_name=image_real_name1{1,1};
            save(['D:\精子显微分析各种数据集\筛选目标\GRAY_feature\0' video_number '\' sub_file_name '\' object_name '\' image_real_name '.mat'],'count1');
            
        end
    end
end



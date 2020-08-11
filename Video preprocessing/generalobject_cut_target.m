%% Purpose of this file: To intercept the target object in general video according to the result of image segmentation
clc;
clear; 
close all;

video_number=4;
video_number=num2str(video_number);


fileFolder=fullfile(strcat('D:\精子显微分析各种数据集\筛选目标\000',video_number));
dirOutput=dir(fullfile(fileFolder,'.'));
fileNames={dirOutput.name}';
num=size(fileNames);
num_file=num(1,1)-2;


for i=1:num_file
    sub_file_name=fileNames{i+2,1};
    
    sub_fileFolder=fullfile(strcat('D:\精子显微分析各种数据集\筛选目标\000',video_number,'\',sub_file_name,'\',sub_file_name,'_object_foleover_224_224'));
    sub_dirOutput=dir(fullfile(sub_fileFolder,'*.mat'));
    sub_fileNames={sub_dirOutput.name}';
    
    [num_mat,column]=size(sub_fileNames);
    for j=1:num_mat
        mat_name= sub_fileNames{j,1};
        mat_name1=strsplit(mat_name,'.');
        mat_name_real=mat_name1{1,1};
        
        
        mat_fileFolder=fullfile(strcat('D:\精子显微分析各种数据集\',video_number,'号视频所有数据集\',sub_file_name,'\',sub_file_name,'(fake_groundtruth)\',mat_name_real));
        mat_dirOutput=dir(fullfile(mat_fileFolder,'*.png'));
        mat_fileNames={mat_dirOutput.name}';
        
        
        [num_object_frames,column]=size(mat_fileNames);
        
        for h=1:num_object_frames
            object_name_frame=mat_fileNames{h,1};
            
            
            object_name_frame_set=strsplit(object_name_frame,'.');
            object_name_frame_set1=strsplit(object_name_frame_set{1,1},'_');
            object_name=object_name_frame_set1{1,1};
            object_frame=object_name_frame_set1{1,2};
            
            
            objcet_path1=strcat('D:\精子显微分析各种数据集\',video_number,'号视频所有数据集\',sub_file_name,'\',sub_file_name,'(fake_groundtruth)\',mat_name_real,'\',object_name_frame_set);
            objcet_path=objcet_path1{1,1};
            object_groundtruth=imread(strcat(objcet_path,'.png'));
            
            
            object_attribute=regionprops(object_groundtruth);
            object_center=object_attribute.Centroid;
            
            
            frame_name=strsplit(object_frame,'0');
            original_image=imread(strcat('D:\精子显微分析各种数据集\',video_number,'号视频所有数据集\s_00',video_number,'_framepic\s_00',video_number,'_',frame_name{1,2},'.jpg'));
            
            
            x=object_center(1,1);
            y=object_center(1,2);
            
           
            x=x-15;
            y=y-15;
            if x<0
               x=0;
            end
            if y<0
               y=0;
            end
            
            
            rect=[x,y,20,20];
            X=imcrop(original_image,rect);
            %figure;
            %subplot(122);
            %imshow(X);
            
         
            judge=exist(strcat('D:\精子显微分析各种数据集\筛选目标\location_target\00',video_number),'dir');
            if judge==0
                mkdir(strcat('D:\精子显微分析各种数据集\筛选目标\location_target\00',video_number));
            end
            
            
            judge_object=exist(strcat('D:\精子显微分析各种数据集\筛选目标\location_target\00',video_number,'\',sub_file_name),'dir');
            if judge_object==0
                mkdir(strcat('D:\精子显微分析各种数据集\筛选目标\location_target\00',video_number,'\',sub_file_name));
            end
            
            
            judge_object1=exist(strcat('D:\精子显微分析各种数据集\筛选目标\location_target\00',video_number,'\',sub_file_name,'\',object_name),'dir');
            if judge_object1==0
                mkdir(strcat('D:\精子显微分析各种数据集\筛选目标\location_target\00',video_number,'\',sub_file_name,'\',object_name));
            end
            
           
            imwrite(X,['D:\精子显微分析各种数据集\筛选目标\location_target\00',video_number,'\',sub_file_name,'\',object_name,'\',object_name,'_',object_frame,'.png']);
        end
    end
end
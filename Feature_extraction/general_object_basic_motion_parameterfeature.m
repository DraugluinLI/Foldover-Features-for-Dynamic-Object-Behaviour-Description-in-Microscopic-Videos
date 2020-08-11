%% The purpose of this file is to extract the basic motion parameter characteristics of a general target
clc;
clear;
close all;



% Get the number of subfolders you have, so you know how many videos you have
fileFolder=fullfile(strcat('D:\精子显微分析各种数据集\筛选目标\location_target\'));
dirOutput=dir(fullfile(fileFolder,'.'));
fileNames={dirOutput.name}';
num=size(fileNames);
num_file=num(1,1)-2;


for i=1:num_file
    % Get the number of folders under the folder, so you know how many shots this video has
    video_number=fileNames{i+2,1};
    
    sub_fileFolder=fullfile(strcat('D:\精子显微分析各种数据集\筛选目标\location_target\',video_number,'\'));
    sub_dirOutput=dir(fullfile(sub_fileFolder,'.'));
    sub_fileNames={sub_dirOutput.name}';
    num_sub_fileNames1=size(sub_fileNames);%计算目标个数
    num_sub_fileNames=num_sub_fileNames1(1,1)-2;
    
    
    for j=1:num_sub_fileNames
        % Get the number of folders under the folder, so that this lens has several targets
        shot_name=sub_fileNames{j+2,1};
       
        ob_imageFolder=fullfile(strcat('D:\精子显微分析各种数据集\筛选目标\location_target\',video_number,'\',shot_name,'\'));
        ob_imageOutput=dir(fullfile(ob_imageFolder,'.'));
        ob_imageNames={ob_imageOutput.name}';
        num_ob_imageNames1=size(ob_imageNames);
        num_ob_imageNames=num_ob_imageNames1(1,1)-2;
        
        motion_parameters_vector=zeros(1,10);
        
        for z=1:num_ob_imageNames
            object_full_name=ob_imageNames{z+2,1};
            
            %====The following actions are used to build the path to extract the target barycenter coordinates=======
            
            A=video_number(2);
            A=str2num(A);
            if A==0
               center_video_number=video_number(3);
            else
               center_video_number=video_number(2:3);
            end
            center_path=strcat('D:\精子显微分析各种数据集\',center_video_number,'号视频所有数据集\',shot_name,'\',shot_name,'_location(fake_groundtruth)\',object_full_name,'.mat');
            %==================================================
            
            center_mat_file=load(center_path);
            judge=isfield(center_mat_file,'general_image_location');

            center_mat=center_mat_file.general_image_location;
            
            center_mat(any(center_mat,2)==0,:)=[];
            num_center_mat=size(center_mat);

            %====Calculate a series of motion parameters=====================================
            motion_time=num_center_mat(1,1);

            
            movement_distance=0;
            for h=1:num_center_mat(1,1)
                if h<num_center_mat(1,1)
                   
                   x_1=center_mat(h,1);
                   y_1=center_mat(h,2);
                   
                   x_2=center_mat(h+1,1);
                   y_2=center_mat(h+1,2);
                   distance_xy=sqrt((x_2-x_1)^2+(y_2-y_1)^2);
                   movement_distance=movement_distance+distance_xy;
                end
            end

            
            X_1=center_mat(1,1);
            Y_1=center_mat(1,2);
            X_2=center_mat(motion_time,1);
            Y_2=center_mat(motion_time,2);
            displacement_XY=sqrt((X_2-X_1)^2+(Y_2-Y_1)^2);

            
            movement_speed=movement_distance/motion_time;

            
            displacement_speed=displacement_XY/motion_time;

            
            
            average_path_x=center_mat(:,1);
            average_path_y=center_mat(:,2);
            average_path_curve=polyfit(average_path_x,average_path_y,3);
            average_path_length1 = polyval(average_path_curve,average_path_x);
            average_path_length=sum(average_path_length1(:));

            
            average_path_speed=average_path_length/motion_time;

            
            linearity=displacement_speed/ movement_speed;

            
            straightness=displacement_speed/average_path_speed;

            
            wobble=average_path_speed/movement_speed;

            
             motion_parameters_vector(1,1)=movement_distance;
             motion_parameters_vector(1,2)=displacement_XY;
             motion_parameters_vector(1,3)=movement_speed;
             motion_parameters_vector(1,4)=displacement_speed;
             motion_parameters_vector(1,5)=average_path_length;
             motion_parameters_vector(1,6)=average_path_speed;
             motion_parameters_vector(1,7)=linearity;
             motion_parameters_vector(1,8)=straightness;
             motion_parameters_vector(1,9)=wobble;
            %===============================================================

            
            lable_set=load(strcat('D:\精子显微分析各种数据集\筛选目标\0',video_number,'\',shot_name,'\',shot_name,'_lable.mat'));
            
            A=object_full_name(2);
            A=str2num(A);
            if A==0
               object_real_number=object_full_name(3);
            else
               object_real_number=object_full_name(2:3); 
            end
            object_real_number=str2num(object_real_number);
            
            motion_parameters_lable=lable_set.lable(object_real_number);
            motion_parameters_vector(1,10)=motion_parameters_lable;

            
            save(['D:\精子显微分析各种数据集\筛选目标\motion_parameters_feature\',shot_name,'_',object_full_name,'.mat'],'motion_parameters_vector');

        end
    end
end

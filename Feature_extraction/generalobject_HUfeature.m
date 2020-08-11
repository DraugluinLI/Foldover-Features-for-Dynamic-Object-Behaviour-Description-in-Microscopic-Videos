%% The purpose of this file is to extract the HU moment characteristics of the general target
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
            %imshow(img);
            
            %-------------------------------------------------------------------------------------------------------
            
            [M,N,O] = size(Image);


            %--------------------------------------------------------------------------
            
            %--------------------------------------------------------------------------
            
            Gray=rgb2gray(Image);
            %--------------------------------------------------------------------------
            
            %-------------------------------------------------------------------------
            Egray = uint8(edge(Gray,'canny'));
            for i = 1:M
                for j = 1:N
                    if Egray(i,j)==0
                        Gray(i,j)=0;
                    end
                end
            end

            %--------------------------------------------------------------------------
            
            %--------------------------------------------------------------------------
           
            for i = 0:255
                h(i+1) = size(find(Gray==i),1);
            end
            p = h/sum(h);
           
            ut = 0;
            for i = 0:255
                ut = i*p(i+1)+ut;
            end
            
            for k = 0:254
                w(k+1) = sum(p(1:k+1));
                u(k+1) = sum((0:k).*p(1:k+1));
            end
            
            deltaB = zeros(1,255);
            for k = 0:254    
                if w(k+1)~=0&&w(k+1)~=1
                    deltaB(k+1) = (ut*w(k+1)-u(k+1))^2/(w(k+1)*(1-w(k+1)));
                end
            end
            [value,thresh] = max(deltaB);
            % deltaB = zeros(1,255);
            % delta1 = zeros(1,255);
            % delta2 = zeros(1,255);
            % deltaW = zeros(1,255);
            % for k = 0:254
            %     if w(k+1)~=0&w(k+1)~=1
            %         deltaB(k+1) = (ut*w(k+1)-u(k+1))^2/(w(k+1)*(1-w(k+1)));
            %         delta1(k+1) = 0;
            %         delta2(k+1) = 0;
            %         for i = 0:k
            %             delta1(k+1) = (i-u(k+1)/w(k+1))^2*p(i+1)+delta1(k+1);
            %         end
            %         for i = k+1:255
            %             delta2(k+1) = (i-(ut-u(k+1))/(1-w(k+1)))^2*p(k+1)+delta2(k+1);
            %         end
            %         deltaW(k+1) = delta1(k+1)+delta2(k+1);
            %     end
            % end
            % for i = 1:255
            %     if deltaB==0
            %         yita=0;
            %     else
            %         yita(i) = 1/(1+deltaW(i)./deltaB(i));
            %     end
            % end
            
            % [value,thresh] = max(yita);

            
            for i = 1:M
                for j = 1:N
                    if Gray(i,j)>=thresh
                        BW(i,j) = 1;
                    else
                        BW(i,j) = 0;
                    end
                end
            end

            %--------------------------------------------------------------------------
            
            %--------------------------------------------------------------------------
            m00 = sum(sum(BW)); 
            m01 = 0;               
            m10 = 0;              
            for i = 1:M
                for j = 1:N
                    m01 = BW(i,j)*j+m01;
                    m10 = BW(i,j)*i+m10;
                end
            end
            I = (m10)/(m00);
            J = m01/m00;

            %--------------------------------------------------------------------------
            
            %--------------------------------------------------------------------------
            u11 = 0;
            u20 = 0; u02 = 0;
            u30 = 0; u03 = 0;
            u12 = 0; u21 = 0;
            for i = 1:M
                for j = 1:N
                    u20 = BW(i,j)*(i-I)^2+u20;
                    u02 = BW(i,j)*(j-J)^2+u02;
                    u11 = BW(i,j)*(i-I)*(j-J)+u11;
                    u30 = BW(i,j)*(i-I)^3+u30;
                    u03 = BW(i,j)*(j-J)^3+u03;
                    u12 = BW(i,j)*(i-I)*(j-J)^2+u12;
                    u21 = BW(i,j)*(i-I)^2*(j-J)+u21;
                end
            end
            u20 = u20/m00^2;
            u02 = u02/m00^2;
            u11 = u11/m00^2;
            u30 = u30/m00^(5/2);
            u03 = u03/m00^(5/2);
            u12 = u12/m00^(5/2);
            u21 = u21/m00^(5/2);
            %--------------------------------------------------------------------------
            %7个Hu不变矩：
            %--------------------------------------------------------------------------
            n(1) = u20+u02;
            n(2) = (u20-u02)^2+4*u11^2;
            n(3) = (u30-3*u12)^2+(u03-3*u21)^2;
            n(4) = (u30+u12)^2+(u03+u21)^2;
            n(5) = (u30-3*u12)*(u30+u12)*((u30+u12)^2-3*(u03-3*u21)^2)+(u03-3*u21)*(u03+u21)*((u03+u21)^2-3*(u30+u12)^2);
            n(6) = (u20-u02)*((u30+u12)^2-(u03+u21)^2)+4*u11*(u30+u12)*(u03+u21);
            n(7) = (3*u21-u03)*(u30+u12)*((u30+u12)^2-3*(u03-3*u21)^2)+(u30-3*u21)*(u03+u21)*((u03+u21)^2-3*(u30+u12)^2);
            % %--------------------------------------------------------------------------
            
            % %--------------------------------------------------------------------------
            % en = mean(n);
            % delta = sqrt(cov(n));
            % n = abs(n-en)/(3*delta);
            
            %-------------------------------------------------------------------------------------------------------
            
           
            
            judge=exist(strcat('D:\精子显微分析各种数据集\筛选目标\HU_feature\0',video_number),'dir');
            if judge==0
                mkdir(strcat('D:\精子显微分析各种数据集\筛选目标\HU_feature\0',video_number));
            end
            
            
            judge_object=exist(strcat('D:\精子显微分析各种数据集\筛选目标\HU_feature\0',video_number,'\',sub_file_name),'dir');
            if judge_object==0
                mkdir(strcat('D:\精子显微分析各种数据集\筛选目标\HU_feature\0',video_number,'\',sub_file_name));
            end
            
            
            judge_object1=exist(strcat('D:\精子显微分析各种数据集\筛选目标\HU_feature\0',video_number,'\',sub_file_name,'\',object_name),'dir');
            if judge_object1==0
                mkdir(strcat('D:\精子显微分析各种数据集\筛选目标\HU_feature\0',video_number,'\',sub_file_name,'\',object_name));
            end
            
            
            image_real_name1=strsplit(image_name,'.');
            image_real_name=image_real_name1{1,1};
            save(['D:\精子显微分析各种数据集\筛选目标\HU_feature\0' video_number '\' sub_file_name '\' object_name '\' image_real_name '.mat'],'n');
            
        end
    end
end

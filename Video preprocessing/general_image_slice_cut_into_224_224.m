%% The purpose of this file is to add the general xy axis direction and then cut 224*224 sections, to do the operation of cutting 224*224
%%doing both the x and y axes
clc;
clear;
close all;
flag1=0;
flag2=0;

folder1='004';
folder2='002';
i_1=2;
i_2=2;

% for i=i_1:i_2
%     
%     path1=strcat('D:\精子显微分析各种数据集\筛选目标\',folder1,'\s_0',folder1,'_',folder2,'\s_0',folder1,'_',folder2,'_object_foleover_3D_slice\');
%     cd(strcat(path1,'x_addfirst'));
%     a=strcat(num2str(i),'.mat');
%     b=exist(a);
%     if b~=0
%        flag1=1;
%     end
%     if flag1==1
%         load(strcat(path1,'x_addfirst\',num2str(i),'.mat'));
%         [R,C]=size(sum);
%         cut_num=R/224;
%         
%         for i1=1:cut_num
%             I=zeros(224,224);
%             I=sum(224*i1-224+1:224*i1,1:224);
%             
%             IMG(:,:,1)=I;
%             IMG(:,:,2)=I;
%             IMG(:,:,3)=I;
%             
%             if i<10
%                
%                cd(strcat(path1,'x_addfirst_cut_3D'));
%                a1=strcat('00',num2str(i));
%                if exist(a1,'dir')==0
%                   mkdir(a1);
%                end
%                %save(['D:\精子显微分析各种数据集\s_0001_001_object_foleover_3D_slice\y_addfirst_cut\00',num2str(i),'_',num2str(i1),'.mat'],'I');%保存mat文件
%                %imwrite(I,strcat(path1,'pic\y_addfirst_cut\00',num2str(i),'_',num2str(i1),'.jpg'));%保存图片形式
%                save([path1,'x_addfirst_cut_3D\00',num2str(i),'\00',num2str(i),'_',num2str(i1),'.mat'],'IMG');
%             else
%                
%                cd(strcat(path1,'x_addfirst_cut_3D'));
%                a1=strcat('0',num2str(i));
%                if exist(a1,'dir')==0
%                   mkdir(a1);
%                end
%                %save(['D:\精子显微分析各种数据集\s_0001_001_object_foleover_3D_slice\y_addfirst_cut\0',num2str(i),'_',num2str(i1),'.mat'],'I');%保存mat文件
%                %imwrite(I,strcat(path1,'pic\y_addfirst_cut\0',num2str(i),'_',num2str(i1),'.jpg'));%保存图片形式
%                save([path1,'x_addfirst_cut_3D\0',num2str(i),'\0',num2str(i),'_',num2str(i1),'.mat'],'IMG');%保存3Dmat文件
%             end
% 
% 
%         end
%     end
%     flag1=0;
% end

%y
for i=i_1:i_2
    
    path1=strcat('D:\精子显微分析各种数据集\筛选目标\',folder1,'\s_0',folder1,'_',folder2,'\s_0',folder1,'_',folder2,'_object_foleover_3D_slice\');
    cd(strcat(path1,'y_addfirst'));
    a=strcat(num2str(i),'.mat');
    b=exist(a);
    if b~=0
       flag2=1;
    end
    if flag2==1
        load(strcat(path1,'y_addfirst\',num2str(i),'.mat'));
        [R,C]=size(sum);
        cut_num=R/224;
        
        for i1=1:cut_num
            I=zeros(224,224);
            I=sum(224*i1-224+1:224*i1,1:224);
            
            IMG(:,:,1)=I;
            IMG(:,:,2)=I;
            IMG(:,:,3)=I;
            
            if i<10
               
               cd(strcat(path1,'y_addfirst_cut_3D'));
               a1=strcat('00',num2str(i));
               if exist(a1,'dir')==0
                  mkdir(a1);
               end
               %save(['D:\精子显微分析各种数据集\s_0001_001_object_foleover_3D_slice\y_addfirst_cut\00',num2str(i),'_',num2str(i1),'.mat'],'I');
               %imwrite(I,strcat(path1,'pic\y_addfirst_cut\00',num2str(i),'_',num2str(i1),'.jpg'));
               save([path1,'y_addfirst_cut_3D\00',num2str(i),'\00',num2str(i),'_',num2str(i1),'.mat'],'IMG');
            else
              
               cd(strcat(path1,'y_addfirst_cut_3D'));
               a1=strcat('0',num2str(i));
               if exist(a1,'dir')==0
                  mkdir(a1);
               end
               %save(['D:\精子显微分析各种数据集\s_0001_001_object_foleover_3D_slice\y_addfirst_cut\0',num2str(i),'_',num2str(i1),'.mat'],'I');
               %imwrite(I,strcat(path1,'pic\y_addfirst_cut\0',num2str(i),'_',num2str(i1),'.jpg'));
               save([path1,'y_addfirst_cut_3D\0',num2str(i),'\0',num2str(i),'_',num2str(i1),'.mat'],'IMG');
            end


        end
    end
    flag2=0;
end
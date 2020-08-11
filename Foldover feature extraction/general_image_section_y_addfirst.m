%% The purpose of this file is to slice the general Y-axis direction of the image (that is, the row direction of the matrix), first add each slice and then divide it into 224*224
clc;
clear;
close all;
flag=0;
%==========================
folder1='023';
folder2='005';
%==========================


for i=1:25
    %Determine if this folder exists
    path1=strcat('D:\精子显微分析各种数据集\筛选目标\',folder1,'\s_0',folder1,'_',folder2,'\s_0',folder1,'_',folder2,'_object_foleover_3D_slice\');
    cd(strcat(path1,'y'));
    a=num2str(i);
    b=exist(a);
    if b~=0
       flag=1;
    end
    if flag==1
        
        namelist = dir(strcat(path1,'y\',num2str(i),'\*.mat'));
        len = length(namelist);
        max_num=0;
        num_flag=0;
        for i1 = 1:len       
            file_name=namelist(i1).name;
            S=regexp(file_name, '_','split');
            s1=char(S(2));
            s2=regexp(s1, '\.','split');
            s3=char(s2(1));
            s3=str2num(s3);
            if s3>max_num
                max_num=s3;
            end
            
        end
        sum=zeros(max_num*224,224);
        
        for i2 = 1:len     
            file_name1=namelist(i2).name;
            S1=regexp(file_name1, '_','split');
            s11=char(S1(2));
            s22=regexp(s11, '\.','split');
            s33=char(s22(1));
            s33=str2num(s33);
            load(strcat(path1,'y\',num2str(i),'\',file_name1));
            sum1=zeros(max_num*224,224);

            diff_num=max_num+1;
            sum1(224*(diff_num-s33)-224+1:224*(diff_num-s33),1:224)=ob_slice;
            sum=sum+sum1;
        end
        
        save([path1,'y_addfirst\',num2str(i),'.mat'],'sum');
        imwrite(sum,strcat(path1,'pic\y_addfirst\',num2str(i),'.jpg'));
    end
    flag=0;
end
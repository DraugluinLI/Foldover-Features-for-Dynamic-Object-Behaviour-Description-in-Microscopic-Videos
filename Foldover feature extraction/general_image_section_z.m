%% Slice the z-axis of the picture
clc;
clear;
close all;
flag=0;
%==========================
folder1='046';
folder2='003';
%==========================


for i=1:25
    if i<10
       path1=strcat('D:\精子显微分析各种数据集\筛选目标\',folder1,'\s_0',folder1,'_',folder2,'\s_0',folder1,'_',folder2,'_object_foleover_224_224');
       cd(path1);
       a=strcat('00',num2str(i),'.mat');
       b=exist(a);
       if b~=0
          load(strcat(path1,'\00',num2str(i),'.mat'));
          flag=1;
       end
    else
        
       cd(path1);
       a=strcat('0',num2str(i),'.mat');
       b=exist(a);
       if b~=0
          load(strcat(path1,'\0',num2str(i),'.mat'));
          flag=1;
       end
    end
    if flag==1
        max_ob=max(img(:));
        [r1,c1]=find(img==max_ob);

       
        xx = mod(max_ob,2);
        path2=strcat('D:\精子显微分析各种数据集\筛选目标\',folder1,'\s_0',folder1,'_',folder2,'\s_0',folder1,'_',folder2,'_object_foleover_3D_slice\');
        if xx==1
            new_max_ob=max_ob+1;
            num1=new_max_ob/20;
            judge1=floor(num1);
            if judge1==num1
                num1=num1;
            else
                num1=ceil(num1); 
            end
            
            for i1=1:num1
                if new_max_ob-20>0
                   small_max=new_max_ob-20;
                   
                   I=img;
                   I(I<small_max) = 0;
                   
                   cd(strcat(path2,'z'));
                   a1=num2str(i);
                   if  exist(a1,'dir')==0
                       mkdir(a1);
                   end
                   save([path2,'z\',num2str(i),'\', num2str(small_max),'_',num2str(new_max_ob), '.mat'],'I');
                   
                   cd(strcat(path2,'pic\z'));
                   a2=num2str(i);
                   if  exist(a2,'dir')==0
                       mkdir(a2);
                   end
                   imwrite(I,strcat(path2,'pic\z\',num2str(i),'\', num2str(small_max),'_',num2str(new_max_ob),'.jpg'));
                   
                   new_max_ob=new_max_ob-20;
                else
                   small_max=new_max_ob;
                   I=img;
                   I(I<small_max) = 0;
                  
                   cd(strcat(path2,'z'));
                   a1=num2str(i);
                   if  exist(a1,'dir')==0
                       mkdir(a1);
                   end
                   save([path2,'z\',num2str(i),'\', num2str(small_max),'_',num2str(new_max_ob), '.mat'],'I');
                   
                   cd(strcat(path2,'pic\z'));
                   a2=num2str(i);
                   if  exist(a2,'dir')==0
                       mkdir(a2);
                   end
                   imwrite(I,strcat(path2,'pic\z\',num2str(i),'\', num2str(small_max),'_',num2str(new_max_ob),'.jpg'));
                   
                end    
            end
        else
            new_max_ob=max_ob;
            num2=new_max_ob/20;
            judge2=floor(num2);
            if judge2==num2
                num2=num2;
            else
                num2=ceil(num2);
            end
            
            for i2=1:num2
                if new_max_ob-20>0
                   small_max=new_max_ob-20;
                   
                   I=img;
                   I(I<small_max) = 0;
                   
                   cd(strcat(path2,'z'));
                   a1=num2str(i);
                   if  exist(a1,'dir')==0
                       mkdir(a1);
                   end
                   save([path2,'z\',num2str(i),'\', num2str(small_max),'_',num2str(new_max_ob), '.mat'],'I');
                  
                   cd(strcat(path2,'pic\z'));
                   a2=num2str(i);
                   if  exist(a2,'dir')==0
                       mkdir(a2);
                   end
                   imwrite(I,strcat(path2,'pic\z\',num2str(i),'\', num2str(small_max),'_',num2str(new_max_ob),'.jpg'));
                  
                   new_max_ob=new_max_ob-20;
                else
                   small_max=new_max_ob;
                   I=img;
                   I(I<small_max) = 0;
                  
                   cd(strcat(path2,'z'));
                   a1=num2str(i);
                   if  exist(a1,'dir')==0
                       mkdir(a1);
                   end
                   save([path2,'z\',num2str(i),'\', num2str(small_max),'_',num2str(new_max_ob), '.mat'],'I');
                   
                   cd(strcat(path2,'pic\z'));
                   a2=num2str(i);
                   if  exist(a2,'dir')==0
                       mkdir(a2);
                   end
                   imwrite(I,strcat(path2,'pic\z\',num2str(i),'\', num2str(small_max),'_',num2str(new_max_ob),'.jpg'));
               
                end    
            end 
        end
    end
    flag=0;
end

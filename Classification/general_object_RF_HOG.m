%% The purpose of this file is: RF classification (optional HOG,GLCM,SIFT,HU)
clear;
close all;
clc; 


name_of_feature='HOG';



HOG_feature=zeros(1376,37);
loc_flag=0;

accuracy_set=zeros(1,10);
Cf=zeros(3,3);
act_set=zeros(10,687);
det_set=zeros(687,10);

for test_number=1:10
   
    fileFolder=fullfile(strcat('D:\精子显微分析各种数据集\筛选目标\',name_of_feature,'_feature'));
    dirOutput=dir(fullfile(fileFolder,'.'));
    fileNames={dirOutput.name}';
    num=size(fileNames);
    num_file=num(1,1)-2;

    
    for v_num=1:num_file
        video_name=fileNames{v_num+2,1};

        
        shot_fileFolder=fullfile(strcat('D:\精子显微分析各种数据集\筛选目标\',name_of_feature,'_feature\',video_name));
        shot_dirOutput=dir(fullfile(shot_fileFolder,'.'));
        shot_fileNames={shot_dirOutput.name}';
        shot_num=size(shot_fileNames);
        shot_num_file=shot_num(1,1)-2;

        
        for s_num=1:shot_num_file
            shot_name=shot_fileNames{s_num+2,1};

            
            object_fileFolder=fullfile(strcat('D:\精子显微分析各种数据集\筛选目标\',name_of_feature,'_feature\',video_name,'\',shot_name));
            object_dirOutput=dir(fullfile(object_fileFolder,'.'));
            object_fileNames={object_dirOutput.name}';
            object_num=size(object_fileNames);
            object_num_file=object_num(1,1)-2;

          
            for o_num=1:object_num_file
                object_name=object_fileNames{o_num+2,1};

                
                frame_fileFolder=fullfile(strcat('D:\精子显微分析各种数据集\筛选目标\',name_of_feature,'_feature\',video_name,'\',shot_name,'\',object_name));
                frame_dirOutput=dir(fullfile(frame_fileFolder,'*.mat'));
                frame_fileNames={frame_dirOutput.name}';
                frame_num=size(frame_fileNames);
                frame_num_file=frame_num(1,1);

                r = randi(frame_num_file);
                r_frame_name=frame_fileNames{r,1};
                r_frame=load(strcat('D:\精子显微分析各种数据集\筛选目标\',name_of_feature,'_feature\',video_name,'\',shot_name,'\',object_name,'\',r_frame_name));
                loc_flag=loc_flag+1;
    %             
    %             em=length(r_frame.featureVec);
    %             if em==0
    %                r_frame.featureVec=zeros(1,36);
    %             end

                lable_set=load(strcat('D:\精子显微分析各种数据集\筛选目标\0',video_name,'\',shot_name,'\',shot_name,'_lable'));
                A=object_name(2);
                A=str2num(A);
                if A>0
                   B=object_name(2:3);
                else
                   B=object_name(3);
                end
                B=str2num(B);
                %------------------------------------------
                r_lable=lable_set.lable(B,1);

                
                HOG_feature(loc_flag,1:36)=r_frame.featureVec;
                HOG_feature(loc_flag,37)=r_lable;
            end
        end
    end









    %============================

    class_feature=HOG_feature(1:1374,1:36);
    class_lable=HOG_feature(1:1374,37);

    dim=50;


    % [pc,score,latent,tsquare] = pca(HOG_feature);
    % a1=cumsum(latent);
    % c1=latent;
    % [r1,q1]=size(c1);
    % sum_num1=0;
    % for i1=1:r1
    %     b1=c1(i1,1);
    %     sum_num1=sum_num1+b1;
    % end
    % a_num1=a1/sum_num1;
    % tran1=pc(:,1:dim);
    % HOG_feature=score(:,1:dim);




    train=[class_feature(1:229,:);class_feature(459:687,:);class_feature(917:1145,:)]; 

    train_group=[class_lable(1:229,:);class_lable(459:687,:);class_lable(917:1145,:)];

    test=[class_feature(230:458,:);class_feature(688:916,:);class_feature(1146:1374,:)];

    test_group=[class_lable(230:458,:);class_lable(688:916,:);class_lable(1146:1374,:)]; 
    %============================
    
   
%     I=train';
%     [train,pstrain] = mapminmax(train');

%     pstrain.ymin = 0;
%     pstrain.ymax = 1;

%     [train,pstrain] = mapminmax(train,pstrain);

%     [test,pstest] = mapminmax(test');

%     pstest.ymin = 0;
%     pstest.ymax = 1;

%     [test,pstest] = mapminmax(test,pstest);

%     train = train';
%     test = test';
    

    nTree =200;
    B = TreeBagger(nTree,train,train_group);
    predict_label = predict(B,test);
    predict_label = str2double(predict_label);
    %accuracy = length(find(predict_label == test_group))/length(test_group)*100;
    accuracy = length(find(predict_label == test_group))/length(test_group);
    

    accuracy_set(1,test_number)=accuracy;

    act_set(test_number,1:687)=test_group';
    det_set(1:687,test_number)=predict_label';
    

    
    

%     act1=test_group';
%     det1=predict_label';
%     %figure;
%     subplot(2,5,test)
%     confusion_matrix(act1,det1); 
end

act=zeros(1,6870);
det=zeros(6870,1);

act1=[act_set(1,:),act_set(2,:),act_set(3,:),act_set(4,:),act_set(5,:),act_set(6,:),act_set(7,:),act_set(8,:),act_set(9,:),act_set(10,:)];
det1=[det_set(:,1);det_set(:,2);det_set(:,3);det_set(:,4);det_set(:,5);det_set(:,6);det_set(:,7);det_set(:,8);det_set(:,9);det_set(:,10)];  

figure;
% subplot(2,5,test)
confusion_matrix(act1,det1);  



sum=0;
for test1=1:10
    sum=sum+accuracy_set(1,test1);
end
sum_mean=sum/10;
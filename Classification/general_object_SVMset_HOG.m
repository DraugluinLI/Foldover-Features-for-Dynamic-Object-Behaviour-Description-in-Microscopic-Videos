%% The purpose of this file is: SVM classification (optional HOG,GLCM,SIFT,HU)
clc;
clear;
close all;

name_of_feature='HOG';



HOG_feature=zeros(1376,37);
loc_flag=0;

accuracy_set=zeros(1,10);

for test_num=1:10
   
    
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

    %             em=length(r_frame.featureVec);
    %             if em==0
    %                r_frame.featureVec=zeros(1,36);
    %             end

                
                lable_set=load(strcat('D:\精子显微分析各种数据集\筛选目标\0',video_name,'\',shot_name,'\',shot_name,'_lable'));%进入存放标签的文件夹，提取标签文件
                
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

    
    class_feature=HOG_feature(1:1374,1:36);
    class_lable=HOG_feature(1:1374,37);


    
    train=[class_feature(1:229,:);class_feature(459:687,:);class_feature(917:1145,:)]; 

    train_group=[class_lable(1:229,:);class_lable(459:687,:);class_lable(917:1145,:)];

    test=[class_feature(230:458,:);class_feature(688:916,:);class_feature(1146:1374,:)];

    test_group=[class_lable(230:458,:);class_lable(688:916,:);class_lable(1146:1374,:)]; 


    % I=train';
    % [train,pstrain] = mapminmax(train');

    % pstrain.ymin = 0;
    % pstrain.ymax = 1;

    % [train,pstrain] = mapminmax(train,pstrain);

    % [test,pstest] = mapminmax(test');

    % pstest.ymin = 0;
    % pstest.ymax = 1;

    % [test,pstest] = mapminmax(test,pstest);

    % train = train';
    % test = test';



    % [bestacc,bestc,bestg] = SVMcgForClass(train_group,train,-10,10,-10,10);

    % [bestacc,bestc,bestg] = SVMcgForClass(train_group,train,-2,4,-4,4,3,0.5,0.5,0.9);

    [mtrain,ntrain] = size(train);
    [mtest,ntest] = size(test);

    dataset = [train;test];

    [dataset_scale,ps] = mapminmax(dataset',0,1);
    dataset_scale = dataset_scale';

    train = dataset_scale(1:mtrain,:);
    test = dataset_scale( (mtrain+1):(mtrain+mtest),: );


    % cmd = ['-c ',num2str(bestc),' -g ',num2str(bestg)];
    % model=svmtrain(train_group,train,cmd);
    %disp(cmd);
    model=svmtrain(train_group,train,'-s 0 -t 2 -c 2 -g 1');


    [predict_label, accuracy, dec_values]=svmpredict(test_group,test,model);

    

    

    act1=test_group';
    det1=predict_label';
    figure;
    subplot(2,5,test_num);
    confusion_matrix(act1,det1);
    
    

%     figure;
%     hold on;
%     plot(test_group,'o');
%     plot(predict_label,'r*');
%     legend('实际测试集分类','预测测试集分类');
%     title('测试集的实际分类和预测分类图','FontSize',10);
end


sum=0;
for test1=1:10
    sum=sum+accuracy_set(1,test1);
end
sum_mean=sum/10;
sum_mean=sum_mean/100;

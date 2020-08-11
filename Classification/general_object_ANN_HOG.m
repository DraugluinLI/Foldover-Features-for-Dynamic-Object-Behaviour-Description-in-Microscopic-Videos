%% The purpose of this file is: ANN classification (optional HOG,GLCM,SIFT,HU)
clc;
clear; 
close all;

%Select features
name_of_feature='HOG';


%Create a matrix to hold the features
HOG_feature=zeros(1376,37);
loc_flag=0;

accuracy_set=zeros(1,10);
Cf=zeros(3,3);
act_set=zeros(10,687);
det_set=zeros(687,10);

for test=1:10

   %% The purpose of this section is: 1, each target randomly selects a feature to be selected. 2. Put all the selected features into a matrix. 3. Add the corresponding label.
    
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

                
                lable_set=load(strcat('D:\精子显微分析各种数据集\筛选目标\0',video_name,'\',shot_name,'\',shot_name,'_lable'));%进入存放标签的文件夹，提取标签文件
               
                A=object_name(2);
                A=str2num(A);
                if A>0
                   B=object_name(2:3);
                else
                   B=object_name(3);
                end
                B=str2num(B);
                
                r_lable=lable_set.lable(B,1);
                
                HOG_feature(loc_flag,1:36)=r_frame.featureVec;
                HOG_feature(loc_flag,37)=r_lable;
            end
        end
    end




    
     

    %% classifier
   
    class_feature=HOG_feature(1:1374,1:36);
    class_lable=HOG_feature(1:1374,37);
    

    
    
    dim=50;

    %PCA操作
    % [pc,score,latent,tsquare] = pca(class_feature);
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
    % class_feature=score(:,1:dim);



    
    train_gather=[class_feature(1:229,:);class_feature(459:687,:);class_feature(917:1145,:)]; 

    train_group=[class_lable(1:229,:);class_lable(459:687,:);class_lable(917:1145,:)];

    test_gather=[class_feature(230:458,:);class_feature(688:916,:);class_feature(1146:1374,:)];

    test_group=[class_lable(230:458,:);class_lable(688:916,:);class_lable(1146:1374,:)]; 

    
    train_gather=train_gather';
    test_gather=test_gather';
    


    [input,minI,maxI] = premnmx(train_gather)  ;

    s = length(train_group) ;
    output = zeros( s , 3  ) ;
    for i = 1 : s 
       output( i , train_group( i )  ) = 1 ;
    end

    net = newff( minmax(input) , [10 3] , {'logsig' 'purelin' } , 'traingdx' ) ; 

    net.trainparam.show = 50 ;
    net.trainparam.epochs = 500 ;
    net.trainparam.goal = 0.01 ;
    net.trainParam.lr = 0.01 ;
   
    net = train( net, input , output' ) ;
    


    testInput = tramnmx (test_gather,minI,maxI) ;

    Y = sim( net , testInput );


    predict_label=zeros(1,687);


    [s1 , s2] = size( Y ) ;
    hitNum = 0 ;
    for i = 1 : s2
        [m , Index] = max( Y( : ,  i ) ) ;
        predict_label(1,i)=Index;

        if( Index  == test_group(i)   ) 
            hitNum = hitNum + 1 ; 
        end
    end
    sprintf('准确率是 %3.3f%%',100 * hitNum / s2 )
    

    accuracy_set(1,test)=hitNum / s2;
    
    

    act_set(test,1:687)=test_group';
    det_set(1:687,test)=predict_label';
    
    
    

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
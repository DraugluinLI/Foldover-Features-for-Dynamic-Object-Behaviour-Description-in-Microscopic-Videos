%% The purpose of this file is: dynamic texture features classification by SVM
clc;
clear; 
close all;


load('D:\精子显微分析各种数据集\筛选目标\object_videos\50_52_size_dynamic_texture_feature_vector\A所有向量的集和.mat');


dynamic_feature=Diff_matrix_pooling(3:1376,1:20);
dynamic_feature_lable=Diff_matrix_pooling(3:1376,21);


train=[dynamic_feature(1:229,:);dynamic_feature(459:687,:);dynamic_feature(917:1145,:)]; 

train_group=[dynamic_feature_lable(1:229,:);dynamic_feature_lable(459:687,:);dynamic_feature_lable(917:1145,:)];

test=[dynamic_feature(230:458,:);dynamic_feature(688:916,:);dynamic_feature(1146:1374,:)];

test_group=[dynamic_feature_lable(230:458,:);dynamic_feature_lable(688:916,:);dynamic_feature_lable(1146:1374,:)]; 



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


Training_set=train;
Training_lable=train_group;
Test_set=test;
Test_lable=test_group;
SVM_classifer_model = libsvm_svmtrain(Training_lable, Training_set,'-s 0 -t 0 -c 2 -g 1 -b 1');
[predicted_label, accuracy, decision_values] =svmpredict(Test_lable,Test_set, SVM_classifer_model,'-b 1');




act1=test_group';
det1=predicted_label';
confusion_matrix(act1,det1);

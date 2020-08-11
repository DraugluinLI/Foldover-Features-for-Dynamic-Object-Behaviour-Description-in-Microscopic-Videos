%% The purpose of this file is: SVM classification of motion parameters
clc;
clear; 
close all;

load('D:\精子显微分析各种数据集\筛选目标\motion_parameters_feature\A所有向量的集和.mat');


dynamic_feature=motion_parameters_set(3:1376,1:9);
dynamic_feature_lable=motion_parameters_set(3:1376,10);



train=[dynamic_feature(1:229,:);dynamic_feature(459:687,:);dynamic_feature(917:1145,:)]; 

train_group=[dynamic_feature_lable(1:229,:);dynamic_feature_lable(459:687,:);dynamic_feature_lable(917:1145,:)];

test=[dynamic_feature(230:458,:);dynamic_feature(688:916,:);dynamic_feature(1146:1374,:)];

test_group=[dynamic_feature_lable(230:458,:);dynamic_feature_lable(688:916,:);dynamic_feature_lable(1146:1374,:)]; 


Training_set=train;
Training_lable=train_group;
Test_set=test;
Test_lable=test_group;
SVM_classifer_model = libsvm_svmtrain(Training_lable, Training_set,'-s 0 -t 0 -c 2 -g 1 -b 1');
[predicted_label, accuracy, decision_values] =svmpredict(Test_lable,Test_set, SVM_classifer_model,'-b 1');




act1=test_group';
det1=predicted_label';
confusion_matrix(act1,det1);

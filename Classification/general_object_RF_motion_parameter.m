%% RF classification of motion parameters
clc;
clear; 
close all;


load('D:\精子显微分析各种数据集\筛选目标\motion_parameters_feature\A所有向量的集和.mat');


dynamic_feature=motion_parameters_set(3:1376,1:9);
dynamic_feature_lable=motion_parameters_set(3:1376,10);


train_gather=[dynamic_feature(1:229,:);dynamic_feature(459:687,:);dynamic_feature(917:1145,:)]; 

train_group=[dynamic_feature_lable(1:229,:);dynamic_feature_lable(459:687,:);dynamic_feature_lable(917:1145,:)];

test_gather=[dynamic_feature(230:458,:);dynamic_feature(688:916,:);dynamic_feature(1146:1374,:)];

test_group=[dynamic_feature_lable(230:458,:);dynamic_feature_lable(688:916,:);dynamic_feature_lable(1146:1374,:)]; 
%============================


nTree =200;
B = TreeBagger(nTree,train_gather,train_group);
predict_label = predict(B,test_gather);
predict_label = str2double(predict_label);
%accuracy = length(find(predict_label == test_group))/length(test_group)*100;
accuracy = length(find(predict_label == test_group))/length(test_group);




act1=test_group';
det1=predict_label';
confusion_matrix(act1,det1);
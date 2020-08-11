%% RF classification of VGG features
clc;
clear; 
close all;


load('D:\������΢�����������ݼ�\ɸѡĿ��\VGG19_image_1000feature\A���������ļ���.mat');


dynamic_feature=VGG16_1000feature_set(3:1376,1:1000);
dynamic_feature_lable=VGG16_1000feature_set(3:1376,1001);


train=[dynamic_feature(1:229,:);dynamic_feature(459:687,:);dynamic_feature(917:1145,:)]; 

train_group=[dynamic_feature_lable(1:229,:);dynamic_feature_lable(459:687,:);dynamic_feature_lable(917:1145,:)];

test=[dynamic_feature(230:458,:);dynamic_feature(688:916,:);dynamic_feature(1146:1374,:)];

test_group=[dynamic_feature_lable(230:458,:);dynamic_feature_lable(688:916,:);dynamic_feature_lable(1146:1374,:)]; 
%============================



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


nTree =200;
B = TreeBagger(nTree,train,train_group);
predict_label = predict(B,test);
predict_label = str2double(predict_label);
%accuracy = length(find(predict_label == test_group))/length(test_group)*100;
accuracy = length(find(predict_label == test_group))/length(test_group);




act1=test_group';
det1=predict_label';
confusion_matrix(act1,det1);
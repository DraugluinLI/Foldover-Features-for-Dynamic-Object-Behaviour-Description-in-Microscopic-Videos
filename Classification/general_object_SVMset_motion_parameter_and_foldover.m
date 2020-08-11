%% General image ANN classification (based on VGG16's xyz three directional features) can choose whether to fuse the foldover feature and motion parameters合

clc;
clear; 
close all;


% load('D:\精子显微分析各种数据集\筛选目标\sample_1000_features\x_sample_1000_features_include_lable');
% load('D:\精子显微分析各种数据集\筛选目标\sample_1000_features\y_sample_1000_features_include_lable');
load('D:\精子显微分析各种数据集\筛选目标\sample_1000_features\z_sample_1000_features_include_lable');


Q=load('D:\精子显微分析各种数据集\筛选目标\motion_parameters_feature\A所有向量的集和.mat');
motion_parameters_set=Q.motion_parameters_set;

% P=load('D:\精子显微分析各种数据集\筛选目标\motion_rangey_feature\A所有向量的集和.mat');
% motion_range_set=P.motion_parameters_set;

% x_feature=A(1:1374,1:1000);
% x_lable=A(1:1374,1001);
% 
% y_feature=B(1:1374,1:1000);
% y_lable=B(1:1374,1001);

z_feature=C(1:1374,1:1000);
z_lable=C(1:1374,1001);

%dim_x=50;
% dim_y=50;
dim_z=50;

motion_parameters=motion_parameters_set(3:1376,1:9);
% motion_range=motion_range_set(3:1376,1:3);


% [pc,score,latent,tsquare] = pca(x_feature);
% a1=cumsum(latent);
% c1=latent;
% [r1,q1]=size(c1);
% sum_num1=0;
% for i1=1:r1
%     b1=c1(i1,1);
%     sum_num1=sum_num1+b1;
% end
% a_num1=a1/sum_num1;
% tran1=pc(:,1:dim_x);
% x_feature=score(:,1:dim_x);


% [pc,score,latent,tsquare] = pca(y_feature);
% a2=cumsum(latent);
% c2=latent;
% [r2,q2]=size(c2);
% sum_num2=0;
% for i2=1:r2
%     b2=c2(i2,1);
%     sum_num2=sum_num2+b2;
% end
% a_num2=a2/sum_num2;
% tran2=pc(:,1:dim_y);
% y_feature=score(:,1:dim_y);


[pc,score,latent,tsquare] = pca(z_feature);
a3=cumsum(latent);
c3=latent;
[r3,q3]=size(c3);
sum_num3=0;
for i3=1:r3
    b3=c3(i3,1);
    sum_num3=sum_num3+b3;
end
a_num3=a3/sum_num3;
tran3=pc(:,1:dim_z);
z_feature=score(:,1:dim_z);
% 
% xyz_feature=cat(2,x_feature,y_feature,z_feature);
% dim_xyz=dim_x+dim_y+dim_z;


column=dim_z+9
mix_feature=zeros(1374,column);
mix_feature(:,1:50)=z_feature;
mix_feature(:,51:column)=motion_parameters;
% mix_feature(:,51:column)=motion_range;



% mix_feature=zeros(1374,13);
% mix_feature(:,1:9)=motion_parameters;
% mix_feature(:,10:13)=motion_range;


% column=dim_y+2;
% mix_feature=zeros(1374,column);
% mix_feature(:,1:dim_y)=y_feature;
% mix_feature(:,dim_y+1:column)=motion_range;


train=[mix_feature(1:229,:);mix_feature(459:687,:);mix_feature(917:1145,:)]; 

train_group=[z_lable(1:229,:);z_lable(459:687,:);z_lable(917:1145,:)];

test=[mix_feature(230:458,:);mix_feature(688:916,:);mix_feature(1146:1374,:)];

test_group=[z_lable(230:458,:);z_lable(688:916,:);z_lable(1146:1374,:)]; 




I=train';
[train,pstrain] = mapminmax(train');

pstrain.ymin = 0;
pstrain.ymax = 1;

[train,pstrain] = mapminmax(train,pstrain);

[test,pstest] = mapminmax(test');

pstest.ymin = 0;
pstest.ymax = 1;

[test,pstest] = mapminmax(test,pstest);

train = train';
test = test';



Training_set=train;
Training_lable=train_group;
Test_set=test;
Test_lable=test_group;
SVM_classifer_model = libsvm_svmtrain(Training_lable, Training_set,'-s 0 -t 0 -c 2 -g 1 -b 1');
[predicted_label, accuracy, decision_values] =svmpredict(Test_lable,Test_set, SVM_classifer_model,'-b 1');




act1=test_group';
det1=predicted_label';
confusion_matrix(act1,det1);

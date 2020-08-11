%% General image ANN classification (based on VGG16's xyz three directional features) can choose whether to fuse the foldover feature and motion parameters合

clear;
close all;
clc;


% load('D:\精子显微分析各种数据集\筛选目标\sample_1000_features\x_sample_1000_features_include_lable');
%load('D:\精子显微分析各种数据集\筛选目标\sample_1000_features\y_sample_1000_features_include_lable');
load('D:\精子显微分析各种数据集\筛选目标\sample_1000_features\z_sample_1000_features_include_lable');


Q=load('D:\精子显微分析各种数据集\筛选目标\motion_parameters_feature\A所有向量的集和.mat');
motion_parameters_set=Q.motion_parameters_set;

% P=load('D:\精子显微分析各种数据集\筛选目标\motion_rangey_feature\A所有向量的集和.mat');
% motion_range_set=P.motion_parameters_set;

% x_feature=A(1:1374,1:1000);
% x_lable=A(1:1374,1001);
 
% y_feature=B(1:1374,1:1000);
% y_lable=B(1:1374,1001);

z_feature=C(3:1376,1:1000);
z_lable=C(3:1376,1001);

motion_parameters=motion_parameters_set(3:1376,1:9);
% motion_range=motion_range_set(3:1376,1:3);
%dim_x=50;
% dim_y=50;
dim_z=50;



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
% 

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


column=dim_z+9;
mix_feature=zeros(1374,column);
mix_feature(:,1:50)=z_feature;
mix_feature(:,51:column)=motion_parameters;
% mix_feature(:,51:column)=motion_range;


% mix_feature=zeros(1374,13);%建立空矩阵
% mix_feature(:,1:9)=motion_parameters;
% mix_feature(:,10:13)=motion_range;


% column=dim_y+2;
% mix_feature=zeros(1374,column);
% mix_feature(:,1:dim_y)=y_feature;
% mix_feature(:,dim_y+1:column)=motion_range;





train_gather=[mix_feature(1:229,:);mix_feature(459:687,:);mix_feature(917:1145,:)]; 

train_group=[z_lable(1:229,:);z_lable(459:687,:);z_lable(917:1145,:)];

test_gather=[mix_feature(230:458,:);mix_feature(688:916,:);mix_feature(1146:1374,:)];

test_group=[z_lable(230:458,:);z_lable(688:916,:);z_lable(1146:1374,:)];


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


act1=test_group';
det1=predict_label';
confusion_matrix(act1,det1);
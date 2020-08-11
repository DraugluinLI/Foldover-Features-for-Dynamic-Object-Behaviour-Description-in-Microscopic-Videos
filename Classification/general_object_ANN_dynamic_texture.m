%% The purpose of this file is: ANN classification of dynamic texture features
clc;
clear; 
close all;


load('D:\精子显微分析各种数据集\筛选目标\object_videos\50_52_size_dynamic_texture_feature_vector\A所有向量的集和.mat');


dynamic_feature=Diff_matrix_pooling(3:1376,1:20);
dynamic_feature_lable=Diff_matrix_pooling(3:1376,21);


%dim_x=50;



% [pc,score,latent,tsquare] = pca(x_feature);%我们这里需要他的pc和latent值做分析
% a1=cumsum(latent);
% c1=latent;
% [r1,q1]=size(c1);
% sum_num1=0;
% for i1=1:r1%循环加和
%     b1=c1(i1,1);
%     sum_num1=sum_num1+b1;
% end
% a_num1=a1/sum_num1;
% tran1=pc(:,1:dim_x);
% x_feature=score(:,1:dim_x);




train_gather=[dynamic_feature(1:229,:);dynamic_feature(459:687,:);dynamic_feature(917:1145,:)]; 

train_group=[dynamic_feature_lable(1:229,:);dynamic_feature_lable(459:687,:);dynamic_feature_lable(917:1145,:)];

test_gather=[dynamic_feature(230:458,:);dynamic_feature(688:916,:);dynamic_feature(1146:1374,:)];

test_group=[dynamic_feature_lable(230:458,:);dynamic_feature_lable(688:916,:);dynamic_feature_lable(1146:1374,:)]; 


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

%% he purpose of this file: for each target individual video, generate and save their own corresponding dynamic texture video, followed by a large section of code suitable for extracting dynamic texture features
clc;
clear;
close all;


% fileFolder=fullfile(strcat('D:\精子显微分析各种数据集\筛选目标\object_videos\50_52_size_videos'));
% dirOutput=dir(fullfile(fileFolder,'*.mp4'));
% fileNames={dirOutput.name}';
% num=size(fileNames);
% 

% for i=1:num
%     video_full_name=fileNames{i,1};
%     video_name1=strsplit(video_full_name,'.');
%     video_name=video_name1{1,1};
%     
%     %====Dynamic texture extraction===================
%     video=VideoReader(strcat('D:\精子显微分析各种数据集\筛选目标\object_videos\50_52_size_videos\',video_full_name));
%     N=video.NumberOfFrames;
%     H=video.Height;
%     W=video.Width;
% 
%     f=N;
%     Y=zeros(f,H*W);
%     error_all=[];
%     for k=1:f
%         mov(k).cdata=read(video,k);
%         image=rgb2gray(mov(k).cdata);     
%         Y(k,:)=reshape(image,[1,H*W]);
%     end
%     Y=Y';
%     Y=Y./255;
%     Y=double(Y);
%     tau=size(Y,2);Ymean=mean(Y,2);
%     [U,S,V]=svd((Y-Ymean*ones(1,tau)),0);
%     %for n=50
%     for n=N
%     X=zeros(n,N);
%     %nv=30;
%     nv=1;
%     Chat=U(:,1:n);
%     Xhat=S(1:n,1:n)*V(:,1:n)';
%     x0=Xhat(:,1);
%     Ahat=Xhat(:,2:tau)*pinv(Xhat(:,1:(tau-1)));
%     Vhat=Xhat(:,2:tau)-Ahat*Xhat(:,1:(tau-1));
%     [Uv,Sv,Vv]=svd(Vhat,0);
%     Bhat=Uv(:,1:nv)*Sv(1:nv,1:nv)/sqrt(tau-1);
%     X(:,1)=x0;
%     I=zeros(W*H,tau);
% 
%     newobj=VideoWriter(strcat('D:\精子显微分析各种数据集\筛选目标\object_videos\50_52_size_videos_dynamic_texture\',video_name));
%     open(newobj);
% 
%     error=0;
%     for t=2:1200
%         X(:,t)=Ahat*X(:,t-1);
%         I(:,t)=Chat*X(:,t)+Ymean;
%         newimage=(reshape(I(:,t),[H,W]));
%          newimage(newimage<0)=0;
%          newimage(newimage>1)=1;
%          writeVideo(newobj,newimage);
%     end
%     error=error/(N-1);
%     error_all=[error_all,error];
%     close(newobj);
%     end
%     %======================================
%     
% end

%% Dynamic texture feature extraction, running this code need to comment out the above code

fileFolder=fullfile(strcat('D:\精子显微分析各种数据集\筛选目标\object_videos\50_52_size_videos_dynamic_texture'));
dirOutput=dir(fullfile(fileFolder,'*.avi'));
fileNames={dirOutput.name}';
num1=size(fileNames);
num=num1(1,1);

Diff_matrix_pooling=zeros(1376,21);


for i=1:num
    video_full_name=fileNames{i,1};
    video_name1=strsplit(video_full_name,'.');
    video_name=video_name1{1,1};
    
    vidObj = VideoReader(strcat('D:\精子显微分析各种数据集\筛选目标\object_videos\50_52_size_videos_dynamic_texture\',video_full_name));

    %Determine the height and width of the frames.
    vidHeight = vidObj.Height;
    vidWidth = vidObj.Width;

    %Create a MATLAB?movie structure array, s.
    s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'));

    %Read one frame at a time using readFrame until the end of the file is reached. Append data from each video frame to the structure array.
    %k = 1;
    k = 1;
    while hasFrame(vidObj)
        s(k).cdata = readFrame(vidObj);
        %imshow(s(k).cdata);
        k = k+1;
    end
   k=k-1;
   
   diff_matrix = struct('diff_img',zeros(vidHeight,vidWidth,3,'uint8'));
   
   for j=1:k
       if j+1<=k
          img1=s(j).cdata;
          img1=rgb2gray(img1);
          img2=s(j+1).cdata;
          img2=rgb2gray(img2);
          diff_img=img2-img1;
          diff_matrix(j).diff_img=diff_img;
       end  
   end
   
   
   diff_matrix_num=k-1;
   diff_matrix_sum=zeros(50,52);
   diff_matrix_sum=uint16(diff_matrix_sum);
   for z=1:diff_matrix_num
       ob=diff_matrix(z).diff_img;
       ob=uint16(ob);
       diff_matrix_sum=diff_matrix_sum+ob;
   end
   
   diff_matrix_pooling=zeros(1,21);
   
   m1=diff_matrix_sum(1:10,1:13);
   m1_pooling=max(max(m1));
   diff_matrix_pooling(1,1)=m1_pooling;
   
   m2=diff_matrix_sum(1:10,14:26);
   m2_pooling=max(max(m2));
   diff_matrix_pooling(1,2)=m2_pooling;
   
   m3=diff_matrix_sum(1:10,27:39);
   m3_pooling=max(max(m3));
   diff_matrix_pooling(1,3)=m3_pooling;
   
   m4=diff_matrix_sum(1:10,40:52);
   m4_pooling=max(max(m4));
   diff_matrix_pooling(1,4)=m4_pooling;
   
   m5=diff_matrix_sum(11:20,1:13);
   m5_pooling=max(max(m5));
   diff_matrix_pooling(1,5)=m5_pooling;
   
   m6=diff_matrix_sum(11:20,14:26);
   m6_pooling=max(max(m6));
   diff_matrix_pooling(1,6)=m6_pooling;
   
   m7=diff_matrix_sum(11:20,27:39);
   m7_pooling=max(max(m7));
   diff_matrix_pooling(1,7)=m7_pooling;
   
   m8=diff_matrix_sum(11:20,40:52);
   m8_pooling=max(max(m8));
   diff_matrix_pooling(1,8)=m8_pooling;
   
   m9=diff_matrix_sum(21:30,1:13);
   m9_pooling=max(max(m9));
   diff_matrix_pooling(1,9)=m9_pooling;
   
   m10=diff_matrix_sum(21:30,14:26);
   m10_pooling=max(max(m10));
   diff_matrix_pooling(1,10)=m10_pooling;
   
   m11=diff_matrix_sum(21:30,27:39);
   m11_pooling=max(max(m11));
   diff_matrix_pooling(1,11)=m11_pooling;
   
   m12=diff_matrix_sum(21:30,40:52);
   m12_pooling=max(max(m12));
   diff_matrix_pooling(1,12)=m12_pooling;
   
   m13=diff_matrix_sum(31:40,1:13);
   m13_pooling=max(max(m13));
   diff_matrix_pooling(1,13)=m13_pooling;
   
   m14=diff_matrix_sum(31:40,14:26);
   m14_pooling=max(max(m14));
   diff_matrix_pooling(1,14)=m14_pooling;
   
   m15=diff_matrix_sum(31:40,27:39);
   m15_pooling=max(max(m15));
   diff_matrix_pooling(1,15)=m15_pooling;
   
   m16=diff_matrix_sum(31:40,40:52);
   m16_pooling=max(max(m16));
   diff_matrix_pooling(1,16)=m16_pooling;
   
   m17=diff_matrix_sum(41:50,1:13);
   m17_pooling=max(max(m17));
   diff_matrix_pooling(1,17)=m17_pooling;
   
   m18=diff_matrix_sum(41:50,14:26);
   m18_pooling=max(max(m18));
   diff_matrix_pooling(1,18)=m18_pooling;
   
   m19=diff_matrix_sum(41:50,27:39);
   m19_pooling=max(max(m19));
   diff_matrix_pooling(1,19)=m19_pooling;
   
   m20=diff_matrix_sum(41:50,40:52);
   m20_pooling=max(max(m20));
   diff_matrix_pooling(1,20)=m20_pooling;
   
   
   video_name_set=strsplit(video_name,'_');
   video_number=video_name_set{1,2};
   shot_number=video_name_set{1,3};
   object_number=video_name_set{1,4};
   
   
   lable_set=load(strcat('D:\精子显微分析各种数据集\筛选目标\',video_number,'\s_',video_number,'_',shot_number,'\s_',video_number,'_',shot_number,'_lable.mat'));
   
   A=object_number(2);
   A=str2num(A);
   if A==0
      object_real_number=object_number(3);
   else
      object_real_number=object_number(2:3); 
   end
   object_real_number=str2num(object_real_number);
 
   diff_matrix_pooling_lable=lable_set.lable(object_real_number);
   diff_matrix_pooling(1,21)=diff_matrix_pooling_lable;
   
   Diff_matrix_pooling(i,1:21)=diff_matrix_pooling;
   
   
   save(['D:\精子显微分析各种数据集\筛选目标\object_videos\50_52_size_dynamic_texture_feature_vector\',video_name,'.mat'],'diff_matrix_pooling')
   
end

save(['D:\精子显微分析各种数据集\筛选目标\object_videos\50_52_size_dynamic_texture_feature_vector\A所有向量的集和.mat'],'Diff_matrix_pooling');

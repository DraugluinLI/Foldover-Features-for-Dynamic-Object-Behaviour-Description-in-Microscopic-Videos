clc;
clear;
close all;

data=load('S_00004_001_27to67_C3.mat');
Match_res=struct('cents',struct('cent1',zeros(1,2),'cent2',zeros(1,2)));



for i=27:66
    
    fcents1=data.features(i).Cent;%The center of mass of the previous frame of each figure is taken out and is a 35 by 1 matrix
    a=i+1;
    fcents2=data.features(a).Cent;%The center of gravity of the next frame of each image is taken out and is a 35 by 1 matrix
    
    fareas1=data.features(i).Area;%The area of the previous frame of each image is taken out, and it is a matrix of 35 by 1
    b=i+1;
    fareas2=data.features(b).Area;%The area of the next frame of each image is taken out, and it is a matrix of 35 by 1
    

   % [~,a1]=size(fcents1);
   % [~,a2]=size(fcents2);
    
    %ÎÒ¸ÄµÄ
    [m1,n1]=size(fcents1);
    [m2,n2]=size(fcents2);


    for j=1:m2
        %Record the barycenter position of each object in the next frame
        x2=fcents2(j).Centroid(1);
        y2=fcents2(j).Centroid(2);
        s=20;
        for k=1:m1
            %Record the barycenter position of each object in the previous frame
            x1=fcents1(k).Centroid(1);
            y1=fcents1(k).Centroid(2);
            
            s_new=sqrt((x2-x1)^2+(y2-y1)^2);
            
            if s_new<s    
                s=s_new;
                h2_1=x1;
                w2_1=y1;
            end
            
        
            
        end
        
%         Match_res(i-141).cents(i).cent2(1)=x2;
%      	  Match_res(i-141).cents(i).cent2(2)=y2;
%         Match_res(i-141).cents(i).cent1(1)=h2_1;
%         Match_res(i-141).cents(i).cent1(2)=w2_1;
        Match_res(i).cents(i).cent2(j,1)=x2;
     	Match_res(i).cents(i).cent2(j,2)=y2;
        Match_res(i).cents(i).cent1(j,1)=h2_1;
        Match_res(i).cents(i).cent1(j,2)=w2_1;
    end
        

end

clear;
close all;
clc;
%% The video is broken down into frames


%Construct a VideoReader object associated with the sample file, xylophone.mp4.
vidObj = VideoReader('S_00001.mp4');

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
    imshow(s(k).cdata);
    k = k+1;
   
end
%%The following actions save images frame by frame
for i=1:k-1
 I=s(i).cdata;
 %imshow(I);
 filepath=pwd;           %Save the current working directory
 cd('D:\精子显微分析各种数据集\46号视频所有数据集\s_0046_framepic')          %Switches the current working directory to the specified folder
 imwrite(I,strcat('D:s_0046_',num2str(i),'.jpg'));
 cd(filepath)            %Cut back to the original working directory
end











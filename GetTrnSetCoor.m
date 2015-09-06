function [Xu,TrnImgFiles]=GetTrnSetCoor(NumLandMarkPts,ContoursEndingPoints)
%function Xu=GetTrnSetCoor(NumLandMarkPts)


ind1=1;


    directory_name=[];   
% % 选择目录
% directory_name = uigetdir(start_path)：在start_path指定的目录文件夹中打开对话框。如果start_path是一个有效的路径，
%则对话框将打开指定的路径，如果start_path是一个空字符串（‘’），则对话框将打开当前目录路径，如果start_path是一个无效的路径，对话框将打开根目录的路径。
%directory_name = uigetdir('F:\MATLAB71\work\facedata');
%directory_name = uigetdir('D:\matlab R2010b\work\asm81\orl');
%directory_name = uigetdir('F:\ASM\asm81\IMM人脸库');
directory_name = uigetdir('F:\医学图像\LiverData\LiverData\test');
if directory_name==0
    TrnImgFiles={};
    msgbox('cancel first'); return;
end
%dir(name)列举特定的文件。name参数可以是路径名称、文件名称或路径名称+文件名称。用户可以使用绝对路径、相对路径和通配符(*)。
files = dir(strcat(directory_name,'\*.BMP'));
%files = dir(strcat(directory_name,'\*.dcm'));

NumTrnSetImgs=length(files);
if NumTrnSetImgs==0
    msgbox('No bmp file here. Exit');
    return;
end

Button1=questdlg('已存在部分标点结果？','ASM');
if(strcmp(Button1,'Yes')) % 有一部分图像已经标过点了，打开标点文件。文件夹中的一部分图像的标点结果在标点文件中。
    [fname,pname]=uigetfile('*.mat','读入已标点文件');    
    %uigetfile是基于图形用户界面（GUI）的。会弹出对话框，列出当前目录的文件和目录，提示你选择一个文件。
    %UIGETFILE让你选择一个文件来写（类似Windows ‘另存为’选项？）。用UIGETFILE，可以选择已存在的文件改写，也可以输入
    %新的文件名。两个函数的返回值是所选文件名和路径。

    load([pname,fname]);
elseif(strcmp(Button1,'No'))
   % [fname,pname] = uiputfile('*.mat', '保存标点结果');
    TrnImgFiles={};
    Xu=[];
else
    msgbox('cancel');
    return;
end



    


while ind1<=NumTrnSetImgs,
   FileName=files(ind1).name;
   PathName=strcat(directory_name,'\');  
   
   % 如果标点文件中已经有了这个图像的标点数据，则跳过这个图像
   skip=0;
   for i=1:1:length(TrnImgFiles)
       if strcmp(TrnImgFiles{i},strcat(PathName,FileName))
           skip=1;
           break;
       end
   end
   if skip==1
       ind1=ind1+1;
       continue;
   end
   
   Img=imread([PathName,FileName]);         %按照路径读取图像文件,返回这个图像的数组信息
   [Y,X]=landmark(Img,['需要标记的文件名: ',num2str(ind1)],NumLandMarkPts);%标记图像，并返回被标记点的坐标
   
   
   button2=questdlg('保存这副图像的标点结果','save');
   if strcmp(button2,'Yes')
       TrnImgFiles=[TrnImgFiles;{[PathName,FileName]}];
       Xu=[Xu,[round(X);round(Y)]];
       %save([pname,fname],'Xu','TrnImgFiles','ContoursEndingPoints','NumLandMarkPts');
       %save('D:\matlab R2010b\work\face\face','Xu','TrnImgFiles','ContoursEndingPoints','NumLandMarkPts');
       save('F:\医学图像\LiverData\LiverData\test','Xu','TrnImgFiles','ContoursEndingPoints','NumLandMarkPts');
      %save('D:\matlab R2010b\work\asm81\orl\dadian2','Xu','TrnImgFiles','ContoursEndingPoints','NumLandMarkPts');
       ind1=ind1+1;
   end
end
close;



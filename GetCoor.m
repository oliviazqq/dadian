% 打点文件
directory_name = uigetdir('F:\my_multipie1','Open a Diretory');
if directory_name==0
    msgbox('cancel first'); return;
end
files = dir(strcat(directory_name,'\*.jpg'));
NumCoorImgs=length(files);
if NumCoorImgs==0
    msgbox('No bmp file here. Exit');
    return;
end
ind1 = 1;
PathName = strcat(directory_name,'\');
NumLandMarkPts=28;
while ind1<=NumCoorImgs
    FileName=files(ind1).name;
    Img=imread([PathName,FileName]);         %按照路径读取图像文件,返回这个图像的数组信息
    [Y,X]=landmark(Img,ind1,NumLandMarkPts);%标记图像，并返回被标记点的坐标
    pts(:,1)=X;
    pts(:,2)=Y;
    [fileDirectory saveparts extension] = fileparts(FileName);
    saveLm = strcat(saveparts,'_','lm','.mat');
    save(['F:\my_annotation\',saveLm],'pts');
    ind1 = ind1+1;
    
end

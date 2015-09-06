function [X,Y]=landmark(I,T,L);
%landmark the image I
%usage
%landmark(I)
%landmark(I,T) T is a title
%landmark(I,T,L) L number of landmarks 
%landmark with right mouse button (or any button if L is specified)
%delete landmark closest to mouse cursor with the backspace key
%finish with (middle or) right mouse button (not valid when L is specified)
%first axis points down, 2nd points left (same as row then col)
%returns the X and Y coordinates

if nargin==1,
   T='';
end
 
X=[];
Y=[];

h=figure;grid on;
colormap(gray)
while 1
   figure(h);clf;hold off;
   imagesc(I);           %imagesc（imagescale）属于图像缩放函数  ,imagesc 函数显示灰度图像
   title([num2str(T),' - LM: ',num2str(length(X)),'(+1)']);
 % set(gcf,'Position',[3,35,1020,655]);     %设置当前图形窗口的position属性为[3,35,1020,655].position属性的取值是一个由4个元素构成的向量，其形式为
  set(gcf,'Position',[3,35,500,500]);     %[n1,n2,n3,n4],这个向量定义了图形窗口在屏幕上的位置和大小，其中n1和n2分别为对象左下角的横纵坐标值，n3和n4分别为图形窗口的宽度和高度。

 hold on                                  %保持当前图像        
 
 %plot(Y,X,'r-+');                       
   plot(Y,X,'*b');
   
   if (nargin==3)
      if(length(X)==L)       
         close(h);
         return; 
      end
   end   
   
   %the first coordinate is put in y
   %and the 2nd coordinate is put in x   
   %to follow the standard for a matrix
   %first axis points down, 2nd points left      
   [yc,xc,button]=myginput(1);
   if (button==2 | button==3) & (nargin<3) %finish
      close(h);
      return
   elseif button==32 %delete the closest
      [val,ind]=min((xc-X).^2  + (yc-Y).^2);
      X=X([1:ind-1 ind+1:end]');
      Y=Y([1:ind-1 ind+1:end]');
   else %landmark
      X=[X;xc];
      Y=[Y;yc];
   end
end


close(h);

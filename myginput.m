function [out1,out2,out3] = myginput(arg1)
%GINPUT Graphical input from mouse.
%   [X,Y] = GINPUT(N) gets N points from the current axes and returns 
%   the X- and Y-coordinates in length N vectors X and Y.  The cursor
%   can be positioned using a mouse (or by using the Arrow Keys on some 
%   systems).  Data points are entered by pressing a mouse button
%   or any key on the keyboard except carriage return, which terminates
%   the input before N points are entered.
%
%   [X,Y] = GINPUT gathers an unlimited number of points until the
%   return key is pressed.
% 
%   [X,Y,BUTTON] = GINPUT(N) returns a third result, BUTTON, that 
%   contains a vector of integers specifying which mouse button was
%   used (1,2,3 from left) or ASCII numbers if a key on the keyboard
%   was used.

%   Copyright 1984-2002 The MathWorks, Inc. 
%   $Revision: 5.32 $  $Date: 2002/04/14 13:20:49 $

out1 = []; out2 = []; out3 = []; y = [];
c = computer;
if ~strcmp(c(1:2),'PC')                     %根对象只具有信息存储的功能，其句柄永远为0.
   tp = get(0,'TerminalProtocol');        %查询根对象的TerminalProtocol属性取值，返回给tp.
   %用户可通过get函数获取图形对象的属性值，其调用格式为    V=get(句柄，属性名)
else
   tp = 'micro';
end

if ~strcmp(tp,'none') & ~strcmp(tp,'x') & ~strcmp(tp,'micro'),
   if nargout == 1,
      if nargin == 1,
         out1 = trmginput(arg1);
      else
         out1 = trmginput;
      end
   elseif nargout == 2 | nargout == 0,
      if nargin == 1,
         [out1,out2] = trmginput(arg1);
      else
         [out1,out2] = trmginput;
      end
      if  nargout == 0
         out1 = [ out1 out2 ];
      end
   elseif nargout == 3,
      if nargin == 1,
         [out1,out2,out3] = trmginput(arg1);
      else
         [out1,out2,out3] = trmginput;
      end
   end
else
   
   fig = gcf; %fig是当前视图句柄    gcf  获取当前图形窗口的句柄     gca  获取当前坐标轴的句柄   gco  获取最近被选中的图形对象的句柄 
   figure(gcf);%激活当前视图
   
   if nargin == 0
      how_many = -1;
      b = [];
   else
      how_many = arg1;
      b = [];
      if  isstr(how_many) ...
            | size(how_many,1) ~= 1 | size(how_many,2) ~= 1 ...
            | ~(fix(how_many) == how_many) ...
            | how_many < 0
         error('Requires a positive integer.')
      end
      if how_many == 0
         ptr_fig = 0;
         while(ptr_fig ~= fig)     %当ptr_fig不等于当前视图句柄时
            ptr_fig = get(0,'PointerWindow');    %查询根对象的PointerWindow属性取值，返回给 ptr_fig.
         end
         scrn_pt = get(0,'PointerLocation');    %查询根对象的PointerLocation属性取值，返回给scrn_pt.
         loc = get(fig,'Position');             %查询当前视图句柄的Position属性取值，返回给loc.
         pt = [scrn_pt(1) - loc(1), scrn_pt(2) - loc(2)];
         out1 = pt(1); y = pt(2);
      elseif how_many < 0
         error('Argument must be a positive integer.')
      end
   end
   
   % Remove figure button functions
   state = uisuspend(fig);%储存老的视图信息
   pointer = get(gcf,'pointer');      %查询当前图形窗口句柄的pointer属性取值，返回给pointer.
   set(gcf,'pointer','crosshair');     %设置当前图形窗口的句柄的pointer 属性取值为crosshair(十字)
   fig_units = get(fig,'units');       %查询当前视图句柄的units 属性取值，返回给fig_units.
   char = 0;
   
   while how_many ~= 0
      % Use no-side effect WAITFORBUTTONPRESS
      waserr = 0;
      try
	keydown = wfbp;          %wfbp表示 等待按下鼠标
      catch
	waserr = 1;
      end
      if(waserr == 1)
         if(ishandle(fig))         %如果fig是图形句柄，则
            set(fig,'units',fig_units);   %设置当前视图句柄的units属性取值为fig_units的值
	    uirestore(state);        %重设为老的设置
            error('Interrupted');
         else
            error('Interrupted by figure deletion');
         end
      end
      
      ptr_fig = get(0,'CurrentFigure');    %查询根对象的CurrentFigure属性取值，返回给 ptr_fig.
      if(ptr_fig == fig)     %如果ptr_fig为当前视图
         if keydown             %按下键盘
            char = get(fig, 'CurrentCharacter');    %查询当前视图句柄的CurrentCharacter属性取值，返回给char.
            button = abs(get(fig, 'CurrentCharacter')); %查询当前视图的CurrentCharacter属性取值，并计算其绝对值或向量的长度，返回给button.
            scrn_pt = get(0, 'PointerLocation');   %查询根对象的PointerLocation属性取值，返回给scrn_pt.
            set(fig,'units','pixels')       %设置当前视图的units属性为pixel（像素）
            loc = get(fig, 'Position');     %查询当前视图的Position属性取值，返回给loc.
            pt = [scrn_pt(1) - loc(1), scrn_pt(2) - loc(2)];
            set(fig,'CurrentPoint',pt);    %设置当前视图的CurrentPoint属性取值为pt的值
         else
            button = get(fig, 'SelectionType');   %查询当前视图句柄的SelectionType（选择类型）属性取值，返回给button.
            if strcmp(button,'open')
               button = b(length(b));
            elseif strcmp(button,'normal')
               button = 1;
            elseif strcmp(button,'extend')
               button = 2;
            elseif strcmp(button,'alt')
               button = 3;
            else
               error('Invalid mouse selection.')
            end
         end
         pt = get(gca, 'CurrentPoint');  %查询当前图形窗口句柄的CurrentPoint（当前点）属性取值，返回给pt.
         
         how_many = how_many - 1;
         
         if(char == 13) % & how_many ~= 0)
            % if the return key was pressed, char will == 13,
            % and that's our signal to break out of here whether
            % or not we have collected all the requested data
            % points.  
            % If this was an early breakout, don't include
            % the <Return> key info in the return arrays.
            % We will no longer count it if it's the last input.
            break;
         end
         
         out1 = [out1;pt(1,1)];
         y = [y;pt(1,2)];
         b = [b;button];
      end
   end
   
   uirestore(state);        %重设为老的设置
   set(fig,'units',fig_units);        %设置当前视图的 units 的特征值为fig_units的值
   
   if nargout > 1
      out2 = y;
      if nargout > 2
         out3 = b;
      end
   else
      out1 = [out1 y];
   end
   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function key = wfbp             %等待按下鼠标
%WFBP   Replacement for WAITFORBUTTONPRESS that has no side effects.

fig = gcf;         %fig是当前视图句柄    gcf  获取当前图形窗口的句柄
current_char = [];

% Now wait for that button press, and check for error conditions
waserr = 0;
try
  h=findall(fig,'type','uimenu','accel','C');   % Disabling ^C for edit menu so the only ^C is for
  set(h,'accel','');                            % interrupting the function.
  keydown = waitforbuttonpress;
  current_char = double(get(fig,'CurrentCharacter')); % Capturing the character.
  if~isempty(current_char) & (keydown == 1)           % If the character was generated by the 
	  if(current_char == 3)                       % current keypress AND is ^C, set 'waserr'to 1
		  waserr = 1;                             % so that it errors out. 
	  end
  end
  
  set(h,'accel','C');                                 % Set back the accelerator for edit menu.
catch
  waserr = 1;
end
drawnow;
if(waserr == 1)
   set(h,'accel','C');                                % Set back the accelerator if it errored out.
   error('Interrupted');
end

if nargout>0, key = keydown; end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

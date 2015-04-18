function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 18-Apr-2015 15:56:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)
handles.image = imread(varargin{1});
axes(handles.axes1)
imshow(handles.image)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
global count;
count = 1;


% --- Executes on button press in add_boundary_button.
function add_boundary_button_Callback(hObject, eventdata, handles)
% hObject    handle to add_boundary_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global count;
if isempty(count)
   count = 1;
end

handles.h = imfreehand(gca);
setClosed(handles.h,false);


if isempty('handles.boundaries')
    handles.boundaries = cell(1);
end
Pos = getPosition(handles.h);
X = Pos(:,1);
Y = Pos(:,2);

%domain = [min(X):0.1:max(X)];
%[X,Y] = interpolate(X,Y);

handles.boundaries{count} = [X Y];

fprintf('----\n')
for j = 1:count
    size(handles.boundaries{j})
end

delete(handles.h);

hold on;
plot(X,Y,'ro-');

count = count + 1;

guidata(hObject, handles); 


% --- Executes on button press in finishboundaries.
function finishboundaries_Callback(hObject, eventdata, handles)
% hObject    handle to finishboundaries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% if ~exist('handles.boundaries')
%     fprintf('Enter a boundry before finishing\n');
%     return;
% end

handles.h = 0;
num_partitions = 8;
handles.lambda = 10;
%now partition boundaries
if ~exist('handles.partitions_B')
    [handles.partitions_B, handles.partitions_alt] = partitionBoundaries(handles.boundaries,num_partitions);
end

fprintf('Number of points in boundary: %d\n', length(handles.boundaries{1}));
original_axes = [get(gca,'XLim') get(gca,'YLim')];
handles.quad_source_points = cell(1,length(handles.boundaries));
handles.points_on_objects = zeros(length(handles.boundaries),2);

for curr_boundary = 1:length(handles.partitions_alt)
    
    min_x = inf;
    max_x = -inf;
    min_y = inf;
    max_y = -inf;
    
    for curr_partition = 1:length(handles.partitions_alt{curr_boundary})
        x_part = handles.partitions_alt{curr_boundary}{curr_partition}(:,1);
        y_part = handles.partitions_alt{curr_boundary}{curr_partition}(:,2);
         plot(x_part,y_part,'go');
  
         
         limit = 10;
         axis([min(x_part) - limit, max(x_part) + limit, min(y_part) - limit, max(y_part) + limit]);
         
         min_x = min(min(x_part),min_x);
         min_y = min(min(y_part),min_y);
         max_x = max(max(x_part),max_x);
         max_y = max(max(y_part),max_y);

         point_a = impoint();
         point_b = impoint();
         point_c = impoint();
         
         handles.quad_source_points{curr_boundary} = [handles.quad_source_points{curr_boundary}; 
                                                      point_a.getPosition();
                                                      point_b.getPosition();
                                                      point_c.getPosition();];
         
         neg_normal_dir = impoint();
         handles.neg_normal_directions{curr_boundary}{curr_partition} = neg_normal_dir.getPosition();
         pause(.5);
         delete(point_a);
         delete(point_b);
         delete(point_c);
         delete(neg_normal_dir);
                 
         plot(x_part,y_part,'ro');
    end
    
    axis([min_x,max_x,min_y,max_y]);
    p = impoint();
    handles.points_on_objects(curr_boundary,:) = p.getPosition();
    delete(p);
end
axis(original_axes);

[Norms,normals_alt, quad_aprox_handles] = findNormals(handles.partitions_B, num_partitions, handles.quad_source_points, handles.neg_normal_directions);
handles.normals = Norms;
handles.normals_alt = normals_alt;
handles.quad_aprox_handles = quad_aprox_handles;

% Plotting the normal
normal_mult = 6;
for i = 1:length(normals_alt)
    for j = 1:length(normals_alt{i})
        for k = 1:length(normals_alt{i}{j})        
            point_1 = handles.partitions_alt{i}{j}(k,:);
            point_2 = normal_mult * normals_alt{i}{j}(k,:) + point_1;
            
            handles.normal_handles{i}{j}{k} = plot([point_1(1) point_2(1)],[point_1(2) point_2(2)],'-g')
            set(handles.normal_handles{i}{j}{k}, 'visible', 'off');
        end
    end
end

%get intensities
handles.intensities = find_intensity(Norms,handles.partitions_B,num_partitions,handles.image);

%get C
handles.C_matrices = cell(length(handles.boundaries),1);
for i = 1:length(handles.C_matrices)
   handles.C_matrices{i} = getC(num_partitions);
end

%get light direction vectors
handles.V_vectors = cell(length(handles.boundaries),1);
for i = 1:length(handles.V_vectors)
    %making separate variables for clarity
    M = handles.normals{i};
    C = handles.C_matrices{i};
    b = handles.intensities{i};
    lambda = handles.lambda;

    handles.V_vectors{i} = pinv((M'*M+lambda*(C'*C)))*M'*b; 
end

for i = 1:length(handles.V_vectors)
    v = handles.V_vectors{i};
    x_comp = mean(v(1:2:end - 1));
    y_comp = mean(v(2:2:end - 1));
    source_point = handles.points_on_objects(i,:);
    
    direction = 1500*[x_comp,y_comp];
    axis(gca);
    quiver(source_point(1), source_point(2),direction(1),direction(2),0,'Color','y','LineWidth',4,'MaxHeadSize',1);

    angle = getAngle(source_point, source_point + direction);
    fprintf('*** \tLight direction: %d degrees south of west \t***\n', angle);
   
end

guidata(hObject, handles); 


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1

state = get(hObject,'Value');

for i = 1:length(handles.normals_alt)
    for j = 1:length(handles.normals_alt{i})
        for k = 1:length(handles.normals_alt{i}{j})        
            if state
                set(handles.normal_handles{i}{j}{k}, 'visible', 'on');
            else
                set(handles.normal_handles{i}{j}{k}, 'visible', 'off');
            end
        end
    end
end

guidata(hObject, handles); 


% --- Executes on button press in togglebutton3.
function togglebutton3_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton3
state = get(hObject, 'Value');

for i = 1:length(handles.normals_alt)
    for j = 1:length(handles.normals_alt{i})
        if state
            set(handles.quad_aprox_handles{i}{j}, 'visible', 'on');
        else
            set(handles.quad_aprox_handles{i}{j}, 'visible', 'off');
        end
        pause()
        if ~state
            set(handles.quad_aprox_handles{i}{j}, 'visible', 'on');
        else
            set(handles.quad_aprox_handles{i}{j}, 'visible', 'off');
        end
    end
end

guidata(hObject, handles); 

function [angle] = getAngle(b,a)
    adj = a(1) - b(1);
    hyp = norm(a - b);
    angle = acosd(adj / hyp);
    angle = fix(angle);

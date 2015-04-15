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

% Last Modified by GUIDE v2.5 14-Apr-2015 13:29:00

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
handles.h = 0;
num_partitions = 3;
handles.lambda = 10;
%now partition boundaries
if ~exist('handles.partitions_B')
    [handles.partitions_B, handles.partitions_alt] = partitionBoundaries(handles.boundaries,num_partitions);
end

fprintf('Number of points in boundary: %d\n', length(handles.boundaries{1}));
original_axes = [get(gca,'XLim') get(gca,'YLim')];
handles.quad_source_points = cell(1,length(handles.boundaries));
handles.directional_points = zeros(length(handles.boundaries),2);

for curr_boundary = 1:length(handles.partitions_alt)
    
    min_x = inf;
    max_x = -inf;
    min_y = inf;
    max_y = -inf;
    
    for curr_partition = 1:length(handles.partitions_alt{curr_boundary})
        x = handles.partitions_alt{curr_boundary}{curr_partition}(:,1);
        y = handles.partitions_alt{curr_boundary}{curr_partition}(:,2);
         plot(x,y,'go');
         
         limit = 10;
         axis([min(x) - limit, max(x) + limit, min(y) - limit, max(y) + limit]);
         
         min_x = min(min(x),min_x);
         min_y = min(min(y),min_y);
         max_x = max(max(x),max_x);
         max_y = max(max(y),max_y);
         
         
         
         point_a = impoint();
         point_b = impoint();
         point_c = impoint();
         
         handles.quad_source_points{curr_boundary} = [handles.quad_source_points{curr_boundary}; 
                                                      point_a.getPosition();
                                                      point_b.getPosition();
                                                      point_c.getPosition();];
         
         pause(.5);
         delete(point_a);
         delete(point_b);
         delete(point_c);
                 
         plot(x,y,'ro');
    end
    
    axis([min_x,max_x,min_y,max_y]);
    p = impoint();
    handles.directional_points(curr_boundary,:) = p.getPosition();
    delete(p);
end
axis(original_axes);

[Norms,normals_alt] = findNormals(handles.partitions_B, num_partitions, handles.quad_source_points,handles.directional_points);
handles.normals = Norms;

for i = 1:length(normals_alt)
    for j = 1:length(normals_alt{i})
        for k = 1:length(normals_alt{i}{j})        
            point_1 = handles.partitions_alt{i}{j}(k,:);
            point_2 = 6*normals_alt{i}{j}(k,:) + point_1;
            
            plot([point_1(1) point_2(1)],[point_1(2) point_2(2)],'-g')
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
    point_1 = [10 10];
    point_2 = point_1 + 10*[x_comp y_comp];
    plot([point_1(1)],[point_1(2)],'go')
    plot([point_2(1)],[point_2(2)],'ro')

    plot([point_1(1) point_2(1)],[point_1(2) point_2(2)],'-y')
    
end

guidata(hObject, handles); 
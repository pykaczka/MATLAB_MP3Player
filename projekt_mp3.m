function varargout = projekt_mp3(varargin)
% PROJEKT_MP3 MATLAB code for projekt_mp3.fig
%      PROJEKT_MP3, by itself, creates a new PROJEKT_MP3 or raises the existing
%      singleton*.
%
%      H = PROJEKT_MP3 returns the handle to a new PROJEKT_MP3 or the handle to
%      the existing singleton*.
%
%      PROJEKT_MP3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJEKT_MP3.M with the given input arguments.
%
%      PROJEKT_MP3('Property','Value',...) creates a new PROJEKT_MP3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before projekt_mp3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to projekt_mp3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help projekt_mp3

% Last Modified by GUIDE v2.5 20-Jan-2016 14:16:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @projekt_mp3_OpeningFcn, ...
                   'gui_OutputFcn',  @projekt_mp3_OutputFcn, ...
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


% --- Executes just before projekt_mp3 is made visible.
function projekt_mp3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to projekt_mp3 (see VARARGIN)

global flaga;
flaga=1;

set(handles.rb1,'Value',1);
% Choose default command line output for projekt_mp3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes projekt_mp3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = projekt_mp3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in wczytaj_muzyke.
function wczytaj_muzyke_Callback(hObject, eventdata, handles)
% hObject    handle to wczytaj_muzyke (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path=get(handles.edit,'String');
tmp=[path '\*.mp3'];
lista = dir(tmp);
tmp2{1}=0;
if length(lista)==0
    set(handles.play,'Enable','off');
    set(handles.stop,'Enable','off');
    set(handles.pause,'Enable','off');
    set(handles.next,'Enable','off');
    set(handles.prev,'Enable','off');
else
    set(handles.play,'Enable','on');
    set(handles.stop,'Enable','on');
    set(handles.pause,'Enable','on');
    set(handles.next,'Enable','on');
    set(handles.prev,'Enable','on');
    for i=1:length(lista)
        tmp2{i}=lista(i).name;
    end
end
set(handles.songs,'String',tmp2);



% --- Executes on button press in play.
function play_Callback(hObject, eventdata,handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set(handles.text, 'String', path2);
global flaga;
if(flaga==1)
    lista=get(handles.songs,'String');
    if(size(lista)==0)
        warndlg('wczytaj piosenki z wybranego katalogu przed uruchomieniem odtwarzania');
    else
        index=get(handles.songs,'Value');
        tmp=lista(index);
        
        path=fullfile(get(handles.edit,'String'), tmp{1})
        [y, Fs]=audioread(path);
        Fs=Fs*str2num(get(get(handles.rb,'SelectedObject'),'String'));
        
        global player;
        player=audioplayer(y, Fs);
        t=0:1/Fs:(length(y)-1)/Fs;
        axes(handles.wykres);
        play(player);
        flaga=0;
        while player.Running & flaga==0
            axis([t(player.CurrentSample)-3 t(player.CurrentSample) -1 1]);
            p=plot(t(player.CurrentSample),y(player.CurrentSample),'o','EraseMode','none');
            set(p,'XData',t(player.CurrentSample),'YData',y(player.CurrentSample));
            drawnow;
            grid on;
            hold on;
        end
        if flaga==0
            next_Callback(hObject, eventdata, handles);
        end
    end
else
    flaga=0;
    global player;
    resume(player);
end


% --- Executes on button press in pause.
function pause_Callback(hObject, eventdata, handles)
% hObject    handle to pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flaga;
if flaga==0
    global player;
    pause(player);
end




% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flaga;
if flaga==0
    global player;
    stop(player);
    cla(handles.wykres);
    global flaga;
    flaga=1;
end



% --- Executes on button press in prev.
function prev_Callback(hObject, eventdata, handles)
% hObject    handle to prev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop_Callback(hObject, eventdata, handles);

index=get(handles.songs,'Value');
lista=get(handles.songs,'String');
if(index-1<1)
    i=size(lista);
    tmp=lista(i(1));
    set(handles.songs, 'Value',i(1));
else 
    tmp=lista(index-1);
    set(handles.songs, 'Value',index-1);
end
play_Callback(hObject, eventdata, handles);

% --- Executes on button press in next.
function next_Callback(hObject, eventdata,handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop_Callback(hObject, eventdata, handles);

index=get(handles.songs,'Value');
lista=get(handles.songs,'String');
if(index+1>size(lista))
    tmp=lista(1);
    set(handles.songs, 'Value',1);
else 
    tmp=lista(index+1);
    set(handles.songs, 'Value',index+1);
end

play_Callback(hObject, eventdata, handles);



% --- Executes on selection change in songs.
function songs_Callback(hObject, eventdata, handles)
% hObject    handle to songs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns songs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from songs

% if(isempty(get(handles.songs,'Value')))
%     warndlg('wczytaj piosenki z wybranego katalogu przed uruchomieniem odtwarzania');
% end

% --- Executes during object creation, after setting all properties.
function songs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to songs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on songs and none of its controls.
function songs_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to songs (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



function edit_Callback(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit as text
%        str2double(get(hObject,'String')) returns contents of edit as a double
if(isempty(get(handles.edit,'String')))
    set(handles.edit,'String','C:\Users\Public\Music\Sample Music\');
end;

% --- Executes during object creation, after setting all properties.
function edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function play_CreateFcn(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global flaga;
% global player;
% if flaga==2
%     play_Callback(hObject, eventdata, handles);
% end
stop_Callback(hObject, eventdata, handles);
global flaga;
flaga=2;
close(handles.figure1);

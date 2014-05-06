function PD_Analysis
%Close all current figures
close all;

%  Create and then hide the GUI as it is being constructed.
fig1 = figure('Visible','off','Position',[100,100,640,480], 'name',...
    'Partial Discharge Characterization Tool - T.Smith & D.Mahmoodi',...
    'NumberTitle', 'off');

% ---  Construct the components.

%Title decleration
htitle = uicontrol('Style','text','String',...
    'Partial Discharge Characterisation Tool',...
    'Position',[0,450,420,30], 'FontSize', 18,...
    'HorizontalAlignment', 'left',...
    'BackgroundColor', [0.8 0.8 0.8]);
%UoS Logo
hlogo = axes('Units','Pixels','Position',[440,340,200,185]);
imshow('uoslogogrey.jpg');
%Open Button
hopen = uicontrol('Style','pushbutton','String','Open File',...
    'Position',[425,350,75,25],'BackgroundColor', [0.9 0.9 0.9],...
    'Callback',{@openbtn_Callback});
%Run Button
hrun  = uicontrol('Style','pushbutton','String','Run PSA',...
    'Position',[425,300,75,25],'BackgroundColor', [0.9 0.9 0.9],...
    'Callback',{@runbtn_Callback});
%File text
hfile = uicontrol('Style','text','String','Select a File to Proceed',...
    'HorizontalAlignment', 'left',...
    'BackgroundColor', [0.8 0.8 0.8],...
    'Position',[510,345,130,25]);
%Drop Down Menu
hpopup = uicontrol('Style','popupmenu',...
    'String',{'Delta U','Delta T','Delta U & Delta T','Voltage - Time'},...
    'Position',[425,250,200,25],...
    'Callback',{@popup_menu_Callback});
%Axes
ha = axes('Units','Pixels','Position',[50,50,350,350]);

% Move the GUI to the center of the screen.
movegui(fig1,'center')

% Make the GUI visible.
set(fig1,'Visible','on');


% --- Define Global Variables
FileName = 0;
PathName = 0;
Voltage = 0;
Du = 0;
Dt = 0;
Du1(1) = 0;
Dt1(1) = 0;
Div = 0;
Div1 = 0;
Time = 0;
FullPathName = 0;

% --- Executes on button press in hopen.
    function openbtn_Callback(source,eventdata)
        [FileName,PathName] = uigetfile({'*.txt'},'Select the Partial Discharge Data file for analysis');
        if isequal(FileName,0)
            errordlg('No File Selected','File Error');
            set(hfile, 'String', 'Select a File to Proceed');
        else
            FullPathName = strcat(PathName, FileName);
            set(hfile, 'String', FileName);
            if (isempty(strfind(FileName, '.txt')))
                warndlg('File selected is not a supported data format','Format Warning');
            end%if
        end%ifelse
    end %function

% --- Executes on button press in hrun
function runbtn_Callback(source, eventdata)
    if isequal(FileName,0)
        errordlg('No File Selected - select a file for analysis','File Error');
        set(hfile, 'String', 'Select a File to Proceed');
    else
        %Import the voltage file (assumed mV following discussion during
        %lecture on 06/05/2014)
        Voltage = importdata(FullPathName);
        %Evenly distribute the time - we know it is 1 second
        Time = transpose(linspace(0,1,length(Voltage)));
        
        %Filter the Variables to find the PD peaks
        PD_Threshold = 1;
        Time = Time(abs(Voltage)>PD_Threshold);
        Voltage = Voltage(abs(Voltage)>PD_Threshold);
        
        %Generate the delta variables
        for i = 1:(length(Voltage)-1)
            Du(i) = Voltage(i+1)-Voltage(i);
            Dt(i) = Time(i+1)-Time(i);
        end
        
        %Generate the +1 variables
        for i = 1:length(Du)
            Du1(i+1) = Du(i);
            Dt1(i+1) = Dt(i);
        end
        
        %Get rid of beginning and end as they are duplicated/obsolete
        Du1(1) = [];
        Dt1(1) = [];
        Du(1) = [];
        Dt(1)=[];
        Dt1(length(Dt1)) = [];
        Du1(length(Du1)) = [];
        
        for i = 1:length(Du)
            Div(i) = Du(i)/Dt(i);
            Div1(i) = Du1(i)/Dt1(i);
        end
        
        %These for loops put the values into the workspace for debugging
        for i = 1:length(Time)
            assignin('base', 'Time', Time);
            assignin('base', 'Voltage', Voltage);
        end
        for i = 1:length(Du)
            assignin('base', 'Du', Du);
            assignin('base', 'Dt', Dt);
        end
        for i = 1:length(Du1)
            assignin('base', 'Du1', Du1);
            assignin('base', 'Dt1', Dt1);
        end
        for i = 1:length(Div)
            assignin('base', 'Div', Div);
        end
        for i = 1:length(Div1)
            assignin('base', 'Div1', Div1);
        end
        
        %From popup function so it auto updates when run 
        popup_menu_Callback(hpopup, 1);
    end
end

%  Pop-up menu callback. Read the pop-up menu Value property to
%  determine which item is currently displayed and make it the
%  current data. This callback automatically has access to 
%  current_data because this function is nested at a lower level.
   function popup_menu_Callback(source,eventdata) 
      % Determine the selected data set.
      str = get(source, 'String');
      val = get(source,'Value');
      % Set current data to the selected data set.
      switch str{val};
      case 'Delta U' % User selects Peaks.
         scatter(Du, Du1, '.');
         title('Pulse Sequence Analysis - \DeltaU Graph');
         xlabel('\DeltaU_{n} (mV)');
         ylabel('\DeltaU_{n+1} (mV)');
      case 'Delta T' % User selects Membrane.
         scatter(Dt, Dt1, '.');
         title('Pulse Sequence Analysis - \DeltaT Graph');
         xlabel('\DeltaT_{n} (s)');
         ylabel('\DeltaT_{n+1} (s)');
      case 'Delta U & Delta T' % User selects Sinc.
         scatter(Div, Div1, '.');
         title('Pulse Sequence Analysis - \DeltaU/\DeltaT Graph');
         xlabel('\DeltaU_{n+1}/\DeltaT_{n}');
         ylabel('\DeltaU_{n}/\DeltaT_{n} (mV)');
      case 'Voltage - Time' % User selects Peaks.
         stem(Time, Voltage, '.', 'MarkerSize',0.1); 
         title('Filtered Data - Voltage Time Graph');
         xlabel('Time (s)');
         ylabel('Voltage (mV)');
      end
   end

end
function PD_Analysis
%Close all current figures
close all;

%  Create and then hide the GUI as it is being constructed.
fig1 = figure('Visible','off','Position',[100,100,660,485], 'name',...
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
U = 0;
dU = 0;
dT = 0;
dUm1(1) = 0;
dTm1(1) = 0;
Div = 0;
Div1 = 0;
T = 0;
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
        %Zero all variables in case of repeated PSA
        dU = 0;
        dT = 0;
        dUm1 = 0;
        dTm1 = 0;
        Div = 0;
        Div1 = 0;
        T = 0;
        
        %Import the voltage file (assumed mV following discussion during
        %lecture on 06/05/2014)
        U = importdata(FullPathName);
        %Evenly distribute the time - we know it is 1 second
        T = transpose(linspace(0,1,length(U)));
        
        %Filter the Variables to find the PD peaks
        PD_Threshold = 1;
        T = T(abs(U)>PD_Threshold);
        U = U(abs(U)>PD_Threshold);
        
        
        %dU(n) = U(n+1) - U(n)
        %dT(n) = T(n+1) - T(n)
        %Generate the delta variables
        for i = 1:(length(U)-1)
            dU(i) = U(i+1)-U(i);
            dT(i) = T(i+1)-T(i);
        end
        
        %dU(n-1) = U(n) - U(n-1)
        %Generate the -1 variables
        for i = 2:length(U) %start at 2 as U0 is not an index
            dUm1(i) = U(i) - U(i-1);
            dTm1(i) = T(i) - T(i-1);
        end
        
        %Delete index 1 of minus ones as they are unasigned
        dUm1(1) = [];
        dTm1(1) = [];
        %Also need to delete ends to make same length vectors
        dUm1(length(dUm1)) = [];
        dTm1(length(dTm1)) = [];
        %Delete vector 1 of the n values to keep offset
        dU(1) = [];
        dT(1) = [];
        
        %Calculate the divided values
        for i = 1:length(dU)
            Div(i) = dU(i)/dT(i);
            Div1(i) = dUm1(i)/dTm1(i);
        end
        
        %These for loops put the values into the workspace for debugging
        for i = 1:length(T)
            assignin('base', 'T', T);
            assignin('base', 'U', U);
        end
        for i = 1:length(dU)
            assignin('base', 'dU', dU);
            assignin('base', 'dT', dT);
        end
        for i = 1:length(dUm1)
            assignin('base', 'dUm1', dUm1);
            assignin('base', 'dTm1', dTm1);
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
         scatter(dU, dUm1, '.');
         title('Pulse Sequence Analysis - \DeltaU Graph');
         xlabel('\DeltaU_{n} (mV)');
         ylabel('\DeltaU_{n+1} (mV)');
      case 'Delta T' % User selects Membrane.
         scatter(dT, dTm1, '.');
         title('Pulse Sequence Analysis - \DeltaT Graph');
         xlabel('\DeltaT_{n} (s)');
         ylabel('\DeltaT_{n+1} (s)');
      case 'Delta U & Delta T' % User selects Sinc.
         scatter(Div, Div1, '.');
         title('Pulse Sequence Analysis - \DeltaU/\DeltaT Graph');
         xlabel('\DeltaU_{n+1}/\DeltaT_{n}');
         ylabel('\DeltaU_{n}/\DeltaT_{n} (mV)');
      case 'Voltage - Time' % User selects Peaks.
         stem(T, U, '.', 'MarkerSize',0.1); 
         title('Filtered Data - Voltage Time Graph');
         xlabel('Time (s)');
         ylabel('Voltage (mV)');
      end
   end
        

end
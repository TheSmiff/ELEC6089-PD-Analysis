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

%Run Recognition Button
hrec  = uicontrol('Style','pushbutton','String','Run Recognition',...
    'Position',[425,50,100,25],'BackgroundColor', [0.9 0.9 0.9],...
    'Callback',{@recbtn_Callback});
%File text
hfile = uicontrol('Style','text','String','Select a File to Proceed',...
    'HorizontalAlignment', 'left',...
    'BackgroundColor', [0.8 0.8 0.8],...
    'Position',[510,345,130,25]);
%Drop Down Menu
hpopup = uicontrol('Style','popupmenu',...
    'String',{'Delta U','Delta T','Delta U & Delta T','Voltage - Time','Voltage - Time 1 cycle'},...
    'Position',[425,250,200,25],...
    'Callback',{@popup_menu_Callback});
%Axes
ha = axes('Units','Pixels','Position',[65,50,350,350]);

%Open Corona Button
hopencor = uicontrol('Style','pushbutton','String','Open Corona File',...
    'Position',[425,200,100,25],'BackgroundColor', [0.9 0.9 0.9],...
    'Callback',{@opencorbtn_Callback});
%File text
hcor = uicontrol('Style','text','String','Corona1.txt',...
    'HorizontalAlignment', 'left',...
    'BackgroundColor', [0.8 0.8 0.8],...
    'Position',[535,195,130,25]);
%Open Button
hopensurf = uicontrol('Style','pushbutton','String','Open Surface File',...
    'Position',[425,150,100,25],'BackgroundColor', [0.9 0.9 0.9],...
    'Callback',{@opensurfbtn_Callback});
%File text
hsurf = uicontrol('Style','text','String','Surface2.txt',...
    'HorizontalAlignment', 'left',...
    'BackgroundColor', [0.8 0.8 0.8],...
    'Position',[535,145,130,25]);
%Open Button
hopenvoid = uicontrol('Style','pushbutton','String','Open Void File',...
    'Position',[425,100,100,25],'BackgroundColor', [0.9 0.9 0.9],...
    'Callback',{@openvoidbtn_Callback});
%File text
hvoid = uicontrol('Style','text','String','Void2.txt',...
    'HorizontalAlignment', 'left',...
    'BackgroundColor', [0.8 0.8 0.8],...
    'Position',[535,95,130,25]);


% Move the GUI to the center of the screen.
movegui(fig1,'center')

% Make the GUI visible.
set(fig1,'Visible','on');


% --- Define Global Variables
FileName = 0;
PathName = 0;
U = 0;
Uf = 0;
n = 0;
dU = 0;
dT = 0;
dUm1(1) = 0;
dTm1(1) = 0;
Div = 0;
Div1 = 0;
T = 0;
FullPathName = 0;
CoronaName = get(hcor, 'String');
CoronaPath = 0;
SurfaceName = get(hsurf, 'String');
SurfacePath = 0;
VoidName = get(hvoid, 'String');
VoidPath = 0;

% --- Executes on button press in hopen.
    function openbtn_Callback(source,eventdata)
        [FileName,PathName] = uigetfile({'*.txt'},'Select the Partial Discharge Data file for analysis');
        if isequal(FileName,0)
            errordlg('No File Selected','File Error');
            set(hfile, 'String', 'Select a File to Proceed');
        else
            FullPathName = strcat(PathName, FileName);
            CoronaPath = PathName;
            SurfacePath = PathName;
            VoidPath = PathName;
            set(hfile, 'String', FileName);
            if (isempty(strfind(FileName, '.txt')))
                warndlg('File selected is not a supported data format','Format Warning');
            end%if
        end%ifelse
    end %function

% --- Executes on button press in hopen.
    function opencorbtn_Callback(source,eventdata)
        [CoronaName,CoronaPath] = uigetfile({'*.txt'},'Select the Partial Discharge Data file for analysis');
        if isequal(CoronaName,0)
            errordlg('No File Selected','File Error');
            set(hcor, 'String', 'Select a File to Proceed');
        else
            set(hcor, 'String', CoronaName);
            if (isempty(strfind(CoronaName, '.txt')))
                warndlg('File selected is not a supported data format','Format Warning');
            end%if
        end%ifelse
    end %function

% --- Executes on button press in hopen.
    function opensurfbtn_Callback(source,eventdata)
        [SurfaceName,SurfacePath] = uigetfile({'*.txt'},'Select the Partial Discharge Data file for analysis');
        if isequal(SurfaceName,0)
            errordlg('No File Selected','File Error');
            set(hsurf, 'String', 'Select a File to Proceed');
        else
            set(hsurf, 'String', SurfaceName);
            if (isempty(strfind(SurfaceName, '.txt')))
                warndlg('File selected is not a supported data format','Format Warning');
            end%if
            warndlg('Check that all 6 stock files stored in same folder as file for analysis','Check Format');
        end%ifelse
    end %function

% --- Executes on button press in hopen.
    function openvoidbtn_Callback(source,eventdata)
        [VoidName,VoidPath] = uigetfile({'*.txt'},'Select the Partial Discharge Data file for analysis');
        if isequal(VoidName,0)
            errordlg('No File Selected','File Error');
            set(hvoid, 'String', 'Select a File to Proceed');
        else
            set(hvoid, 'String', VoidName);
            if (isempty(strfind(VoidName, '.txt')))
                warndlg('File selected is not a supported data format','Format Warning');
            end%if
            warndlg('Check that all 6 stock files stored in same folder as file for analysis','Check Format');
        end%ifelse
    end %function

% --- Executes on button press in hrun
function runbtn_Callback(source, eventdata)
    if isequal(FileName,0)
        errordlg('No File Selected - select a file for analysis','File Error');
        set(hfile, 'String', 'Select a File to Proceed');
    else
        [dU, dUm1, dT, dTm1, Div, Div1, T, U]= PSA(FullPathName);
        %Dump variables to workspace - debug
        %         for i = 1:length(dU)
        %             assignin('base', 'dU', dU);
        %             assignin('base', 'dT', dT);
        %         end
        %         for i = 1:length(dUm1)
        %             assignin('base', 'dUm1', dUm1);
        %             assignin('base', 'dTm1', dTm1);
        %         end
        %         for i = 1:length(Div)
        %             assignin('base', 'Div', Div);
        %         end
        %         for i = 1:length(Div1)
        %             assignin('base', 'Div1', Div1);
        %         end
        %         for i = 1:length(U)
        %             assignin('base', 'U', U);
        %             assignin('base', 'T', T);
        %         end
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
         scatter(dUm1, dU, '.');
         title('Pulse Sequence Analysis - \DeltaU Graph');
         xlabel('\DeltaU_{n-1} (mV)');
         ylabel('\DeltaU_{n} (mV)');
         axis([-2, 2, -2, 2]);
      case 'Delta T' % User selects Membrane.
         scatter(dTm1, dT, '.');
         title('Pulse Sequence Analysis - \DeltaT Graph');
         xlabel('\DeltaT_{n-1} (s)');
         ylabel('\DeltaT_{n} (s)');
      case 'Delta U & Delta T' % User selects Sinc.
         scatter(Div1, Div, '.');
         title('Pulse Sequence Analysis - \DeltaU/\DeltaT Graph');
         xlabel('\DeltaU_{n-1}/\DeltaT_{n-1}');
         ylabel('\DeltaU_{n}/\DeltaT_{n} (mV)');
      case 'Voltage - Time' % User selects Peaks.
         Wave = linspace(0,1, 500);
         SinWave = (sind((rem(Wave,0.02)*360)/0.02)*0.1)-1.1;
         stem(T, U, '.', 'MarkerSize',0.1);
         hold on
         plot(Wave, SinWave, '-r');
         hold off
         title('Filtered Data - Voltage Time Graph');
         xlabel('Time (s)');
         ylabel('Voltage (mV)');
         axis([0, 1, -1.2, 1]);
      case 'Voltage - Time 1 cycle' % User selects Peaks.
         Wave = linspace(0,1, 1000);
         SinWave = sind((rem(Wave,0.02)*360)/0.02);
         stem(T, U, '.', 'MarkerSize',0.1);
         hold on
         plot(Wave, SinWave, '-r');
         hold off
         title('Filtered Data - Voltage Time Graph');
         xlabel('Time (s)');
         ylabel('Voltage (mV)'); 
         v = axis;
         axis([0.02, 0.04, -1, 1]);
         hold off;
        
      end
   end
            
% --- Executes on button press in hrec
    function recbtn_Callback(source, eventdata)
        if isequal(CoronaName,0)
            errordlg('No Corona File Selected - select a file for analysis','File Error');
            set(hcor, 'String', 'Select a File to Proceed');
        else
            if isequal(SurfaceName,0)
                errordlg('No Surface File Selected - select a file for analysis','File Error');
                set(hsurf, 'String', 'Select a File to Proceed');
            else
                if isequal(VoidName,0)
                    errordlg('No Void File Selected - select a file for analysis','File Error');
                    set(hvoid, 'String', 'Select a File to Proceed');
                else
                    if isequal(FileName,0)
                        errordlg('No File Selected - select a file for analysis','File Error');
                        set(hfile, 'String', 'Select a File to Proceed');
                    else
                        clear dU dT dUm1 dTm1 Div Div1 T I If n U 
                        clear C.dU C.dUm1 C.dT C.dTm1 C.Div C.Div1
                        clear V.dU V.dUm1 V.dT V.dTm1 V.Div V.Div1S.dU
                        clear S.dUm1 S.dT S.dTm1 S.Div S.Div1
                        clear CdU SdU VdU CdT SdT SdV maxU dUpad dTpad
                        [C.dU, ~, C.dT, ~, ~, ~, ~, ~] = PSA(strcat(CoronaPath, CoronaName));
                        [V.dU, ~, V.dT, ~, ~, ~, ~, ~] = PSA(strcat(SurfacePath, SurfaceName));
                        [S.dU, ~, S.dT, ~, ~, ~, ~, ~] = PSA(strcat(VoidPath, VoidName));
                        [dU, dUm1, dT, dTm1, Div, Div1, T, U]= PSA(FullPathName);
                                                
                        %Pad dU and dT with 0s to maximum length
                        maxU = length(C.dU);
                        if(maxU < length(V.dU))
                            maxU = length(V.dU);
                        end
                        if(maxU < length(S.dU))
                            maxU = length(S.dU);
                        end
                        if(maxU < length(dU))
                            maxU = length(dU);
                        end

                        dUpad = [dU; transpose(zeros(1,(maxU-length(dU))))];
                        dTpad = [dT; transpose(zeros(1,(maxU-length(dT))))];
                        C.dU = [C.dU; transpose(zeros(1,(maxU-length(C.dU))))];
                        C.dT = [C.dT; transpose(zeros(1,(maxU-length(C.dT))))];
                        S.dU = [S.dU; transpose(zeros(1,(maxU-length(S.dU))))];
                        S.dT = [S.dT; transpose(zeros(1,(maxU-length(S.dT))))];
                        V.dU = [V.dU; transpose(zeros(1,(maxU-length(V.dU))))];
                        V.dT = [V.dT; transpose(zeros(1,(maxU-length(V.dT))))];

                        
                        UC = diag(pdist2(dUpad, C.dU));
                        US = diag(pdist2(dUpad, S.dU));
                        UV = diag(pdist2(dUpad, V.dU));
                        TC = diag(pdist2(dTpad, C.dT));
                        TS = diag(pdist2(dTpad, S.dT));
                        TV = diag(pdist2(dTpad, V.dT));

                        assignin('base', 'UC', UC);
                        assignin('base', 'US', US);
                        assignin('base', 'UV', UV);
                        assignin('base', 'TC', TC);
                        assignin('base', 'TS', TS);
                        assignin('base', 'TV', TV);
                        assignin('base', 'dUpad', dUpad);
                        assignin('base', 'dTpad', dTpad);
                        assignin('base', 'maxU', maxU);

                        
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
                        for i = 1:length(C)
                            assignin('base', 'C', C);
                        end
                        for i = 1:length(V)
                            assignin('base', 'V', V);
                        end
                        for i = 1:length(S)
                            assignin('base', 'S', S);
                        end
                        
                        
                        %From popup function so it auto updates when run
                        popup_menu_Callback(hpopup, 1);
                    end
                end
            end
        end
    end

    
        

end
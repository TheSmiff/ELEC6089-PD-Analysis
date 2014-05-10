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
    'Position',[425,350,100,25],'BackgroundColor', [0.9 0.9 0.9],...
    'Callback',{@openbtn_Callback});
%Run Button
hrun  = uicontrol('Style','pushbutton','String','Run PSA',...
    'Position',[425,300,100,25],'BackgroundColor', [0.9 0.9 0.9],...
    'Callback',{@runbtn_Callback});

%Run Recognition Button
hrec  = uicontrol('Style','pushbutton','String','Run Recognition',...
    'Position',[425,50,100,25],'BackgroundColor', [0.9 0.9 0.9],...
    'Callback',{@recbtn_Callback});
hrectext = uicontrol('Style','text','String','',...
    'HorizontalAlignment', 'left',...
    'BackgroundColor', [0.8 0.8 0.8],...
    'Position',[535,45,130,25]);
%File text
hfile = uicontrol('Style','text','String','Select a File to Proceed',...
    'HorizontalAlignment', 'left',...
    'BackgroundColor', [0.8 0.8 0.8],...
    'Position',[535,345,130,25]);
%Drop Down Menu
hpopup = uicontrol('Style','popupmenu',...
    'String',{'Delta U','Delta T','Delta U & Delta T','Voltage - Time',...
    'Voltage - Time 1 cycle','Classification by dU/dT','Class Probability'},...
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
CUw = 0;
SUw = 0;
VUw = 0;
dUw = 0;
CUe = 0;
VUe = 0;
SUe = 0;
Class = 0;
recflag = 0;

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
            end
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
        end%ifelse
    end %function

% --- Executes on button press in hrun
function runbtn_Callback(source, eventdata)
    if isequal(FileName,0)
        errordlg('No File Selected - select a file for analysis','File Error');
        set(hfile, 'String', 'Select a File to Proceed');
    else
        %Since it is not recognition
        recflag = 0;
        set(hrectext, 'String', '');
        %Just normal PSA
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
     case 'Classification by dU/dT' % User selects Peaks.
         if(~isequal(recflag,1))
               errordlg('Not available without running recognition','Program Error');
         else
         scatter(dUw(:,1),dUw(:,2), '.b');
         hold on
         scatter(CUw(:,1),CUw(:,2), '.r');
         scatter(SUw(:,1),SUw(:,2), '.g');
         scatter(VUw(:,1),VUw(:,2), '.m');
         hold off
         title('Filtered Data - Voltage Time Graph');
         xlabel('Time (s)');
         ylabel('Voltage (mV)'); 
         legend('\DeltaU plot Features', 'Corona Features', 'Surface Features', 'Void Features');
         hold off;
         end
       case 'Class Probability' % User selects Peaks.
         if(~isequal(recflag,1))
               errordlg('Not available without running recognition','Program Error');
         else
         bar([CUe SUe VUe]);
         set(ha, 'XTickLabel',{'Corona','Surface','Void'});
         hold off;
         end
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
                        recflag = 1;
                        clear dU dT dUm1 dTm1 Div Div1 T I If n U 
                        clear C.dU C.dUm1 C.dT C.dTm1 C.Div C.Div1
                        clear V.dU V.dUm1 V.dT V.dTm1 V.Div V.Div1 S.dU
                        clear S.dUm1 S.dT S.dTm1 S.Div S.Div1
                        clear CdU SdU VdU CdT SdT SdV maxU dUpad dTpad Class
                        [C.dU, C.dUm1, C.dT, C.dTm1, C.Div, C.Div1, ~, ~] = PSA(strcat(CoronaPath, CoronaName));
                        [V.dU, V.dUm1, V.dT, V.dTm1, S.Div, S.Div1, ~, ~] = PSA(strcat(SurfacePath, SurfaceName));
                        [S.dU, S.dUm1, S.dT, S.dTm1, V.Div, V.Div1, ~, ~] = PSA(strcat(VoidPath, VoidName));
                        [dU, dUm1, dT, dTm1, Div, Div1, T, U]= PSA(FullPathName);
                        
                        CUmat = [transpose(C.Div); transpose(C.Div1)];
                        SUmat = [transpose(S.Div); transpose(S.Div1)];
                        VUmat = [transpose(V.Div); transpose(V.Div1)];
                        dUmat = [transpose(Div); transpose(Div1)];
                        
                        
                        set(hrectext, 'String', 'Corona Network 1/4');
                        drawnow();
                        CUnet = competlayer(20,.1);
                        CUnet = configure(CUnet,CUmat);
                        CUnet.trainParam.epochs = 15;
                        CUnet.trainParam.showWindow = false;
                        CUnet = train(CUnet,CUmat);
                        CUw = CUnet.IW{1};
                        
                        set(hrectext, 'String', 'Surface Network 2/4');
                        drawnow();
                        SUnet = competlayer(20,.1);
                        SUnet = configure(SUnet,SUmat);
                        SUnet.trainParam.epochs = 15;
                        SUnet.trainParam.showWindow = false;
                        SUnet = train(SUnet,SUmat);
                        SUw = SUnet.IW{1};
                        
                        set(hrectext, 'String', 'Void Network 3/4');
                        drawnow();
                        VUnet = competlayer(20,.1);
                        VUnet = configure(VUnet,VUmat);
                        VUnet.trainParam.epochs = 15;
                        VUnet.trainParam.showWindow = false;
                        VUnet = train(VUnet,VUmat);
                        VUw = VUnet.IW{1};
                        
                        set(hrectext, 'String', 'Unknown Network 4/4');
                        drawnow();
                        dUnet = competlayer(20,.1);
                        dUnet = configure(dUnet,dUmat);
                        dUnet.trainParam.epochs = 15;
                        dUnet.trainParam.showWindow = false;
                        dUnet = train(dUnet,dUmat);
                        dUw = dUnet.IW{1};
                        
                        CUe = mean(pdist2(dUw, CUw, 'euclidean','Smallest', 1));
                        SUe = mean(pdist2(dUw, SUw, 'euclidean','Smallest', 1));
                        VUe = mean(pdist2(dUw, VUw, 'euclidean','Smallest', 1));
                        
                        Sum = CUe + SUe + VUe;
                        CUe = Sum - CUe;
                        SUe = Sum - SUe;
                        VUe = Sum - VUe;
                        Sum = CUe + SUe + VUe;
                        CUe = CUe*(100/Sum);
                        SUe = SUe*(100/Sum);
                        VUe = VUe*(100/Sum);
                        
                        Class = '';
                        if((CUe > SUe) && (CUe > VUe))
                            Class = ['Corona: ', num2str(CUe, '%2.1f'), '%'];
                        end
                        if((SUe > CUe) && (SUe > VUe))
                            Class = ['Surface: ', num2str(SUe, '%2.1f'), '%'];
                        end
                        if((VUe > CUe) && (VUe > SUe))
                            Class = ['Void: ', num2str(VUe, '%2.1f'), '%'];
                        end
                        set(hrectext, 'String', Class);
                        
                        assignin('base', 'CUmat', CUmat);
                        assignin('base', 'SUmat', SUmat);
                        assignin('base', 'VUmat', VUmat);
                        assignin('base', 'dUmat', dUmat);
                        assignin('base', 'CUw', CUw);
                        assignin('base', 'SUw', SUw);
                        assignin('base', 'VUw', VUw);
                        assignin('base', 'dUw', dUw);
                        assignin('base', 'CUe', CUe);
                        assignin('base', 'SUe', SUe);
                        assignin('base', 'VUe', VUe);                     
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
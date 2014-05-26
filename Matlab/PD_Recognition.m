% -----------------------------------------------
% --- PD_Recognition.m
% --- Partial Discharge Recognition Tool
% -----------------------------------------------
% --- Authors: Thomas J. smith & David Mahmoodi
% --- University of Southampton
% --- School of Electronics and Computer Science
% --- ELEC6089 High Voltage Insulation Systems
% --- PD Coursework
% -----------------------------------------------
% --- Functional Description:
% --- Performs a GUI driven Pulse Sequence Analysis
% --- characterization of PD data into void, corona
% --- and surface types. Uses neural networks to
% --- compare an unkown data set with 3 reference types
% --- and successfully automates characterization.
% -----------------------------------------------
% --- Requirements:
% --- PSA.m & uoslogogrey.jpg must be located in same
% --- root  file. All PD data stored in same directory.
% -----------------------------------------------

function PD_Analysis
%Close all current figures
close all;

%  Create and then hide the GUI as it is being constructed.
fig1 = figure('Visible','off','Position',[100,100,660,485], 'name',...
    'Partial Discharge Characterization Tool - T.Smith & D.Mahmoodi',...
    'NumberTitle', 'off', 'Resize', 'on', 'units','normalized');

% ---  Construct the components.
%GUI information for programatic GUIs found here
%http://www.mathworks.co.uk/help/matlab/creating_guis/creating-and-running-a-programmatic-gui.html

%Title decleration
htitle = uicontrol('Style','text','String',...
    'Partial Discharge Characterisation Tool',...
    'Position',[10,450,420,30], 'FontSize', 18,...
    'HorizontalAlignment', 'left',...
    'BackgroundColor', [0.8 0.8 0.8]);
%UoS Logo
hlogo = axes('Units','Pixels','Position',[550,410,100,92.5]);
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
    'Voltage - Time 1 cycle','Feature Comparison dU/dT','Classification'},...
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
%Author Text
hauthors = uicontrol('Style','text','String','Authors: Thomas J. Smith & David Mahmoodi',...
    'HorizontalAlignment', 'left',...
    'BackgroundColor', [0.8 0.8 0.8],...
    'Position',[435,0,300,17]);
%Time Elapsed
htime = uicontrol('Style','text','String',' ',...
    'HorizontalAlignment', 'left',...
    'BackgroundColor', [0.8 0.8 0.8],...
    'Position',[535,295,130,25]);

%This means you can resize the window
set(fig1, 'units','normalized');
set(htitle, 'units','normalized');
set(hlogo, 'units','normalized');
set(hopen, 'units','normalized');
set(hrun, 'units','normalized');
set(hrec, 'units','normalized');
set(hrectext, 'units','normalized');
set(hfile, 'units','normalized');
set(hpopup, 'units','normalized');
set(ha, 'units','normalized');
set(hopencor, 'units','normalized');
set(hcor, 'units','normalized');
set(hopensurf, 'units','normalized');
set(hsurf, 'units','normalized');
set(hopenvoid, 'units','normalized');
set(hvoid, 'units','normalized');
set(hauthors, 'units','normalized');
set(htime, 'units','normalized');

%To resize fonts in the window
set(htitle, 'fontunits', 'normalized');
set(hlogo, 'fontunits', 'normalized');
set(hopen, 'fontunits', 'normalized');
set(hrun, 'fontunits', 'normalized');
set(hrec, 'fontunits', 'normalized');
set(hrectext, 'fontunits', 'normalized');
set(hfile, 'fontunits', 'normalized');
set(hpopup, 'fontunits', 'normalized');
%set(ha, 'fontunits', 'normalized'); %This doesnt look so cool
set(hopencor, 'fontunits', 'normalized');
set(hcor, 'fontunits', 'normalized');
set(hopensurf, 'fontunits', 'normalized');
set(hsurf, 'fontunits', 'normalized');
set(hopenvoid, 'fontunits', 'normalized');
set(hvoid, 'fontunits', 'normalized');
set(hauthors, 'fontunits', 'normalized');
set(htime, 'fontunits', 'normalized');

%Context Menu handles for making popup function on right click
%in graph mode - useful for copying figures into presentation
cmenu = uicontextmenu('Parent',fig1,'Position',[10 215]);
mh1 = uimenu(cmenu,'Label','Open in New Window',...
    'Accelerator','W',...
    'Callback',{@uimenu_window});
mh3 = uimenu(cmenu,'Label','Reset View',...
    'Accelerator','R',...
    'Callback',{@uimenu_reset});
cmenuhandles = findall(fig1,'type','uicontextmenu');
set(cmenuhandles,'HandleVisibility','off')
menuitemhandles = findall(cmenuhandles,'type','uimenu');
set(menuitemhandles,'HandleVisibility','off')
set(ha,'UIContextMenu',cmenu);

% Move the GUI to the center of the screen.
movegui(fig1,'center')
% Make the GUI visible.
set(fig1,'Visible','on');

% --- Define Global Variables
%File Name Variables
FileName = 0; %Unknown file name
PathName = 0; %Unknown file path name
FullPathName = 0; %Concat of filename + pathname
CoronaName = get(hcor, 'String');
CoronaPath = 0;
SurfaceName = get(hsurf, 'String');
SurfacePath = 0;
VoidName = get(hvoid, 'String');
VoidPath = 0;
%PSA Storage Variables
U = 0;
dU = 0;
dT = 0;
dUm1(1) = 0;
dTm1(1) = 0;
Div = 0;
Div1 = 0;
T = 0;
%Online data variables
I = 0;
F = 0;
%Variables for automted characterization
CUw = 0;
SUw = 0;
VUw = 0;
dUw = 0;
CUe = 0;
VUe = 0;
SUe = 0;
%Other Program Flags
Class = 0;
recflag = 0;


% --- Executes on button press in hopen.
    function openbtn_Callback(source,eventdata)
        %Temp storage of previous variables in case open fails
        clear tmpf tmpp;
        tmpf = FileName;
        tmpp = PathName;
        %Open the file
        [FileName,PathName] = uigetfile({'*.txt'},'Select the Partial Discharge Data file for analysis');
        %If return 0, open has failed - reset to original
        if isequal(FileName,0)
            errordlg('No File Selected','File Error');
            FileName = tmpf;
            PathName = tmpp;
            set(hfile, 'String', tmpf);
        else
            %Open file success - check and warn if it has been selected as
            %a characterization reference file
            if (or(~isempty(strfind(CoronaName, FileName)),or(~isempty(strfind(SurfaceName, FileName)),~isempty(strfind(VoidName, FileName)))))
                warndlg('File already selected for comparison','Selection Warning');
            end
            %Populate the variables
            FullPathName = strcat(PathName, FileName);
            CoronaPath = PathName;
            SurfacePath = PathName;
            VoidPath = PathName;
            %Update the GUI
            set(hfile, 'String', FileName)
            %Check it is a .txt and warn if it is not
            if (isempty(strfind(FileName, '.txt')))
                warndlg('File selected is not a supported data format','Format Warning');
            end%if
        end%ifelse
    end %function

% --- Executes on button press in hopencor.
    function opencorbtn_Callback(source,eventdata)
        %Essentially the same as openbtn_Callback
        clear tmpf tmpp;
        tmpf = CoronaName;
        tmpp = CoronaPath;
        [CoronaName,CoronaPath] = uigetfile({'*.txt'},'Select the Partial Discharge Data file for analysis');
        if isequal(CoronaName,0)
            errordlg('No File Selected','File Error');
            CoronaName = tmpf;
            CoronaPath = tmpp;
            set(hcor, 'String', tmpf);
        else
            if (~isempty(strfind(CoronaName, FileName)))
                errordlg('File cannot be the same as unknown file','Selection Error');
            else
                if (isempty(strfind(CoronaName, 'Corona')))
                    warndlg('Check this file contains Corona data','File Warning');
                end
                set(hcor, 'String', CoronaName);
                if (isempty(strfind(CoronaName, '.txt')))
                    warndlg('File selected is not a supported data format','Format Warning');
                end%if
            end
        end%ifelse
    end %function

% --- Executes on button press in hopensurf
    function opensurfbtn_Callback(source,eventdata)
        %Essentially the same as openbtn_Callback
        clear tmpf tmpp;
        tmpf = SurfaceName;
        tmpp = SurfacePath;
        [SurfaceName,SurfacePath] = uigetfile({'*.txt'},'Select the Partial Discharge Data file for analysis');
        if isequal(SurfaceName,0)
            errordlg('No File Selected','File Error');
            SurfaceName = tmpf;
            SurfacePath = tmpp;
            set(hsurf, 'String', tmpf);
        else
            if (~isempty(strfind(SurfaceName, FileName)))
                errordlg('File cannot be the same as unknown file','Selection Error');
            else
                if (isempty(strfind(SurfaceName, 'Surface')))
                    warndlg('Check this file contains Surface data','File Warning');
                end
                set(hsurf, 'String', SurfaceName);
                if (isempty(strfind(SurfaceName, '.txt')))
                    warndlg('File selected is not a supported data format','Format Warning');
                end
            end
        end%ifelse
    end %function

% --- Executes on button press in hopenvoid
    function openvoidbtn_Callback(source,eventdata)
        %Essentially the same as openbtn_Callback
        clear tmpf tmpp;
        tmpf = VoidName;
        tmpp = VoidPath;
        [VoidName,VoidPath] = uigetfile({'*.txt'},'Select the Partial Discharge Data file for analysis');
        if isequal(VoidName,0)
            errordlg('No File Selected','File Error');
            VoidName = tmpf;
            VoidPath = tmpp;
            set(hvoid, 'String', tmpf);
        else
            if (~isempty(strfind(VoidName, FileName)))
                errordlg('File cannot be the same as unknown file','Selection Error');
            else
                if (isempty(strfind(VoidName, 'Void')))
                    warndlg('Check this file contains Void data','File Warning');
                end
                set(hvoid, 'String', VoidName);
                if (isempty(strfind(VoidName, '.txt')))
                    warndlg('File selected is not a supported data format','Format Warning');
                end%if
            end
        end%ifelse
    end %function

% --- Executes on button press in hrun
% --- Runs just the PSA analysis - no automated characterization
    function runbtn_Callback(source, eventdata)
        %Check there is a valid file selected
        if isequal(FileName,0)
            errordlg('No File Selected - select a file for analysis','File Error');
            set(hfile, 'String', 'Select a File to Proceed');
        else
            %Record the start time for diagnostics
            tStart = tic;
            %recflag is checked when plotting characterization graphs
            %setting it to zero means that characterization hasn't been
            %performed yet so those graphs are unavailable
            recflag = 0;
            %Clear the recognised class text if there was any beforehand
            set(hrectext, 'String', '');
            %Perform PSA - see PSA.m for funtion details
            [dU, dUm1, dT, dTm1, Div, Div1, T, U, I, F]= PSA(FullPathName);
            %Dump variables to workspace - debug
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
            for i = 1:length(U)
                assignin('base', 'U', U);
                assignin('base', 'T', T);
            end
            %From popup function so it auto updates when run
            popup_menu_Callback(hpopup, 1);
            %Update elapsed timings on the GUI
            tElapsed = toc(tStart);
            set(htime, 'String', ['Calculation Time: ', num2str(tElapsed, '%3.1f'), 's']);
        end
    end

% --- Executes on button press in hrec
    function recbtn_Callback(source, eventdata)
        %Start Timer
        tStart = tic;
        %Check all four files are selected as required
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
                        %initialise a progress bar
                        hwait = waitbar(0,'Starting Recognition','Name', 'Recognizing Partial Discharge Type...');
                        %enable the use of the last two graphs
                        recflag = 1;
                        %Clear all variables
                        clear dU dT dUm1 dTm1 Div Div1 T I If n U
                        clear C.dU C.dUm1 C.dT C.dTm1 C.Div C.Div1
                        clear V.dU V.dUm1 V.dT V.dTm1 V.Div V.Div1 S.dU
                        clear S.dUm1 S.dT S.dTm1 S.Div S.Div1
                        clear CdU SdU VdU CdT SdT SdV maxU dUpad dTpad Class
                        
                        %Perform PSA on the four selected samples
                        %See PSA.m for PSA algorithm
                        [C.dU, C.dUm1, C.dT, C.dTm1, C.Div, C.Div1, ~, ~, ~, ~] = PSA(strcat(CoronaPath, CoronaName));
                        waitbar(0.03,hwait, 'Surface PSA')
                        [S.dU, S.dUm1, S.dT, S.dTm1, S.Div, S.Div1, ~, ~, ~, ~] = PSA(strcat(SurfacePath, SurfaceName));
                        waitbar(0.06,hwait,'Void PSA')
                        [V.dU, V.dUm1, V.dT, V.dTm1, V.Div, V.Div1, ~, ~, ~, ~] = PSA(strcat(VoidPath, VoidName));
                        waitbar(0.09,hwait,'Unknown PSA')
                        [dU, dUm1, dT, dTm1, Div, Div1, T, U, I, F]= PSA(FullPathName);
                        
                        %Produce a 2xn matrix with the Div values in the
                        %top row and the Div1 values in the other.
                        %dU/dT graph chosen for recognition since it is the
                        %most characteristic graph with very well defined
                        %differences between PD types
                        CUmat = [transpose(C.Div); transpose(C.Div1)];
                        SUmat = [transpose(S.Div); transpose(S.Div1)];
                        VUmat = [transpose(V.Div); transpose(V.Div1)];
                        dUmat = [transpose(Div); transpose(Div1)];
                        
                        %Use a competitive neural network to extract 20
                        %clusters from the corona data
                        waitbar(0.10,hwait,'Corona Neural Network Feature Extraction')
                        set(hrectext, 'String', 'Corona Network 1/4');
                        %Update GUI with progress
                        drawnow();
                        %Build a competitive layer network
                        %See http://www.mathworks.co.uk/help/nnet/examples/competitive-learning.html
                        %For more examples
                        CUnet = competlayer(20,.1);
                        %Feed in the matrix data
                        CUnet = configure(CUnet,CUmat);
                        %Set the training length (7 found to be about
                        %right from experimentation)
                        CUnet.trainParam.epochs = 7;
                        %Don't show the window - it spoils the professional
                        %feel
                        CUnet.trainParam.showWindow = false;
                        %"train" the network to give the weight vectors
                        CUnet = train(CUnet,CUmat);
                        %20x2 matrix containing the x and y coordinates of
                        %the cluster positions.
                        CUw = CUnet.IW{1};
                        
                        %nn analysis of the Surface data - same as above
                        waitbar(0.30,hwait,'Surface Neural Network Feature Extraction')
                        set(hrectext, 'String', 'Surface Network 2/4');
                        drawnow();
                        SUnet = competlayer(20,.1);
                        SUnet = configure(SUnet,SUmat);
                        SUnet.trainParam.epochs = 7;
                        SUnet.trainParam.showWindow = false;
                        SUnet = train(SUnet,SUmat);
                        SUw = SUnet.IW{1};
                        
                        %nn of the void data
                        waitbar(0.50,hwait, 'Void Neural Network Feature Extraction')
                        set(hrectext, 'String', 'Void Network 3/4');
                        drawnow();
                        VUnet = competlayer(20,.1);
                        VUnet = configure(VUnet,VUmat);
                        VUnet.trainParam.epochs = 7;
                        VUnet.trainParam.showWindow = false;
                        VUnet = train(VUnet,VUmat);
                        VUw = VUnet.IW{1};
                        
                        %%nn of the unknown data
                        waitbar(0.70,hwait,'Unknown Neural Network Feature Extraction')
                        set(hrectext, 'String', 'Unknown Network 4/4');
                        drawnow();
                        dUnet = competlayer(20,.1);
                        dUnet = configure(dUnet,dUmat);
                        dUnet.trainParam.epochs = 7;
                        dUnet.trainParam.showWindow = false;
                        dUnet = train(dUnet,dUmat);
                        dUw = dUnet.IW{1};
                        
                        %Extract the shortest distance between each vector
                        %and sum. The one it is most likely to be will be
                        %the shortest one
                        waitbar(0.90,hwait,'Eucledian Distance Comparison')
                        CUe = sum(pdist2(dUw, CUw, 'euclidean','Smallest', 1));
                        SUe = sum(pdist2(dUw, SUw, 'euclidean','Smallest', 1));
                        VUe = sum(pdist2(dUw, VUw, 'euclidean','Smallest', 1));
                        %For comparison
                        Sum = CUe+SUe+VUe;
                        
                        %Set output string accordingly
                        Class = '';
                        if((CUe < SUe) && (CUe < VUe))
                            Class = ['Corona: ', num2str(CUe, '%2.2f'), '/', num2str(Sum, '%2.1f')];
                        end
                        if((SUe < CUe) && (SUe < VUe))
                            Class = ['Surface: ', num2str(SUe, '%2.2f'), '/', num2str(Sum, '%2.1f')];
                        end
                        if((VUe < CUe) && (VUe < SUe))
                            Class = ['Void: ', num2str(VUe, '%2.2f'), '/', num2str(Sum, '%2.1f')];
                        end
                        set(hrectext, 'String', Class);
                        
                        %Output variables to the workspace where required
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
                        
                        %Delete the wait bar - we're done
                        waitbar(1,hwait,'Finished')
                        delete(hwait);
                        
                        %From popup function so it auto updates when run
                        popup_menu_Callback(hpopup, 1);
                        
                        %Process timing function and update gui
                        tElapsed = toc(tStart);
                        set(htime, 'String', ['Calculation Time: ', num2str(tElapsed, '%3.1f'), 's']);
                        
                    end
                end
            end
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
            case 'Delta U' % User selects dU.
                %Scatter graph of dU
                scatter(dUm1, dU, '.');
                title('Pulse Sequence Analysis - \DeltaU Graph');
                xlabel('\DeltaU_{n-1} (V)');
                ylabel('\DeltaU_{n} (V)');
                axis([-2, 2, -2, 2]);
                grid on;
            case 'Delta T' % User selects dT
                scatter(dTm1, dT, '.');
                title('Pulse Sequence Analysis - \DeltaT Graph');
                xlabel('\DeltaT_{n-1} (s)');
                ylabel('\DeltaT_{n} (s)');
                grid on;
            case 'Delta U & Delta T' % User selects dU and dT.
                scatter(Div1, Div, '.');
                title('Pulse Sequence Analysis - \DeltaU/\DeltaT Graph');
                xlabel('\DeltaU_{n-1}/\DeltaT_{n-1}');
                ylabel('\DeltaU_{n}/\DeltaT_{n}');
                grid on;
            case 'Voltage - Time' % User selects whole online data.
                %generate a sine wave to plot
                Wave = linspace(0,1, 5000);
                SinWave = (sind((rem(Wave,0.02)*360)/0.02));
                scatter(T, I, 'xm');
                hold on
                plot(transpose(linspace(0,1,length(F))), F, '-b');
                plot(Wave, SinWave, '-r');
                hold off
                title('Filtered Data - Voltage Time Graph');
                xlabel('Time (s)');
                ylabel('Voltage (V)');
                grid on;
            case 'Voltage - Time 1 cycle' % User selects one cycle of online
                %Generate sine wave
                Wave = linspace(0.02,0.04, 300);
                SinWave = sind((rem(Wave,0.02)*360)/0.02);
                %Select data that comes in T>0.02 and T<0.04s for second sine wave
                clear tmp1 tmp2;
                tmp1 = T(T>0.02);
                tmp2 = I(T>0.02);
                tmp2 = tmp2(tmp1<0.04);
                tmp1 = tmp1(tmp1<0.04);
                scatter(tmp1, tmp2, 'xm');
                hold on
                %F is the filtered online data
                plot(transpose(linspace(0.02,0.04,length(F(10000:20000)))), F(10000:20000), '-b');
                plot(Wave, SinWave, '-r');
                hold off
                title('Filtered Data - Voltage Time Graph');
                xlabel('Time (s)');
                ylabel('Voltage (V)');
                v = axis;
                grid on;
                hold off;
            case 'Feature Comparison dU/dT' % User selects feature comparison
                %Plot scatter of features extracted from neural networks
                if(~isequal(recflag,1))
                    errordlg('Not available without running recognition','Program Error');
                else
                    scatter(dUw(:,2),dUw(:,1), '.b');
                    hold on
                    scatter(CUw(:,2),CUw(:,1), '.r');
                    scatter(SUw(:,2),SUw(:,1), '.g');
                    scatter(VUw(:,2),VUw(:,1), '.m');
                    hold off
                    title('Features Extracted by Competitive Neural Network - dU/dT Graph');
                    xlabel('\DeltaU_{n-1}/\DeltaT_{n-1}');
                    ylabel('\DeltaU_{n}/\DeltaT_{n}');
                    legend('\DeltaU plot Features', 'Corona Features', 'Surface Features', 'Void Features', 'Location', 'SouthEast');
                    grid on;
                    hold off;
                end
            case 'Classification' % User selects classification
                %Plot a bar graph of sum distances - shortest indicator
                if(~isequal(recflag,1))
                    errordlg('Not available without running recognition','Program Error');
                else
                    if((CUe < SUe) && (CUe < VUe))
                        hb1 = bar(1, CUe, 'r');
                        hold on
                        hb2 = bar(2, SUe, 'b');
                        hb3 = bar(3, VUe, 'b');
                    end
                    if((SUe < CUe) && (SUe < VUe))
                        hb1 = bar(1, CUe, 'b');
                        hold on
                        hb2 = bar(2, SUe, 'r');
                        hb3 = bar(3, VUe, 'b');
                    end
                    if((VUe < CUe) && (VUe < SUe))
                        hb1 = bar(1, CUe, 'b');
                        hold on
                        hb2 = bar(2, SUe, 'b');
                        hb3 = bar(3, VUe, 'r');
                    end
                    set(ha, 'Xtick', 1:3, 'XTickLabel',{'Corona','Surface','Void'});
                    title('Sum euclidean distance between each feature set');
                    ylabel('Sum E Distance');
                    xlabel('Lowest bar indicates class');
                    hold off;
                end
        end
    end

% --- Executes on button press in uimenu_reset
% --- Resets graph if you mess it up - although I think matlab does this
% anyway!
    function uimenu_reset(source,eventdata)
        if(isequal(recflag, 1))
            popup_menu_Callback(hpopup, 1);
        end
    end %function

% --- Executes on button press in uimenu_window
% --- Makes the current gui graph in a seperate window for saving
    function uimenu_window(source,eventdata)
        fig2 = figure('Visible','off','Position',[100,100,600,485], 'name',...
            'Partial Discharge Characterization Tool - T.Smith & D.Mahmoodi',...
            'NumberTitle', 'off', 'Resize', 'on', 'units','normalized');
        % Move the GUI to the center of the screen.
        movegui(fig2,'center')
        % Make the GUI visible.
        set(fig2,'Visible','on');
        h2 = axes('Units','Pixels','Position',[65,50,500,390]);
        hold on
        %Copy the current graph shown
        copyobj(get(ha,'children'),h2);
        grid on;
        xlabel(get(get(ha,'xlabel'),'string'));
        ylabel(get(get(ha,'ylabel'),'string'));
        title(get(get(ha,'title'),'string'));
        set(h2, 'units','normalized');
        hold off
    end %function

end %End Function
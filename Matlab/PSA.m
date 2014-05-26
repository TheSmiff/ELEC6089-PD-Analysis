% -----------------------------------------------
% --- PSA.m
% --- Pulse Sequence Analysis Funtion
% -----------------------------------------------
% --- Authors: Thomas J. smith & David Mahmoodi
% --- University of Southampton
% --- School of Electronics and Computer Science
% --- ELEC6089 High Voltage Insulation Systems
% --- PD Coursework
% -----------------------------------------------
% --- Functional Description:
% --- Given a set of online PD data as specified in
% --- the PD coursework, this function reads in the
% --- file, filters using wavelet denoising, detects
% --- PD activity and uses a normalised (between 1 and
% --- -1) sine wave to produce Pulse Sequence Analysis
% --- dU, dT and dU/dT and associated vectors.
% -----------------------------------------------
% --- Requirements:
% --- Called by PD_Recognition.m - should be in same directory
% -----------------------------------------------

function [dU,dUm1,dT,dTm1,Div,Div1, T, U, I, If] = PSA(FilePathName)
%Zero all variables in case of repeated PSA
clear dU dT dUm1 dTm1 Div Div1 T I If n U;

%Import the voltage file (assumed mV following discussion during
%lecture on 06/05/2014)
I = importdata(FilePathName);
%Evenly distribute the time - we know it is 1 second length
T = transpose(linspace(0,1,length(I)));

% --- Filtering by wavelet decomposition
%Extend U to next power of two length for wavelet transform
n = 524288 - length(I);
If = wextend(1, 'sym', I, n, 'r');
%Use symlet6 wavelet denoising as in Lewin's paper
%Wavelet denoising is detailed here:
%http://eprints.soton.ac.uk/262866/
%Matlab function information here:
%http://www.mathworks.co.uk/help/wavelet/ug/denoising.html#f8-22239
%http://www.mathworks.co.uk/help/wavelet/ref/wden.html
%Filters If with universal threshold function, hard thresholding,
%level dependent noise estimation, 8 level wavelet decomposition by
%symlet 6 wavelet.
If = wden(If, 'sqtwolog', 'h', 'mln', 8, 'sym6');
%Unextend it and free up memory
n = length(I);
%return the filtered data to the program for plotting
If = If(1:n);

% --- Peak detection
%I is a set of peaks, locs are their location
%Values chosen by trial and error to get best peak recognition
%http://www.mathworks.co.uk/help/signal/examples/peak-analysis.html
%See above link for more info on findpeaks function
[I,locs] = findpeaks(If, 'MINPEAKDISTANCE',50,...
    'THRESHOLD', 0.0, 'MINPEAKHEIGHT', 0.1);
%Only keep the Tvalues we care about
T = T(locs);
%Generate normalized sine values for this
U = sind((rem(T,0.02)*360)/0.02);

% --- PSA Arithmetic
%Preallocate variable lengths for speed
dU = zeros(length(U)-1,1);
dT = zeros(length(T)-1,1);
%Perform the following calculations in the for loop
%dU(n) = U(n+1) - U(n)
%dT(n) = T(n+1) - T(n)
%Generate the delta variables
for i = 1:(length(U)-1)
    dU(i) = U(i+1)-U(i);
    dT(i) = T(i+1)-T(i);
end

%Preallocate variable length for speed
dUm1 = zeros(length(U)-1,1);
dTm1 = zeros(length(T)-1,1);
%dU(n-1) = U(n) - U(n-1)
%dT(n-1) = T(n) - T(n-1)
%Generate the -1 variables
for i = 2:length(U) %start at 2 as U0 is not an index
    dUm1(i) = U(i) - U(i-1);
    dTm1(i) = T(i) - T(i-1);
end

%Delete index 1 of minus ones as they are unasigned (starts at 2)
dUm1(1) = [];
dTm1(1) = [];
%Also need to delete ends to make same length vectors
dUm1(length(dUm1)) = [];
dTm1(length(dTm1)) = [];
%Delete vector 1 of the n values to keep offset
dU(1) = [];
dT(1) = [];

%preallocate array length for speed
Div = zeros(length(dU),1);
Div1 = zeros(length(dU),1);
%Calculate the divided values
for i = 1:length(dU)
    Div(i) = dU(i)/dT(i);
    Div1(i) = dUm1(i)/dTm1(i);
end

%All the dU, dT, dUm1, dTm1 and Div, Div1 are returned by the function 
%and read into the variables sent to the function at the top.
%this information is plotted and processed by popup_menu_Callback 
%function in PD_Recognition.m
end
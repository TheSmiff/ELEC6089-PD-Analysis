function [dU,dUm1,dT,dTm1,Div,Div1, T, U, I, If] = PSA(FilePathName)
       %Zero all variables in case of repeated PSA
       clear dU dT dUm1 dTm1 Div Div1 T I If n U; 

        %Import the voltage file (assumed mV following discussion during
        %lecture on 06/05/2014)
        I = importdata(FilePathName);
        %Evenly distribute the time - we know it is 1 second length
        T = transpose(linspace(0,1,length(I)));
        
        % --- Filtering
        %Extend U to next power of two length for wavelet transform
        n = 524288 - length(I);
        If = wextend(1, 'sym', I, n, 'r');
        %Use symlet6 wavelet denoising
        If = wden(If, 'sqtwolog', 'h', 'mln', 8, 'sym6');
        %Unextend it and free up memory
        n = length(I);
        %return the filtered data to the program for plotting
        If = If(1:n);
        
        %I is a set of peaks
        [I,locs] = findpeaks(If, 'MINPEAKDISTANCE',50,...
            'THRESHOLD', 0.05, 'MINPEAKHEIGHT', 0.05);
        T = T(locs);
        
        U = sind((rem(T,0.02)*360)/0.02);        
        
        %Preallocate variable lengths for speed
        dU = zeros(length(U),1);
        dT = zeros(length(U),1);
        %dU(n) = U(n+1) - U(n)
        %dT(n) = T(n+1) - T(n)
        %Generate the delta variables
        for i = 1:(length(U)-1)
            dU(i) = U(i+1)-U(i);
            dT(i) = T(i+1)-T(i);
        end
        
        %Preallocate variable length for speed
        dUm1 = zeros(length(U)+1,1);
        dTm1 = zeros(length(U)+1,1);
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
        
        %preallocate array length for speed
        Div = zeros(length(dU),1);
        Div1 = zeros(length(dU),1);
        %Calculate the divided values
        for i = 1:length(dU)
            Div(i) = dU(i)/dT(i);
            Div1(i) = dUm1(i)/dTm1(i);
        end
        
    end
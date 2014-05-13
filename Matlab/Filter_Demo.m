%Plot the sym6 wavelet function
% Set number of iterations and wavelet name. 
iter = 10;
wav = 'sym6';

% Compute approximations of the wavelet function using the
% cascade algorithm. 
[phi,psi,xval] = wavefun(wav,10); 
figure(22);
subplot(1,2, 1);
plot(xval,psi);
title('Symlet 6 Wavelet Function');
xlim([0 10]);
subplot(1, 2, 2);
plot(xval, phi);
title('Symlet 6 Scaling Function');
xlim([0 10]);

%Import example data
Corona1 = importdata('../Known Data/Corona1.txt');
Void2 = importdata('../Known Data/Void2.txt');
Surface2 = importdata('../Known Data/Surface2.txt');

%Extend Function to next power of 2
n = 524288 - length(Corona1);
Corona1_Ext = wextend(1, 'sym', Corona1, n, 'r');
n = 524288 - length(Void2);
Void2_Ext = wextend(1, 'sym', Void2, n, 'r');
n = 524288 - length(Surface2);
Surface2_Ext = wextend(1, 'sym', Surface2, n, 'r');

figure(21);
plot(Void2, '-b');
hold on
Wave = linspace(0,500002, 1000);
SinWave = sind((rem(Wave,10000.4)*360)/10000.4);
plot(Wave, SinWave, '-r');
hold off
title('Online Partial Discharge Detection Data');
xlabel('Sample Number');
ylabel('Signal (mV)');
legend('Void 2 Data Set', 'Sine Wave, Magnitude = 1', 'Location', 'SouthEast');
xlim([3500 3535]);

figure(2);
plot(Corona1_Ext);
hold on
plot(Corona1, '-r');
title('Extended Corona1 Data Set');
xlabel('Sample Number');
ylabel('Signal (mV)');
legend('Wavelet Extended Data Set', 'Original Data Set', 'Location', 'SouthWest');
xlim([0 524288]);
hold off

figure(3);
plot(Void2_Ext);
hold on
plot(Void2, '-r');
title('Extended Void2 Data Set');
xlabel('Sample Number');
ylabel('Signal (mV)');
legend('Wavelet Extended Data Set', 'Original Data Set', 'Location', 'SouthWest');
xlim([0 524288]);
hold off

figure(4);
plot(Surface2_Ext);
hold on
plot(Surface2, '-r');
title('Extended Surface2 Data Set');
xlabel('Sample Number');
ylabel('Signal (mV)');
legend('Wavelet Extended Data Set', 'Original Data Set', 'Location', 'SouthWest');
xlim([0 524288]);
hold off

% [Cswa,Cswd] = swt(Corona1_Ext,8,'sym6');
% [Sswa,Sswd] = swt(Surface2_Ext,8,'sym6');
% [Vswa,Vswd] = swt(Void2_Ext,8,'sym6');
% 
% kp = 0; 
% for i = 1:8
%     subplot(8,2,kp+1), plot(Cswa(i,:));
%     title(['Approx. cfs level ',num2str(i)])
%     subplot(8,2,kp+2), plot(Cswd(i,:));  
%     title(['Detail cfs level ',num2str(i)])
%     kp = kp + 2; 
% end
% kp = 0; 
% for i = 1:8
%     subplot(8,2,kp+1), plot(Vswa(i,:));
%     title(['Approx. cfs level ',num2str(i)])
%     subplot(8,2,kp+2), plot(Vswd(i,:));  
%     title(['Detail cfs level ',num2str(i)])
%     kp = kp + 2; 
% end
% kp = 0; 
% for i = 1:8
%     subplot(8,2,kp+1), plot(Sswa(i,:));
%     title(['Approx. cfs level ',num2str(i)])
%     subplot(8,2,kp+2), plot(Sswd(i,:));  
%     title(['Detail cfs level ',num2str(i)])
%     kp = kp + 2; 
% end


% Filter the data
[Corona1_Filt, CCXD, CLXD] = wden(Corona1_Ext, 'sqtwolog', 'h', 'mln', 8, 'sym6');
[Void2_Filt, SCXD, SLXD] = wden(Void2_Ext, 'sqtwolog', 'h', 'mln', 8, 'sym6');
[Surface2_Filt, VCXD, VLXD] = wden(Surface2_Ext, 'sqtwolog', 'h', 'mln', 8, 'sym6');

figure(5);
plot(Corona1_Ext);
hold on
plot(Corona1_Filt, '-r');
title('Denoised Corona1 Data Set');
xlabel('Sample Number');
ylabel('Signal (mV)');
legend('Wavelet Extended Data Set', 'Denoised Data Set', 'Location', 'SouthWest');
xlim([0 524288]);
hold off

figure(6);
plot(Void2_Ext);
hold on
plot(Void2_Filt, '-r');
title('Denoised Void2 Data Set');
xlabel('Sample Number');
ylabel('Signal (mV)');
legend('Wavelet Extended Data Set', 'Denoised Data Set', 'Location', 'SouthWest');
xlim([0 524288]);
hold off

figure(7);
plot(Surface2_Ext);
hold on
plot(Surface2_Filt, '-r');
title('Denoised Surface2 Data Set');
xlabel('Sample Number');
ylabel('Signal (mV)');
legend('Wavelet Extended Data Set', 'Denoised Data Set', 'Location', 'SouthWest');
xlim([0 524288]);
hold off

figure(8);
plot(Corona1_Ext(7050:7150));
hold on
plot(Corona1_Filt(7050:7150), '-r');
title('Denoised Corona1 Data Set');
xlabel('Sample Number');
ylabel('Signal (mV)');
legend('Wavelet Extended Data Set', 'Denoised Data Set', 'Location', 'NorthWest');
xlim([0 100]);
hold off

figure(9);
plot(Void2_Ext(7000:7100));
hold on
plot(Void2_Filt(7000:7100), '-r');
title('Denoised Void2 Data Set');
xlabel('Sample Number');
ylabel('Signal (mV)');
legend('Wavelet Extended Data Set', 'Denoised Data Set', 'Location', 'SouthWest');
xlim([0 100]);
hold off

figure(10);
plot(Surface2_Ext(7000:7100));
hold on
plot(Surface2_Filt(7000:7100), '-r');
title('Denoised Surface2 Data Set');
xlabel('Sample Number');
ylabel('Signal (mV)');
legend('Wavelet Extended Data Set', 'Denoised Data Set', 'Location', 'SouthEast');
xlim([0 100]);
hold off


% Threshold Generation
PD_Threshold = 0.1;
x = linspace(0,1,1000);
k = ones(1,1000);
for i = 1:length(x)
    if(x(i) < PD_Threshold)
        k(i) = 0;
    end
end
figure(11);
plot(x, k);
title('Threshold Filter');
xlabel('Sample Number');
ylabel('Signal');
xlim([0 1]);


%Threshold Data

Corona1_Thresh = transpose(zeros(1, length(Corona1_Filt)));
for i = 1:length(Corona1_Filt)
    if(gt(abs(Corona1_Filt(i)),PD_Threshold))
        Corona1_Thresh(i) = Corona1_Filt(i);
    end
end
Void2_Thresh = transpose(zeros(1, length(Void2_Filt)));
for i = 1:length(Void2_Filt)
    if(gt(abs(Void2_Filt(i)),PD_Threshold))
        Void2_Thresh(i) = Void2_Filt(i);
    end
end

Surface2_Thresh = transpose(zeros(1, length(Surface2_Filt)));
for i = 1:length(Surface2_Filt)
    if(gt(abs(Surface2_Filt(i)),PD_Threshold))
        Surface2_Thresh(i) = Surface2_Filt(i);
    end
end

figure(12);
plot(Corona1_Ext);
hold on
plot(Corona1_Filt, '-r');
plot(Corona1_Thresh, '-g');
title('Threshold Corona1 Data Set');
xlabel('Sample Number');
ylabel('Signal (mV)');
legend('Wavelet Extended Data Set', 'Denoised Data Set', 'Threhsold Data Set', 'Location', 'SouthWest');
xlim([0 524288]);
hold off

figure(13);
plot(Void2_Ext);
hold on
plot(Void2_Filt, '-r');
plot(Void2_Thresh, '-g');
title('Threshold Void2 Data Set');
xlabel('Sample Number');
ylabel('Signal (mV)');
legend('Wavelet Extended Data Set', 'Denoised Data Set','Threshold Data Set', 'Location', 'SouthWest');
xlim([0 524288]);
hold off

figure(14);
plot(Surface2_Ext);
hold on
plot(Surface2_Filt, '-r');
plot(Surface2_Thresh, '-g');
title('Threshold Surface2 Data Set');
xlabel('Sample Number');
ylabel('Signal (mV)');
legend('Wavelet Extended Data Set', 'Denoised Data Set', 'Location', 'SouthWest');
xlim([0 524288]);
hold off

figure(15);
plot(Corona1_Ext(7050:7150));
hold on
plot(Corona1_Filt(7050:7150), '-r');
plot(Corona1_Thresh(7050:7150), '-g');
title('Threshold Corona1 Data Set');
xlabel('Sample Number');
ylabel('Signal (mV)');
legend('Wavelet Extended Data Set', 'Denoised Data Set', 'Threshold Data Set', 'Location', 'NorthWest');
xlim([0 100]);
hold off

figure(16);
plot(Void2_Ext(7000:7100));
hold on
plot(Void2_Filt(7000:7100), '-r');
plot(Void2_Thresh(7000:7100), '-g');
title('Threshold Void2 Data Set');
xlabel('Sample Number');
ylabel('Signal (mV)');
legend('Wavelet Extended Data Set', 'Denoised Data Set','Threshold Data Set', 'Location', 'SouthWest');
xlim([0 100]);
hold off

figure(17);
plot(Surface2_Ext(7000:7100));
hold on
plot(Surface2_Filt(7000:7100), '-r');
plot(Surface2_Thresh(7000:7100), '-g');
title('Threshold Surface2 Data Set');
xlabel('Sample Number');
ylabel('Signal (mV)');
legend('Wavelet Extended Data Set', 'Denoised Data Set', 'Location', 'SouthEast');
xlim([0 100]);
hold off

%Generate Time Stamping
T_C1 = transpose(linspace(0, 1000, 524288));
T_V2 = transpose(linspace(0, 1000, 524288));
T_S2 = transpose(linspace(0, 1000, 524288));

% --- Peak Selection
[Corona1_Peak,locs] = findpeaks(Corona1_Thresh, 'MINPEAKDISTANCE', 20);
T_C1 = T_C1(locs);
[Void2_Peak,locs] = findpeaks(Void2_Thresh, 'MINPEAKDISTANCE', 20);
T_V2 = T_V2(locs);
[Surface2_Peak,locs] = findpeaks(Surface2_Thresh, 'MINPEAKDISTANCE', 20);
T_S2 = T_S2(locs);

% --- Sine Wave Gen
Wave = linspace(0,1000, 1000);
SinWave = sind((rem(Wave/1000,0.02)*360)/0.02);

T_C1_old = transpose(linspace(0, 1000, 524288));
figure(18);
plot(T_C1_old, Corona1_Ext);
hold on
plot(T_C1_old, Corona1_Filt,  '-r');
plot(T_C1_old, Corona1_Thresh, '-g' );
scatter(T_C1, Corona1_Peak, 'x');
title('Peak Detect Corona1 Data Set');
xlabel('Sample Number');
ylabel('Signal (mV)');
legend('Wavelet Extended Data Set', 'Denoised Data Set', 'Threshold Data Set', 'Peak Detected', 'Location', 'SouthWest');
xlim([108 112]);
hold off

figure(19);
plot(T_C1_old, Void2_Ext);
hold on
plot(T_C1_old, Void2_Filt,  '-r');
plot(T_C1_old, Void2_Thresh, '-g' );
scatter(T_V2, Void2_Peak, 'x');
plot(Wave, SinWave, '-m');
title('Peak Detect Void2 Data Set');
xlabel('Time(ms)');
ylabel('Signal (mV)');
legend('Wavelet Extended Data Set', 'Denoised Data Set', 'Threshold Data Set', 'Peak Detected','Sine Wave', 'Location', 'SouthWest');
xlim([390 400]);
hold off


figure(20);
plot(T_C1_old, Surface2_Ext);
hold on
plot(T_C1_old, Surface2_Filt,  '-r');
plot(T_C1_old, Surface2_Thresh, '-g' );
scatter(T_S2, Surface2_Peak, 'x');
title('Peak Detect Surface2 Data Set');
xlabel('Tims(ms)');
ylabel('Signal (mV)');
legend('Wavelet Extended Data Set', 'Denoised Data Set', 'Threshold Data Set', 'Peak Detected', 'Location', 'SouthWest');
xlim([107 111]);
hold off



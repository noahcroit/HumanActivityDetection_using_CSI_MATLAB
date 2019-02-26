%% Read .csv file
% csi_dataTableFile    = 'csi_data.csv';
% csi_dataTableFile    = 'data_no_preserve_5PM.csv';
% csi_dataTableFile    = 'jok.csv';
% csi_dataTableFile    = 'jok.csv';
csi_dataTableFile = 'no_people.csv';

% [num, txt, raw] = xlsread(csi_dataTableFile);
[num, txt, raw] = xlsread(csi_dataTableFile);

% Convert 'cell' data-type to double
rawForCSI   = str2double(txt);

% Read time-stamp
t_stamp     = (cell2mat(raw(:, 2)))./1000;

% Put raw data into "CSI channel matrix"
[r, c] = size(txt);
csi_complexNumData = zeros(r, 64);
for n = 1:r
    for m = 1:64
        csi_complexNumData(n, m) = rawForCSI(n, m+2);
    end
end

%% Extract CSI Magnitude time-waveform

% Calculate magnitude & phase
CSI_Magnitude = abs(csi_complexNumData);
CSI_Phase     = angle(csi_complexNumData);

% Select CSI signal by the channel
channel = 1:30;
x = zeros(r, length(channel));

% Time-waveform interpolation + re-sampling & moving average
fresampling = 50;
dt = 1/fresampling;
t_resampling = (dt : dt : 200)';
x_smooth = zeros(length(t_resampling), length(channel));
for c = 1 : length(channel)
 
    x(:, c) = CSI_Magnitude(:, channel(c));

    % Time-waveform interpolation + re-sampling & moving average 
    t_resampling = (dt : dt : 200)';
    interpolate_method = 'linear';
    x_channel_c = x(:, c);
    x_channel_c_interpolated = interp1(t_stamp, x_channel_c, t_resampling, interpolate_method);
    x_channel_c_smooth = smooth(x_channel_c_interpolated, 'moving');
    x_smooth(:, c) = x_channel_c_smooth;
end

%% Extract spectrogram from time-domain CSI signal
windowLength  = 128;
overlap = 64;

for c = 21 : 21
%for c = 1 : length(channel)
    %figure;
    % spectrogram(x_smooth(:, c), windowLength, overlap, fresampling);
    % title('Without human activity (No human)');
    % title('With human activity (Walking)');
    s = spectrogram(x_smooth(:, c), windowLength, overlap, windowLength);
    s = s';
    %s = s(:, 2:windowLength);
    psd = abs(s);
    
    %% Save spectrogram log to excel
%     filename = ['CSI_spectrogram (channel', num2str(c), ' ', csi_dataTableFile, ').xlsx'];
%     xlswrite(filename, spectrogram_magnitude, 'B1:BM30');
%     xlswrite(filename, t, 'A1:A30');
end

%% Extract feature using PCA
% PCA is calculated from matrix of spectrogram(s)
[r_psd, c_psd] = size(psd);
PCA = zeros(c_psd, overlap + 1);
for frame = 3 : r_psd
    psd_1 = psd(frame-1, :);
    psd_2 = psd(frame, :);
    diff_psd = [psd_1; psd_2];
    coeff = pca(diff_psd);
    PCA(frame, :) = coeff;
end

%% Save spectrogram log to excel

t_frameLog = (1 : r_psd).*(overlap/fresampling);
filename = ['feature_of_csi (', csi_dataTableFile, ').xlsx'];

%%
writeData = [t_frameLog' PCA];
xlswrite(filename, writeData, 'A');



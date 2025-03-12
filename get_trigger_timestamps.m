% 
dir = 'Z:/Animals/Test_files/';

%%
% read wavesurfer file
filename = '#Test_cam_1_0001.h5';

data = ws.loadDataFile(fullfile(dir,filename)); %using wavesurfer function

% get sampling rate
Fs = data.header.AcquisitionSampleRate;

% values in 'ans.sweep_001.analogScans (channels in columns)
%numSamples = size(data.sweep_0001.analogScans, 1);
%timeVector = (0:numSamples-1) / Fs;

channelIndex = 1; %Pulse Train
pulse_signal = data.sweep_0001.analogScans(:, channelIndex);
numSamples = length(pulse_signal);

% get trigger timestamps
threshold = mean(pulse_signal);
risingEdges = find(diff(pulse_signal > threshold) == 1); % find rising edges
timestamps = (risingEdges/Fs)/60; %in minutes

%%
videoname = '#Test_cam_1.avi';
vidObj = VideoReader(fullfile(dir,videoname));
numFrames = vidObj.NumFrames;
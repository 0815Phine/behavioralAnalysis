% 
dir = 'Z:/Animals/Test_files/';

%%
% read wavesurfer file
filename = '#Test_cam_5_0001.h5';

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
t_ts = (risingEdges/Fs)/60; %in minutes

%%
videoname = '#Test_cam_5.avi';
vidObj = VideoReader(fullfile(dir,videoname));
numFrames = vidObj.NumFrames;

% load timestamps
v_ts = load(fullfile(dir,'#Test_cam_5_video_timestamps.txt'));
time_diff = diff(v_ts);
cumulative_time = ([0; cumsum(time_diff)])/60;

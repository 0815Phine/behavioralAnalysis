% 
dir = 'Z:/Animals/Test_files/250702';

%% from wavesurfer Pulse Train
% read wavesurfer file
filename = 'hab_test_2_0001.h5';

data = ws.loadDataFile(fullfile(dir,filename)); %using wavesurfer function

% get sampling rate
Fs = data.header.AcquisitionSampleRate;

% values in 'ans.sweep_001.analogScans (channels in columns)
%numSamples = size(data.sweep_0001.analogScans, 1);
%timeVector = (0:numSamples-1) / Fs;

chanFlag = find(contains(data.header.AIChannelNames, 'Cam'));
for i = 1:length(chanFlag)
    chanIdx = chanFlag(i);
    pulse_signal = data.sweep_0001.analogScans(:, chanIdx);
    %numSamples(chanIdx) = length(pulse_signal);

    % get trigger timestamps
    threshold = mean(pulse_signal);
    risingEdges = find(diff(pulse_signal > threshold) == 1); % find rising edges
    t_ts{i} = (risingEdges/Fs)/60; %in minutes
    clear("pulse_signal")
end

%% from video file (this takes long!!!)
videoname = '#Test_hab_2.mp4';
vidObj = VideoReader(fullfile(dir,videoname));
numFrames = vidObj.NumFrames;

%% from timestamps.txt file
% load timestamps
v_ts = load(fullfile(dir,'#Test_hab_2_video_timestamps.txt'));
time_diff = diff(v_ts);
cumulative_time = ([0; cumsum(time_diff)])/60;

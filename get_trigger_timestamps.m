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

%% compare timestamps
trigg_diff = diff(t_ts{1,1});

figure;
plot(trigg_diff, 'b.-'); hold on;
plot(time_diff, 'r.-');
legend('Trigger intervals', 'Video intervals');
xlabel('Frame index');
ylabel('Time between frames');
title('Frame interval comparison');

%% find missing frames
idx_diff = zeros(length(t_ts{1,1}), 1); % 0 if match, 1 if missing
j = 1; % index for video timestamps
trigger_ts = t_ts{1,1};

for i = 1:length(trigger_ts)
    if j > length(cumulative_time)
        idx_diff(i:end) = 1; % remaining triggers have no video match
        break;
    end
    if abs(trigger_ts(i) - cumulative_time(j)) < 0.005
        % Match
        idx_diff(i) = 0;
        j = j + 1;
    else
        % No match, mark as missing
        idx_diff(i) = 1;
    end
end

% Show missing frame indices
missingFrames = find(idx_diff == 1);
disp('Missing frame indices:');
disp(missingFrames);
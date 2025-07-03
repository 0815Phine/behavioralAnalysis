%%
% define start path
startdir = 'Z:/Animals';
startdir = uigetdir(startdir,'Select folder');

%% from wavesurfer Pulse Train
% read wavesurfer file
ws_file = dir(fullfile(startdir, '*.h5'));
ws_fname = ws_file(1).name;

ws_data = ws.loadDataFile(fullfile(startdir, ws_fname)); %using wavesurfer function

% get sampling rate
Fs = ws_data.header.AcquisitionSampleRate;

chanFlag = find(contains(ws_data.header.AIChannelNames, 'Cam'));
for i = 1:length(chanFlag)
    chanIDX = chanFlag(i);
    pulse_signal = ws_data.sweep_0001.analogScans(:, chanIDX);

    % get trigger timestamps
    threshold = mean(pulse_signal);
    risingEdges = find(diff(pulse_signal > threshold) == 1); % find rising edges
    t_ts{i} = (risingEdges/Fs)/60; %in minutes
    clear("pulse_signal")
end

%% from video file (this takes long!!!)
v_files = dir(fullfile(startdir, '*.mp4'));
v_name = v_files(1).name;
vidObj = VideoReader(fullfile(startdir,v_name));
numFrames = vidObj.NumFrames;

%% from timestamps.txt file
% load timestamps
txt_files = dir(fullfile(startdir, '*.txt'));
v_ts = load(fullfile(startdir,txt_files(1).name));
time_diff = diff(v_ts);
cumulative_time = ([(t_ts{1,1}(1)*60); cumsum(time_diff)])/60; %in minutes

%% compare timestamps
fig1 = figure;
plot(time_diff); hold on;

for wsIDX = 1:length(t_ts)
    trigg_diff = diff(t_ts{1,wsIDX}*60);
    plot(trigg_diff);
end

legend('Video intervals', 'Trigger intervals', 'Feedback intervals');
xlabel('Frame index');
ylabel('Time between frames[s]');
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
    if abs(trigger_ts(i) - cumulative_time(j)) < 5e-4 %tolerance of three frames
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
fprintf('You are missing %d frames\n', length(trigger_ts)-numFrames)
disp('Potential missing frame indices:');
disp(missingFrames);

%% save figure
fig_name = fullfile(startdir, 'frame_interval_comparison.png');
%saveas(fig1, fig_name)
exportgraphics(fig1, fig_name)


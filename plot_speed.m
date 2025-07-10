function [speed,fig_speed] = plot_speed(ws_data)
% the following variables are based on the Arduino Sketch
MaxSpeed = 1; %in m/s
MinSpeed = -MaxSpeed;
Maxpwm = 4095;

% get wavesurfer signal
chanFlag = find(contains(ws_data.header.AIChannelNames, 'Speed'));
pulse_signal = ws_data.sweep_0001.analogScans(:, chanFlag);
% get sampling rate
fs = ws_data.header.AcquisitionSampleRate;

%% calculate duty cycle
threshold = mean(pulse_signal);
T_window = 0.01;
samples_per_window = round(fs * T_window);
num_windows = floor(length(pulse_signal) / samples_per_window);

duty_cycles = zeros(1, num_windows);
time_vector = zeros(1, num_windows);
for i = 1:num_windows
    start_idx = (i - 1) * samples_per_window + 1;
    end_idx = i * samples_per_window;
    window = pulse_signal(start_idx:end_idx);

    high_time = sum(window > threshold);   % Count of HIGH samples
    duty_cycles(i) = high_time / samples_per_window * 100;  % In percent
    time_vector(i) = (start_idx - 1) / fs;  % Time at the start of window
end

%% calculate speed from duty cycle
pwmOut = duty_cycles / 100 * Maxpwm;
speed = pwmOut*((MaxSpeed-MinSpeed)/Maxpwm) + MinSpeed;

%% plot speed
fig_speed = figure;
plot(time_vector, speed);
ylabel('Speed (m/s)');
xlabel('Time (s)');
title('Speed over Time');
end
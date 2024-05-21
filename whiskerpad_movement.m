%% 

% get users home directory
home_dir = getenv('USERPROFILE');
% define the start path
start_path = fullfile(home_dir, 'OneDrive\Whiskertracking\Videos');
% select the folder
start_path = uigetdir(start_path, 'Select Session Folder');
% select file
[file_name,~] = uigetfile({'*.csv', 'Excel File'}, 'Select a file', start_path);

% load the selected excel file
file_matrix = readmatrix(fullfile(start_path,file_name));
file_table = readtable(fullfile(start_path,file_name), 'Range','A2'); % x, y, likelihood

% choose dimensions to analyze
headers = file_table.Properties.VariableNames;
x_col_IDX = listdlg('ListString',headers,'PromptString','Choose the columns to analyze.');

% define your framerate (you can find it in the .pickle file, use load_metadata.py
framerate = 200;

%%
color_map = [[0.502 0 1]; [0.251 0.3843 0.984];...
    [0 0.7059 0.9254]; [0.251 0.9255 0.8314];...
    [0.502 1 0.7059]; [0.749 0.9255 0.5569];...
    [1 0.7059 0.3843]; [1 0.3843 0.1961]; [1 0 0]];

figure; subplot(3,1,1:2)
dist = NaN(length(file_matrix)-1,length(x_col_IDX));
for col_IDX = x_col_IDX
    loop_IDX = find(x_col_IDX == col_IDX);
    %figure(loop_IDX); hold on
    med_col = median(file_matrix(:,col_IDX));
    for row_IDX = 2:length(file_matrix)
        if file_matrix(row_IDX,col_IDX) < med_col
            dist(row_IDX-1, loop_IDX) = (med_col - file_matrix(row_IDX,col_IDX))*-1;
        elseif file_matrix(row_IDX,col_IDX) > med_col
            dist(row_IDX-1, loop_IDX) = file_matrix(row_IDX,col_IDX) - med_col;
        end
    end
    plot((1:length(file_matrix)-1)/framerate,dist(:,loop_IDX), 'Color', color_map(loop_IDX,:))
    hold on
end
legend(headers{x_col_IDX})
title('Movement of whiskerpad')
label_y = ylabel('Distance to median in x-dimension [pixel]');
label_y.Position(2) = -30;

subplot(3,1,3)
med_dist = median(dist,2,'omitnan');
plot((1:length(med_dist))/framerate,med_dist, 'k')
xlabel('Time [sec]');
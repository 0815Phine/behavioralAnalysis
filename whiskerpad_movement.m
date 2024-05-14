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
for col_IDX = x_col_IDX
    loop_IDX = find(x_col_IDX == col_IDX);
    %figure(loop_IDX); hold on
    med_col = median(file_matrix(:,col_IDX));
    for row_IDX = 2:length(file_matrix)
        if file_matrix(row_IDX,col_IDX) < med_col
            dist(row_IDX-1) = (med_col - file_matrix(row_IDX,col_IDX))*-1;
        elseif file_matrix(row_IDX,col_IDX) > med_col
            dist(row_IDX-1) = file_matrix(row_IDX,col_IDX) - med_col;
        end
    end
    plot((1:length(file_matrix)-1)/framerate,dist, 'Color', color_map(loop_IDX,:))
    hold on
end

title('Movement of whiskerpad')
xlabel('Time [sec]'); ylabel('Distance to median in x-dimension [pixel]')
legend(headers{x_col_IDX})

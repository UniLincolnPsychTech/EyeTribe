clear all
close all

[sock, screen] = etconnect(6555); % Connect to EyeTribe

%% Pre-load stimuli
stim = etstim(screen, 'example_image.png');
txt = etstim(screen, 'example_text.txt', [NaN, 200]);

%% Define regions of interest
stim.ROI = etroi('Image', stim); % Define ROI for image (supplied stim structure rather than coords)
txt.ROI = etroi('Text', ... % Define ROI for text stimulus...
    txt.Pos(1) + [0 0 500 500], ... % ...text corner x coords (formatted to define a polygon)
    txt.Pos(2) + [0 500 500 0] ... % ...text corner y coords (formatted to define a polygon)
    );

%% Initialise window
[ax, fig] = etwindow(); % Create window

%% Draw stimuli
stim = etstim(ax, stim); % Draw image stimulus
txt = etstim(ax, txt); % Draw text stimulus
drawnow % Refresh window

%% Get data from EyeTribe
data = etrun(sock, 30, stim.ROI, txt.ROI); % Run the EyeTribe for 30 seconds, with ROI's for the image and text

%% End Experiment
close(fig); % Close window
etdisconnect(sock); % Disconnect EyeTribe

%% Plot results
[fig2, ax2] = etplot(data, screen, stim, txt); % Plot trace on top of stimuli and ROI's

%% Save data
dataFlat = etcsv(data, 'example_data.csv'); % Flatten data and save as a csv
clear all
close all

[sock, screen] = etconnect(6555); % Connect to EyeTribe

%% Pre-load stimuli
stim = etstim(screen, 'example_image.png'); % Load an image stimulus
txt = etstim(screen, 'example_text.txt', [NaN, 200]); % Load a text stimulus

%% Define regions of interest
stim.ROI = etroi('Image', stim); % Define ROI for image (supplied stim structure rather than coords)
txt.ROI = etroi('Text', ... % Define ROI for text stimulus...
    txt.Pos(1) + [-300 -300 300 300], ... % ...text corner x coords (formatted to define a polygon)
    txt.Pos(2) + [-50  50   50  -50] ... % ...text corner y coords (formatted to define a polygon)
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
[fig2, ax2] = etplot(data, screen, ... % Plot trace...
    stim, txt, ... % ...stimuli...
    stim.ROI, txt.ROI ... % ...and regions of interest
    );

%% Save data
dataFlat = etcsv(data, 'example_data.csv'); % Flatten data and save as a csv
function etdrawroi(screen, varargin)
% NTS: Add save button, fix text drawing


%% Create figure
sDim = get(groot, 'ScreenSize'); % Get screen size
s = min( (sDim(3)-200) / screen.Width, (sDim(4)-200) / screen.Height ); % Calculate the ratio between the screen used for testing and current screen
fig = uifigure(...
    'InnerPosition', sDim.*s, ... % Make figure the same size as the screen * scale
    'WindowButtonDownFcn', @getcoords ...
    );
movegui(fig, 'center');

%% Create axis
ax = axes(fig, ... % Create axis
    'Position', [0.1, 0.15, 0.8, 0.8], ... % Fill window
    'NextPlot', 'add', ... % Keep plots when drawing new ones
    'XLim', [0, screen.Width], ... % X limits to window width (pixels)
    'YLim', [0, screen.Height], ... % X limits to window width (pixels)
    'Color', [0.97, 0.97, 0.99], ... % Grey background
    'Box', 'off', ... % No outline
    'TickLength', [0 0], ... % No tickmarks
    'FontName', 'Verdana', ... % Nicer font
    ... % Add major gridlines
    'GridColor', 'white', ... % White lines
    'GridAlpha', 1, ... % Full opacity
    'GridLineStyle', '-', ... % Solid lines
    'XGrid', 'on', ... % Vertical lines
    'YGrid', 'on', ... % Horizontal lines
    ... % Add minor gridlines
    'MinorGridColor', 'white', ... % White lines
    'MinorGridAlpha', 1, ... % Full opacity
    'MinorGridLineStyle', '-', ... % Solid lines
    'XMinorGrid', 'on', ... % Vertical lines
    'YMinorGrid', 'on' ... % Horizontal lines
    );

%% Draw stimulus
for stim = varargin % For each stimulus...
    stim = stim{:}; % Remove extraneous layer
    etstim(ax, stim.Dir, stim.Pos(1), stim.Pos(2), stim.Pos(3), stim.Pos(4)); % Draw stimulus
end

%% Draw beginnings of roi
fig.UserData.roi = [];
fig.UserData.obj = [];
fig.UserData.screen = screen;

function getcoords(app, event)
    ax = findobj(app, 'Type', 'axes');
    axpos = ax.Position .* app.Position([3 4 3 4]); % Axis position relative to the figure
    relpos = ( app.CurrentPoint - axpos([1 2]) ) ./ axpos([3 4]); % How far into the axis was the click?
    abspos = [max(ax.XLim) max(ax.YLim)] .* relpos; % What is the on-screen equivalent of the click?

    delete(app.UserData.obj)
    app.UserData.roi = [app.UserData.roi; abspos];
    
    if size(app.UserData.roi, 1) < 3
        app.UserData.obj = scatter(ax, app.UserData.roi(:,1), app.UserData.roi(:,2));
    else
        app.UserData.obj = plot(ax, polyshape(app.UserData.roi(:,1), app.UserData.roi(:,2)));
        set(app.UserData.obj, ...
            'FaceColor', 'b', ...
            'EdgeColor', 'b', ...
            'LineWidth', 2 ...
            )
    end 
end
end
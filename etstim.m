function stim = etstim(ax, stimdir, x, y, w, h)

%% Defaults for non-values


%% Create storage structure
stim = struct(...
    'Type', [], ... % File type
    'Pos', [x y w h], ... % Position (x, y, width, height)
    'Dir', stimdir, ... % File location
    'Obj', [] ... % Object handle
    );

%% Determine stim type
stimdirSplt = strsplit(stimdir, '.');
stimExt = stimdirSplt{end};
imgExts = imformats;
switch stimExt
    %% If stimulus is an image
    case [imgExts.ext] % If stimulus is an image...
        %% Read image
        [img, ~, alpha] = imread(stimdir); % Read image
        if isempty(alpha) % If no transparency data...
            alpha = ones(size(img, [1,2])); % Set all pixels to fully opaque
        end
        
        %% Defaults for non-values
        if isempty(w) % If width is blank...
            stim.Pos(3) = size(img, 2); % Default to full size
        end
        if isempty(h) % If height is blank...
            stim.Pos(4) = size(img, 1); % Default to full size
        end
        if isempty(x) % If x is blank...
            stim.Pos(1) = (ax.XLim(2) - stim.Pos(3)) / 2; % Default to center
        end
        if isempty(y) % If y is blank...
            stim.Pos(2) = (ax.YLim(2) - stim.Pos(4)) / 2; % Default to center
        end
        
        %% Draw image
        stim.Obj = image(ax, ...
            'XData', [stim.Pos(1), stim.Pos(1) + stim.Pos(3)], ... % Position horizontal
            'YData', [stim.Pos(2), stim.Pos(2) + stim.Pos(4)], ... % Position vertical
            'CData', flipud(img), ... % Flip upside down as y axes are backwards
            'AlphaData', flipud(alpha) ... % Apply transparency
            );
    case 'txt'
        %% Read text
        txt = fileread(stimdir);
        
        %% Defaults for non-values
        if isempty(w) % If width is blank...
            stim.Pos(3) = 0.8; % Default to full size
        end
        if isempty(h) % If height is blank...
            stim.Pos(4) = 0.2; % Default to full size
        end
        if isempty(x) % If x is blank...
            stim.Pos(1) = 0.1; % Default to center
        end
        if isempty(y) % If y is blank...
            stim.Pos(2) = 0.1; % Default to center
        end
        
        %% Draw text
        stim.Obj = annotation('textbox', ...
            'EdgeColor', 'none', ...
            'FontSize', 20, ...
            'Position', [stim.Pos(1) stim.Pos(2) stim.Pos(3) stim.Pos(4)], ...
            'String', txt);
end





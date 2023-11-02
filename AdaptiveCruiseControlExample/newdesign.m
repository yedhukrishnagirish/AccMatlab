function ACC_GUI()
    % Create the main figure
    fig = figure('Position', [100, 100, 600, 400], 'MenuBar', 'none', 'NumberTitle', 'off', 'Name', 'ACC System');
    fig = uifigure;
    k = uiknob(fig);
    %k.Value = 45;
    % Create UI components
    uicontrol('Style', 'text', 'String', 'Lead Car Speed:', 'Position', [50, 300, 100, 25]);
    lead_speed_edit = uicontrol('Style', 'edit', 'Position', [160, 300, 100, 25]);
    uicontrol('Style', 'text', 'String', 'Ego Car Speed:', 'Position', [50, 250, 100, 25]);
    ego_speed_edit = uicontrol('Style', 'edit', 'Position', [160, 250, 100, 25]);
    plot_button = uicontrol('Style', 'pushbutton', 'String', 'Plot Velocity Graph', 'Position', [50, 200, 200, 30], 'Callback', @plotGraph);
    velocity_plot = axes('Parent', fig, 'Position', [0.1, 0.1, 0.8, 0.6]);
    
    function plotGraph(~, ~)
        % Get speeds from the edit fields
        lead_speed = str2double(get(lead_speed_edit, 'String'));
        ego_speed = str2double(get(ego_speed_edit, 'String'));
        
        % Check for invalid input
        if isnan(lead_speed) || isnan(ego_speed)
            errordlg('Invalid input. Please enter valid numbers.', 'Error');
            return;
        end
        
        % Call ACC function with the given speeds
        ACC(lead_speed, ego_speed);
    end
end

function ACC(lead_speed, ego_speed)
    % ACC Parameters
    desired_distance = 5; % Desired following distance in meters
    time_gap = 1.5; % Time gap in seconds
    
    % Simulation Parameters
    time_step = 0.1; % Simulation time step in seconds
    initial_distance = 20; % Initial distance between cars in meters
    initial_velocity = 0; % Initial velocity in m/s
    
    % Simulation Loop
    time = 0:time_step:60; % Simulation time from 0 to 60 seconds
    lead_velocity = ones(size(time)) * lead_speed;
    ego_velocity = zeros(size(time));
    distance = initial_distance;
    
    for i = 2:length(time)
        % ACC Control Law
        acceleration = 0.2 * (lead_velocity(i-1) - ego_velocity(i-1)) + 0.1 * (distance - desired_distance);
        ego_velocity(i) = ego_velocity(i-1) + acceleration * time_step;
        distance = distance - ego_velocity(i-1) * time_step;
    end
    
    % Plotting
    plot(time, lead_velocity, 'b-', 'LineWidth', 2, 'DisplayName', 'Lead Car');
    hold on;
    plot(time, ego_velocity, 'r-', 'LineWidth', 2, 'DisplayName', 'Ego Car');
    hold off;
    xlabel('Time (s)');
    ylabel('Velocity (m/s)');
    title('Adaptive Cruise Control System');
    legend('show');
end

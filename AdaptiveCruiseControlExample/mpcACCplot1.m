function mpcACCplot1(logsout, D_default, t_gap, v_set, plotAxes)
    %% Get the data from simulation
    a_ego = logsout.getElement('a_ego');             % acceleration of ego car
    v_ego = logsout.getElement('v_ego');             % velocity of ego car
    a_lead = logsout.getElement('a_lead');           % acceleration of lead car
    v_lead = logsout.getElement('v_lead');           % velocity of lead car
    d_rel = logsout.getElement('d_rel');             % actual distance
    d_safe = D_default + t_gap * v_ego.Values.Data;  % desired distance
    
    %% Plot the results on specified axes
    
    axes(plotAxes);
    cla(plotAxes); % Clear existing plot on specified axes
    hold(plotAxes, 'on'); % Hold the specified axes for updating
    
    % Get data points
    time = v_ego.Values.time;
    v_ego_data = v_ego.Values.Data;
    v_lead_data = v_lead.Values.Data;
    v_set_data = v_set * ones(size(time));

  
    
    % Plot data point by point with dots and pause
    for i = 1:length(time)
        % Plot velocity data point by point with dots
        plot(plotAxes, time(i), v_ego_data(i), '.', 'Color', 'r', 'MarkerSize', 5);
        plot(plotAxes, time(i), v_lead_data(i), '.', 'Color', 'b', 'MarkerSize', 5);
        
        %disp(['Lead Car Velocity: ' num2str(v_lead_data(i)) ' m/s']);
        
        grid(plotAxes, 'on');
        ylim(plotAxes, [0, 100]); % Set y-axis limit from 15 to 35
        legend(plotAxes, 'ego', 'lead', 'set', 'location', 'SouthEast');
        title(plotAxes, 'Velocity');
        xlabel(plotAxes, 'time (sec)');
        ylabel(plotAxes, '$m/s$', 'Interpreter', 'latex');
        
        % Pause to show the graph point by point
        pause(0.00000000001); % Adjust the pause duration (in seconds) as needed
    end
    
    hold(plotAxes, 'on'); % Release hold on specified axes for next update
end

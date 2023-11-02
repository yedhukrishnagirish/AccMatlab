function mpcACCplot2(logsout, D_default, t_gap, v_set, plotAxesA,plotAxesV,plotAxesD)
    %% Get the data from simulation
    a_ego = logsout.getElement('a_ego');             % acceleration of ego car
    v_ego = logsout.getElement('v_ego');             % velocity of ego car
    a_lead = logsout.getElement('a_lead');           % acceleration of lead car
    v_lead = logsout.getElement('v_lead');           % velocity of lead car
    d_rel = logsout.getElement('d_rel');             % actual distance
    d_safe = D_default + t_gap * v_ego.Values.Data;  % desired distance
    
    %% Plot the results on specified axes

    axes(plotAxesA);
    cla(plotAxesA); % Clear existing plot on specified axes
    hold(plotAxesA, 'on'); % Hold the specified axes for updating
    
    axes(plotAxesV);
    cla(plotAxesV); % Clear existing plot on specified axes
    hold(plotAxesV, 'on'); % Hold the specified axes for updating

    axes(plotAxesD);
    cla(plotAxesD); % Clear existing plot on specified axes
    hold(plotAxesD, 'on'); % Hold the specified axes for updating
    
    % Get data points
    time = v_ego.Values.time;


    a_ego_data = a_ego.Values.Data;
    a_lead_data = a_lead.Values.Data;

    v_ego_data = v_ego.Values.Data;
    v_lead_data = v_lead.Values.Data;
    v_set_data = v_set * ones(size(time));

    d_rel_data = d_rel.Values.Data;
    d_safe_data = d_safe;

    % Plot the entire dataset at once
    plot(plotAxesA, time, a_ego_data, '.', 'Color', 'r', 'MarkerSize', 5);
    plot(plotAxesA, time, a_lead_data, '.', 'Color', 'b', 'MarkerSize', 5);

    plot(plotAxesV, time, v_ego_data, '.', 'Color', 'r', 'MarkerSize', 5);
    plot(plotAxesV, time, v_lead_data, '.', 'Color', 'b', 'MarkerSize', 5);

    plot(plotAxesD, time, d_rel_data, '.', 'Color', 'r', 'MarkerSize', 5);
    plot(plotAxesD, time, d_safe_data, '.', 'Color', 'b', 'MarkerSize', 5);
   % plot(plotAxes, time, v_set_data, '.', 'Color', 'g', 'MarkerSize', 5);

    grid(plotAxesA, 'on');
    ylim(plotAxesA, [0, 100]); % Set y-axis limit from 0 to 100
    legend(plotAxesA, 'ego', 'lead', 'set', 'location', 'SouthEast');
    title(plotAxesA, 'Acceleration');
    xlabel(plotAxesA, 'time (sec)');
    ylabel(plotAxesA, '$m/s^2$', 'Interpreter', 'latex');

     grid(plotAxesV, 'on');
    ylim(plotAxesV, [0, 100]); % Set y-axis limit from 0 to 100
    legend(plotAxesV, 'ego', 'lead', 'set', 'location', 'SouthEast');
    title(plotAxesV, 'Velocity');
    xlabel(plotAxesV, 'time (sec)');
    ylabel(plotAxesV, '$m/s$', 'Interpreter', 'latex');


     grid(plotAxesD, 'on');
    ylim(plotAxesD, [0, 100]); % Set y-axis limit from 0 to 100
    legend(plotAxesD, 'ego', 'lead', 'set', 'location', 'SouthEast');
    title(plotAxesD, 'Distance');
    xlabel(plotAxesD, 'time (sec)');
    ylabel(plotAxesD, '$m$', 'Interpreter', 'latex');
end

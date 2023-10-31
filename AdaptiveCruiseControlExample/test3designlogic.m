function main 
    clc;
    clearvars;

    D_default = 15;
    
    mdl = 'mpcACCsystem';
    T = 100;
    Ts = 0.1;
    
    t_gap = 1.4;
    
    
    x0_lead = 50;
    v0_lead = 25;

    x0_ego = 10;
    v0_ego = 20;

    v_set = 50;

    assignin('base', 'D_default', D_default);
   
    assignin('base', 'mdl', mdl);

    assignin('base', 'T', T);
    assignin('base', 't_gap', t_gap);
    assignin('base', 'Ts', Ts);

    assignin('base', 'x0_lead', x0_lead);
    assignin('base', 'v0_lead', v0_lead);

    assignin('base', 'x0_ego', x0_ego);
    assignin('base', 'v0_ego', v0_ego);
    assignin('base', 'v_set', v_set);

    fig = figure('Position', [100, 100, 600, 400]); 
    handles.fig = fig;

    updateSpeed(handles);
end

function updateSpeed(handles)
    % Initialize simulation state
    handles.simulationRunning = true;
    handles.simulationTime = 0;
    handles.increaseButtonPressed = false;
    handles.decreaseButtonPressed = false;
    handles.clicked = false

    % Increase Speed Button closer to the top center
    handles.increaseButton = uicontrol('Style', 'pushbutton', 'Position', [180, 300, 100, 30], 'String', 'Increase Speed', 'Callback', @increaseSpeedCallback);

    % Decrease Speed Button closer to the top center
    handles.decreaseButton = uicontrol('Style', 'pushbutton', 'Position', [320, 300, 100, 30], 'String', 'Decrease Speed', 'Callback', @decreaseSpeedCallback);

    function increaseSpeedCallback(~, ~)
        handles.increaseButtonPressed = true;
        handles.decreaseButtonPressed = false;
        handles.clicked = true
        runSimulation(handles);
        
    end

    function decreaseSpeedCallback(~, ~)
        handles.increaseButtonPressed = false;
        handles.decreaseButtonPressed = true;
        handles.clicked = true
        runSimulation(handles);
        
    end

    % Run the simulation

    runSimulation(handles);
end


function runSimulation(handles)
    % Simulation parameters
    D_default = evalin('base', 'D_default');
    mdl = evalin('base', 'mdl');
    Ts = evalin('base', 'Ts');
    t_gap = evalin('base', 't_gap');
    x0_lead = evalin('base', 'x0_lead');
    v0_ego = evalin('base', 'v0_ego');
    x0_ego = evalin('base', 'x0_ego');
    v_set = evalin('base', 'v_set');

    % Plotting setup
    fig = handles.fig;
    plotAxes = axes('Parent', fig, 'Position', [0.1, 0.1, 0.8, 0.8], 'XLim', [0, 100], 'YLim', [0, 100]);
    
    %if handles.clicked == false
        sim(mdl)
        mpcACCplot2(logsout, D_default, t_gap, v_set,plotAxes, handles);
    %end    

   
end

function mpcACCplot2(logsout, D_default, t_gap, v_set, plotAxes, handles)
    
    %% Get the data from simulation
    v_ego = logsout.getElement('v_ego');             % velocity of ego car
    v_lead = logsout.getElement('v_lead');           % velocity of lead car
    d_rel = logsout.getElement('d_rel');             % actual distance
    d_safe = D_default + t_gap * v_ego.Values.Data;  % desired distance
    
 
    % Plot the results on specified axes
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
        if handles.increaseButtonPressed
             disp('pressed');
             disp(v_lead_data(i));
             v_lead_data(i) = v_lead_data(i) + 3; % Increase lead car speed by 3 m/s
             assignin('base', 'v0_lead',  v_lead_data(i));
             disp('after');
             disp(v_lead_data(i));
             handles.increaseButtonPressed = false
             
             
        elseif handles.decreaseButtonPressed
              v_lead_data(i) = v_lead_data(i) - 3; % Decrease lead car speed by 3 m/s
              assignin('base', 'v0_lead',  v_lead_data(i));
              handles.decreaseButtonPressed = false
              
        end

        
        plot(plotAxes, time(i), v_ego_data(i), '.', 'Color', 'r', 'MarkerSize', 5);
        plot(plotAxes, time(i), v_lead_data(i), '.', 'Color', 'b', 'MarkerSize', 5);
        
       % disp(['Lead Car Velocity: ' num2str(v_lead_data(i)) ' m/s']);
        
        grid(plotAxes, 'on');
        ylim(plotAxes, [0, 100]); % Set y-axis limit from 0 to 100
        legend(plotAxes, 'ego', 'lead', 'set', 'location', 'SouthEast');
        title(plotAxes, 'Velocity');
        xlabel(plotAxes, 'time (sec)');
        ylabel(plotAxes, '$m/s$', 'Interpreter', 'latex');
        
        % Pause to show the graph point by point
        pause(0.00000000001); % Adjust the pause duration (in seconds) as needed
    end
    
    hold(plotAxes, 'on'); % Release hold on specified axes for next update
end



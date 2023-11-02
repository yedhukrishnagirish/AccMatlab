function main 
    clc;
    clearvars;

    D_default = 15;
    
    mdl = 'mpcACCsystem';
    T = 80;
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

    updateSpeed()
end
function updateSpeed

    fig = figure('Position', [100, 100, 600, 400]); 

    handles.speed = 25;
    handles.fig = fig; % Store the figure handle in handles structure

    % Speed Label at the top
    % Speed Label closer to the top center
   
    
    handles.speedLabel = uicontrol('Style', 'text', 'Position', [250, 350, 100, 30], 'String', ['Speed: ' num2str(handles.speed)]);

    % Increase Speed Button closer to the top center
    handles.increaseButton = uicontrol('Style', 'pushbutton', 'Position', [180, 300, 100, 30], 'String', 'Increase Speed', 'Callback', @increaseSpeed);

    % Decrease Speed Button closer to the top center
    handles.decreaseButton = uicontrol('Style', 'pushbutton', 'Position', [320, 300, 100, 30], 'String', 'Decrease Speed', 'Callback', @decreaseSpeed);


    % Set the 'UserData' property of the figure to store handles
    handles.plotAxes = axes('Parent', handles.fig, 'Position', [0.3, 0.1, 0.6, 0.4], 'XLim', [0, 50], 'YLim', [0, 100]);
    set(fig, 'UserData', handles);
    % Callback function to increase speed


    function increaseSpeed(~, ~)
        handles = get(handles.fig, 'UserData'); % Retrieve handles structure
        handles.speed = handles.speed + 3;
        updatePlot(handles);
        
        % Store the updated handles structure
        set(handles.fig, 'UserData', handles);
    end
    % Callback function to decrease speed
    function decreaseSpeed(~, ~)
        
        handles = get(handles.fig, 'UserData'); % Retrieve handles structure
        if  handles.speed > 0 
             handles.speed = handles.speed - 3;
             updatePlot(handles);
        % Store the updated handles structure
             set(handles.fig, 'UserData', handles);
        end
    end
    % Function to update speed label
    function updatePlot(handles)
        set(handles.speedLabel, 'String', ['Speed: ' num2str(handles.speed)]);
        % Print the speed value in the Command Window
        disp(['Current Speed: ' num2str(handles.speed)]);
        runSimulation(handles.speed,handles.plotAxes)
    end
end
function runSimulation(speed,plotAxes)
    % Simulation code
    
    D_default = evalin('base', 'D_default');
   
    mdl = evalin('base', 'mdl');
    T = evalin('base', 'T');
    Ts = evalin('base', 'Ts');
    t_gap = evalin('base', 't_gap');
    x0_lead = evalin('base', 'x0_lead');
    assignin('base', 'v0_lead', speed);

    v0_ego = evalin('base', 'v0_ego');
    x0_ego = evalin('base', 'x0_ego');
    v_set = evalin('base', 'v_set');
    
    
  
    % Run the simulation
    sim(mdl);
    % Plot the simulation result
   
    mpcACCplot1(logsout, D_default, t_gap, v_set,plotAxes);
    
end
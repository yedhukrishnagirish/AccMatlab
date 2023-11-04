function main 
    clc;
    clearvars;
    D_default = 15;
    v0_ego = 20;
    mdl = 'mpcACCsystem';
    T = 80;
    Ts = 0.1;
    
    t_gap = 1.4;
    
    
    x0_lead = 50;
    v0_lead = 25;
    x0_ego = 20;
    v_set = 10;
    assignin('base', 'D_default', D_default);
    assignin('base', 'v0_ego', v0_ego);
    assignin('base', 'mdl', mdl);
    assignin('base', 'T', T);
    assignin('base', 't_gap', t_gap);
    assignin('base', 'Ts', Ts);
    assignin('base', 'x0_lead', x0_lead);
    assignin('base', 'v0_lead', v0_lead);
    assignin('base', 'x0_ego', x0_ego);
    assignin('base', 'v_set', v_set);
    runSimulation(x0_ego)
    %updateSpeed()
end
function updateSpeed
    fig = figure('Position', [100, 100, 300, 200]);
    handles.speed = 20;
    handles.fig = fig; % Store the figure handle in handles structure
    handles.speedLabel = uicontrol('Style', 'text', 'Position', [20, 150, 100, 30], 'String', ['Speed: ' num2str(handles.speed)]);
    handles.increaseButton = uicontrol('Style', 'pushbutton', 'Position', [20, 100, 100, 30], 'String', 'Increase Speed', 'Callback', @increaseSpeed);
    handles.decreaseButton = uicontrol('Style', 'pushbutton', 'Position', [140, 100, 100, 30], 'String', 'Decrease Speed', 'Callback', @decreaseSpeed);
    % Set the 'UserData' property of the figure to store handles
    set(fig, 'UserData', handles);
    % Callback function to increase speed
    function increaseSpeed(~, ~)
        handles = get(handles.fig, 'UserData'); % Retrieve handles structure
        handles.speed = handles.speed + 3;
        updateSpeedLabel(handles);
        % Store the updated handles structure
        set(handles.fig, 'UserData', handles);
    end
    % Callback function to decrease speed
    function decreaseSpeed(~, ~)
        
        handles = get(handles.fig, 'UserData'); % Retrieve handles structure
        if  handles.speed > 0 
             handles.speed = handles.speed - 3;
             updateSpeedLabel(handles);
        % Store the updated handles structure
             set(handles.fig, 'UserData', handles);
        end
    end
    % Function to update speed label
    function updateSpeedLabel(handles)
        set(handles.speedLabel, 'String', ['Speed: ' num2str(handles.speed)]);
        % Print the speed value in the Command Window
        disp(['Current Speed: ' num2str(handles.speed)]);
       % runSimulation(handles.speed)
    end
end
function runSimulation(speed)
    % Simulation code
    assignin('base', 'v0_ego', speed);
    D_default = evalin('base', 'D_default');
    v0_ego = evalin('base', 'v0_ego');
    mdl = evalin('base', 'mdl');
    T = evalin('base', 'T');
    Ts = evalin('base', 'Ts');
    t_gap = evalin('base', 't_gap');
    x0_lead = evalin('base', 'x0_lead');
    v0_lead = evalin('base', 'v0_lead');
    x0_ego = evalin('base', 'x0_ego');
    v_set = evalin('base', 'v_set');
    
    % Set the new initial velocity for the ego car
  
    % Run the simulation
    sim(mdl);
    % Plot the simulation result
   
    mpcACCplot(logsout, D_default, t_gap, v_set);
    
end
function main
    clc;
    clearvars;
    D_default = 10;
    
    mdl = 'mpcACCsystemModel';
    T = 80;
    Ts = 0.1;
    
    t_gap = 1.4;
    
    x0_lead = 50;
    v0_lead = 25;

    x0_ego = 10;
    v0_ego = 20;

    v_set = 30;

    env_value = 0;
    assignin('base', 'env_value', env_value);
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

    fig = uifigure('Position', [100, 100, 960, 960]);

    handles.v_set = v_set;
    handles.distance = D_default;

    handles.fig = fig;

    handles.plotAxesA = axes('Parent', handles.fig, 'Position', [0.1, 0.65, 0.5, 0.25], 'XLim', [0, 80]);
    handles.plotAxesV = axes('Parent', handles.fig, 'Position', [0.1, 0.35, 0.5, 0.25], 'XLim', [0, 80]);
    handles.plotAxesD = axes('Parent', handles.fig, 'Position', [0.1, 0.05, 0.5, 0.25], 'XLim', [0, 80]);


    handles.gauge = uigauge(handles.fig, 'Position', [640, 500, 100, 100], 'Limits', [0 10]);

    handles.speedLabel = uicontrol('Parent', handles.fig,'Style', 'text', 'Position', [640, 800, 100, 100], 'String', 'Set Speed'); 
    handles.speedKnob = uiknob(handles.fig, 'Position', [640, 700, 100, 100], 'ValueChangedFcn', @(speedKnob, event) updateCruiseSpeed(speedKnob, handles));

    handles.DistanceLabel = uicontrol('Parent', handles.fig,'Style', 'text', 'Position', [800, 800, 100, 100], 'String','Set Distance'); 
    handles.distanceKnob = uiknob(handles.fig, 'Position', [800, 700, 100, 100], 'ValueChangedFcn', @(distanceKnob, event) updateSafeDistance(distanceKnob, handles));

    handles.speedKnob.Limits = [0 50]; % Set the knob limits
    handles.speedKnob.Value = v_set;

    handles.distanceKnob.Limits = [0 35]; % Set the knob limits
    handles.distanceKnob.Value = handles.distance;

    set(handles.fig, 'UserData', handles);
    updatePlot(handles);
end

function updateCruiseSpeed(speedKnob, handles)
    handles = get(handles.fig, 'UserData');
    handles.v_set = speedKnob.Value;
  
    evalin('base', ['v_set = ' num2str(handles.v_set) ';']);
    updatePlot(handles);
end

function updateSafeDistance(distanceKnob, handles)
    handles = get(handles.fig, 'UserData');
    handles.distance = distanceKnob.Value;

    evalin('base', ['D_default  = ' num2str(handles.distance) ';']);
    updatePlot(handles);
end


function updatePlot(handles)
    cla(handles.plotAxesA);
    cla(handles.plotAxesV);
    cla(handles.plotAxesD);
  
    runSimulation(handles.v_set, handles.plotAxesA, handles.plotAxesV, handles.plotAxesD, handles.distance);
end

function runSimulation(v_set, plotAxesA, plotAxesV, plotAxesD, distance)
    mdl = evalin('base', 'mdl');
    
    t_gap = 1.4;
    sim(mdl);

    mpcACCplot2(logsout, distance, t_gap, v_set, plotAxesA, plotAxesV, plotAxesD);
end

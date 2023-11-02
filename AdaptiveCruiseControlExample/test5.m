function main
    clc;
    clearvars;
    D_default = 15;
    
    mdl = 'mpcACCsystem';
    T = 30;
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

    fig = uifigure('Position', [100, 100, 960, 960]);

    handles.speed = 25;
    handles.distance = D_default;

    handles.fig = fig;

    handles.plotAxesA = axes('Parent', handles.fig, 'Position', [0.1, 0.65, 0.8, 0.25], 'XLim', [0, 100], 'YLim', [0, 50]);
    handles.plotAxesV = axes('Parent', handles.fig, 'Position', [0.1, 0.35, 0.8, 0.25], 'XLim', [0, 100], 'YLim', [0, 50]);
    handles.plotAxesD = axes('Parent', handles.fig, 'Position', [0.1, 0.05, 0.8, 0.25], 'XLim', [0, 100], 'YLim', [0, 50]);




    handles.knob = uiknob(handles.fig, 'Position', [200, 700, 100, 100], 'ValueChangedFcn', @(knob, event) updateSpeed(knob, handles));
    handles.knob1 = uiknob(handles.fig, 'Position', [400, 700, 100, 100], 'ValueChangedFcn', @(knob1, event) updateDistance(knob1, handles));

    handles.knob.Limits = [0 100]; % Set the knob limits
    handles.knob.Value = v0_ego;

    handles.knob1.Limits = [0 35]; % Set the knob limits
    handles.knob1.Value = handles.distance;

    set(handles.fig, 'UserData', handles);
    updatePlot(handles);
end

function updateSpeed(knob, handles)
    handles = get(handles.fig, 'UserData');
    handles.speed = knob.Value;
    disp(['Current Speed: ' num2str(handles.speed)]);
    updatePlot(handles);
end

function updateDistance(knob1, handles)
    handles = get(handles.fig, 'UserData');
    handles.distance = knob1.Value;
    disp(['Current Distance: ' num2str(handles.distance)]);
    updatePlot(handles);
end

function updatePlot(handles)
    cla(handles.plotAxesA);
    cla(handles.plotAxesV);
    cla(handles.plotAxesD);
    disp("hello");
    disp(['Current Speed: ' num2str(handles.speed)]);
    runSimulation(handles.speed, handles.plotAxesA, handles.plotAxesV, handles.plotAxesD, handles.distance);
end

function runSimulation(speed, plotAxesA, plotAxesV, plotAxesD, distance)
    mdl = evalin('base', 'mdl');
    T = evalin('base', 'T');
    Ts = evalin('base', 'Ts');
    t_gap = evalin('base', 't_gap');
    x0_lead = evalin('base', 'x0_lead');
    
    assignin('base', 'v0_ego', speed);
    assignin('base', 'D_default', distance);

    v0_ego = evalin('base', 'v0_ego');
    x0_ego = evalin('base', 'x0_ego');
    v_set = evalin('base', 'v_set');

    sim(mdl);

    mpcACCplot2(logsout, distance, t_gap, v_set, plotAxesA, plotAxesV, plotAxesD);
end

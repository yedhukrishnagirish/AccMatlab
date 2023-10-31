% Define car parameters
carLength = 4; % Length of the car in meters
carWidth = 2; % Width of the car in meters
wheelRadius = 0.5; % Radius of the wheels in meters

% Create car body
carBody = [0, 0, 0;...
           carLength, 0, 0;...
           carLength, carWidth, 0;...
           0, carWidth, 0;...
           0, 0, 0;...
           0, 0, 2;...
           carLength, 0, 2;...
           carLength, carWidth, 2;...
           0, carWidth, 2];

% Create wheel positions
wheel1Pos = [0, 0, 0];
wheel2Pos = [carLength, 0, 0];
wheel3Pos = [carLength, carWidth, 0];
wheel4Pos = [0, carWidth, 0];

% Plot car body
figure;
plot3(carBody(:, 1), carBody(:, 2), carBody(:, 3), 'b', 'LineWidth', 2);
hold on;

% Plot wheels
drawWheel(wheel1Pos, wheelRadius);
drawWheel(wheel2Pos, wheelRadius);
drawWheel(wheel3Pos, wheelRadius);
drawWheel(wheel4Pos, wheelRadius);

xlabel('X');
ylabel('Y');
zlabel('Z');
view(3); % Set the 3D view
grid on;

% Function to draw wheels
function drawWheel(position, radius)
    [x, y, z] = cylinder(radius, 100);
    z = z * 0.1; % Set the thickness of the wheel
    z = z + position(3); % Set the position of the wheel along the z-axis
    wheel = surf(x + position(1), y + position(2), z, 'FaceColor', [0.3 0.3 0.3], 'EdgeColor', 'none');
end

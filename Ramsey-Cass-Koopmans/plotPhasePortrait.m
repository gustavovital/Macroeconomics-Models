
%% plotPhasePortrait
% Create a visualization of the 2D phase plane for the Ramsey-Cass-Koopmans
% model.
%
% Authors: Sonia Bridge, Ken Deeley
% Copyright 2016 The MathWorks, Inc.

%% Ensure that the required parameters are defined.
defineRCKParams
%% Visualize the phase portrait.
figure('Units', 'Normalized', 'Position', 0.25*[1, 1, 2, 2])
h = streamslice(params.K, params.C, params.dK, params.dC, 2, 'noarrows', 'cubic');
set(h, 'LineStyle', ':', 'LineWidth', 1.5)
% Hide all but one streamslice from the legend.
set(h(2:end), 'HandleVisibility', 'off')
% Plot the steady-state vertical line and smooth curve.
hold on
plot(params.k_fine, params.c_star, 'r', 'LineWidth', 2)
plot([params.k_steady, params.k_steady], ylim(), 'm', 'LineWidth', 2)
xlabel('{\it{k}} (capital per capita)')
ylabel('{\it{c}} (consumption per capita)')
title('Ramsey-Cass-Koopmans Capital-Consumption Phase Plane')
grid on
% Increase the font size.
ax = gca;
ax.FontSize = 15;
% Add the legend.
legend({'Stream slices', '$dk/dt = 0$', '$dc/dt = 0$'}, ...
        'Interpreter', 'LaTeX', ...
        'FontSize', 15)
% Add the direction arrows (four regi   ons) and labels.
% Top-right quadrant.
% Coordinates.
x = [75, 75];
y = [2.5, 2.2];
[xFig, yFig] = ds2nfu(x, y);
% Annotation.
annotation('arrow', xFig, yFig, 'LineWidth', 1.5)
% Coordinates.
x = [75, 68];
y = [2.5, 2.5];
[xFig, yFig] = ds2nfu(x, y);
% Annotation.
annotation('arrow', xFig, yFig, 'LineWidth', 1.5)
% Top-left quadrant.
% Coordinates.
x = [20, 20];
y = [2.6, 2.9];
[xFig, yFig] = ds2nfu(x, y);
% Annotation.
annotation('arrow', xFig, yFig, 'LineWidth', 1.5)
% Coordinates.
x = [20, 13];
y = [2.6, 2.6];
[xFig, yFig] = ds2nfu(x, y);
% Annotation.
annotation('arrow', xFig, yFig, 'LineWidth', 1.5)
% Bottom-right quadrant.
% Coordinates.
x = [60, 60];
y = [1.0, 0.7];
[xFig, yFig] = ds2nfu(x, y);
% Annotation.
annotation('arrow', xFig, yFig, 'LineWidth', 1.5)
% Coordinates.
x = [60, 67];
y = [1.0, 1.0];
[xFig, yFig] = ds2nfu(x, y);
% Annotation.
annotation('arrow', xFig, yFig, 'LineWidth', 1.5)
% Bottom-left quadrant.
% Coordinates.
x = [15, 15];
y = [1.0, 1.3];
[xFig, yFig] = ds2nfu(x, y);
% Annotation.
annotation('arrow', xFig, yFig, 'LineWidth', 1.5)
% Coordinates.
x = [15, 22];
y = [1.0, 1.0];
[xFig, yFig] = ds2nfu(x, y);
% Annotation.
annotation('arrow', xFig, yFig, 'LineWidth', 1.5)

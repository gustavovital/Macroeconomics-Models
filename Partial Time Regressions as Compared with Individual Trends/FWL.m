%% Frisch-Waugh-Lovell theorem - Econometrica

% Author: gustavo vital
% Date: 12/07/2020

clear; clc;
%% Data
x = [-5 -3 -2 2 1 4 3]';
t = [-3 -2 -1 0 1 2 3]';
y = [6 5 1 2 -3 -5 -6]';

%% Matrixes
mxx = sum(x.^2);
myy = sum(y.^2);
mtt = sum(t.^2);

mxy = sum(x.*y);
mxt = sum(x.*t);
myt = sum(y.*t);

%% results
x_trend = x - mxt/mtt * t;
y_trend = y - myt/mtt * t;

% trend values 
disp(x - x_trend);
disp(y - y_trend);

% deviations
disp(x_trend);
disp(y_trend);

% trend coefficients
disp(mxt/mtt);
disp(myt/mtt);

%% by'x'
mxx_t = sum(x_trend.^2);
mxy_t = sum(x_trend.*y_trend);

byxt = (mtt*mxy-mxt*myt)/(mtt*mxx-mxt^2);

%% FWL Theorem
disp("By the deviations coefficients:")
disp(mxy_t/mxx_t);
disp("By the partial time regression:")
disp(byxt);

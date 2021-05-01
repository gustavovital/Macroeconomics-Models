%% defineRCKParams
% Parameter definitions for the Ramsey-Cass-Koopmans model.
%
% Authors: Sonia Bridge, Ken Deeley
% Copyright 2016 The MathWorks, Inc.
%% Capital equation parameters.
% Growth rate of labor productivity.
params.phi = 0.02; 
% Growth rate of labor supply (population growth).
params.xi = 0.01; 
% Decay rate of capital (capital depreciation over time).
params.delta = 0.07; 
% Consumption equation parameters.
% Exponent in the Cobb-Douglas production function.
params.alpha = 0.5;
% Rate at which consumption is discounted.
params.rho = 0.035;
% Intertemporal elasticity of substitution.
params.theta = 0.01;
% Initial conditions.
% Initial per capita capital (wealth).
params.k0 = 5; 
% Initial per capital consumption.
params.c0 = 3; 
% Steady state value of k obtained when dc/dt = 0.
params.k_steady = (params.alpha / ...
    (params.theta+params.xi+params.delta+params.rho*params.phi)) ...
     ^ (1/(1-params.alpha));
 
% Define sample values for the x-axis (per-capita wealth).
params.k_root = (params.phi + params.xi + params.delta) ^ ...
         (1 / (params.alpha - 1));
params.nPoints = 50;
params.k_init = 0;
params.k_fine = linspace(params.k_init, params.k_root, params.nPoints);
% Compute the steady-state curve c = c*(k) obtained when dk/dt = 0.
params.c_star = params.k_fine .^ params.alpha - ...
               (params.phi + params.xi + params.delta) * params.k_fine;
% Define sample values for the y-axis (per-capita consumption).
params.c_fine = linspace(params.k_init, params.c0, params.nPoints);
% Create a lattice of (k, c) points for the stream slices.
[params.K, params.C] = meshgrid(params.k_fine, params.c_fine);
%% Compute the differentials.
% dk/dt.
params.dK = RCK_f(params.K, params) - params.C - ...
           (params.phi + params.xi + params.delta) * params.K;

%% dc/dt.       
params.dC = ((RCK_df(params.K, params) - ...
             (params.xi + params.delta + params.theta)) ...
             / params.rho - params.phi) .* params.C;
%%
params.dC(~isfinite(params.dC)) = 0;
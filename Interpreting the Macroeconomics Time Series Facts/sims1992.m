%% Interpreting the macroeconomics time series facts
%
% Author: gustavo vital
% Date: 05/07/2020

%% Data

load Data_USEconModel
DEF = log(DataTable.CPIAUCSL);
GDP = log(DataTable.GDP);
rGDP = diff(GDP - DEF);   % Real GDP is GDP - DEF
TB3 = 0.01*DataTable.TB3MS;
dDEF = 4*diff(DEF);       % Scaling
rTB3 = TB3(2:end) - dDEF; % Real interest is deflated
Y = [rGDP,rTB3];

%% fit var
Mdl = varm(2,4);
Mdl.SeriesNames = {'Transformed real GDP','Transformed real 3-mo T-bill rate'};
EstMdl = estimate(Mdl,Y);

%% irf
[YIRF,h] = armairf(EstMdl.AR,{},'InnovCov',EstMdl.Covariance);
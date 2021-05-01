function dY_dt = RCK_Equations(t, Y, params) 
%RCK_EQUATIONS Function defining the right-hand sides of the two 
%coupled ordinary differential equations defining the Ramsey-Cass-
%Koopmans model.
 
% Extract k and c.
k = Y(1);
c = Y(2);
 
% Write down the equations for dk/dt and dc/dt.
dY_dt(1, 1) = RCK_f(k, params) - c - ...
              (params.phi + params.xi + params.delta) * k; % dk/dt
 
dY_dt(2, 1) = ( ( RCK_df(k, params) - params.theta - params.xi - ...
             params.delta ) / params.rho - params.phi ) * c; % dc/dt      
 
end % RCK_Equations
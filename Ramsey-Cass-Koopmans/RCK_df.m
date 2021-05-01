function df_dk = RCK_df(k, params)
% RCK_df Defines the derivative of the customizable Cobb-Douglas function 
% f(k) in the Ramsey-Cass-Koopmans equations.
%
% Authors: Sonia Bridge, Ken Deeley
% Copyright 2016 The MathWorks, Inc.
df_dk = (params.alpha) .* ( k .^ (params.alpha - 1) );
end % RCK_df
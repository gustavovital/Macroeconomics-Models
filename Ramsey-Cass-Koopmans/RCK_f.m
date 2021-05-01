function fk = RCK_f(k, params)
% RCK_f Defines the customizable Cobb-Douglas function f(k) in the 
% Ramsey-Cass-Koopmans equations
%
% Authors: Sonia Bridge, Ken Deeley
% Copyright 2016 The MathWorks, Inc.
fk = k .^ (params.alpha);
end % RCK_f
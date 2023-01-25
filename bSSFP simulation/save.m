function param=save(parameters)
% save function is used to keep parameters enter by the user is a more
% straightforward way that calling parameters{i}, i being the
% field-position of a parameter

% Tissues parameters
param.T1=str2num(parameters{1});
param.T2=str2num(parameters{2});
param.TR=str2num(parameters{3});
param.TE=str2num(parameters{4});

% Scan parameters
off_max=str2num(parameters{8});
step_off=str2num(parameters{9});
param.N=str2num(parameters{11});
param.beta=-off_max:step_off:0;
alpha_min=str2num(parameters{5});
alpha_max=str2num(parameters{6});
step_alpha=str2num(parameters{7});
param.alpha=alpha_min:step_alpha:alpha_max;
param.cycling_max=str2num(parameters{10});
param.N_TR=500;
param.sign=str2num(parameters{12});
end


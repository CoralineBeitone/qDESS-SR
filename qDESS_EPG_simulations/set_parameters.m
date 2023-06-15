function [param,seq]=set_parameters(parameters)

% Tissues and times parameters
param.T1=str2num(parameters{1});
param.T2min=str2num(parameters{2});
param.T2max=str2num(parameters{3});
param.T2=param.T2min:5:param.T2max;
param.TE=str2num(parameters{4});
param.TR=str2num(parameters{13});

% Sequence parameters
alpha_min=str2num(parameters{5});
alpha_max=str2num(parameters{6});
step_alpha=str2num(parameters{7});
seq.delta_k=str2num(parameters{8});
seq.inc=str2num(parameters{9});
seq.N_RF=str2num(parameters{10});
seq.alpha=alpha_min:step_alpha:alpha_max;
seq.sign=str2num(parameters{11});
seq.RF_spoling=str2num(parameters{12});


end


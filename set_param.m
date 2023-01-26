function [param,seq]=set_param(parameters)

% Tissues parameters and relevant timings
param.T1=str2num(parameters{1});
param.T2min=str2num(parameters{2});
param.T2max=str2num(parameters{3});
param.T2=param.T2min:5:param.T2max;
param.TR=str2num(parameters{4});
param.TE=str2num(parameters{5});


% Scan parameters
alpha_min=str2num(parameters{6});
alpha_max=str2num(parameters{7});
step_alpha=str2num(parameters{8});
seq.delta_k=str2num(parameters{9});
seq.inc=str2num(parameters{10});
seq.N=str2num(parameters{11});
seq.alpha=alpha_min:step_alpha:alpha_max;
seq.sign=str2num(parameters{12});
seq.RF_spoling=str2num(parameters{13});


end


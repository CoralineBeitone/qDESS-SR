function [param,seq]=set_param(parameters)

% Tissues parameters
param.T1=str2num(parameters{1});
param.T2=str2num(parameters{2});
param.TR=str2num(parameters{3});
param.TE=str2num(parameters{4});


% Scan parameters
seq.tau=param.TR-2*param.TE;
alpha_min=str2num(parameters{5});
alpha_max=str2num(parameters{6});
step_alpha=str2num(parameters{7});
seq.Gread=str2num(parameters{8});
seq.inc=str2num(parameters{9});
seq.N=str2num(parameters{10});
seq.gamma=42.576;
seq.alpha=alpha_min:step_alpha:alpha_max;
seq.sign=str2num(parameters{11});
seq.RF_spoling=str2num(parameters{12});
seq.Gspoiler=str2num(parameters{13});



end


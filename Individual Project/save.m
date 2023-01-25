function [param,seq]=save(parameters)

% Tissues parameters
param.T1=str2num(parameters{1});
param.T2=str2num(parameters{2});
param.TR=str2num(parameters{3});
param.TE=str2num(parameters{4});

% Scan parameters
seq.prephasing=str2num(parameters{5});
alpha_min=str2num(parameters{6});
alpha_max=str2num(parameters{7});
step_alpha=str2num(parameters{8});
seq.Gread=str2num(parameters{9});
seq.Gdiff=str2num(parameters{10});
seq.slices=str2num(parameters{11});
seq.phi=str2num(parameters{12});
seq.alpha=alpha_min:step_alpha:alpha_max;
seq.N=str2num(parameters{13});
seq.sign=str2num(parameters{14});
seq.RF_spoling=str2num(parameters{145);

end

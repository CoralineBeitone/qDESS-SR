function [M] = relaxation(param,M0,t,beta)

% Function which applies the Bloch equations to the magnetization and
% stores the signal every TE.


T1=param.T1;
T2=param.T2;
TR=param.TR;


E1=exp(-t/T1);
E2=exp(-t/T2);

I=eye(3);

E=[E2, 0, 0; 0, E2, 0; 0, 0 , E1];


P=[cosd(beta), sind(beta), 0; -sind(beta), cosd(beta), 0; 0, 0 ,1];

M=P*E*M0+(I-E)*[0;0;1];




end


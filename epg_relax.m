function [omega] = epg_relax(t,param,omega,T2)

T1=param.T1;
TR=param.TR;

E1=exp(-t/T1);
E2=exp(-t/T2);

[c,n]=size(omega); % c:component (normally 3) and n is the total number of 'modes' or 'states'

if c ~=3 % verification assessment 
    msg = 'Error matrix should have three components.';
    error(msg)
end


E=[E2,0,0;
   0,E2,0;
   0, 0 ,E1];
omega=E*omega; 

omega(:,1)=omega(:,1)+[0;0;(1-E1)]; % for k=0


end


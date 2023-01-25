function [omega_postg] = epg_gradient(delta_k,omega)
 

[c,n]=size(omega); % c:components (normally 3) and n is the total number of 'modes' or 'states'


if c ~=3 % verification assessment 
    msg = 'Error matrix should have three components.';
    error(msg)
end


if delta_k==0
    omega_postg=omega;

else
    if n>1
        F = [fliplr(omega(1,:)) omega(2,2:end)]; % equation [27] at time t from the paper [ F2(t), F1(t), F0(t), F-1(t), F-2(t), ...]'
        if delta_k>0
            F=[F zeros(1,delta_k)]; % F-state components are pushed upwards due to positive gradient F_k -> F_k+delta_k
            F_dph=fliplr(F(1:n+delta_k));
            F_rph=[F(n+delta_k:end) zeros(1,delta_k)];
            Z=[squeeze(omega(3,:)) zeros(1,delta_k)];
            F_dph(1)=conj(F_rph(1));

        else
            F=[zeros(1,delta_k) F];
            F_dph=[fliplr(F(1:n)) zeros(1,delta_k)];
            Z=[squeeze(omega(3,:)) zeros(1,delta_k)];
            F_rph=F(n:end);
            F_rph(1)=conj(F_dph(1));
        end

    else
        if (delta_k>0)
            F_dph=[zeros(1,delta_k) omega(1)];
            F_rph=[0 zeros(1,delta_k)];
            Z=[omega(3) zeros(1,delta_k)];
        else
            F_dph=[0 zeros(1,delta_k)];
            F_rph=[zeros(1,delta_k) omega(2)];
            Z=[omega(3) zeros(1,delta_k)];
        end

    end
    
end

omega_postg = [F_dph;F_rph;Z];



end


function [signal,S] = get_Mss(param,M0,beta,alpha)

if param.N>1
    phase_cycling=(param.cycling_max/(N-1))*(0:(N-1));
else
    phase_cycling=param.cycling_max;
end


signal=[];
sign=param.sign;
S= zeros(1,param.N_TR,2); 
idx=1; 
shift=param.cycling_max(1);
for i=1:param.N_TR

        if idx==length(phase_cycling)
            idx=1;
        else
            idx=idx+1;
        end

        if param.N==1
            shift=shift+phase_cycling(idx);
        else
            shift=phase_cycling(idx);
        end
        
        M0=tip(alpha,M0,shift,sign); % RF pulse
        S(1,i,1)=M0(1)+1j*M0(2); % Transient tranverse magnetization
        S(1,i,2)=M0(3); % Transient longitudinal magnetization
        M=relaxation(param,M0,param.TE,beta); % Tip-Precession-Relaxation from t=0 to t=TE
        signal=[signal,M(1)+1j*M(2)]; % Signal measurement
        M0=relaxation(param,M,param.TE,beta);% Precession-Relaxation from t=TE2 to t=TR
        
        if param.sign>0
            sign=1;
        else
            sign=-sign;
        end
        
end

signal=signal(end-(param.N-1):end); % Keep only the N steady state value

end


function [Xi,omega_postRF,ratio] = DESS(param,seq,flip,phi,TR)

ratio=zeros(length(param.T2),length(seq.alpha),length(TR),3); % determine ratio echo S-1/S0
idx_T2=1;
limit=20;
Xi=zeros(3,seq.N_RF,seq.N_RF); % store the omega matrix at each time t 
for T2=param.T2
    for idx_alpha=1:length(seq.alpha)  % given T2 but different TE (and thus TR) and variable flip angle
        idx_TR=1;
        for t=TR % given alpha and T2 but different TR
            FID=[];
            echo=[];
            omega=[0;0;1]; % initialization 
            param.TR=t;
            for rf=1:seq.N_RF
                omega=epg_RF(flip(idx_alpha,rf),phi(rf),omega);
                omega_postRF=[exp(1i*deg2rad(-phi(rf))),0,0; 0, exp(1i*deg2rad(phi(rf))),0; 0,0,1]*omega;
                omega=epg_relax(param.TE,param,omega,T2); 
                FID=[FID,omega(1,1)]; 
                [n,c]=size(omega_postRF);
                Xi(:,1:c,rf)=omega_postRF;
                omega=epg_relax(param.TE,param,omega,T2);  
                omega=epg_grad(seq.delta_k,omega); 
                omega=epg_relax(param.TR-3*param.TE,param,omega,T2); 
                echo=[echo,omega(1,1)];
                omega=epg_relax(param.TE,param,omega,T2);
               
               
            end
            if length(TR)==1 && length(seq.alpha)==1 && length(param.T2)==1
            show_epg(omega_postRF,seq,idx_alpha,T2,limit);
            end
            ratio(idx_T2,idx_alpha,idx_TR,1)=abs(echo(end))/abs(FID(end));
            ratio(idx_T2,idx_alpha,idx_TR,2:end)=[abs(FID(end)) abs(echo(end))];
            idx_TR=idx_TR+1;
           

        end
       
        
    end
    idx_T2=idx_T2+1;
end

end




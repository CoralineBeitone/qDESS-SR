clear; clc; close all;


%% User interface: definition of T1,T2,TE,TR, range of flip angle α, range of off-resonance β (or spoiler gradient effect), addition of linear phase cycling ϕmax, and periodicity of phase cycling N
prompt={'T_{1} (in ms)', 'T_{2} (in ms)', 'TR (in ms)', 'TE (in ms)', '\alpha_{min} (in degrees)', '\alpha_{max} (in degrees)', '\Delta \alpha (in degrees)','\beta_{max} (in degrees)', '\Delta \beta (in degrees)','\phi_{max} (in degrees)', 'Period N','Alternate'};
dlgtitle='Parameters';
dims=[1 1 1 1 1 1 1 1 1 1 1 1 ];
definput={'0','0','0','0','0','0','0','0','0','0','0','1'};
opts.Interpreter='tex';
parameters=inputdlg(prompt,dlgtitle,dims,definput,opts);

%% Initialization parameters
param=save(parameters);
fig=figure; 
T2=200;
%T2=param.T2;
ratio=zeros(length(T2),2);


for i=1:length(T2)
    param.T2=T2(i);
%% Simulation for a linear phase cycling increment
    for alpha=param.alpha
        Mss_TE= zeros(length(param.beta),param.N); % matrice containing the off-resonnance profile for a given flip angle 
        S= zeros(length(param.beta),param.N_TR,2); 
        Mss_preRF= zeros(length(param.beta),param.N);
        for beta=param.beta
        j=find(param.beta==beta);
        M0= [0;0;1]; % initial state 
        [Mss_TE(j,:),S(j,:,:)]=get_Mss(param, M0,beta,alpha);
        Mss_preRF(j,:)=S(j,end,1);
        end
    % Plot the evolution of the off-resonnance profile in function of the
    % off-resonance frequency for a given flip angle
    figure(1)

    plot_solution(fig,param,Mss_preRF,alpha);
    %figure(2)
    %plot_transient(param,S,alpha);
    %hold off;
    end


ratio(i,1)=exp(-(param.TE/param.T2))/exp(-(2*param.TR-param.TE)/param.T2);
ratio(i,2)=ratio_exp(param,Mss_preRF);

end

figure(3)
plot(T2,ratio(:,1),'--r');
hold on;
plot(T2,ratio(:,2),'k');
grid on;
legend('Theory', 'Simulation');
xlabel("$T2\;values\;[ms]$", 'Interpreter', 'latex', 'FontSize',15);
ylabel("Ratio $\frac{F_{0}}{F_{-1}}$",'Interpreter','latex','FontSize',15);
title("Comparison F-state components for a flip angle $\alpha$="+ num2str(alpha)+" degrees",'Interpreter','latex','FontSize',15);

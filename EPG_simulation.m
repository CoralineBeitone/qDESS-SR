clear; clc; close all;


%% User interface: definition of T1,T2,TR, range of flip angle α, gradient area Gt, RF phase phi, number of RF pulses N

prompt={'T_{1} (in ms)', 'T_{2,min} (in ms)', 'T_{2,max} (in ms)', 'TR (in ms)', 'TE (in ms)', '\alpha_{min} (in degrees)', '\alpha_{max} (in degrees)', '\Delta \alpha (in degrees)','\delta k (cm^{-1})', '\phi (in degrees)', 'N_{TR}','alternate','RF Spoling'};
dlgtitle='Parameters';
dims=[1 1 1 1 1 1 1 1 1 1 1 1 1  ];
definput={'0','0','0','0','0','0','0','0','0','0','0','0','0'};
opts.Interpreter='tex';
parameters=inputdlg(prompt,dlgtitle,dims,definput,opts);

[param,seq]=set_param(parameters);

seq=show_DESS(param,seq);

flip=angles(seq);
phi=phase_inc(seq);
omega=[0;0;1];
N_TR=seq.N; % number of repetitions
FID=[];
echo=[];
ratio=[];
omega_preRF=[];


%% Loop over the total number of TRs chosen, DESS sequence consists in RF-Relaxation-FID (FISP signal)-Spoiler gradient-Relaxation-Echo (PSFIP signal)-Relaxation-RF
for T2=param.T2
    for rf=1:N_TR
        omega=epg_RF(flip(rf),phi(rf),omega); % T matrix 'RF' pulse
        omega_postRF=omega;
        omega=epg_relax(param.TE,param,omega,T2); % E matrix 'Relaxation' up to TE (echo time)
        FID=[FID,omega(1,1)]; % F0 component
        omega_TE=omega;
        omega=epg_relax(param.TE*0.5,param,omega,T2);
        omega=epg_gradient(seq.delta_k,omega); % S matrix, shift according to the gradient area defined by seq.Gt
        omega=epg_relax(param.TE*0.5,param,omega,T2);
        echo=[echo,omega(1,1)];
        omega=epg_relax(param.TE,param,omega,T2); % beginning of the second readout gradient - relaxation 
    end
    show_epg(omega_postRF,seq,T2);
    ratio=[ratio,abs(echo(end))/abs(FID(end))];
    FID=[];
    echo=[];
end

  figure(3)
  T2=param.T2;
  ratio_exp=[exp(-2*(param.TR-param.TE)./param.T2)];
  plot(param.T2,ratio_exp,'-sb','MarkerSize',5,...
    'MarkerEdgeColor','blue',...
    'MarkerFaceColor',[0 .45 .74]);
  hold on;
  plot(param.T2,ratio,'-sr','MarkerSize',5,...
    'MarkerEdgeColor','red',...
    'MarkerFaceColor',[1 .6 .6]);
  leg=legend('Theoretical ratio ($exp\{-2\times(TR-TE)/T2\}$)', 'Simulation ratio','interpreter','latex','Location','northwest');
  set(leg,'Interpreter','latex');
  set(leg,'FontSize',10);
  grid('minor');
  xlabel('$T2\;values$','Interpreter','latex','FontSize',15);
  ylabel('$Ratio\;amplitude$','Interpreter','latex','FontSize',15);
  title("FISP and PSIF signal amplitudes evolution with $T2$ for a flip angle $\alpha$="+ num2str(seq.alpha)+"$^{\circ}$" ,'Interpreter','latex','FontSize',15);

    

%% TEST for TSE

%TSE_sequence(seq,omega,N_TR,phi,flip)



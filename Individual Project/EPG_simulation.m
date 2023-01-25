clear; clc; close all;


%% User interface: definition of T1,T2,TR, range of flip angle α, gradient area Gt, RF phase phi, number of RF pulses N

prompt={'T_{1} (in ms)', 'T_{2} (in ms)', 'TR (in ms)', 'TE (in ms)', '\alpha_{min} (in degrees)', '\alpha_{max} (in degrees)', '\Delta \alpha (in degrees)','\gamma G_{read} (mT/m)', '\phi(in degrees)', 'N_{TR}','alternate','RF Spoling','\gamma G_{spoiler} (mT/m)','TE2 (in ms)'};
dlgtitle='Parameters';
dims=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 ];
definput={'0','0','0','0','0','0','0','0','0','0','0','0','0','0'};
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


%% Loop over the total number of TRs chosen, DESS sequence consists in RF-Relaxation-FID (FISP signal)-Spoiler gradient-Relaxation-Echo (PSFIP signal)-Relaxation-RF

    for rf=1:N_TR
        omega=epg_RF(flip(rf),phi(rf),omega); % T matrix 'RF' pulse
        omega=epg_relax(param.TE,param,omega,T2); % E matrix 'Relaxation' up to TE (echo time)
        FID=[FID,omega(1,1)]; % F0 component
        omega=epg_relax(param.TE*0.5,param,omega,T2);
        omega=epg_gradient(seq.Gspoiler,seq.tau,omega); % S matrix, shift according to the gradient area defined by seq.Gt
        omega=epg_relax(param.TE*0.5,param,omega,T2);
        echo=[echo,omega(1,1)];
        omega=epg_relax(param.TE,param,omega,T2); % beginning of the second readout gradient - relaxation     
    end
    ratio=[ratio,abs(echo(end))/abs(FID(end))];
    FID=[];
    echo=[];


%% TEST for TSE

%TSE_sequence(seq,omega,N_TR,phi,flip)
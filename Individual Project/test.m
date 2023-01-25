clear; clc; close all;


%% User interface: definition of T1,T2,TR, range of flip angle α, gradient area Gt, RF phase phi, number of RF pulses N

prompt={'T_{1} (in ms)', 'T_{2} (in ms)', 'TR (in ms)', 'TE (in ms)', 'prephasing (ms)', '\alpha_{min} (in degrees)', '\alpha_{max} (in degrees)', '\Delta \alpha (in degrees)','Readout gradient', 'Diffusion gradient', 'Slice thickness', '\phi(in degrees)', 'N_{TR}','alternate','RF Spoling'};
dlgtitle='Parameters';
dims=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1   ];
definput={'0','0','0','0','0','0','0','0','0','0','0','0','0','0','0'};
opts.Interpreter='tex';
parameters=inputdlg(prompt,dlgtitle,dims,definput,opts);

[param,seq]=save_param(parameters);

flip=angles(seq);
phi=phase_inc(seq);
omega=[0;0;1];
N_TR=seq.N; % number of repetitions
Xi_FISP=[];
Xi_PSIF=[];
FID=[];
echo=[];

% Reminder: seq.rlx_timings=[TE,read_out,read_out,TE];

%% Loop over the total number of TRs chosen, DESS sequence consists in RF-Relaxation-FID (FISP signal)-Spoiler gradient-Relaxation-Echo (PSFIP signal)-Relaxation-RF
for rf=1:N_TR
    omega=epg_RF(flip(1),phi(1),omega);% application of the first RF pulse
    omega=epg_gradient(seq.prephasing, seq.Gread,omega);
    omega=epg_relax(param.TE/2,param,omega,T2); % E matrix 'Relaxation' up to TE (echo time)
    [m,n]=size(omega);
    if n>1
        F0_F_1=[omega(1,1) conj(omega(2,2))]'; % equation [27], only get F-components of interest (i.e F0 and F-1)
        Xi_FISP= cat(2,Xi_FISP,F0_F_1); % Measurement F-component at time t=TE, store signal in matrix Xi_F as defined by equation [27a]
    else
        F0_F_1=[omega(1,1) 0]'; % equation [27], only get F-components of interest (i.e F0 and F-1)
        Xi_FISP= cat(2,Xi_FISP,F0_F_1); % Measurement F-component at time t=TE, store signal in matrix Xi_F as defined by equation [27a]
    end
    omega=epg_gradient(seq.prephasing, seq.Gread,omega);
    omega=epg_relax(param.TE/2,param,omega,T2); % E matrix 'Relaxation' up to TE (echo time)

    omega=epg_gradient(seq.tau, seq.Gdiff,omega); % S matrix, shift according to the gradient area defined by seq.Gt
    omega=epg_relax(param.TR-(param.TE+seq.tau),param,omega,T2); % beginning of the second readout gradient - relaxation
    F0_F_1=[omega(1,1) conj(omega(2,2))]';  % Measurement F-components at time t=TR-TE (i.e PSIF echo)
    Xi_PSIF=cat(2,Xi_PSIF,F0_F_1); 
    %omega=epg_relax(delta_t(4),param,omega); % rest of the readout gradient - relaxation
    omega=epg_RF(flip(rf),phi(rf),omega); % T matrix 'RF' pulse
end
    FID=[FID,Xi_FISP(1,end)];
    echo=[echo,Xi_PSIF(1,end)];


%% TEST for TSE

%TSE_sequence(seq,omega,N_TR,phi,flip)
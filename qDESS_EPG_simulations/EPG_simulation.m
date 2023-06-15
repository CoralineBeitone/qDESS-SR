


%% User interface: definition of T1,T2,TR, range of flip angle α, gradient area Gt, RF phase phi, number of RF pulses N

prompt={'T_{1} (in ms)', 'T_{2,min} (in ms)', 'T_{2,max} (in ms)', 'TE (in ms)', '\alpha_{min} (in degrees)', '\alpha_{max} (in degrees)', '\Delta \alpha (in degrees)','\delta k (cm^{-1})', '\phi (in degrees)', 'N_{TR}','alternate','RF Spoling','TR (ms)'};
dlgtitle='Parameters';
dims=[1 1 1 1 1 1 1 1 1 1 1 1 1];
definput={'0','0','0','0','0','0','0','0','0','0','0','0','0'};
opts.Interpreter='tex';
parameters=inputdlg(prompt,dlgtitle,dims,definput,opts);

[param,seq]=set_parameters(parameters);

%seq=show_DESS(param,seq); % sequence diagram, to be uncommented if necessary 

RF_phase=[0];
seq.inc=RF_phase;
flip=angles(seq);
phi=phase_inc(seq);
omega=[0;0;1];
TR=param.TR;
[signal,omega_postRF,data]=DESS(param,seq,flip,phi,TR);

% Animation 

display=50; % number of F-states to consider for the display
for i=1:seq.N_RF
    show_epg(signal(:,:,i),seq,1,param.T2,display);
    pause(0.01)
end
  

%% FEMR simulation 

display=50;% number of F-states to consider for the display
FEMR=[0,90];
flip=angles(seq);
phi=repmat(FEMR,1,seq.N_RF/2);
omega=[0;0;1];
TR=param.TR;
[signal,omega_postRF,data]=DESS(param,seq,flip,phi,TR);

figure(1)
show_epg(signal(:,:,seq.N_RF),seq,1,param.T2,display);
figure(2)
show_epg(signal(:,:,seq.N_RF-1),seq,1,param.T2,display);



%% T2 model fitting and comparison with the numerical results
% Reference [17] Final report: Sveinsson B, Chaudhari AS, Gold GE, and Hargreaves BA. A simple analytic method for
%                              estimating T2 in the knee from DESS. Magn Reson Imaging 2017;38:63–70.


% This part is only called if a range of T2 and/or flip angle is used in the simulation 

ratio=squeeze(data(:,:,1,1));
Sig=squeeze(data(1,1,:,2:end));
idx=3;% index for figure display

if length(param.T2)>1 
    figure(idx)
    ratio_vs_T2(seq,param,ratio,2)
    idx=idx+1;
end

if length(seq.alpha)>1 
    figure(idx)
    ratio_vs_alpha(seq,param,ratio,2);
    idx=idx+1;
    figure(idx)
    get_T2(seq,param,ratio)
    idx=idx+1;
end

if length(TR)>1
    figure(idx)
    T2_vs_TR(param,Sig,TE)
end
    
    

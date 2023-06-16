
clear all;

%% Load data & dependencies

% 2D experiment: drift correction based on navigators + super-resolution reconstruction 

addpath('./external');
addpath('./rawdata/qDESS_290323');

twix_SR_ref=mapVBVD('./rawdata/qDESS_290323/meas_MID356_qDESS_SR_ref_FID44036');
twix_SR_0=mapVBVD('./rawdata/qDESS_290323/meas_MID357_qDESS_SR_PC0_FID44037');
twix_SR_180=mapVBVD('./rawdata/qDESS_290323/meas_MID358_qDESS_SR_PC180_FID44038');

% remove oversampling in the readout direction
twix_SR_ref.image.flagRemoveOS=true;
twix_SR_0.image.flagRemoveOS=true;
twix_SR_180.image.flagRemoveOS=true;
os=2;

% get dimensions
NCol= twix_SR_ref.image.NCol/os;
NCha=twix_SR_ref.image.NCha;
NLin=twix_SR_ref.image.NLin;
NRep_ref=twix_SR_ref.image.NRep;
NRep=twix_SR_0.image.NRep;
NSet=twix_SR_ref.image.NSet;


% k-spaces for echo 1 PC0, PC180 and reference qDESS
ks_0_echo1=squeeze(twix_SR_0.image(:,:,:,1,1,1,1,1,:,1,1));
ks_180_echo1=squeeze(twix_SR_180.image(:,:,:,1,1,1,1,1,:,1,1));
ks_ref_echo1=squeeze(twix_SR_ref.image(:,:,:,1,1,1,1,1,:,1,1));

% k-spaces for echo 2 PC0, PC180 and reference qDESS
ks_0_echo2=squeeze(twix_SR_0.image(:,:,:,1,1,1,1,1,:,2,1));
ks_180_echo2=squeeze(twix_SR_180.image(:,:,:,1,1,1,1,1,:,2,1));
ks_ref_echo2=squeeze(twix_SR_ref.image(:,:,:,1,1,1,1,1,:,2,1));


%% Navigator-based approach for drift correct in echo 1 data  

delta=10; % distance between successive navigators in the experimental space 
K=round(NRep/delta); % Number of navigators (excluding reference navigator)
k=1:K;
Nav_idx1= 1+(k-1)*delta; % keep track of navigators positions in experiment 1
Nav_idx2=1+k*delta; % keep track of navigators positions in experiment 2
Nav_idx1(Nav_idx1>NRep)=NRep;
Nav_idx2(Nav_idx2>NRep)=NRep;
for j=1:K
    dphi1=angle(ks_0_echo1(:,:,:,Nav_idx1(j)).*conj(ks_0_echo1(:,:,:,end))); % phase comparison relative to reference navigator
    dphi2=angle(ks_180_echo1(:,:,:,Nav_idx2(j)).*conj(ks_180_echo1(:,:,:,1))); % phase comparison relative to reference navigator
    psi1(:,:,:,j)=dphi1;
    psi2(:,:,:,j)=dphi2;
    inf=(1+(j-1)*delta);
    if 1+j*delta>NRep % condition to avoid being out of boundaries for correction
        sup=NRep;
    else
        sup=1+j*delta;
    end
    k_0(:,:,:,inf:sup)= ks_0_echo1(:,:,:,inf:sup).*exp(-1i*dphi1); % phase compensation in experiment 1
    k_180(:,:,:,inf:sup)=ks_180_echo1(:,:,:,inf:sup).*exp(-1i*dphi2); % phase compensation in experiment 2
end


% Display: Drift maps  

map_idx=5;
assert(K>=map_idx)
chn_coil=1;
figure(1)
set(gcf, 'Position',  [500, 500, 800, 300])
subplot(1,2,1)
imagesc(rad2deg(squeeze(psi1(:,chn_coil,:,map_idx)))); colormap;
hcb=colorbar;
title(hcb,"Phase $(^{\circ})$",'Fontsize',13,'interpreter', 'Latex');
titlestr = ['$\psi_{', '1', ',', num2str(map_idx), '}$'];
subtitle(titlestr,'Interpreter','latex','FontSize',15)
subplot(1,2,2)
imagesc(rad2deg(squeeze(psi2(:,chn_coil,:,map_idx)))); colorbar; 
hcb=colorbar;
title(hcb,"Phase $(^{\circ})$",'Fontsize',13,'interpreter', 'Latex');
titlestr = ['$\psi_{', '2', ',', num2str(map_idx), '}$'];
subtitle(titlestr,'Interpreter','latex','FontSize',15)


% k-space combinaisons with/without drift correction

k_F0_echo1_raw=(ks_0_echo1+ks_180_echo1)/2;
k_F1_echo1_raw=(ks_0_echo1-ks_180_echo1)/2;

k_F0_echo1=(k_0+k_180)/2;
k_F1_echo1=(k_0-k_180)/2;


% Display : raw vs drift corrected k-spaces

for i=1:(NRep)
    subplot(2,2,1)
     imagesc(log(abs(squeeze(k_F0_echo1_raw(:,2,:,i))))); colormap gray; colorbar;
    hcb=colorbar;
    title(hcb,'Amplitude','interpreter', 'latex', 'Fontsize',7);
    subtitle('Addition without pre-drift correction','Interpreter','latex','FontSize',10)
    subplot(2,2,2)
    imagesc(log(abs(squeeze(k_F1_echo1_raw(:,2,:,i))))); colormap gray; colorbar;
    hcb=colorbar;
    title(hcb,'Amplitude','interpreter', 'latex', 'Fontsize',7);
    subtitle('Subtraction without pre-drift correction','Interpreter','latex','FontSize',10)
    subplot(2,2,3)
    imagesc(log(abs(squeeze(k_F0_echo1(:,2,:,i))))); colormap gray; colorbar;
    hcb=colorbar;
    title(hcb,'Amplitude','interpreter', 'latex', 'Fontsize',7);
    subtitle('Addition with pre-drift correction','Interpreter','latex','FontSize',10)
    subplot(2,2,4)
    imagesc(log(abs(squeeze(k_F1_echo1(:,2,:,i))))); colormap gray; colorbar;
    hcb=colorbar;
    title(hcb,'Amplitude','interpreter', 'latex', 'Fontsize',7);
    subtitle('Subtraction with pre-drift correction','Interpreter','latex','FontSize',10,'Color','red')
    pause(0.2)
    disp(i)
end



%% Navigator-based approach for drift correct in echo 2 data  

delta=10; % distance between successive navigators in the experimental space 
K=round(NRep/delta); % Number of navigators (excluding reference navigator)
k=1:K;
Nav_idx1= 1+(k-1)*delta;% keep track of navigators positions in experiment 1
Nav_idx2=1+k*delta; % keep track of navigators positions in experiment 2
Nav_idx1(Nav_idx1>NRep)=NRep;
Nav_idx2(Nav_idx2>NRep)=NRep;
for j=1:K
    dphi1=angle(ks_0_echo2(:,:,:,Nav_idx1(j)).*conj(ks_0_echo2(:,:,:,end)));
    dphi2=angle(ks_180_echo2(:,:,:,Nav_idx2(j)).*conj(ks_180_echo2(:,:,:,1)));
    psi1(:,:,:,j)=dphi1;
    psi2(:,:,:,j)=dphi2;
    inf=(1+(j-1)*delta);
    if 1+j*delta>NRep % condition to avoid being out of boundaries for correction
        sup=NRep;
    else
        sup=1+j*delta;
    end
    k_0(:,:,:,inf:sup)= ks_0_echo2(:,:,:,inf:sup).*exp(-1i*dphi1); % phase compensation in experiment 1
    k_180(:,:,:,inf:sup)=ks_180_echo2(:,:,:,inf:sup).*exp(-1i*dphi2); % phase compensation in experiment 2
end



% Display: Drift maps  

map_idx=5;
assert(K>=map_idx)
chn_coil=1;
figure(1)
set(gcf, 'Position',  [500, 500, 800, 300])
subplot(1,2,1)
imagesc(rad2deg(squeeze(psi1(:,chn_coil,:,map_idx)))); colormap;
hcb=colorbar;
title(hcb,"Phase $(^{\circ})$",'Fontsize',13,'interpreter', 'Latex');
titlestr = ['$\psi_{', '1', ',', num2str(map_idx), '}$'];
subtitle(titlestr,'Interpreter','latex','FontSize',15)
subplot(1,2,2)
imagesc(rad2deg(squeeze(psi2(:,chn_coil,:,map_idx)))); colorbar; 
hcb=colorbar;
title(hcb,"Phase $(^{\circ})$",'Fontsize',13,'interpreter', 'Latex');
titlestr = ['$\psi_{', '2', ',', num2str(map_idx), '}$'];
subtitle(titlestr,'Interpreter','latex','FontSize',15)


% k-space combinaisons with/without drift correction

k_F0_echo2_raw=(ks_0_echo2+ks_180_echo2)/2;
k_F1_echo2_raw=(ks_0_echo2-ks_180_echo2)/2;

k_F0_echo2=(k_0+k_180)/2;
k_F1_echo2=(k_0-k_180)/2;


% Display : raw vs drift corrected k-spaces

subplot(2,2,1)
imagesc(log(abs(squeeze(k_F0_echo2_raw(:,2,:,i))))); colormap gray; colorbar;
hcb=colorbar;
title(hcb,'Amplitude','interpreter', 'latex', 'Fontsize',7);
subtitle('Addition without pre-drift correction','Interpreter','latex','FontSize',8)
subplot(2,2,2)
imagesc(log(abs(squeeze(k_F1_echo2_raw(:,2,:,i))))); colormap gray; colorbar;
hcb=colorbar;
title(hcb,'Amplitude','interpreter', 'latex', 'Fontsize',7);
subtitle('Subtraction without pre-drift correction','Interpreter','latex','FontSize',8)
subplot(2,2,3)
imagesc(log(abs(squeeze(k_F0_echo2(:,2,:,i))))); colormap gray; colorbar;
hcb=colorbar;
title(hcb,'Amplitude','interpreter', 'latex', 'Fontsize',7);
subtitle('Addition with pre-drift correction','Interpreter','latex','FontSize',8)
subplot(2,2,4)
imagesc(log(abs(squeeze(k_F1_echo2(:,2,:,i))))); colormap gray; colorbar;
hcb=colorbar;
title(hcb,'Amplitude','interpreter', 'latex', 'Fontsize',7);
subtitle('Subtraction with pre-drift correction','Interpreter','latex','FontSize',8)




%% SR reconstruction echo 2

spoil_grad=80;
W=100; % sampling window width
assert(spoil_grad-W/2<=W/2);
r=(NCol/2)+W/2;
l=(NCol/2)-W/2;
chn_coil=1;% arbitrary channel coil for visualization
sli=10; % arbitrary slice number for visualization
mid_frag=squeeze(k_F1_echo2(:,:,l:r,:));
rgh_frag=squeeze(k_F0_echo2(:,:,l:r,:));
ext_dim=spoil_grad;
subplot(2,2,1)
samp_win=k_F1_echo2;
samp_win(1,:,l:r,:)=0;
samp_win(:,:,l,:)=0;
samp_win(:,:,r,:)=0;
samp_win(end,:,l:r,:)=0;
imagesc(log(abs(squeeze(samp_win(:,chn_coil,:,sli))))); colormap gray; 
subplot(2,2,2)
imagesc(log(abs(squeeze(mid_frag(:,chn_coil,:,sli))))); colormap gray; axis image off;
subtitle('$F_{-1}$ signal contribution','Interpreter','latex','FontSize',13)
subplot(2,2,3)
samp_win=k_F0_echo2;
samp_win(1,:,l:r,:)=0;
samp_win(:,:,l,:)=0;
samp_win(:,:,r,:)=0;
samp_win(end,:,l:r,:)=0;
imagesc(log(abs(squeeze(samp_win(:,chn_coil,:,sli))))); colormap gray; 
subplot(2,2,4)
imagesc(log(abs(squeeze(rgh_frag(:,chn_coil,:,sli))))); colormap gray; axis image off;
subtitle('$F_{0}$ signal contribution','Interpreter','latex','FontSize',13)


% Fragment-based reconstruction and Partial Fourier Transform
% Reference [26] Final Report: John Pauly Notes Partial k-space reconstruction. September 29, 2005
% Same notations adopted than in [26]

lft_frag=zeros([NLin,NCha,ext_dim,NRep]);
Mpk=cat(3,lft_frag,mid_frag,rgh_frag(:,:,end-spoil_grad:end,:));
centband=floor(0.5*size(Mpk,3));
width=30;
win=centband-width-1:centband+width+1;
Ms=zeros(size(Mpk), 'single');
Ms(:,:,win,:)=Mpk(:,:,win,:);
subplot(1,2,1)
imagesc(log(abs(squeeze(Mpk(:,chn_coil,:,sli))))); colormap gray;
subplot(1,2,2)
imagesc(log(abs(squeeze(Ms(:,chn_coil,:,sli))))); colormap gray;
N=size(Mpk,3);

fft_dims=[1 3]; % phase encode/read out
ms=Ms;
mpk=Mpk;
for f=fft_dims
    ms=ifftshift(ifft(fftshift(ms,f),[],f),f);
    mpk=ifftshift(ifft(fftshift(mpk,f),[],f),f);
end
p=exp(-1i*angle(ms));
Mpk_corr=mpk.*p;
subplot(1,2,1)
imagesc(angle(squeeze(ms(:,chn_coil,:,sli)))); colormap gray;
subtitle('Low-res image')
subplot(1,2,2)
imagesc(angle(squeeze(mpk(:,chn_coil,:,sli)))); colormap gray;
subtitle('Original image'); colorbar;

fft_dims=[1 3]; % phase encode/read out
for f=fft_dims
    Mpk_corr=fftshift(fft(ifftshift(Mpk_corr,f),[],f),f);
end

subplot(1,2,1)
Mpk_corr(:,:,1:ext_dim,:)=0;
imagesc(log(abs(squeeze(Mpk_corr(:,chn_coil,:,sli))))); colormap gray; colorbar; caxis([-18, -10]); axis image off
subtitle('After B0 correction')
subplot(1,2,2)
imagesc(log(abs(squeeze(Mpk(:,chn_coil,:,sli))))); colormap gray; colorbar; axis image off;
subtitle("Before B0 correction")

ks_SR_echo2= Mpk_corr;
N=size(Mpk,3);
ks_SR_echo2(:,:,1:ext_dim,:)=conj(flipud(Mpk_corr(:,:,end:-1:end-ext_dim+1,:)));
imagesc(log(abs(squeeze(ks_SR_echo2(:,1,:,10))))); colormap gray;

% Image comparaison: super-resolution image vs reference low-resolution qDESS 

fft_dims=[1 3]; % phase encode/read out
img_corr=ks_SR_echo2;
img_qDESS=ks_ref_echo2(:,:,l:r,:);% reference low-resolution qDESS scan
for f=fft_dims
    img_corr=ifftshift(ifft(fftshift(img_corr,f),[],f),f);
    img_qDESS=ifftshift(ifft(fftshift(img_qDESS,f),[],f),f);
end

figure(1)
img_SR_corr_echo2=squeeze(sqrt(sum(abs(img_corr).^2,2)));
img_qDESS=squeeze(sqrt(sum(abs(img_qDESS).^2,2)));
subplot(1,2,1)
imagesc(abs(squeeze(img_SR_corr_echo2(:,:,sli)))); colormap gray;
subplot(1,2,2)
imagesc(abs(squeeze(img_qDESS(:,:,1)))); colormap gray;



%% SR reconstruction echo 1

chn_coil=2; % arbitrary channel coil choice for visualisation
sli=50;% arbitrary slice number choice for visualisation
spoil_grad=80;
W=100; % sampling window width
assert(spoil_grad-W/2<=W/2);
r=(NCol/2)+W/2;
l=(NCol/2)-W/2;
mid_frag=squeeze(k_F0_echo1(:,:,l:r,:));
lft_frag=squeeze(k_F1_echo1(:,:,l:r,:));
ext_dim=spoil_grad;
subplot(2,2,1) % visualisation: decomposition F0 and F-1 resolved fragments
samp_win=k_F0_echo1;
samp_win(1,:,l:r,:)=0;
samp_win(:,:,l,:)=0;
samp_win(:,:,r,:)=0;
samp_win(end,:,l:r,:)=0;
imagesc(log(abs(squeeze(samp_win(:,chn_coil,:,sli))))); colormap gray; 
subplot(2,2,2)
imagesc(log(abs(squeeze(mid_frag(:,chn_coil,:,sli))))); colormap gray; axis image off;
subtitle('$F_{-1}$ signal contribution','Interpreter','latex','FontSize',13)
subplot(2,2,3)
samp_win=k_F1_echo1;
samp_win(1,:,l:r,:)=0;
samp_win(:,:,l,:)=0;
samp_win(:,:,r,:)=0;
samp_win(end,:,l:r,:)=0;
imagesc(log(abs(squeeze(samp_win(:,chn_coil,:,sli))))); colormap gray; 
subplot(2,2,4)
imagesc(log(abs(squeeze(lft_frag(:,chn_coil,:,sli))))); colormap gray; axis image off;
subtitle('$F_{0}$ signal contribution','Interpreter','latex','FontSize',13)


% filling k-space 
rgh_frag=zeros([NLin,NCha,ext_dim,NRep]);
Mpk=cat(3,lft_frag(:,:,1:spoil_grad,:),mid_frag,rgh_frag);
centband=floor(0.5*size(Mpk,3));
width=15;
win=centband-width-1:centband+width+1;
Ms=zeros(size(Mpk), 'single');
Ms(:,:,win,:)=Mpk(:,:,win,:);
subplot(1,2,1)
imagesc(log(abs(squeeze(Mpk(:,chn_coil,:,sli))))); colormap gray;
subplot(1,2,2)
imagesc(log(abs(squeeze(Ms(:,chn_coil,:,sli))))); colormap gray;
N=size(Mpk,3);


% Partial Fourier Transform
% Reference [26] Final Report: John Pauly Notes Partial k-space reconstruction. September 29, 2005
% Same notations adopted than in [26]

fft_dims=[1 3]; % phase encode/read out
ms=Ms;
mpk=Mpk;
for f=fft_dims
    ms=ifftshift(ifft(fftshift(ms,f),[],f),f);
    mpk=ifftshift(ifft(fftshift(mpk,f),[],f),f);
end
p=exp(-1i*angle(ms));
Mpk_corr=mpk.*p;
subplot(1,2,1)
imagesc(angle(squeeze(ms(:,chn_coil,:,sli)))); colormap gray;
subtitle('Low-res image')
subplot(1,2,2)
imagesc(angle(squeeze(mpk(:,chn_coil,:,sli)))); colormap gray;
subtitle('Original image'); colorbar;

fft_dims=[1 3]; % phase encode/read out
for f=fft_dims
    Mpk_corr=fftshift(fft(ifftshift(Mpk_corr,f),[],f),f);
end

subplot(1,2,1)
Mpk_corr(:,:,end-ext_dim:end,:)=0;
imagesc(log(abs(squeeze(Mpk_corr(:,chn_coil,:,sli))))); colormap gray; colorbar; caxis([-18, -10]);
subtitle('After B0 correction')
subplot(1,2,2)
imagesc(log(abs(squeeze(Mpk(:,chn_coil,:,sli))))); colormap gray; colorbar; 
subtitle("Before B0 correction")

ks_SR_echo1= Mpk_corr;
N=size(Mpk,3);
ks_SR_echo1(:,:,end-ext_dim:end,:)=conj(flipud(Mpk_corr(:,:,ext_dim+1:-1:1,:)));
imagesc(log(abs(squeeze(ks_SR_echo1(:,chn_coil,:,sli))))); colormap gray;


% Image comparaison: super-resolution image vs reference low-resolution qDESS 

fft_dims=[1 3]; % phase encode/read out
img_corr=ks_SR_echo1;
img_qDESS=ks_ref_echo1(:,:,l:r,:); % reference low-resolution qDESS scan  
for f=fft_dims
    img_corr=ifftshift(ifft(fftshift(img_corr,f),[],f),f);
    img_qDESS=ifftshift(ifft(fftshift(img_qDESS,f),[],f),f);
end

figure(1)
img_SR_corr_echo1=squeeze(sqrt(sum(abs(img_corr).^2,2)));% Sum-of-Squares
img_qDESS=squeeze(sqrt(sum(abs(img_qDESS).^2,2))); % Sum-of-Squares
subplot(1,2,1)
imagesc(abs(squeeze(img_SR_corr_echo1(:,:,sli)))); colormap gray;
subplot(1,2,2)
imagesc(abs(squeeze(img_qDESS(:,:,1)))); colormap gray;


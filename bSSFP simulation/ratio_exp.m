function [ratio] = ratio_exp(param,Mss)

m=max(abs(unwrap(angle(Mss))))/(2*pi);
count=ceil(m);
ze=ceil((count/m)*length(param.beta));
y=fft(Mss);
z=abs(fftshift(y));
idx1=find(z==max(z));
F0=z(idx1);
z(idx1)=-1;
idx2=find(z==max(z));
F1=z(idx2);
ratio=F0/F1;

end


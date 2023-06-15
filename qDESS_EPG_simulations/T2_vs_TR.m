function T2_vs_TR(param,Sig,TE)

y=Sig;
T1=repmat(param.TE,length(Sig),1);
T2=(2*TR-param.TE)';
t=cat(2,T1,T2);
Information=diff(y,1,2)./diff(t,1,2);
plot(diff(t,1,2),diff(y,1,2));
disp(abs(diff(y,1,2)./diff(t,1,2)));

end


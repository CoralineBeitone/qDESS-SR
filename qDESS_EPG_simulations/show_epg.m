function  show_epg(omega,seq,idx_alpha,T2,limit)

subplot(2,1,1)

x=-(limit-1):1:(limit-1);

 
F_dph=omega(1,1:limit);
F_rph=-fliplr(conj(omega(2,2:limit)));

F=[F_rph F_dph];
F_real=real(F);
F_im=imag(F);
F_mag=abs(F);

h_real = stem(x,F_real,'k');
hold on;
h_im=stem(x,-F_im,'r');
hold on;
%h_mag=stem(x,F_mag,'k');
set(h_real, 'Marker', 'none','LineWidth',2)
set(h_im, 'Marker', 'none','LineWidth',2)
%set(h_mag, 'Marker', 'none','LineWidth',2)

if limit>10
set(gca,'xTick',[])
set(gca, 'ylim', [-0.8*max(abs(F)) 1.3*max(abs(F))]);
set(gca,'TickLabelInterpreter','latex');
else
set(gca,'xTick',(-limit:1:limit));
set(gca, 'ylim', [-0.1 0.1]);
set(gca,'XTickLabelRotation',0);
set(gca,'TickLabelInterpreter','latex');
N=length(F);
txt = "$F_{0}$";
text(-0.2,1.2*F(ceil(N*0.5)),txt,'Interpreter','latex','FontSize',15)
txt = "$F_{-1}$";
text(-seq.delta_k-0.2,1.2*F(ceil(N*0.5)-seq.delta_k),txt,'Interpreter','latex','FontSize',15)
end

xlabel('$k_{x}$','Interpreter','latex','FontSize',15);
ylabel('$Amplitude$','Interpreter','latex','FontSize',15);
legend('Imag','Real')

%grid('minor');
title("F-states components for $\alpha$="+ num2str(seq.alpha(idx_alpha))+"$^{\circ}$, $\phi$="+ num2str(seq.inc)+ "$^{\circ}$ and $T2=$"+ num2str(T2)+ "ms",'Interpreter','latex','FontSize',15);
hold off;


subplot(2,1,2)

Mss=[fliplr(conj(omega(2,2:end))) omega(1,:)];
Mx=real(ifft(ifftshift(Mss)));
My=imag(ifft(ifftshift(Mss)));

plot(Mx,'k');
hold on;
plot(My,'r');
hold on;
plot(abs(Mx+1i*My),'b');
set(gca,'xTick',[])
set(gca, 'ylim', [-max(abs(Mx+1i*My)) max(abs(Mx+1i*My))]);
set(gca,'TickLabelInterpreter','latex');
xlabel('$x$','Interpreter','latex','FontSize',15);
ylabel('$Amplitude$','Interpreter','latex','FontSize',15);
legend('Real','Imag','Modulus');
grid('minor');
title("Spatial pattern $\Gamma(x)$ for $\alpha$="+ num2str(seq.alpha(idx_alpha))+"$^{\circ}$, $\phi$="+ num2str(seq.inc)+ "$^{\circ}$ and $T2=$"+ num2str(T2)+ "ms",'Interpreter','latex','FontSize',15);
pause(0.1);
hold off;

end


function  show_epg(omega,seq,T2)
figure(2)
x=-7:1:7;
F_dph=abs(omega(1,1:8));
F_rph=fliplr(abs(omega(2,2:8)));
F=[F_rph F_dph];
h = stem(x,F);
set(h, 'Marker', 'none','LineWidth',3)
grid on;
set(gca, 'xlim', [-8 8]);
set(gca,'xTick',(-8:1:8));
set(gca, 'ylim', [0 1.1*max(F)]);
ax=gca;
set(ax,'XTickLabelRotation',0)
xlabel('$Modes$','Interpreter','latex','FontSize',15);
ylabel('$Amplitude$','Interpreter','latex','FontSize',15);
N=length(F);

txt = "$F_{0}$";
text(-0.2,1.05*F(ceil(N*0.5)),txt,'Interpreter','latex','FontSize',15)
txt = "$F_{-1}$";
text(-1.2,1.05*F(ceil(N*0.5)-1),txt,'Interpreter','latex','FontSize',15)
grid('minor');

title("F-states components for a flip angle $\alpha$="+ num2str(seq.alpha)+"$^{\circ}$ and $T2=$"+ num2str(T2)+ "ms",'Interpreter','latex','FontSize',15);

pause(1);
hold off;

end


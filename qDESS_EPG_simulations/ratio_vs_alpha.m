function ratio_vs_alpha(seq,param,ratio,factor)

if isnan(ratio(1))
   ratio(1)=0;
end

den=1-cosd(seq.alpha)*exp(-param.TR/param.T1);
num=round(1+exp(-param.TR/param.T1),factor);

ratio_exp=exp(-2*(param.TR-param.TE)/param.T2(ceil(length(param.T2)*0.5)))*sind(0.5*seq.alpha).^2.*(num./den);

plot(seq.alpha,ratio_exp,'LineWidth',1.5,'LineStyle','--', 'Color', [0.87 0.11 0.11]);
hold on;
plot(seq.alpha,ratio(ceil(length(param.T2)*0.5),:),'LineWidth',1.5,'LineStyle','-', 'Color', [0.87 0.11 0.11]);
grid('minor');
leg=legend('Theoretical ratio ($exp\{-2(TR-TE)/T2\}sin^{2}(\frac{\alpha}{2})\frac{1+exp\{-TR/T1\}}{2}$)', 'Simulation','interpreter','latex','Location','south');
set(leg,'Interpreter','latex');
set(leg,'FontSize',10);
yticks(0:(1/10):max(ratio,[],'all'));
set(gca,'TickLabelInterpreter','latex');
xlabel('$\alpha\;values$','Interpreter','latex','FontSize',15);
ylabel('$Ratio\;amplitude$','Interpreter','latex','FontSize',15);
title("$\frac{S_{2}}{S_{1}}$ evolution with $\alpha$ for $T2$="+ num2str(param.T2(ceil(length(param.T2)*0.5)))+"$ ms$" ,'Interpreter','latex','FontSize',15);



end


function get_T2(seq,param,ratio)

den=1-cosd(seq.alpha)*exp(-param.TR/param.T1);
num=1+exp(-param.TR/param.T1);
B=sind(0.5*seq.alpha).^2.*(num./den);
B=repmat(B,length(param.T2),1);
T2_estimate=2*(param.TE-param.TR)./(log(ratio./B));
T2_th=repmat(param.T2,length(seq.alpha),1);


plot(seq.alpha,T2_estimate,'-s','LineWidth',1.0,'MarkerSize',5);
hold on;
plot(seq.alpha,T2_th,'LineWidth',1,'LineStyle','--','Color','k');
grid('minor');
leg=legend('T2=30 ms', 'T2=35 ms', 'T2=40 ms');
set(leg,'Interpreter','latex');
set(leg,'FontSize',10);
ylim([min(param.T2)-5 max(param.T2)+10])
set(gca,'TickLabelInterpreter','latex');
xlabel('$\alpha\; [^{\circ}]$','Interpreter','latex','FontSize',15);
ylabel('$T2 \; [ms]$','Interpreter','latex','FontSize',15);
title("T2 estimation with respect to $\alpha$ " ,'Interpreter','latex','FontSize',15);


end


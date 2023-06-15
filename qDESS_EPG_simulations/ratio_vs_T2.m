function ratio_vs_T2(seq,param,ratio,factor)

T2=param.T2;
den=1-cosd(seq.alpha(ceil(0.5*length(seq.alpha))))*exp(-param.TR/param.T1);
num=round(1+exp(-param.TR/param.T1),factor);
ratio_exp=exp(-2*(param.TR-param.TE)./param.T2)*sind(seq.alpha(ceil(0.5*length(seq.alpha)))/2)^2*(num/den);
plot(param.T2,ratio_exp,'-sb','MarkerSize',5,...
    'MarkerEdgeColor','blue',...
    'MarkerFaceColor',[0 .45 .74]);
hold on;
plot(param.T2,ratio(:,ceil(length(seq.alpha)*0.5)),'-sr','MarkerSize',5,...
    'MarkerEdgeColor','red',...
    'MarkerFaceColor',[1 .6 .6]);
leg=legend('Theoretical ratio ($exp\{-2(TR-TE)/T2\}sin^{2}(\frac{\alpha}{2})\frac{1+exp\{-TR/T1\}}{2}$', 'Simulation ratio','interpreter','latex','Location','southeast');
set(leg,'Interpreter','latex');
set(leg,'FontSize',10);
set(gca,'TickLabelInterpreter','latex');
grid('minor');
xlabel('$T2\;values$','Interpreter','latex','FontSize',15);
ylabel('$Ratio\;amplitude$','Interpreter','latex','FontSize',15);
title("$\frac{S_{2}}{S_{1}}$ evolution with $T2$ for a flip angle $\alpha$="+ num2str(seq.alpha(ceil(0.5*length(seq.alpha))))+"$^{\circ}$" ,'Interpreter','latex','FontSize',15);



end


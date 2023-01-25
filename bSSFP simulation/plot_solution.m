function plot_solution(fig,param,Mss,alpha)

phase_cycling_max=param.cycling_max;
N=param.N;
TR=(param.TR)*1e-3;
beta=param.beta;
    if N==1
        subplot(2,1,1);
        plot(param.beta,abs(Mss), 'k', 'LineWidth',1);
        hold on;
        plot(param.beta,real(Mss), 'r', 'LineWidth',0.5);
        hold on;
        plot(param.beta,imag(Mss), 'b', 'LineWidth',0.5);
        hold on;
        %leg1 = legend('$\bar{x}$','$\tilde{x}$','$\hat{x}$');
        leg1=legend('$\mid M_{ss} \mid$', '$ M_{ss,x}$', '$ M_{ss,y}$','interpreter','latex');
        set(leg1,'Interpreter','latex');
        set(leg1,'FontSize',10);
        xlabel("$off\; resonance$ [Hz]",'Interpreter','latex','FontSize',15);
        ylabel("$  M_{x}+iM_{y} $",'Interpreter','latex','FontSize',15);
        xlim([min(param.beta) max(param.beta)])
        grid('minor')
        pause(0.01);
        hold off;
        subplot(2,1,2)
        TR=param.TR;
        TE=param.TE;
        y=fft(Mss);
        z=abs(fftshift(y));
        N=length(z);
        Fs=1/(TR*1e-3);
        x=(-0.5+(1/N):(1/N):0.5)*Fs;
       % z(z<max(z)*0.4)=0;
        h=stem(x,fliplr(z'),'b');
        %hold on;
        %plot(x,z,'k','LineWidth',0.3);
        set(h, 'Marker', 'none','LineWidth',3);
        grid on; 
        ylim([0,1.1*max(z)]);
        xlim([-5 5]);
        grid on;
        xlabel("k",'Interpreter','latex');
        ylabel('Amplitude');
        title("Fourier Transform for $T2=$"+ num2str(param.T2)+" ms" ,'Interpreter','latex','FontSize',15);
        pause(1);
        hold off;


    else

    for i=1:N
        h=zeros(2,1);
        left_color = [0 0.4470 0.7410];
        right_color = [0 0 0];
        set(fig,'defaultAxesColorOrder',[left_color; right_color]);
        subplot(N,1,i);
        yyaxis left
        h(1)=plot(param.beta/(2*pi*TR),abs(Mss(:,i)),'LineWidth',1);
        xlabel("$\beta $ (in degrees)",'Interpreter','latex','FontSize',15);
        ylabel("$\mid M_{ss} \mid  $",'Interpreter','latex','FontSize',15);
        grid on;
        hold on;
        yyaxis right
        h(2)=plot(param.beta/(2*pi*TR), pi+unwrap(angle(Mss(:,i))),'-k','Linewidth',0.5);
        hold on;
        %h(3)=plot(phi,angle(Mss(:,i)),'--r');
        hold on;
        %legend(h(2:3),'unwrap','wrap');
        ylabel("$\angle M_{ss}\; (rd) $",'Interpreter','latex','FontSize',15);
        title("Phase cycling signal magnitude and phase for a flip angle $\alpha$="+ num2str(alpha)+" degrees, sampled every " + ...
            ""+ num2str(i)+ " on $N=$ "+ num2str(N)+ " periods" ,'Interpreter','latex','FontSize',15);
        pause(0.1);
        hold off;
    end
    end
end

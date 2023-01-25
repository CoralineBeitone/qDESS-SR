function seq=show_DESS(param,seq)

TR=param.TR;
TE=param.TE;
tau=TR-3*TE;


% Assertion the timing-sequence must be correctly chosen

assert(TR==3*TE+tau  ,'Incorrect dimensioning of the sequence, choose a smaller TE or a larger TR')

figure(1)

% Background, readout and Rf lines  

set(gcf,'color','w');

% Rf pulse 1
line([0.5 0.5], [4.0 4.5], ...                       
        'linewidth', 3, ...
        'color', [0,0,0]); 

% Rf pulse 2
line([11 11], [4.0 4.5], ...                       
        'linewidth', 3, ...
        'color', [0,0,0]); 


% Readout (RO) line
line([0.0 12.0], [2.0 2.0], ...                       
        'linewidth', 1, ...
        'color', [0,0,0]); 

% Rf line
line([0.0 12.0], [4.0 4.0], ...                       
        'linewidth', 1, ...
        'color', [0,0,0]); 

% Gradient area including readout gradient (red) and spoiler gradient (grey)
rectangle('Position',[4 2 2 0.25],'FaceColor', [.92 .92 .92],'LineWidth',1)
rectangle('Position',[0.5 1.75 1.75 0.25],'FaceColor', [.77 .66 .66],'LineWidth',1)
rectangle('Position',[2.25 2 1.75 0.25],'FaceColor', [.77 .66 .66],'LineWidth',1)
rectangle('Position',[6 2 1.75 0.25],'FaceColor', [.77 .66 .66],'LineWidth',1)
rectangle('Position',[7.75 1.75 1.75 0.25],'FaceColor', [.77 .66 .66],'LineWidth',1)

% Dash red lines
line([3.1 3.1], [2.0 4.2],'Color','red','LineStyle','--')
line([6.85 6.85], [2.0 4.4],'Color','red','LineStyle','--')

str="FISP ";
dim = [.3 .12 .3 .3];
a=annotation('textbox',dim,'String',str,'FitBoxToText','on','EdgeColor',[ 1 1 1],'FontSize',12);
a.Color = 'red';

str="PSIF ";
dim = [.54 .12 .3 .3];
a=annotation('textbox',dim,'String',str,'FitBoxToText','on','EdgeColor',[ 1 1 1],'FontSize',12);
a.Color = 'red';

alpha=seq.alpha;
str="\alpha = "+alpha + "°";
dim = [.15 .46 .3 .3];
annotation('textbox',dim,'String',str,'FitBoxToText','on','EdgeColor',[ 1 1 1],'FontSize',12);

ylim([0,5]);

dim = [.05 .5 .3 .3];
str = 'RF';
annotation('textbox',dim,'String',str,'FitBoxToText','on');


dim = [.05 .5 .08 .01];
str = 'RO';
annotation('textbox',dim,'String',str,'FitBoxToText','on');

axis off;


A = [0.31 0.335];
B = [0.8 0.8];

messageToDisplay = "$$T_{E1}=$$"+TE+" ms";
annotation('textarrow', A, B, 'String', messageToDisplay,'Interpreter','latex','FontSize',12)

C = [0.21 0.18];
D = [0.8 0.8];
annotation('textarrow', C, D)


A = [0.505 0.53];
B = [0.50 0.50];


messageToDisplay = "$$\tau=$$"+tau+"ms";
annotation('textarrow', A, B, 'String', messageToDisplay,'Interpreter','latex','FontSize',12)

C = [0.43 0.40];
D = [0.50 0.50];
annotation('textarrow', C, D)




A = [0.6 0.84];
B = [0.88 0.88];

messageToDisplay = "$$TR=$$"+TR+" ms";
annotation('textarrow', A, B, 'String', messageToDisplay,'Interpreter','latex','FontSize',12)

C = [0.48 0.18];
D = [0.88 0.88];
annotation('textarrow', C, D)

A = [0.45 0.58];
B = [0.84 0.84];

TE2=(3/2)*TE;
messageToDisplay = "$$T_{E2}=$$"+TE2+" ms";
annotation('textarrow', A, B, 'String', messageToDisplay,'Interpreter','latex','FontSize',12)

C = [0.35 0.18];
D = [0.84 0.84];
annotation('textarrow', C, D)

title("DESS Sequence",'FontSize',12);
set(get(gca,'title'),'Position',[5.5 0.4 1.00011])

%% Timing events for the DESS Sequence


% Timing for each TR

seq.events={};
seq.events={'Rf','FID (FISP)','Grad','Echo (PSIF)','Rf'};

end


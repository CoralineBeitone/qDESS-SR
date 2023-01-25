function plot_transient(param,S,alpha)

set(gcf, 'color', [.92 .92 .92], ...                % Figure, color
       'Menubar', 'none', ...
   'numbertitle', 'off');
set(gca,         'Units',  'Normalized', ...     % Axes  
         'OuterPosition', [0, 0, 1, .9], ...     % - position
  'TickLabelinterpreter',       'Latex',...
  'XLim', [-0.3 0.3], 'YLim',[-0.3 0.3], 'ZLim',[0 0.6]); % - limits

set(gca,'CLim',[-max(param.beta) max(param.beta)]);

info = annotation(  'TextBox',              ...  % Info Box
                   'Position', [0,.9,1,.1], ...  % - position
            'BackgroundColor',  [.84 .84 .84], ...  % - color
'Fontsize', 18, 'Interpreter',     'Latex');     % - font
                
view(120, 30);  grid on;                         % View Angle, 
% (1) Rainbow-Spiral-Arrows
set(info, 'string', "Off-resonnance distribution for $\alpha=$"+ num2str(alpha),...
           'color', [0 0 0]);

achromats=length(param.beta);
cmap = jet(achromats);
c=colorbar;
colormap(jet);
c.Label.String='Off-resonance';
lines=[];


for j=1:param.N_TR
    for i = 1:length(param.beta)                           % Loop for each arrow
        color = cmap(i,:);
        width=2;
        lines=[lines,farrow(0, 0, 0 ,real(S(i,j,1)), imag(S(i,j,1)),S(i,j,2), color,width)];   % Arrow Function
    end
    pause(0.1);
    delete(lines);
end



end


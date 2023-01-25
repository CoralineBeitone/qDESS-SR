function  show_epg(omega)

figure(2)
x=-5:1:5;
F=abs(omega);
F=[fliplr(F(2:6)) F(1:6) ];
h = stem(x, F);
set(h, 'Marker', 'none','LineWidth',3)
grid on;
xlim([-10, 10]);

end


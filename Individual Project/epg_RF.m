function [omega] = epg_RF(alpha,phi,omega)

c=cosd(alpha);
s=sind(alpha);
c2=cosd(alpha/2)^2;
s2=sind(alpha/2)^2;


phi=deg2rad(phi);

T=[ c2, exp(2*1i*phi)*s2, -1i*exp(1i*phi)*s;
    exp(-2*1i*phi)*s2, c2, 1i*exp(-1i*phi)*s;
    -0.5i*exp(-1i*phi)*s, 0.5i*exp(1i*phi)*s, c
];


omega=T*omega;

end


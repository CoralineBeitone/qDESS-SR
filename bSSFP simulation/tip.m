function [M] = tip(alpha,M0,phi,sign)
% Function used to tip the magnetization from a given flip angle about an
% axis contains in the x-y plane that makes a certain angle with respect to
% the x axis

c=cosd(sign*alpha);
s=sind(sign*alpha);
x= cosd(phi);
y=sind(phi);

R=[ c*y*y+x*x, (1-c)*x*y, -s*y; 
    (1-c)*x*y, c*x*x+y*y, s*x;
    s*y, -s*x, c
    
];


M=R*M0;

end


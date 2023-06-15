function [M] = rotz(alpha,M0)

R=[ cosd(alpha), sind(alpha),0 ; -sind(alpha), cosd(alpha) 0; 0, 0 1];

M=R*M0;

end


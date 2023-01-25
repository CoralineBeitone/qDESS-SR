function [flip] = angles(seq)
N=seq.N;
alpha_in=seq.alpha;
sign=seq.sign;
flip=[];

for i=1:N
    flip=[flip, alpha_in];

end

if sign<0
    flip(2:2:end)=-flip(2:2:end);
end


end

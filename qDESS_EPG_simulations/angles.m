function [flip] = angles(seq)
alpha=seq.alpha;
sign=seq.sign;
flip=zeros(length(alpha),seq.N_RF);

for i=1:length(seq.alpha)
    flip(i,:)= alpha(i);
    if sign<0
    flip(i,2:2:end)=-alpha(i);
    end
end



end

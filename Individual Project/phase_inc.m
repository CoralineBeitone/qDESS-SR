function [phi] = phase_inc(seq)

N=seq.N;


if seq.RF_spoling==0
    phi=zeros(1,N);
end
if seq.RF_spoling==1
    phi=[phi,seq.inc];
    for i=2:N-1
        phi=[phi,phi(end)+i*seq.inc];
    end
end

end


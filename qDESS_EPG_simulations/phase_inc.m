function [phi] = phase_inc(seq)

phi=[0];


if seq.RF_spoling==1
    phi=[phi,seq.inc];
    for i=2:N_RF-1
        phi=[phi,phi(end)+i*seq.inc];
    end
else
   for i=2:seq.N_RF
           phi=[phi,phi(end)+seq.inc];
           if phi(i)>=360
               phi(i)=phi(i)-360;
           end

   end
end

end



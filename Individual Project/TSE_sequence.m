function TSE_sequence(seq,omega,N_TR,phi,flip)

omega=epg_RF(90,90,omega);% application of the first RF pulse
%disp('Rf 90°');
%disp(omega);
omega=epg_gradient(seq,omega); % S matrix, shift according to the gradient area defined by seq.Gt
%disp('After gradient');
%disp(omega);
omega=epg_RF(flip(1),phi(1),omega); % T matrix 'RF' pulse
%disp('Second Rf 120°');
%disp(omega);
for rf=1:N_TR
    omega=epg_gradient(seq,omega); % S matrix, shift according to the gradient area defined by seq.Gt
    %disp('After gradient');
    %disp(omega);
    omega=epg_gradient(seq,omega); % S matrix, shift according to the gradient area defined by seq.Gt
    %disp('After gradient');
    %disp(omega);
    omega=epg_RF(flip(rf),phi(rf),omega); % T matrix 'RF' pulse
    %disp('Rf 120°');
    %disp(omega); 
end
    


end


function ResultH=MIMOHAPSchannel(lambda,D,Theta,Phi,alpha_angle,beta_angle,gamma_angle)

% Parameters (adjust according to your system setup)
Nu=size(D,1);
Nt=size(D,2);

H=zeros(Nu,Nt);

for i=1:Nu
    
    D_u=D(i,:);
    theta_u=Theta(i,:);
    phi_u=Phi(i,:);
    % Compute p_u (path loss term)
    p_u = ((4 * pi / lambda)*D_u).^(-1);

    % Compute d_u (phase shift term)
    d_u = exp(1j * (2 * pi / lambda).* D_u);
    

    % Compute g_u (antenna pattern gain)
    g_u= magnitude_response(theta_u, phi_u,alpha_angle,beta_angle,gamma_angle);
    
    H(i,:)= p_u .* d_u .* g_u;
 
end

ResultH=H;


end
function [ResultH,ResultG,ResultThetaTrans,ResultPhiTrans]=MIMOHAPSchannel(lambda,D,Theta,Phi,alpha_angle,beta_angle,gamma_angle)

% Parameters (adjust according to your system setup)
Nu=size(D,1);
Nt=size(D,2);

H=zeros(Nu,Nt);
ThetaTrans=zeros(Nu,Nt);
PhiTrans=zeros(Nu,Nt);
G=zeros(Nu,Nt);

for i=1:Nu
    
    D_u=D(i,:);
    theta_u=Theta(i,:);
    phi_u=Phi(i,:);
    % Compute p_u (path loss term)
    p_u = ((4 * pi / lambda)*D_u).^(-1);
    
    r_u=(2 * pi / lambda)* D_u;
    % Compute d_u (phase shift term)
    d_u = exp(1i .*r_u);
    

    % Compute g_u (antenna pattern gain)
    [g_u,theta_u_trans,phi_u_trans]= magnitude_response(theta_u, phi_u,alpha_angle,beta_angle,gamma_angle);
    ThetaTrans(i,:)=theta_u_trans;
    PhiTrans(i,:)=phi_u_trans;
    G(i,:)=g_u;
    H(i,:)= p_u .* d_u .* g_u;
 
end

ResultH=H;
ResultG=G;
ResultThetaTrans=ThetaTrans;
ResultPhiTrans=PhiTrans;


end
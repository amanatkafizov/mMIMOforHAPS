function [ResultH,ResultG,ResultThetaTrans]=MIMOHAPSchannel(lambda,D,Theta)

% Parameters (adjust according to your system setup)
Nu=size(D,1);
Nt=size(D,2);

H=zeros(Nu,Nt);
ThetaTrans=zeros(Nu,Nt);
G=zeros(Nu,Nt);

for i=1:Nu
    
    D_u=D(i,:);
    theta_u=Theta(i,:);
    % Compute p_u (path loss term)
    p_u = ((4 * pi / lambda)*D_u).^(-1);
    
    r_u=(2 * pi / lambda)* D_u;
    % Compute d_u (phase shift term)
    d_u = exp(1i .*r_u);
    

    % Compute g_u (antenna pattern gain)
    [g_u,theta_u_trans]= magnitude_response(theta_u);
    ThetaTrans(i,:)=theta_u_trans;
    G(i,:)=g_u;
    H(i,:)= p_u .* d_u .* g_u;
 
end

ResultH=H;
ResultG=G;
ResultThetaTrans=ThetaTrans;


end
function [Resulttheta, Resultphi]=convertLCStoGCS(alpha,beta,gamma,theta,phi)

Resulttheta=acos(cos(beta)*cos(gamma)*cos(theta)+(sin(beta)*cos(gamma)*cos(phi-alpha)-sin(gamma)*sin(phi-alpha)).*sin(theta));


% Real part of the equation
real_part = (cos(beta) * sin(theta).* cos(phi - alpha) - sin(beta) * cos(theta));

% Imaginary part of the equation
imag_part = 1i * (cos(beta) * sin(gamma) * cos(theta) + (sin(beta) * sin(gamma) * cos(phi - alpha) + cos(gamma) * sin(phi - alpha)).* sin(theta));

% Full complex expression
complex_expr = real_part + imag_part;

% Calculate the argument (phase)
Resultphi = angle(complex_expr);


end
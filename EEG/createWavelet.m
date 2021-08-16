function [wave]=createWavelet(time_mesh,tau,omega,theta,alpha,f)
    %See (4.25) from KMD paper where cos is changed by the functions in the database (here f)
    wave=(2/pi^3)^(1/4)*sqrt(omega/alpha)*f(omega*(time_mesh-tau)+theta).*exp(-(omega*(time_mesh-tau)/alpha).^2);
end
function [K]=createKernel(time_mesh,tau,omega,theta_mesh,alpha,f)
    %Compute K=int_(-theta_min)^theta_max chi(s)chi(t)dtheta at tau and
    %omega fixed
    K=zeros(length(time_mesh),length(time_mesh),'double');
    for i=1:length(theta_mesh)
        Chi=createWavelet(time_mesh,tau,omega,theta_mesh(i),alpha,f); %column
        K=K+(Chi)*(Chi');
    end
end
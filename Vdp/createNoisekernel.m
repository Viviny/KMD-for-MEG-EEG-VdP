function [kernel]=createNoisekernel(time_mesh,sigma)
    %Blank noise kernel
    kernel=sigma^2*eye(length(time_mesh));
end
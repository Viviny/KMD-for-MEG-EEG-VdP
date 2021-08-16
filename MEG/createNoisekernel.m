function [kernel]=createNoisekernel(time_mesh,sigma)
    %Blank noise kernel
    kernel=sigma^2*eye(length(time_mesh),'double');
    
    %Other try at making a blank noise kernel, not working as wanted
    %kernel=wgn(length(time_mesh),length(time_mesh),sigma^2);
end
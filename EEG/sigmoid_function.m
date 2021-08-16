function [ sx ] = sigmoid_function(x,v0)
% This file is part of the function Neural Mass Model Simulation for EEG generation. 
%Name of this file on my computer is:..... 
% Refrecne of this simulation is " electroencephalogram and visual
% potential generatino in Mathematical model of coupled cortical columns,
% Ben H Jensen, Vincent G. Rit. , 1995.
% This file is for generating sigma function equation 3  
%Amirhossein Jafarian.2012. 
e0=2.5; r=.56; 
sx=2*e0/(1+exp(r*(v0-x)));

end


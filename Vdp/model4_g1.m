function xout = model4_g1(x,y,p)

delta=p(4);

% Linear slow subsystem added to Morris-Lecar model 
xout=-0.05+x(1);

end


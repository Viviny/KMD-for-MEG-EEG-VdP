function [f] = createDatafunc(x,y)
%Create a (x(end)-x(1))-periodic function based on x,y arrays
f=fit(x,y,'linearinterp');
f=@(var) f(mod(var,x(end)-x(1)+eps)+x(1));
f=@(var) f(var-x(1));
end


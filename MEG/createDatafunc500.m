function [func] = createDatafunc500(x,y)
%Create a (x(end)-x(1))-periodic function based on x,y arrays
%Working fine on VdP but not on MEG
f=fit(double(x),double(y),'linearinterp');
func=@(var) f(mod(var,x(end)-x(1)+eps)+x(1));
func=@(var) f(var-x(1));
end


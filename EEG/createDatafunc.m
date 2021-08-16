function [func] = createDatafunc(v,per)
%Create a function based on a spike represented in v to add in the database
%The function will be per-periodic
%f=fit([-1/(length(v)-1) 0:1/(length(v)-1):1 1+1/(length(v)-1)]',1/max(abs(v))*[v(1) v v(end)]','linearinterp');
f=fit(linspace(0,1,length(v))',double(v),'linearinterp');
%func=@(x) f(mod(x,per)-per/2);
%func=@(x) f(x+per/2);
func=@(x) f(mod(x,per));
end


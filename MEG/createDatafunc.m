function [func] = createDatafunc(v,per)
%Create a function based on a spike represented in v to add in the database
%The function will be per-periodic
f=fit(linspace(0,1,length(v))',double(v),'linearinterp');

func=@(x) f(mod(x,per));
end


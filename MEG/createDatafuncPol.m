function [func] = createDatafuncPol(v)
%Create polynomial function fitted on v
f=poly2sym(polyfit(0:1/(length(v)-1):1,1/max(abs(v))*v,length(v)-1));
disp(f);
func=matlabFunction(f);
end


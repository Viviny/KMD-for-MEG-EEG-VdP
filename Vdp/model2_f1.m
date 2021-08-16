function xout = model2_f1(x,y,p)

% delta is the parameter
delta=p(4);
xout=y-27/(4*delta^3)*x^2*(x+delta);

end


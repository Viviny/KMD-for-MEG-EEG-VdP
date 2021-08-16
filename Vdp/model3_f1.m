function xout = model3_f1(x,y,p)

% delta is the parameter
delta=p(4);
if(x>=0)
    xout=y-x;
elseif(x<0 && x>1-delta)
    xout=y-1/(1-delta)*x;
else
    xout=y-(x+delta);
end

end


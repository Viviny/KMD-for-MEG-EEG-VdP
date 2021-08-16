function xout = model2_f2(x,y)

xout=eye(length(x));

if(x>0 && x<0.2 && rand<0.3)
    xout=40*(2*rand-1);
end


end


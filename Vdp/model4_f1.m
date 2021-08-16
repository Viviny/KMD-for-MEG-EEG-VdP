function xout = model4_f1(x,y,p)

% delta is external input parameter
delta=p(4);

% Morris Lecar parameters (Izhikevich IJBC paper)
V1=-0.01; V2=0.15; V3=delta; V4=0.05; 
El=-0.5; Ek=-0.7; ECa=1.0; 
gl=0.5; gk=2.0; gCa=1.2;

minf=0.5*(1+tanh((x(1)-V1)/V2));
winf=0.5*(1+tanh((x(1)-V3)/V4));
lambda=1/3*(cosh((x(1)-V3)/2*V4));

xout=zeros(2,1);

xout(1) = -y-gl*(x(1)-El)-gk*x(2)*(x(1)-Ek)-gCa*minf*(x(1)-ECa);
xout(2) = lambda*(winf-x(2));

end


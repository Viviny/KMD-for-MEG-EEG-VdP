function dx= eq_SF(t,x)
% slow-fast NMM. 14/03/2019-Dr Amirhossein Jafarian
% model parameters
m =200;   
c = 250;c1=c;c2=.8*c;c3=.25*c;c4=.25*c; 
A= 3.25; 
AA= 3.20 ;
B= 20 ;
b  = 50;
a  = 110 ;
aa = 110 ;
%
dx = zeros(9,1);
% fast states
dx(1) =  x(4);
dx(2) =  x(5);
dx(3) =  x(6);
dx(4) =  A*a*sigmoid_function(x(2)-x(3),x(7))-2*a*x(4)-(a.^2)*x(1);
dx(5) =  AA*aa*(m+c2*sigmoid_function(c1*x(1),x(8)))-2*aa*x(5)-(aa^2)*x(2)+5*randn/sqrt(.01);
dx(6)=   B*b*c4*sigmoid_function(c3*x(1),x(9))-2*b*x(6)-(b^2)*x(3);
% slow  states 
epsilon = 1; % with ep>1 you see more swiches whereas ep<1 otherwise.
dx(7) = epsilon*(0.02*(-x(7))+ 0.182*sigmoid_function(x(2)-x(3),x(7)))+1*randn/sqrt(.01); 
dx(8) = epsilon*(0.03*(-x(8))+ 0.182*sigmoid_function(c1*x(1),x(8)))+1*randn/sqrt(.01);
dx(9) = epsilon*(0.02*(-x(9))+ 0.172*sigmoid_function(c3*x(1),x(9)))+1*randn/sqrt(.01);

end


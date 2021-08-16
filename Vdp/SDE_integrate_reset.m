function [res_x,res_y,res_t] = SDE_integrate_reset(f1,f2,g1,g2,p,alg_p,Xzero,Yzero)

% Euler-Maruyama method, solves different types of SDEs of general form
% + HYBRID Style resets [version of normal SDE_integrate]
%
% SDE is  dx = 1/epsilon*f1(x,y,delta) dt + 1/sqrt(epsilon)*sigma_1*f2(x,y) dW_1,   
%         dy = g1(x,y) dt                 + sigma_2*g2(x,y) dW_2
%   
% with initial condition z0=(x(0),y(0)) so first column x0 second y0.

% Discretized Brownian path over [0,T] uses timestep 4*dt with dt=T/N and
% total number of steps N/R.
%
% p=[sigma1,sigma2,epsilon, +additional parameters]
% alg_p=[T N]

% make a few nicer names
sigma1=p(1); sigma2=p(2); epsilon=p(3); delta=p(4);

T=alg_p(1); N=alg_p(2); dt = T/N;

% we can put the random number generator into a fixed state if necessary
%randn('state',200)
        
dW1 = sqrt(dt)*randn(length(Xzero),N);         % Brownian increments for x 
dW2 = sqrt(dt)*randn(length(Yzero),N);         % Brownian increments for y

R = 4; Dt = R*dt; L = N/R;        % L EM steps of size Dt = R*dt

Xem = zeros(length(Xzero),L);
Yem = zeros(length(Yzero),L);     % preallocate results vectors

Xtemp = Xzero; Ytemp = Yzero;
% main Euler step
for j = 1:L
   Winc1 = sum(dW1(:,R*(j-1)+1:R*j),2);
   Winc2 = sum(dW2(:,R*(j-1)+1:R*j),2);
   if(Xtemp>-delta)
       Xtemp = Xtemp + Dt/epsilon*feval(f1,Xtemp,Ytemp,p) + sigma1/sqrt(epsilon)*feval(f2,Xtemp,Ytemp)*Winc1;
       Ytemp = Ytemp + Dt*feval(g1,Xtemp,Ytemp,p)         + sigma2*feval(g2,Xtemp,Ytemp)*Winc2;
   else
       %rn = rand+0.5; % random number reset between 0.5 and 1.5
       %deterministic reset, just set it equal to 1
       rn = 1;
       Xtemp = rn;
       Ytemp = rn^2;
   end
   Xem(:,j) = Xtemp;
   Yem(:,j) = Ytemp;
end

% format results for output
res_x=[Xzero,Xem]; res_y=[Xzero,Xem]; res_t=[0 linspace(Dt,T,N/R)];

% visual check in phase space - if necessary
% plot([Xzero,Xem],[Yzero,Yem],'k'), hold on

end


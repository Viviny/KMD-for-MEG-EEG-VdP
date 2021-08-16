% Simulation of a Slow-Fast neural mass model- 
% 14/03/20219- Dr. Amirhossein Jafarian  
close all
format long g
tic;

Y0_SF = [  0.145283949860409
          22.7971804500111
          14.8752150509589
        -0.557232247111013
           36.909705362522
          352.840448612509
          6 
          6
          6];

duration = 500; 
tspan = [0 duration];
tspan=linspace(0,duration,100000);
[T,Y] = ode45(@eq_SF, tspan, Y0_SF);
EEG = Y(:,2)- Y(:,3);

figure
subplot(2,1,1);
plot(T,EEG,'k')
ylabel('EEG')
box off
axis tight
subplot(2,1,2);
plot( T, Y(:,7),T,Y(:,8),T,Y(:,9)) 
ylabel('Slow-states')
toc;
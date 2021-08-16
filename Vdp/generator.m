% script to generate time series for various parameter values

% MODEL SELECTION:
% There are four models:
% -> set model='lif' : stochastic fold normal form with reset (quadratic
% leaky-integrate and fire model
% -> set model='vdP' : a van der Pol type oscillator 
% -> set model='pwl' : a piecewise-linear vdP-type model
% [-> set model='MoLe': a more complicated bursting Morris-Lecar model]
%%% last model maybe too complicated yet for our purposes, do not use yet

model = 'vdP';
model = 'lif';

% JUMP HEIGHT:
% The size of the spike can be controlled in the first three models
% explicitly, a single parameter controls this
% -> set delta > 0

delta = 1;

% NOISE LEVEL and DRIFT SPEED:
% The size of the noise can be controlled as well as the time scale
% separation, which controls, how quickly we slide towards the next event
% -> set sigma1  >0  [fast variable noise level]
% -> set sigma2  >0  [slow variable noise level]
% -> set epsilon >0  [time scale separation]

sigma1=0.1;
sigma2=0.1;
epsilon=0.01;

% ALGORITHMIC PARAMETERS:
% The length of the time series and the time discretization can be adjusted
% NOTE: If the time discretization is too small, then the scheme may be
% unstable, still works if step is small enough but at some point one could
% think of implementing a better scheme (e.h. Milstein, RK, etc)
% -> set T >0  [final time]
% -> set h >0  [number of interval subdivisions of (0,T)]

T=10;
h=4*2^(22);

h=4*2^13;

% INITIAL CONDITION:
% NOTE: The initial condition should not matter after a short time, however
% this can easily be dealt with in data processing by cutting the time
% series accordingly
% -> set x0 \in \R  [fast variable initial condition]
% -> set y0 \in \R  [slow variable initial condition]

x0=1;
y0=1;

%%% Main integration starts here
if model == 'lif'
    [res_x,res_y,res_t]=SDE_integrate_reset(@model1_f1,@model1_f2,...
    @model1_g1,@model1_g2,[sigma1,sigma2,epsilon,delta],[T,h],x0,y0);
elseif model == 'vdP'
    [res_x,res_y,res_t]=SDE_integrate(@model2_f1,@model1_f2,...
    @model2_g1,@model1_g2,[sigma1,sigma2,epsilon,delta],[T,h],x0,y0);
elseif model == 'pwl'
    [res_x,res_y,res_t]=SDE_integrate(@model3_f1,@model1_f2,...
    @model3_g1,@model1_g2,[sigma1,sigma2,epsilon,delta],[T,h],x0,y0);
elseif model == 'MoLe'
% currently not fully implemented
end

% plotting only for test purposes only, uncomment next two lines to see the
% time series for the fast variable, which has the big jumps
figure(2); clf
plot(res_t,res_x);
    
res=[res_t' res_x'];
    
% save the outputfile, only label main parameters that change the dynamics 
save(['run_model_' model '_delta_' num2str(delta) '_epsilon_' num2str(epsilon) ...
    '_sigma1_' num2str(sigma1) '_sigma2_' num2str(sigma2)...
    '_T_' num2str(T)],'res','-ascii')
tic;

v=data_down20hz(l,513-100+96:513-100+103);
v=data_down20hz(230,513-100+96:513-100+103);
%v=data_down20hz(l,1285:1285+7);
%v=data(l,12832-200+143:12832-200+231);
v=data_down15hz(250,385-50+51:385-50+56);
v=data_down15hz(250,387:390);
v=v/max(abs(v));
time_mesh=linspace(0,1,length(v))';
%theta_mesh=linspace(-3/7,3/7,7)'; %Same size as the mesh of time ?

%database={functest_500lin};
database={spike};

E_thresh=0.9; %The threshold in percent for estimating if there is a spike

alpha=25;
sigma=1e-2;

K_datab={};
Ktot=zeros(length(time_mesh),length(time_mesh));

for i=1:length(database)
    f=database{i}; %Database is a cell array
    tau=0; %Might be changed if we do a loop over the time, can be implied by f in the database
    omega=1; %We can put 1 if omega is implied by f in the database
    K_f=zeros(length(time_mesh),length(time_mesh));
    %for tau_ind=1:length(time_mesh)
        %tau=time_mesh(tau_ind);
        K_f=K_f+nearestSPD(createKernel(time_mesh,tau,omega,theta_mesh,alpha,f));
    %end
    K_datab{i}=K_f;
    Ktot=Ktot+K_f;
end

K_datab{length(database)+1}=createNoisekernel(time_mesh,sigma);
Ktot=Ktot+K_datab{length(database)+1};
%[V,D]=eig(K_datab{4};
%M_new=V*max(0,D)/V;
%K_datab{4}=M_new;

Emode=0;
f=Ktot\(v');

% for i=1:length(database)
%      Emode=Emode+compute_E(K_datab{i},f);
% end

Emode=compute_E(Ktot-K_datab{end},f,length(f)); 

Etot=Emode+compute_E(K_datab{end},f,length(f));

disp(Emode);
disp(compute_E(K_datab{end},f));
disp(Emode/Etot);

if Emode/Etot>=E_thresh
    disp("yay");
end

toc;
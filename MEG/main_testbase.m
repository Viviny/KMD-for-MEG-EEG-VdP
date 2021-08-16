tic;

%signal=repelem(1,10000);
%signal=cos(2*pi*time_mesh)+2/pi*sin(2*pi/6*time_mesh).*exp(time_mesh)+log(1+time_mesh);
v=repelem(1,8193);
time_mesh=linspace(0,1,length(v))';
%time_mesh=res_t(1162:4067)';
%theta_mesh=linspace(0,1,length(v))'; %Same size as the mesh of time ?
theta_mesh=linspace(-(res_t(4362)-res_t(1168))/2,(res_t(4362)-res_t(1168))/2,length(v))'; %Same size as the mesh of time ?
%theta_mesh=0;
%signal=cos(2*pi*time_mesh)+2/pi*sin(2*pi/6*time_mesh).*exp(time_mesh)+log(1+time_mesh);
%signal=2/pi*sin(2*pi/6*time_mesh).*exp(time_mesh)+log(1+time_mesh);
%signal=zeros(length(v),1);
%signal(1:50)=cos(time_mesh(1:50));
%signal(51:end)=cos(time_mesh(51));
%signal(1:66)=cos(time_mesh(1:66));
%signal(67:end)=cos(time_mesh(67));
%signal=cos(time_mesh+theta_mesh);
%signal=cos(time_mesh+5);
%signal=exp(time_mesh);
database={func};

v=signal; %The signal to decompose
E_thresh=0.9; %The threshold in percent for estimating if there is a spike

alpha=25;
sigma=1e-2;

K_datab={};
Ktot=zeros(length(time_mesh),length(time_mesh),'double');

for i=1:length(database)
    f=database{i}; %Database is a cell array
    tau=0; %Might be changed if we do a loop over the time, can be implied by f in the database
    omega=1; %We can put 1 if omega is implied by f in the database
    K_f=zeros(length(time_mesh),length(time_mesh),'double');
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
f=Ktot\(v);

% for i=1:length(database)
%      Emode=Emode+compute_E(K_datab{i},f);
% end

Emode=compute_E(Ktot-K_datab{end},f,length(f)); 

Etot=Emode+compute_E(K_datab{end},f,length(f));

disp(Emode);
disp(compute_E(K_datab{end},f,length(f)));
disp(Emode/Etot);

if Emode/Etot>=E_thresh
    disp("yay");
end

toc;
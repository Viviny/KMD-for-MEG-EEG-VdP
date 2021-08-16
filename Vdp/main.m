clear func Ktot K_datab f
tic;
begin=3569;
en=4480;
trueSPD=false; %If we want numerically SPD matrix (no floating error)
morePrecision=false; %To upgrade precision with a greater mesh over theta

signal=res_x';
func=createDatafunc(res_t(begin:en)',res_x(begin:en)');

%Create time and theta_mesh
time_mesh=linspace(0,1,length(signal))';
if morePrecision
    theta_mesh=linspace(-(res_t(en)-res_t(begin))/2,(res_t(en)-res_t(begin))/2,length(signal))';
else
    theta_mesh=linspace(-(res_t(en)-res_t(begin))/2,(res_t(en)-res_t(begin))/2,en-begin+1)';
end


database={func}; %We can add more functions to the database so as to recover other patterns too

alpha=25;
sigma=1e-2;

K_datab={};
Ktot=zeros(length(time_mesh),length(time_mesh),'double');

for i=1:length(database)
    f=database{i}; %Database is a cell array
    tau=0; %Center of f wavelet (default : 0)
    omega=1; %Frequency in f (default : 1)
    if trueSPD
        K_f=nearestSPD(createKernel(time_mesh,tau,omega,theta_mesh,alpha,f));
    else
        K_f=createKernel(time_mesh,tau,omega,theta_mesh,alpha,f);
    end
    K_datab{i}=K_f;
    Ktot=Ktot+K_f;
end
K_datab{length(database)+1}=createNoisekernel(time_mesh,sigma);
Ktot=Ktot+K_datab{length(database)+1};

Emode=0;
f=Ktot\signal;

Emode=compute_E(Ktot-K_datab{end},f); 

Etot=Emode+compute_E(K_datab{end},f);

disp(Emode);
disp(Etot);
disp(Emode/Etot);

%True signal and reconstructed signal
plot(res_t,signal,res_t,(Ktot-K_datab{end})*f);
legend('Signal','Reconstruction');
title('Reconstruction of signal with KMD based on an oscillation')

toc;
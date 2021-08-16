%The motif here is the length of agitation in the signal

tic;
ind_spike=cell(size(EEGtot,1),2);%First value is the index of the spike, second one is its ratio value Emode/Etot

E_thresh=0.6; %The threshold in percent for estimating if there is a spike

%Parameters for KMD
alpha=25;
tau=0;
omega=1;
theta_mesh=0;

%Find the smallest spike
lengthSpikes=zeros(size(SpikesLocation,1),1);
for i=1:length(lengthSpikes)
    lengthSpikes(i)=SpikesLocation{i,4}-SpikesLocation{i,3}+1;
end
minLen=min(lengthSpikes);

%Downscale the data so that the spikes aren't too big
downscale=1;
while minLen/downscale >300
    downscale=downscale+1;
end
data_down=downsample(EEGtot',downscale)';
func_datab=createDatabase(SpikesLocation,data_down,downscale,round(minLen/downscale));

%Everything will be of the size of the smallest spike in the downscaled
%data
time_mesh=linspace(0,1,round(minLen/downscale))';

%Create kernels
Kmode=zeros(round(minLen/downscale),round(minLen/downscale));
for i=1:size(func_datab,1)
    Kmode=Kmode+nearestSPD(createKernel(time_mesh,tau,omega,theta_mesh,alpha,func_datab{i,1}));
end

%Found empirically
sigma=0.5*max(max(Kmode));

Ktot=Kmode+createNoisekernel(time_mesh,sigma);

n=size(data_down,2)-round(minLen/downscale);

dist=1:40; %Simulations we want to apply KMD on

for i=1:length(dist)
    signal_ind=dist(i);
    arr=data_down(signal_ind,:);
    toc;
    k=1;
    while k<=n
        v=arr(k:k+round(minLen/downscale)-1)';
        v=v/max(abs(v));
        f=Ktot\v;
        Emode=compute_E(Kmode,f); 
        Etot=compute_E(Ktot,f);
        if Emode>=E_thresh*Etot
            ind_spike{i,1}=[ind_spike{signal_ind,1} k];
            ind_spike{i,2}=[ind_spike{signal_ind,2} Emode/Etot];
            %Skip this size since if there is one in between, it's part of
            %the same spike
            k=k+round(minLen/downscale);
        else
            k=k+1;
        end
            
    end
end





toc;
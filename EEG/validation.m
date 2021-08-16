tic;
ind_spike_val=cell(size(EEGtot,1),2); %First value is the index of the spike, second one the value Emode/Etot

E_thresh=0.4; %The threshold in percent for estimating if there is a spike
%Set to 0.1 to be sorted after
%Can be set at the threshold used at 125hz

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

%Find the downscale factor used before
downscale=1;
while minLen/downscale >300
    downscale=downscale+1;
end

%Get the functions
func_datab=createDatabase(SpikesLocation,EEGtot,1,minLen);

%Everything will be of the size of the smallest spike in the downscaled
%data
time_mesh=linspace(0,1,minLen)';

Kmode=zeros(minLen,minLen);
for i=1:size(func_datab,1)
    Kmode=Kmode+nearestSPD(createKernel(time_mesh,tau,omega,theta_mesh,alpha,func_datab{i,1}));
end

%Found empirically
sigma=0.1*max(max(Kmode));

Ktot=Kmode+createNoisekernel(time_mesh,sigma);

n=size(EEGtot,2)-minLen;

dist=1:40; %Simulations we want to apply KMD on

%Number of indices around each index to check
interind=downscale*2+1;

for i=1:length(dist)
    toc;
    %Get the corresponding data
    signal_ind=dist(i);
    arr=EEGtot(signal_ind,:);
    
    %Enlarge the data to fill the holes around the previous indices
    listind=ones(interind*length(ind_spike{signal_ind,1}),1,'single');
    for j=1:length(ind_spike{i,1})
        for inc=1:interind
            val=ind_spike{i,1}(j)*downscale+inc-((interind+1)/2);
            if val==0
                listind((j-1)*interind+inc)=1;
            elseif val+minLen-1<=length(arr)
                listind((j-1)*interind+inc)=val;
            else
                listind((j-1)*interind+inc)=listind(1);
            end
        end
    end
    
    %Remove duplicates
    listind=unique(listind);
    
    %Apply KMD
    n=length(listind);

    for k=1:n
        flag=false;

        v=arr(listind(k):listind(k)+minLen-1)';
        %Normalize v
        v=v/max(abs(v));
        f=Ktot\(v);
        %Get the energies
        Emode=compute_E(Kmode,f); 
        Etot=compute_E(Ktot,f);
        %Search for max
        if Emode>=E_thresh*Etot
            ind_spike_val{signal_ind,1}=[ind_spike_val{signal_ind,1} listind(k)];
            ind_spike_val{signal_ind,2}=[ind_spike_val{signal_ind,2} Emode/Etot];
        end
    end
end



toc;
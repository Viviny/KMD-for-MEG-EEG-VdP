tic;
ind_spike_val=cell(size(data,1),3); %First value is the index of the spike, second one is the length of the kernel that produced the greatest ratio value Emode/Etot, third is this value

E_thresh=0.1; %The threshold in percent for estimating if there is a spike
%Set to 0.1 to be sorted after
%Can be set at the threshold used at 125hz

%Parameters for KMD
alpha=25;
tau=0;
omega=1;
theta_mesh=0;

%Get the functions at 500Hz
func_datab=createDatabase(SpikesLocation,data,1);

%Sort the functions according to their time window length
[sortedfunc,ind,valmax]=getLengthTime(func_datab);


K_datab=cell(length(ind)+1,2); %K_datab{x,1}=full kernel; K_datab{x,2}= mode kernel (full kernel minus noise kernel)


%ind will be empty if all of the time windows have the same length
indempty=isempty(ind);
sup=0;
for i=1:length(ind)+1
    inf=sup+1;
    
    %Create time_mesh of according size
    if i<=length(ind)
        time_mesh=linspace(0,1,sortedfunc{ind(i),2})';
        sup=ind(i);
    else
        if indempty
            time_mesh=linspace(0,1,sortedfunc{1,2})';
        else
            time_mesh=linspace(0,1,sortedfunc{ind(i-1)+1,2})';
        end
        sup=size(sortedfunc,1);
    end
    
    %Create kernels of the same size and create a mama kernel for this size
    K_datab{i,1}=zeros(length(time_mesh),length(time_mesh));
    for k=inf:sup
        K_datab{i,1}=K_datab{i,1}+nearestSPD(createKernel(time_mesh,tau,omega,theta_mesh,alpha,sortedfunc{k,1}));
    end
    
    %Mode kernel for this size
    K_datab{i,2}=K_datab{i,1};
    
    %Sigma found empirically
    sigma=1.3*max(max(K_datab{i,2}));
    
    %Full kernel for this size
    K_datab{i,1}=K_datab{i,1}+createNoisekernel(time_mesh,sigma);
end

%Sort the found spikes at 125hz by how many there are per sensor
[lensens,ordersens]=sort(cellfun(@length,ind_spike),'descend');
indsens=cell(length(lensens(lensens(:,1)>0)),1);
indsens{1}=ind_spike{ordersens(1,1),1};

%%%Discard the duplicates within each sensor line and between sensors

%Apply uniquetol with a tolerance of 4, can be higher
tol=4;
%I used 4 since it equals the min length of the functions at 125hz /4
%According to some papers the max epileptic seizures/min is 70 so tolerance
%can be increased up to 107 without consequences
alrdone=uniquetol(indsens{1},tol,'DataScale',1);

for i=2:size(indsens,1)
    indsens{i}=uniquetol(ind_spike{ordersens(i,1),1},tol,'DataScale',1);
    indsens{i}=indsens{i}(not(ismembertol(uniquetol(ind_spike{ordersens(i,1),1},tol,'DataScale',1),alrdone,tol,'DataScale',1)));
    alrdone=cat(2,alrdone,indsens{i});
end

%Number of indices around each index to check
interind=500/125*tol*2+1;

for sens=1:size(indsens,1)
    toc;
    %Get the corresponding data
    arr=data(ordersens(sens,1),:);
    
    %Enlarge the data to fill the holes around the previous indices
    listind=ones(interind*length(indsens{sens}),1,'single');
    for j=1:length(indsens{sens})
        for inc=1:interind
            val=indsens{sens}(j)*tol+inc-((interind+1)/2);
            if val==0
                listind((j-1)*interind+inc)=1;
            elseif val+valmax-1<=length(arr)
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
        %We want to find the maximum ratio we can have at the indices
        %validating the test
        maxE=0;
        for i=1:length(ind)
            %where is the index used to recover the size of the kernel
            if i<=length(ind)
                where=ind(i);
            else
                if indempty
                    where=1;
                else
                    where=ind(i-1)+1;
                end
            end
            v=arr(listind(k):listind(k)+sortedfunc{where,2}-1)';
            
            %Normalize v
            v=v/max(abs(v));
            f=K_datab{i,1}\(v);
            %Get the energies
            Emode=compute_E(K_datab{i,2},f,length(f)); 
            Etot=compute_E(K_datab{i,1},f,length(f));
            %Search for max
            if Emode>=maxE*Etot
                spilen=sortedfunc{where,2};
                maxE=Emode/Etot;
            end
        end
        if maxE>=E_thresh
            ind_spike_val{ordersens(sens,1),1}=[ind_spike_val{ordersens(sens,1),1} listind(k)];
            ind_spike_val{ordersens(sens,1),2}=[ind_spike_val{ordersens(sens,1),2} spilen];
            ind_spike_val{ordersens(sens,1),3}=[ind_spike_val{ordersens(sens,1),3} maxE];
        end
    end
end

toc;
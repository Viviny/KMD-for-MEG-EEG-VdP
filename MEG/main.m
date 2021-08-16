tic;
ind_spike=cell(size(data,1),2); %First value is the index of the spike, second one is its ratio value Emode/Etot

E_thresh=0.71; %The threshold in percent for estimating if there is a spike
%Empirically, 0.71 is good

%Parameters for KMD
alpha=25;
tau=0;
omega=1;
theta_mesh=0;

%Downscale the data to 125Hz and get the functions out of it
data_down125hz=downsample(data',4)';
func_datab=createDatabase(SpikesLocation,data_down125hz,4);

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


n=size(data_down125hz,2)-valmax;

dist=1:306; %Sensors we want to apply KMD on

for ind_sens=1:length(dist)
    %Get the index of the sensor and the corresponding data
    sens=dist(ind_sens);
    arr=data_down125hz(sens,:);
    
    toc;
    for k=1:n
        %Try with the long kernels first
        for i=length(ind)+1:-1:1
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
            v=arr(k:k+sortedfunc{where,2}-1)';
            
            %Normalize v
            v=v/max(abs(v));
            f=K_datab{i,1}\(v);      
            %Get the energies
            Emode=compute_E(K_datab{i,2},f,length(f)); 
            Etot=compute_E(K_datab{i,1},f,length(f));
            if Emode>=E_thresh*Etot
                ind_spike{sens,1}=[ind_spike{sens,1} k];
                ind_spike{sens,2}=[ind_spike{sens,2} Emode/Etot];
                
                %break so as to not try with the other kernels if it passed
                %the test, it can be removed if we want to find the best
                %ratio at indices validating the test
                break;
            end
            
        end
    end
end
toc;
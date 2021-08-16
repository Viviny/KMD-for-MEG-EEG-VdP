%Greatly faster method than main.m since we do a lot less mldivide operations
%Not working as of now but might be worth checking, the first part of the
%kernel is too permissive since it contains lot of mini-kernels
%It can be used on the full dataset at 500Hz
tic;
ind_spike=cell(size(data,1),2);

E_thresh=0.85; %The threshold in percent for estimating if there is a spike

%Parameters for KMD
alpha=25;
sigma=1e-2;
tau=0;
omega=1;

%Sort the functions according to their time window length
[sortedfunc,ind,valmax]=getLengthTime(func_datab);
theta_mesh=0;

%ind will be empty if all of the time windows have the same length
indempty=isempty(ind);

%Here we create only one big kernel, the functions whose time window is
%smaller will be used to create kernel enlarged by zeros
Kmode=zeros(valmax,valmax,'double');

%We still store the smaller kernels
K_datab=cell(length(ind)+1,1);
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
            time_mesh=linspace(0,1,sortedfunc{end,2})';
        end
        sup=size(sortedfunc,1);
    end
    
    K_datab{i}=zeros(length(time_mesh),length(time_mesh),'double');
    
    %Create kernels of the same size and create a mama kernel for this size
    for k=inf:sup
        fun=sortedfunc{k,1};
        temp=nearestSPD(createKernel(time_mesh,tau,omega,theta_mesh,alpha,fun));
        K_datab{i}=K_datab{i}+temp;
        
        %Enlarge it
        temp(end+1:valmax,end+1:valmax)=0;
        
        %Add to big kernel
        Kmode=Kmode+temp;
    end
end
%Sigma found empirically
sigma=max(max(Kmode));
Ktot=Kmode+createNoisekernel(time_mesh,sigma);



n=size(data,2)-valmax;
toc;

dist=1:306; %Sensors we want to apply KMD on

for ind_sens=1:length(dist)
    %Get the index of the sensor and the corresponding data
    sens=dist(ind_sens);
    arr=data(sens,:);
    
    toc;
    for k=1:n
        v=arr(k:k+valmax-1)';
        v=v/max(abs(v));
        f=Ktot\v;
        
        %We can escape from doing \ length(ind) times but we still need to
        %compute the ratio length(ind) times
        for i=1:length(ind)+1
            if i<=length(ind)
                where=ind(i);
            else
                if indempty
                    where=1;
                else
                    where=ind(i-1)+1;
                end
            end        
            
            %Get the energies
            Emode=compute_E(Kmode,f,sortedfunc{where,2}); 
            Etot=compute_E(Ktot,f,sortedfunc{where,2});
            if Emode>=E_thresh*Etot
                disp(k);
                ind_spike{sens}=[ind_spike{sens} k];
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
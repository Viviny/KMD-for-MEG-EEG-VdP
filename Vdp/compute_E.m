function [E]=compute_E(K,f)
    %See (4.37) of KMD paper
    E=f'*K*f;
end
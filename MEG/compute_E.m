function [E]=compute_E(K,f,last)
    %See (4.37) of KMD paper
    %last may be used if the second method can work
    E=(f(1:last).')*K(1:last,1:last)*f(1:last);
end
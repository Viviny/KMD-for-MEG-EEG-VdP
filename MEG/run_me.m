load('Data\EPI001_EPILEPSY_MEG_kt.mat');
load('Data\SpikesLocation.mat');
main;
validation;

%Might be worth checking evaluateresults for other methods on how to
%extract spikes from ind_spike_val
getSpikes;
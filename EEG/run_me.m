load('newdata.mat');
main;
validation;
spikes=cell(size(ind_spike_val));
for i=1:size(ind_spike_val,1)
    spikes{i,1}=uniqueTolMax(ind_spike_val{i,1},10,ind_spike_val{i,2});
    spikes{i,2}=ind_spike_val{i,2}(ismember(spikes{i,1},ind_spike_val{i,1}));
end
function [database] = createDatabase(spikes_table,data,factor,endsp)
%Create a database of spikes based on a table spikes_table created from an
%excel file, can downscale by a factor
%endsp is the length of the smallest spike
database=cell(size(spikes_table,1),1);
for i=1:size(spikes_table,1)
    %Better in low hertz
    %database{i,1}=createDatafuncPol(data(spikes_table{i,2},spikes_table{i,5}:spikes_table{i,6}));
    %Better in high hertz
    database{i,1}=createDatafunc(1/max(abs(data(spikes_table{i,2},max(round(spikes_table{i,3}/factor),1):max(round(spikes_table{i,3}/factor),1)+endsp-1)))*data(spikes_table{i,2},max(round(spikes_table{i,3}/factor),1):max(round(spikes_table{i,3}/factor),1)+endsp-1)',1+eps);
end
end


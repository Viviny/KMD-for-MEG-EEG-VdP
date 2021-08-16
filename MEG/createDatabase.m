function [database] = createDatabase(spikes_table,data,factor)
%Create a database of spikes based on a table spikes_table created from an
%excel file, can downscale by a factor
database=cell(size(spikes_table,1),2);
for i=1:size(spikes_table,1)
    %Better in low hertz
    %database{i,1}=createDatafuncPol(data(spikes_table{i,2},spikes_table{i,5}:spikes_table{i,6}));
    %Better in high hertz
    database{i,1}=createDatafunc(1/max(abs(data(spikes_table{i,2},round(spikes_table{i,3}/factor):round(spikes_table{i,4}/factor))))*data(spikes_table{i,2},round(spikes_table{i,3}/factor):round(spikes_table{i,4}/factor))',1+eps);
    database{i,2}=round(spikes_table{i,4}/factor)-round(spikes_table{i,3}/factor)+1;
end
end


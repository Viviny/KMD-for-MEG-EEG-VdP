function [sorted, ind, max] = getLengthTime(func_datab)
%Return ind with func_datab a cellarray where func_datab{i,1}=func and 
%func_datab{i,2}=size of time window
%Ind is an array with the last index of each consequent time window length
%max is the max length of time windows
%sorted is the sorted func_datab according to time window lengths
sorted=sortrows(func_datab,2);
lengthtime=cell2mat(sorted(1:end,2));
dif=diff(lengthtime);
ind=find(dif>=1);
val=lengthtime(ind);
max=lengthtime(end);

end


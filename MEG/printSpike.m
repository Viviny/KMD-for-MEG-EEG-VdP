function [] = printSpike(n,events,data,data_down,freq)
%Print the data from the sensor where the n-th spike is maximum
%Plot the data at those index at freqhz
%events.samples(n) is the index of the n-th spike
spike=events.samples(n);
[m,l]=max(data(:,spike));

%Print sensor index and 
disp(l);
center=round(spike/round(500/freq));

%Print beginning index of the plot
disp(center-500/freq);

%Plot the spike
plot(0:1000,data_down(l,center-500/freq:center+500/freq));
end


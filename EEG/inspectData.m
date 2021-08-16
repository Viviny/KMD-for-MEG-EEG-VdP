%Used to inspect the data and create the excel file with the correct spikes
%indices

for i=1:40
    close all
    subplot(2,1,1);
    plot(Ttot(i,:),EEGtot(i,:),'k')
    ylabel('EEG')
    box off
    axis tight
    subplot(2,1,2);
    plot( Ttot(i,:), Y1(i,:),Ttot(i,:),Y2(i,:),Ttot(i,:),Y3(i,:)) 
    ylabel('Slow-states')
    figure;
    plot3(Ttot(i,:),EEGtot(i,:),1:100000);
    view(0,90);
    pause;
end
%Used to create the datax.mat

for i=36:40
    run_me;
    EEGtot(i,:)=EEG';
    Ttot(i,:)=T';
    Y1(i,:)=Y(:,7)';
    Y2(i,:)=Y(:,8)';
    Y3(i,:)=Y(:,9)';
end
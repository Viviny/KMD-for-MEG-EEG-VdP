%ind_spike has the indices of spike at 125hz
%ind_spike_val is for 500hz
%%%% FOR THE TOLERANCES %%%%

%According to some papers the max epileptic seizures/min is 70 so tolerance
%can be increased up to hz*60/70 without consequences

l=0;
alrdone=[];

%Number of spikes found without duplicates within a tolearance
for i=1:size(data,1)
    l=l+length(uniquetol(ind_spike{i,1},4,'DataScale',1));
    alrdone= [alrdone ind_spike{i,1}];
end
disp(l);

%True spikes given by the data, per sensors in "in" and unordered in
%"truespikes"
truespikes=zeros(size(SpikesLocation,1),1);
for i=1:size(func_datab,1)
    truespikes(i)=SpikesLocation{i,5};
end
in=cell(size(data,1),1);
for i=1:size(SpikesLocation,1)
    in{SpikesLocation{i,2}}=[in{SpikesLocation{i,2}} SpikesLocation{i,5}];
end

%Number of exact spikes in the 250th sensor line
l=0;
for i=1:size(data,1)
    l=l+length(intersect(in{i},ind_spike{250,1}));
end
disp(l);

%Number of spikes within a tol of 4 in the 250th sensor line
nb_pm=0;
for j=1:size(data,1)
    nb_pm=nb_pm+length(in{j}(ismembertol(in{j},ind_spike{250,1},4,'DataScale',1)));
end
disp(nb_pm);

%Number of exact spikes with corresponding sensor line 
l=0;
for i=1:size(data,1)
    l=l+length(intersect(in{i},ind_spike{i,1}));
end
disp(l);

%Number of spikes with corresponding sensor line within tolerance of 1 2 4
nb_pm=0;
for j=1:size(data,1)
    nb_pm=nb_pm+length(in{j}(ismembertol(in{j},ind_spike{j,1},1,'DataScale',1)));
end
disp(nb_pm);
nb_pm=0;
for j=1:size(data,1)
    nb_pm=nb_pm+length(in{j}(ismembertol(in{j},ind_spike{j,1},2,'DataScale',1)));
end
disp(nb_pm);

nb_pm=0;
for j=1:size(data,1)
    nb_pm=nb_pm+length(in{j}(ismembertol(in{j},ind_spike{j,1},4,'DataScale',1)));
end
disp(nb_pm);

%Number of spikes with corresponding sensor line within tolerance of 4
%after removing duplicates from ind_spike lines with a tolerance of 4

nb_pm=0;
for j=1:size(data,1)
    nb_pm=nb_pm+length(in{j}(ismembertol(in{j},uniquetol(ind_spike{j,1},4,'DataScale',1),4,'DataScale',1)));
end
disp(nb_pm);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%True spikes given by the data, unordered
truespikes=zeros(size(SpikesLocation,1),1);
for i=1:size(SpikesLocation,1)
    truespikes(i)=SpikesLocation{i,5};
end

%Number of all spikes found (there may be duplicates)
alrdone1=[];
for i=1:size(data,1)
    alrdone1=[alrdone1 ind_spike{i,1}];
end
disp(length(alrdone1));

%Number of all spikes found, each line has been applied a tolerance
%around each value
alrdone2=[];
for i=1:size(data,1)
    alrdone2=[alrdone2 uniquetol(ind_spike{i,1},4,'DataScale',1)];
end
disp(length(alrdone2));

%Number of all spikes found, duplicates have been removed with a tolerance
%between sensor lines 
[lensens,ordersens]=sort(cellfun(@length,ind_spike),'descend');
indsens=cell(length(lensens(lensens(:,1)>0)),1);
indsens{1}=ind_spike{ordersens(1,1),1};

alrdone3=indsens{1};

for i=2:size(indsens,1)
    indsens{i}=ind_spike{ordersens(i,1),1};
    indsens{i}=indsens{i}(not(ismembertol(ind_spike{ordersens(i,1),1},alrdone3,4,'DataScale',1)));
    alrdone3=cat(2,alrdone3,indsens{i});
end
disp(length(alrdone3));


%Number of all spikes found, each line has been applied a tolerance
%around each value and duplicates have been removed with a tolerance
%between sensor lines too

[lensens,ordersens]=sort(cellfun(@length,ind_spike),'descend');
indsens=cell(length(lensens(lensens(:,1)>0)),1);
indsens{1}=ind_spike{ordersens(1,1),1};

alrdone4=uniquetol(indsens{1},100,'DataScale',1);


for i=2:size(indsens,1)
    indsens{i}=uniquetol(ind_spike{ordersens(i,1),1},100,'DataScale',1);
    indsens{i}=indsens{i}(not(ismembertol(uniquetol(ind_spike{ordersens(i,1),1},100,'DataScale',1),alrdone4,100,'DataScale',1)));
    alrdone4=cat(2,alrdone4,indsens{i});
end

disp(length(alrdone4));

%Number of spikes in alrdone1 that are true spikes within a tolerance
arrm=truespikes(ismembertol(truespikes,alrdone1,4,'DataScale',1));
disp(length(arrm));

%Number of spikes in alrdone4 that are true spikes within a tolerance
arrm=truespikes(ismembertol(truespikes,alrdone4,50,'DataScale',1));
disp(length(arrm));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Sort ind_spike_val to only take the spikes with a ratio value above a
%certain threshold
ind_spike_val=cell(size(data,1),3);
for i=1:size(data,1)
    for j=1:3
        ind_spike_val{i,j}=ind_spike_val_full01{i,j}(ind_spike_val_full01{i,3}>=0.71);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%True spikes given by the data in 500hz, unordered
truespikes500=zeros(size(SpikesLocation,1),1);
for i=1:size(SpikesLocation,1)
    truespikes500(i)=SpikesLocation{i,3};
end

%Number of all spikes found (there may be duplicates)
alrdone1=[];
for i=1:size(data,1)
    alrdone1=[alrdone1 ind_spike_val{i,1}];
end
disp(length(alrdone1));

%Number of all spikes found, each line has been applied a tolerance
%around each value
alrdone2=[];
for i=1:size(data,1)
    alrdone2=[alrdone2 uniquetol(ind_spike_val{i,1},16,'DataScale',1)];
end
disp(length(alrdone2));


%Number of all spikes found, duplicates have been removed with a tolerance
%between sensor lines 
[lensens,ordersens]=sort(cellfun(@length,ind_spike_val),'descend');
indsens=cell(length(lensens(lensens(:,1)>0)),1);
indsens{1}=ind_spike_val{ordersens(1,1),1};

alrdone3=indsens{1};

for i=2:size(indsens,1)
    indsens{i}=ind_spike_val{ordersens(i,1),1};
    indsens{i}=indsens{i}(not(ismembertol(ind_spike_val{ordersens(i,1),1},alrdone3,16,'DataScale',1)));
    alrdone3=cat(2,alrdone3,indsens{i});
end
disp(length(alrdone3));

%Number of all spikes found, each line has been applied a tolerance
%around each value and duplicates have been removed with a tolerance
%between sensor lines too
[lensens,ordersens]=sort(cellfun(@length,ind_spike_val),'descend');
indsens=cell(length(lensens(lensens(:,1)>0)),1);
indsens{1}=uniquetol(ind_spike_val{ordersens(1,1),1},380,'DataScale',1);

%uniqueTolMax acts like uniqueTol but keep the index with the highest corresponding ratio value, gives worse results
% indsens{1}=uniqueTolMax(ind_spike_val{ordersens(1,1),1},380,ind_spike_val{ordersens(1,1),3});


alrdone4=indsens{1};
endone4=ind_spike_val{ordersens(1,1),3}(ismember(ind_spike_val{ordersens(1,1),1},indsens{1}));
for i=2:size(indsens,1)
    indsens{i}=uniquetol(ind_spike_val{ordersens(i,1),1},400,'DataScale',1);
    indsens{i}=indsens{i}(not(ismembertol(uniquetol(ind_spike_val{ordersens(i,1),1},400,'DataScale',1),alrdone4,400,'DataScale',1)));
%     indsens{i}=indsens{i}(not(ismembertol(uniqueTolMax(ind_spike_val{ordersens(i,1),1},380,ind_spike_val{ordersens(i,1),3}),alrdone4,380,'DataScale',1)));
    endone4=cat(2,endone4,ind_spike_val{ordersens(i,1),3}(ismember(ind_spike_val{ordersens(i,1),1},indsens{i})));
    alrdone4=cat(2,alrdone4,indsens{i});
end
disp(length(alrdone4));

%Gives worse results, same than above but keep the max value of ratios
%across each line and between lines
%[alrdone4,indsens] = whichIndex(ind_spike_val, lensens, ordersens,tol)

%Number of spikes in alrdone1 that are true spikes within a tolerance
arrm=truespikes500(ismembertol(truespikes500,alrdone1,16,'DataScale',1));
disp(length(arrm));

%Number of spikes in alrdone4 that are true spikes within a tolerance
arrm=truespikes500(ismembertol(truespikes500,alrdone4,200,'DataScale',1));
disp(length(arrm));









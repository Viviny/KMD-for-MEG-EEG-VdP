%Check evaluateresults, gives the smallest arrays to analyze with the best
%results

[lensens,ordersens]=sort(cellfun(@length,ind_spike_val),'descend');
indsens=cell(length(lensens(lensens(:,1)>0)),1);
indsens{1}=uniquetol(ind_spike_val{ordersens(1,1),1},400,'DataScale',1);


alrdone=indsens{1};
endone4=ind_spike_val{ordersens(1,1),3}(ismember(ind_spike_val{ordersens(1,1),1},indsens{1}));
for i=2:size(indsens,1)
    indsens{i}=uniquetol(ind_spike_val{ordersens(i,1),1},400,'DataScale',1);
    indsens{i}=indsens{i}(not(ismembertol(uniquetol(ind_spike_val{ordersens(i,1),1},380,'DataScale',1),alrdone,400,'DataScale',1)));
    endone4=cat(2,endone4,ind_spike_val{ordersens(i,1),3}(ismember(ind_spike_val{ordersens(i,1),1},indsens{i})));
    alrdone=cat(2,alrdone,indsens{i});
end
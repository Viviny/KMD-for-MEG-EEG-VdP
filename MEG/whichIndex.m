function [alrdone,indsens] = whichIndex(ind_spike_val, lensens, ordersens,tol)
%Same as doing uniquetol and ismembertol (see evaluateresults) with tol
%[lensens,ordersens]=sort(cellfun(@length,ind_spike_val),'descend');
%So lensens is ind_spike_val sorted by length

%ind_spike_val is a n times 3 cell array
indsens=cell(length(lensens(lensens(:,1)>0)),1);

%Creation of the unique (within tol) cell arrays
ind_temp=cell(length(lensens(lensens(:,1)>0)),1);
lastpos=0;
for i=1:size(ind_temp,1)
    [ind_temp{i,1}, indices, ~]=uniquetol(double(ind_spike_val{ordersens(i,1),1}),tol,'DataScale',1);
    for j=2:3
        ind_temp{i,j}=double(ind_spike_val{ordersens(i,1),j}(indices));
    end
    if max(ind_temp{i,1})>lastpos
        lastpos=max(ind_temp{i,1});
    end
end

beg=-tol;
alrdone=[];
flag=true;

while flag
    %Where to start
    mat=ind_temp{1,1}(ind_temp{1,1}-beg>tol);
    [mindist,indmin]=min(abs(mat-(beg+2*tol)));    
    pos=mat(indmin); %pos is the closest value to lastval+2*tol
    for i=2:size(ind_temp,1)
        mat=ind_temp{i,1}(ind_temp{i,1}-beg>tol);
        [mini,indi]=min(abs(mat-(beg+2*tol)));
        if mini < mindist
            pos=mat(indi);
            mindist=mini;
        end
    end
    
    %Who is the max ratio of index "ind" such that abs(pos-arr(ind)) <= tol
    val=ind_temp{1,3}(ismembertol(ind_temp{1,1},pos,tol,'DataScale',1));
    if isempty(val)
        maxratio=0;
    else
        [maxratio,maxind]=max(val);
        mat=ind_temp{1,1}(ismembertol(ind_temp{1,1},pos,tol,'DataScale',1));
        maxind=mat(maxind);
    end
    where=1;
    for i=2:size(ind_temp,1)
        val=ind_temp{i,3}(ismembertol(ind_temp{i,1},pos,tol,'DataScale',1));
        if ~isempty(val)
           mat=ind_temp{i,1}(ismembertol(ind_temp{i,1},pos,tol,'DataScale',1));
           [maxi,indi]=max(val);
           if maxi>maxratio
               maxratio=maxi;
               maxind=mat(indi);
               where=i;
           end
        end
        
    end
    
    %Update things
    if maxind==beg-1
        break;
    end
    alrdone=[alrdone maxind];
    indsens{where}=[indsens{where} maxind];
    beg=maxind+1;
    if abs(maxind-lastpos)<=tol 
        flag=false;
    end
end


end


function [uniquearr] = uniqueTolMax(array,tol,values)
%Same as uniquetol with a data scale of 1 but keep the index with the
%maximum value within values
%values and array must be the same size
%array is the array upon which 'uniquetol' is used 
%values(n) is a corresponding value to the data array(n)
[sortedarr, indarr]=sort(array);
sortedval=values(indarr);
i=1;
uniquearr=[];
while i<=length(array)
    %State the max is the first index
    maxval=sortedval(i);
    indmax=i;
    out=0;
    for j=i+1:length(array)
        %Look if the element is within tol of the previous one
        if abs(sortedarr(i)-sortedarr(j))<=tol
            %If yes, find the max
            if sortedval(j)>maxval
                maxval=sortedval(j);
                indmax=j;
            end
        else
            %First index of element not within tol
            out=j;
            break;
        end
    end
    %Add the element with the max value
    uniquearr=[uniquearr sortedarr(indmax)];
    
    %Try again from the first index not within tol from the last one or
    %leave loop if there isn't one
    i=(out~=0)*out+(out==0)*(length(array)+1);
end
end


function array=split(cad,sep)
    ind=find(cad==sep); ind0=1;
    array=cell(length(ind),1);
    for i=1:length(ind)
        array{i}=cad(ind0:(ind(i)-1));
        ind0=ind(i)+1;
    end
    array{length(ind)+1}=cad(ind0:end);
function decision = classifier(new, numerical, branches, labels, thresholds, classification)
decision = 0;
s = size(branches);
% class assigned if the point are equal to 3: if the value of branches is
% equal to inf that means that the corrisponding variable is not considered
% in the path so that means that the classification doesn't depends on this
% variable and a point +1 is assigned as default 

branches
labels

thresholds
for i=1:s(1)
    point = 0;
    temp_new = new;
    for j = 1:s(2)
        if branches(i, j)~=Inf && ismember(branches(i, j), numerical)
            if new(branches(i, j)) <= thresholds(i, j)
                temp_new(branches(i, j)) = 0;
            elseif new(branches(i, j)) > thresholds(i, j)
                temp_new(branches(i, j)) = 1;
            end
        end
    end
    
    for j=1:s(2)
        if branches(i, j) == Inf
            
            point=point +1;
        elseif branches(i, j) ~= Inf && temp_new(branches(i, j)) == labels(i, j)
            
            point = point +1;
        end
    end
    
    if point == 3
        decision =classification(i);
        return
    end
end
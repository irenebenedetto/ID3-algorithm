function [branches, labels, thresholds, classification] = build_tree(level, ts, c, to_take, tree, lab, alpha, numerical, branches, labels,classification, thresholds, thresh)


% fprintf('\n\t LEVEL  ');
% fprintf('%d \n', level);
pc = [];

% here I compute the the probability of the class that it is used later to
% compute the entropy of the class label
for i=1:length(alpha)
    pc = [pc, length(c(c==alpha(i)))/length(c)];
end

if level == 3
%   exit condition: arrived at level 3, that is the maximum depth that our
%   tree with 3 feature can reach, I extracted the the most probable class
%   label and I assigned this value to the corrisponding feature feature
    [pm, apmax] = max(pc);
    variable = ts(apmax, tree(length(tree)));
     class = c(apmax);
    
    classification = [classification; class];
    disp(classification);
    %branches, classification, thershold
    
    padding_tree = repelem(inf, 3-length(tree));
    padding_th = repelem(inf, 3-length(thresh));
    padding_lab = repelem(inf, 3-length(lab));
    
    branches = [branches; [tree, padding_tree]];
    labels = [labels; [lab, padding_lab]];
    thresholds = [thresholds; [thresh, padding_th]];
    
end


HC = H(pc);
% fprintf('\nH(C):\t%.4f ', HC);
IGR = zeros(1, 3);

if ~isempty(to_take)
    
    max_thershold = [];
    
%   array that take into account the variable already found that are
%   numerical, that is used to control that a numerical variable is not
%   taken twice on the same branch

    found_numerical = [];
%   cicle over the variables that aren't already considered, saved in the
%   vector "to_take": for these variables I compute the IGR. If it is
%   numerical it takes the treshold that makes the IGR maximal. 
    for i=1:length(to_take)
%         fprintf('\n\nVariable: %d', to_take(i));
        X = unique(ts(:, to_take(i)));
        HC_X = [];
        px = [];
        max_th = 0;
        if  ismember(to_take(i), numerical)==1

            found_numerical = [found_numerical, to_take(i)];
            values = unique(ts(:, to_take(i)));
            igr_num = zeros(1, length(values));
            max_igr = 0;
            
            for q = 1:length(values)-1
                thre = values(q);
                den = length(ts(ts(:, to_take(i))<=thre));
                l0 = (c == alpha(1))&(ts(:, to_take(i))<=thre);
                l1 = (c == alpha(2))&(ts(:, to_take(i))<=thre);
                p0 = length(l0(l0==1))/den;
                
                p1 = length(l1(l1==1))/den;
                
                denu = length(ts(ts(:, to_take(i))>thre));
                ub0 = (c == alpha(1))&(ts(:, to_take(i))>thre);
                ub1 = (c == alpha(2))&(ts(:, to_take(i))>thre);
                
                pu0 = length(ub0(ub0==1))/denu;
                
                pu1 = length(ub1(ub1==1))/denu;

                
                px = [length(ts(ts(:, to_take(i))<=thre))/length(ts'), length(ts(ts(:, to_take(i))>thre))/length(ts')];
                HC_X =[H([p1, p0]), H([pu0,pu1])];
                
                HCX = sum(HC_X.*px);
                HX= H(px);
                ICX = HC - HCX;
                igr_num(q) = ICX/HX;

                if ICX/HX> max_igr
                    max_igr = igr_num(q);
                    max_th = values(q);
                end
                
            end
            IGR(i) = max_igr;
%             fprintf('\nIGR:\t%.4f', max_igr);
%             fprintf('\nThreshold:\t%.4f', max_th);
            max_thershold = [max_thershold, max_th];
        else
            for k = 1:length(X)
                den = length(ts(ts(:, to_take(i))==X(k)));
                l0 = (c == alpha(1))&(ts(:, to_take(i))==X(k));
                l1 = (c == alpha(2))&(ts(:, to_take(i))==X(k));
                p0 = length(l0(l0==1))/den;

                p1 = length(l1(l1==1))/den;

                HC_X =[HC_X, H([p0, p1])];
                
                px = [length(ts(ts(:, to_take(i))==X(k)))/length(ts'), px];
            end
            
            HCX = sum(HC_X.*px);
            ICX = HC - HCX;
            HX= H(px);
            IGR(i) = ICX/HX;
            
%             fprintf('\nH(C/X vect):\t');
%             fprintf('%.4f ', HC_X);
%             
%             fprintf('\nH(C/X):\t%.4f', HCX);
%             fprintf('\nH(X):\t%.4f', HX);
%             fprintf('\nI(C;X):\t%.4f', ICX);
%             fprintf('\nIGR:\t%.4f', IGR(i));
        end
        
        %take the variable that generate the maximum IGR and classify if
        %the entropy is equal to 0.
        if i == length(to_take)
            [m, amax] = max(IGR);
            m = to_take(amax);
%             fprintf('\n\nMax IGR of variable:\t%d\n', m);
            tree = [tree, to_take(amax)];
            
%           when  the variable with maximum IGR is numerical I created I temporary matrix
%           that contains the same values 
            ts_temp = ts;
            
            new_ts = [];
            if ismember(m, numerical)
                
                index = find(found_numerical == m);
                max_th = max_thershold(index);
                
                ts_temp = ts;
                ts_temp(ts_temp(:, to_take(amax))<=max_th, to_take(amax)) = 0;
                ts_temp(ts_temp(:, to_take(amax))>max_th, to_take(amax)) = 1;
            end
            
            X = unique(ts_temp(:, to_take(amax)));
            
            HC_X = [];
            
            for k = 1:length(X)
                den = length(ts_temp(ts_temp(:, to_take(i))==X(k)));
                l0 = (c == alpha(1))&(ts_temp(:, m)==X(k));
                l1 = (c == alpha(2))&(ts_temp(:, m)==X(k));
                p0 = length(l0(l0==1))/den;
                p1 = length(l1(l1==1))/den;
                HC_X =[HC_X, H([p0, p1])];
                
            end
            
            if ismember(m, numerical)
                thresh = [thresh, max_th];
            else
                thresh = [thresh, inf];
            end
            
            temp = find(to_take == to_take(amax));
            to_take(temp) = [];
            
 
            for k=1:length(HC_X)
               
                new_ts = ts_temp(ts_temp(:, m)==X(k), :);
                new_c = c(ts_temp(:, m)==X(k));
                
                e = 0;
                if HC_X(k)==0
                    e = 1;
                    nlab = [lab, X(k)];
                    
                    class = c(ts_temp(:, m)==X(k));
                    class = class(1);
                    
                    %branches, labels, thershold
                    
                    padding_tree = repelem(inf, 3-length(tree));
                    padding_lab = repelem(inf, 3-length(nlab));
                    padding_th = repelem(inf, 3-length(thresh));
                    
                    classification = [classification; class];
                    branches = [branches; [tree, padding_tree]];
                    labels = [labels; [nlab, padding_lab]];
                    thresholds = [thresholds; [thresh, padding_th]];
                    
%                     fprintf('\n\t%d CLASSIFIED AS %d\n', X(k), class(1));
%                     fprintf('classification with pattern:\t');
%                     fprintf('%d ', [tree, padding_tree]);
%                     
%                     fprintf('\n\n\n');
                else
                  
                    lab = [lab, X(k)];
                    
                    
                    [branches, labels, thresholds, classification] = build_tree(level+1, new_ts, new_c, to_take, tree, lab, alpha, numerical, branches, labels,classification, thresholds, thresh);
%                     fprintf('\n\t\t--> BACKTRACK');
                    lab(length(lab)) = [];
                end
            end
            
            
        end
        
        
    end
end


clear all;
clc;
train_set = [30, 0, 10;      %0
             30, 0, 70;      %0
             30, 1, 20;      %0
             30, 1, 80;      %1
             60, 0, 40;      %0
             60, 0, 60;      %1
             60, 1, 50;      %0
             60, 1, 60;];    %1
         
class_label = [0;0;0;1;0;1;0;1];
numerical = [1 3];
test_set = [0, 1, 122;
            7, 17, 2;
            75, 50, 6;];
        
decision = decision_tree_classifier(test_set, train_set, class_label, numerical);

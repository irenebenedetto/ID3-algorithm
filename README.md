# ID3-algorithm
Matlab implementation of the <a href="https://en.wikipedia.org/wiki/ID3_algorithm">ID3 algorithm</a> for classification: this implementation makes use of entropy and information gain to split the node of a tree. 
This repository contains different files:
- `main.m`: calls the function `decision_tree_classifier()`, that receives the training set, the class labels and the number of columns to consider as numerical and the test set;
- `decision_tree_classifier.m`: calls the function `build_tree()` in order to build a decision tree and then classifies the test set with the function `classifier()`;
- `build_tree.m`: builds the decision tree recursively by splitting each node with the feature that maximizes the information gain. 
- `classifier.m`: computes the classification with the tree previously built;
- `H.m`: function that computes the entropy of a probability vector.

## Usage

Insert the training set and the corresponding labels and indicate which columns should dbe considered as numerical: the file plots the trends of the Bit Error Rate over the Signal-To-Noise rate for the three windows chosen.


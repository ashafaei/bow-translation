#!/bin/bash

echo "Downloading the dataset!"
wget http://www.cs.ubc.ca/~shafaei/homepage/projects/datasets/bmvc14.dataset.tar.gz

echo "Extracting files"
tar xzfv bmvc14.dataset.tar.gz

echo "Done!"

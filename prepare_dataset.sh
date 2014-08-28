#!/bin/bash

echo "Downloading the dataset!"
wget -O bmvc14.dataset.tar.gz http://www.cs.ubc.ca/~shafaei/homepage/projects/datasets/bmvc14.dataset.php

echo "Extracting files"
tar xzfv bmvc14.dataset.tar.gz

echo "Done!"

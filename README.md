BoW translation of dense trajectory features
===============
This is the code that accompanies the paper

A. Gupta, A. Shafaei, J. J. Little and R. J. Woodham. *Unlabelled 3D Motion Examples Improve Cross-View Action Recognition*. In BMVC, 2014.
See [project page](http://cs.ubc.ca/research/motion-view-translation/) for more information.

The basic idea is to learn a transformation function for BoW features that translates the feature descriptor as if they were seen from another view point. Weuse this idea to perform cross-view action recognition.

In order to run this code you need to have
* [VLFeat](http://www.vlfeat.org/) for Matlab.
* [LibLinear](http://www.csie.ntu.edu.tw/~cjlin/liblinear/) for Matlab.

We use VLFeat to calculate [Homogenous Kernel Maps](http://www.vlfeat.org/api/homkermap.html) if chi-squared kernel. LibLinear is used to train an SVM. You can easily replace these parts with any other implementations you like.


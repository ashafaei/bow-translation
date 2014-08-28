# BoW Translation of Dense Trajectory Features
This is the code that accompanies the paper

A. Gupta, A. Shafaei, J. J. Little and R. J. Woodham. *Unlabelled 3D Motion Examples Improve Cross-View Action Recognition*. In BMVC, 2014.
See [project page](http://cs.ubc.ca/research/motion-view-translation/) for more information.

The basic idea is to learn a transformation function for BoW features that translates the feature descriptor as if they were seen from another viewpoint. We use this idea to perform cross-view action recognition.

### How to run
In order to run this code you need to have
* [VLFeat](http://www.vlfeat.org/) for Matlab.
* [LibLinear](http://www.csie.ntu.edu.tw/~cjlin/liblinear/) for Matlab.

We use VLFeat to calculate [Homogenous Kernel Maps](http://www.vlfeat.org/api/homkermap.html) of chi-squared kernel. LibLinear is used to train an SVM. You can easily replace these parts with any other implementations you like.

Before you can run this code you need to download and extract the dataset. If you're using Unix based machines you simply need to navigate to the base folder and run `./prepare_dataset.sh`.

If you are a windows user you can manually download and extract the dataset from [here](http://www.cs.ubc.ca/~shafaei/homepage/projects/datasets/bmvc14.dataset.php).

After that you can simply run `classify_ixmas.m` in Matlab.

### What's in the dataset?
The dataset contains
* IXMAS Precomputed and quantized dense trajectory features. You can also use the vocbulary inside these files to quantize your own dense trajectory features to use with this code.
* Trained transition matrices for 426 viewpoint changes. The procedure to prepare this data is explained in the paper. 

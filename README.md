# HyTrack
Tracking neurons in Hydra vulgaris

The code consists of 3 parts.

1. Detection
2. Tracking 
3. Tracklet association

The detection algorithm we use is adapted from u-track, described here:
http://lccb.hms.harvard.edu/software.html
The detection algorithm itself is the one described in Supplementary Note 2
http://www.nature.com/nmeth/journal/v5/n8/extref/nmeth.1237-S1.pdf

The tracklet association is described here:
https://www.robots.ox.ac.uk/~vgg/rg/papers/huang_etal__robust_object__eccv2008.pdf


We use the GPML toolbox (for obtaining motion affinity). Download from here: http://www.gaussianprocess.org/gpml/code/matlab/doc/


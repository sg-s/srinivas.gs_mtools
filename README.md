# mtools by srinivas.gs

This repository contains a bunch of useful scripts and functions that make working in MATLAB much easier. All my other MATLAB repositories depend on this. Feel free to do with functions that I have written what you will. Some functions written by others are also included here, with licenses and attribution where possible. 


# List of Functions 

Click on the links to go to the doc page of that function. 

### [GammaDist.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/GammaDist.m)
generate a parametric gamma distribution
### [STA.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/STA.m)
computes the spike triggered averaged stimulus.
### [angularDifference.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/angularDifference.m)
computes absolute angular distance between two angles in degrees
### [argInNames.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/argInNames.m)
returns a cell containing the names of the variables that are returned by a function, as defined in the function. 
### [argOutNames.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/argOutNames.m)
returns a cell containing the names of the variables that are returned by a function, as defined in the function. 
### [autoCorr2d.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/autoCorr2d.m)
2D autocorrelation of a matrix (image)
### [autoPlot.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/autoPlot.m)
autoPlot is a wrapper for subplot that allows you to simplify figure creation where you know the number of plots, but don't want to bother to calcualte how many subplots you want in the X and Y directions. 
### [bandPass.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/bandPass.m)
bandpasses input signal to spikes and/or slow fluctuations
### [barfit.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/barfit.m)
Finds x which minimizes |Ax - b|_1 (ie. 1-norm of the residuals) using the Barrowdale/Roberts algorithm (Comm.of the ACM June 1974)
### [barwitherr.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/barwitherr.m)
bar chart with error bars
### [batchTask.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/batchTask.m)
reorganises a folder with many *.mat files into subfolders. the number of folders can be specified, or is automatically set to the number of physical cores on your CPU
### [betterMean.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/betterMean.m)
mean2 differs from mean in two different ways: it ignores NaNs, and if provided a matrix, mean2 intelligently operates on the shortest dimension. 
### [cache.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/cache.m)
fast, hash-based cache function to speed up computation. 
### [checkForNewestVersionOnGitHub.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/checkForNewestVersionOnGitHub.m)
checks for newest version of a given repo or file on github. 
### [circFit.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/circFit.m)
fits a circle to a set of points
function   [xc,yc,R,a] = circFit(x,y)
### [circle.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/circle.m)
plots a circle
### [cleanPublish.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/cleanPublish.m)
cleanPublish removes all the junk created by MATLAB's publish() function in the html/ folder in the current directory. Make sure you compile the PDF before running this! 
### [clusterDP.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/clusterDP.m)
"Density peaks" based clustering
### [computeOnsOffs.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/computeOnsOffs.m)
given a logical vector x, this function returns the on and off times of the logical vector
### [console.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/console.m)
logs messages to console
### [convertMATFileTo73.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/convertMATFileTo73.m)
converts a MATFile to v7.3
### [convolve.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/convolve.m)
convolve is just like filter.m, but accepts a-causal filters.
### [cost2.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/cost2.m)
computes a cost for two vectors
### [cutImage.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/cutImage.m)
cuts a small square of an image out a bigger image.
### [cv.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/cv.m)
coefficient of variation of a matrix of a vector.
### [dataHash.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/dataHash.m)
computes hash of data. 
### [deconvolve.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/deconvolve.m)
Devonvolves a signal using Wiener deconvoltuion
### [designFig.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/designFig.m)
interactively design a figure with multiple subplots and get designFig to make the code for you
### [dift.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/dift.m)
derivative of a non-regularly sampled time series
### [dist_gamma2.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/dist_gamma2.m)
distribution based on two gamma functions
### [dist_gauss2.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/dist_gauss2.m)
distribution from a mixture of 2 gaussians
### [distance.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/distance.m)
finds the distance (l-2 norm) b/w two points
### [duplicateFigure.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/duplicateFigure.m)
creates a duplicate of the figure that you have right now
### [elasticnet.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/elasticnet.m)
  Elastic Net.
### [envelopePlot.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/envelopePlot.m)

### [errorShade.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/errorShade.m)
a fast error-shading plot function
### [errorbarxy.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/errorbarxy.m)
error bars in both X and Y
### [filter_alpha.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/filter_alpha.m)
2 parameter bilobed filter based on an alpha function
### [filter_alpha2.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/filter_alpha2.m)
four parameter bilobed filter based on an alpha function
### [filter_exp.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/filter_exp.m)
exponentially decaying filter
### [filter_exp2.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/filter_exp2.m)
2-lobed exponentially decaying filter
### [filter_gamma.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/filter_gamma.m)
usage:  f = filter_gamma(tau,n,A,t)
### [filter_gamma2.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/filter_gamma2.m)
parametrically generate a 2-lobed gamma filter
### [findCorrelationTime.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/findCorrelationTime.m)
finds the correlation time of a vector. returns an answer in the units of vector indices
### [findData.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/findData.m)
finds indices of a structure that have non empty fields. 
### [findMATFileVersion.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/findMATFileVersion.m)
determines the version of a mat file (cannot resolve v6 from v7)
### [findShortestDimension.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/findShortestDimension.m)
finds the shortest dimension in a multidimensional matrix x
### [fitModel2Data.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/fitModel2Data.m)
fits a model specified by a file to data. 
### [folderName.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/folderName.m)
returns the current folder's name
### [geffenMeister.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/geffenMeister.m)
performs a trial-wise analysis of model fits as done in Geffen and Meister 2009
### [getAllFiles.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/getAllFiles.m)
recursively get all files from a specific directory 
### [getAllSubFolders.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/getAllSubFolders.m)
a stupid wrapper around getAllFiles that gets all sub folders from a given folder
### [getBounds.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/getBounds.m)
gets upper and lower bounds by reading a .m file
### [getComputerName.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/getComputerName.m)
returns the host name of the computer
### [getDependants.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/getDependants.m)
builds reverse-dependency list of functions in a list of folders
### [getDependencies.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/getDependencies.m)
builds dependency list of functions in a list of folders
### [getLatestHash.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/getLatestHash.m)
gets the SHA-1 hash of the latest git commit at online repository. 
### [getLinks.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/getLinks.m)
gets links from a snippet of HTML text (h)
### [getModelParameters.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/getModelParameters.m)
reads a model file to determine parameters. 
### [gini.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/gini.m)
Givne these values, this computes the GINI coefficient according to
### [gitHash.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/gitHash.m)
finds the hash of the current commit of the git repository of the given file
### [hill.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/hill.m)
3-parameter Hill function
### [hill2.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/hill2.m)
2-parameter Hill function
### [hill4.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/hill4.m)
4-parameter Hill function, with a X and a Y offset. the x-offset is automatically determined from the data, so be careful in using this in multiple datasets
### [hill5.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/hill5.m)
5-parameter Hill function, with a X and a Y offset
### [ihill.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/ihill.m)
Inverse Hill Function
### [ihill2.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/ihill2.m)
2-parameter Inverse Hill Function
### [install.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/install.m)
install.m is a package manager for @sg-s' MATLAB code. install.m downloads code from GitHub and fixes your MATLAB path so that everything works out of the box. 
### [iseven.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/iseven.m)
is the number even or not?
### [isint.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/isint.m)
returns 1 if input is an integer, 0 if otherwise
### [l1eq_pd.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/l1eq_pd.m)
finds the solution to min_x ||x||_1  s.t.  Ax = b, recast as a linear program
### [l2.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/l2.m)
calcualtes the l2 norm between 2 vectors a and b
### [larsen.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/larsen.m)
The LARS-EN algorithm for estimating Elastic Net solutions.
### [lineRead.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/lineRead.m)
reads a text file line by line and returns the text as a structure array
### [listSubFunctions.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/listSubFunctions.m)
makes a list of all subfunctions in a matfile 
### [logistic.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/logistic.m)
3-parameter logistic function
### [logistic4.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/logistic4.m)
4-parameter logistic function
### [makePDF.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/makePDF.m)
a wrapper for MATLAB's publish() function, it makes a PDF directly from the .tex that MATLAB creates and cleans up afterwards.
### [manualCluster.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/manualCluster.m)
creates a GUI to manually cluster 2D data into clusters
### [mat2struct.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/mat2struct.m)
converts a vector into a structure
### [mdot.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/mdot.m)
mdot returns the column-wise dot product of a matrix
### [min2.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/min2.m)
finds the minimum of a vector, ignoring Infs and NaNs
### [modInv.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/modInv.m)
ModInv(x,n) computes the multiplicative inverse of x modulo n if one
### [modd.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/modd.m)
returns remainder if non zero. 
### [movePlot.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/movePlot.m)
moves the given plot up down, left or right
### [multiPlot.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/multiPlot.m)
mulitplot accepts 1 time axis and multiple data channels, and figures out what to do with them.
### [nonnans.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/nonnans.m)
removes NaNs from a vector
### [online.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/online.m)
checks to see if the computer is online
### [oss.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/oss.m)
OS-based slash
### [oval.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/oval.m)
oval is a better version of round, which rounds to how many ever
### [parseHTML.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/parseHTML.m)
extracts a section from a text string containing HTML so that only text from a specified tag to the end of the tag is extracted. 
### [pdfrnd.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/pdfrnd.m)
pdfrnd(x, px, sampleSize): return a random sample of size sampleSize from 
### [plotPieceWiseLinear.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/plotPieceWiseLinear.m)
creates a piecewise linear fit to the data, and then plots it
### [powerspec.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/powerspec.m)
power spectral density of an input time series
### [prettyFig.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/prettyFig.m)
makes current figure pretty:
### [publish_skeleton.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/publish_skeleton.m)
a minimal template for .m files that will be published using publish()
### [randomString.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/randomString.m)
makes a random string
### [raster2.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/raster2.m)
raster2(A,B)
### [rdir.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/rdir.m)
Recursive directory listing.
### [readPref.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/readPref.m)
reads a preferences file, which is a human readable (and editable) text file and return formatted data
### [removePointDefects.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/removePointDefects.m)
removes large, single time point excursions from signal
### [resizePlot.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/resizePlot.m)

### [rsquare.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/rsquare.m)
computes the coefficent of determination (http://en.wikipedia.org/wiki/Coefficient_of_determination) between two inputs
### [saturationPlane.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/saturationPlane.m)
calculates the saturation plane from a 3-channel image. 
### [searchPath.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/searchPath.m)
searches path for a given folder
### [sem.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/sem.m)
computes standard error of mean of a matrix
### [shadedErrorBar.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/shadedErrorBar.m)

### [spear.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/spear.m)
Spearman's rank correalation coefficient.
### [spellcheck.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/spellcheck.m)
small wrapper function to check spelling using aspell
### [spiketimes2f.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/spiketimes2f.m)
accepts a vector of spike times and returns a firing rate estimate using a Gaussian smoothing window. 
### [spinner.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/spinner.m)
simple, text-based spinner to indicate that some computation is being done
### [splineHist.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/splineHist.m)
uses smoothing splines to make nice-looking histograms 
### [stripPath.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/stripPath.m)
strips the path from a complete path to a file
### [strkat.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/strkat.m)
alternate version of strcat, to better handle spaces
### [struct2mat.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/struct2mat.m)
converts a structure to a matrix, when possible
### [summarise.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/summarise.m)
reads m files and makes a text file containing the file name and the second line of each m file. 
### [sweetspot.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/sweetspot.m)
makes a colour map that goes from blue (too low) through green (nice) to red (too high)
### [textbar.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/textbar.m)
textbar is the text equivalent of waitbar.
### [totient.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/totient.m)
calculates the totient function  of any positive integer n.
### [triangle.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/triangle.m)
triangle.m draws a equliateral triangle at a given point and orientation,
### [uid.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/uid.m)
make a Unique ID every time this is run
### [width.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/width.m)
width is like the built in "length"
### [xcoeff.m](https://github.com/sg-s/srinivas.gs_mtools/blob/master/xcoeff.m)
computes the cross-correlation coefficient between two signals


## General Notes on Usage

All functions here have help above the function definition, and you can get help about any file using `help`:

```
>> help Manipulate
```

shows:

```
Manipulate.m
  Mathematica-stype model manipulation
  usage: 
  Manipulate(fname,p,stimulus,response,time)
  where p is a structure containing the parameters of the model you want to manipulate 
  The function to be manipulated (fname) should conform to the following standard: should accept two inputs, time and stimulus, and a third input which is a structure specifying parameters (p)
  x is the stimulus input
 
 and response is an optional reference output that will be plotted with the model output (useful if you want to manually tune some parameters to fit data)
time is an optional time vector
  
Minimal Usage: 
  Manipulate(fname,p,stimulus);
  
  
created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
  
This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
  
```

You can also call any function with no arguments and it will return help, if at least one argument is required for that function. So `Manipulate` is the same as `help Manipulate`

I've tried to follow the style guidelines specified in `mfile style guideline.md`

# Installation

You can install all these functions from within MATLAB using my package manager:

```
>> urlwrite('http://srinivas.gs/install.m','install.m');
>> install srinivas.gs_mtools
```

or you can install using `git`

```
$ git clone https://github.com/sg-s/srinivas.gs_mtools.git
```


# Detailed Notes	

## makePDF.m and cleanPublish.m
`makePDF.m` is a wrapper for MATLAB's [publish](http://www.mathworks.com/help/matlab/ref/publish.html) function that accepts a script, and makes into a PDF directly. It works by first using `publish` to make a .tex file, then using `pdflatex` to compile that to a PDF. Assumes you are working on a Unix machine with `pdflatex` installed. 

[This](https://github.com/sg-s/awesome-matlab-notebook) repo has a detailed workflow built around `makePDF`, `cleanPublish`, and `cache`. 

It uses `cleanPublish.m` to remove all the figures and log files after the PDF is compiled. 
	
## textbar.m

`textbar` is a text-based `waitbar` replacement. Drop it into long loops:

```
for i = 1:34
	textbar(i,34)
	% do some long computation
end
```

will show you a progress bar and how many loops have evaluated. For loops that run more than a hundred times, textbar intellgitently switches to percent completed. The progress bar is erased when the loop completes. 


## Manipulate.m

`Manipulate` offers Mathematica-style function and model manipulation in MATLAB. Manipulate can handle any function or model that is defined the following way:

```
function [x1,x2,...] = function_name(time,stimulus,p)
```
where `time` and `stimulus` are vectors of equal length and `p` is a structure that contains the parameters you want to manipulate. 

If your function/model isn't in this form, write a wrapper that is in this form and use 

```
>> Manipulate('function_name',p,stimulus)
```

## oval.m

`oval` is a version of `round` that is meant for use in figure labels, etc. `oval` returns a rounded string to an arbitrary number of digits:

```
>> oval(pi,2)

3.14

```

`oval` can also handle fractions, if you tell it to:

```
>> oval(1/7,'frac')

1/7
```
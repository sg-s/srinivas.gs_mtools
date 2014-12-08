# srinivas.gs_mtools: README

This repository contains some useful functions and scripts written in MATLAB that I've written over the years. My other repositories depend on this. Feel free to do whatever you want with this. 

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

or 

```
$ git clone git@github.com:sg-s/srinivas.gs_mtools.git
```

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

# Contents

1. AngularDifference.m
1. CheckForNewestVersionOnBitBucket.m
1. CheckForNewestVersionOnGitHub.m
1. CleanPublish.m
1. ComputeOnsOffs.m
1. Cost2.m
1. CutImage.m
1. FindBestFilter.m
1. FindCorrelationTime.m
1. FindShortestDimension.m
1. FitFilter2Data.m
1. FitModel2Data.m
1. GammaDist.m
1. GetLatestHash.m
1. GetLinks.m
1. GitHash.m
1. MakePDF.m
1. Manipulate.m
1. ManualCluster.m
1. ParseHTML.m
1. PrettyFig.m
1. RandomString.m
1. RemovePointDefects.m
1. SaturationPlane.m
1. StripPath.m
1. TrialPlot.m
1. arginnames.m
1. argoutnames.m
1. autoplot.m
1. cluster_dp.m
1. convolve.m
1. cv.m
1. deconvolve.m
1. dift.m
1. distance.m
1. filter_alpha.m
1. filter_alpha2.m
1. filter_exp.m
1. filter_exp2.m
1. filter_gamma.m
1. filter_gamma2.m
1. find_data.m
1. foldername.m
1. getAllFiles.m
1. getComputerName.m
1. header.m
1. hill.m
1. hill2.m
1. hill4.m
1. ihill.m
1. ihill2.m
1. install.m
1. iseven.m
1. l2.m
1. logistic.m
1. logistic4.m
1. mat2struct.m
1. mdot.m
1. mean2.m
1. min2.m
1. modd.m
1. multiplot.m
1. online.m
1. oss.m
1. oval.m
1. plott.m
1. powerspec.m
1. raster2.m
1. rsquare.m
1. searchpath.m
1. spellcheck.m
1. spiketimes2f.m
1. spinner.m
1. strkat.m
1. struct2mat.m
1. textbar.m
1. triangle.m
1. uid.m
1. width.m



# Detailed Notes	

## MakePDF.m and CleanPublish.m
`MakePDF.m` is a wrapper for MATLAB's [publish](http://www.mathworks.com/help/matlab/ref/publish.html) function that accepts a script, and makes into a PDF directly. It works by first using `publish` to make a .tex file, then using `pdflatex` to compile that to a PDF. Assumes you are working on a Unix machine with `pdflatex` installed. 

It uses `CleanPublish.m` to remove all the figures and log files after the PDF is compiled. 
	
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
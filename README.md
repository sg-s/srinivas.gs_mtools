# mtools by srinivas.gs

This repository contains a bunch of useful scripts and functions that make working in MATLAB much easier. All my other MATLAB repositories depend on this. Feel free to do with this what you will. 

<!-- MarkdownTOC -->

- [List of Functions](#list-of-functions)
  - [General Notes on Usage](#general-notes-on-usage)
- [Installation](#installation)
- [Detailed Notes](#detailed-notes)
  - [MakePDF.m and CleanPublish.m](#makepdfm-and-cleanpublishm)
  - [textbar.m](#textbarm)
  - [Manipulate.m](#manipulatem)
  - [oval.m](#ovalm)

<!-- /MarkdownTOC -->


# List of Functions 

`AngularDifference.m`
`CheckForNewestVersionOnBitBucket.m`
`CheckForNewestVersionOnGitHub.m`
`CleanPublish.m`
`ComputeOnsOffs.m`
`Cost2.m`
`CutImage.m`
`DataHash.m`
`DesignFig.m`
`FindBestFilter.m`
`FindCorrelationTime.m`
`FindShortestDimension.m`
`FitFilter2Data.m`
`FitModel2Data.m`
`GammaDist.m`
`GetLatestHash.m`
`GetLinks.m`
`GitHash.m`
`MakePDF.m`
`Manipulate.m`
`ManualCluster.m`
`ParseHTML.m`
`PrettyFig.m`
`README.md`
`RandomString.m`
`RemovePointDefects.m`
`SaturationPlane.m`
`StripPath.m`
`TrialPlot.m`
`arginnames.m`
`argoutnames.m`
`autoplot.m`
`cache.m`
`cluster_dp.m`
`console.log`
`console.m`
`convolve.m`
`cv.m`
`deconvolve.m`
`dift.m`
`distance.m`
`filter_alpha.m`
`filter_alpha2.m`
`filter_exp.m`
`filter_exp2.m`
`filter_gamma.m`
`filter_gamma2.m`
`find_data.m`
`foldername.m`
`getAllFiles.m`
`getComputerName.m`
`getModelParameters.m`
`header.m`
`hill.m`
`hill2.m`
`hill4.m`
`ihill.m`
`ihill2.m`
`install.m`
`iseven.m`
`l2.m`
`logistic.m`
`logistic4.m`
`mat2struct.m`
`mdot.m`
`mean2.m`
`mfile style guideline.md`
`min2.m`
`modd.m`
`multiplot.m`
`online.m`
`oss.m`
`oval.m`
`plott.m`
`powerspec.m`
`raster2.m`
`rsquare.m`
`searchpath.m`
`spellcheck.m`
`spiketimes2f.m`
`spinner.m`
`splinehist.m`
`strkat.m`
`struct2mat.m`
`textbar.m`
`triangle.m`
`uid.m`
`width.m`


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
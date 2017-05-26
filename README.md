# mtools by srinivas.gs

This repository contains a bunch of useful scripts and functions that make working in MATLAB much easier. All my other MATLAB repositories depend on this. Feel free to do with functions that I have written what you will. Some functions written by others are also included here, with licenses and attribution where possible. 

## Some of the things you can do with this toolbox

| What you want to do                            | Use this |
| --------------------                           | -------  |
| Visualise animated phase plot                  | [animatePhasePlot](src/figure-tools/animatePhasePlot.m) |
| Make subplots without worrying about layout    | [autoPlot](src/figure-tools/autoPlot.m) | 
| Make bar chart with errorbars | [barwitherr](src/figure-tools/barwitherr.m) |
| Introduce breaks in axes | [breakPlot](src/figure-tools/breakPlot.m) |
| prevent X and Y axes from intersecting | [deintersectAxes](src/figure-tools/deintersectAxes.m) |
| make a copy of the current figure | [duplicateFigure](src/figure-tools/duplicateFigure.m) |
| Visualise matrix with missing data | [imagescnan](src/figure-tools/imagescnan.m) |
| Add a label to a panel/axes/plot | [labelAxes](src/figure-tools/labelAxes.m) |
| Add labels to all panels in a figure | [labelFigure](src/figure-tools/labelFigure.m) |
| Move a plot left, right, etc. | [movePlot](src/figure-tools/movePlot.m) |
| Quickly plot multiple time series | [multiPlot](src/figure-tools/multiPlot.m) |
| Make your plots prettier, fixes MATLAB's horrible defaults | [prettyFig](src/figure-tools/prettyFig.m) |
| Add shading to plot showing error | [shadedErrorBar](src/figure-tools/shadedErrorBar.m) |
| Reduce data in plot by discarding visually indiscernible data  | [shrinkDataInPlot](src/figure-tools/shrinkDataInPlot.m) |
| Make visually identical figures by throwing out data  | [shrinkFigure](src/figure-tools/shrinkFigure.m) |
| Use splines to make smooth histograms | [splineHist](src/figure-tools/splineHist.m) |
| Make error bars with p-values | [superbar](src/figure-tools/superbar.m) |
| Make error bars with p-values | [superbar](src/figure-tools/superbar.m) |
| Make error bars with p-values | [superbar](src/figure-tools/superbar.m) |
| Convert ABF spike files to kontroller files | [abf2kontroller](src/file-tools/abf2kontroller.m) |
| Load ABF spike files in MATLAB | [abfload](src/file-tools/abfload.m) |
| Convert .avi movie files to .mat files | [avi2mat](src/file-tools/avi2mat.m) |
| cache data using hashes | [cache](src/file-tools/cache.m) |
| Convert .mat file to v7.3  | [convertMATFileTo73.m](src/file-tools/convertMATFileTo73.m) |
| Convert TDMS files to .mat files  | [convertTDMS.m](src/file-tools/convertTDMS.m) |
| Hash data, files  | [dataHash.m](src/file-tools/dataHash.m) |
| Find the version of .mat files  | [findMATFileVersion.m](src/file-tools/findMATFileVersion.m) |
| Find all files recursively | [findAllFiles.m](src/file-tools/findAllFiles.m) |
| Get hash of current commit of git repository  | [gitHash.m](src/file-tools/gitHash.m) |
| Check if .mat file is compressed | [isMATFileCompressed.m](src/file-tools/isMATFileCompressed.m) |
| Hash using md5 | [md5.m](src/file-tools/md5.m) |
| Recursively list all folders | [rdir.m](src/file-tools/rdir.m) |
| Save .mat files quickly and without compression | [savefast.m](src/file-tools/savefast.m) |
| Search MATLAB path for a given folder | [searchPath.m](src/file-tools/searchPath.m) |

## Contents

Functions in this repository are organized into:

1. `beta` don't use this. 
2. `figure-tools` Tools to make better plots. For example, [prettyFig](https://github.com/sg-s/srinivas.gs_mtools/blob/master/src/figure-tools/prettyFig.m) makes pretty figures. 
3. `file-tools` tools for working with files on your computer. For example, `abf2kontroller`, which converts AutoSpike files into [kontroller](https://github.com/sg-s/kontroller) compatible files. 
4. `image-tools` tools to help you with working with images. For example, `saturationPlane` computes the saturation plane from a colour image. 
5. `internet-tools` to help you work over HTTP connections. `install` is my package manager that installs toolboxes from GitHub. 
6. `maths-tools` are functions for various mathematical operations. e.g., `spear` computes the Spearman rank correlation. 
7. `matlab-tools` MATLAB-specific tools, to work around various quirks and missing bits in MATLAB. For example, the excellent `swap` swaps two variable in place. 
8. `neuro-tools` tools specific to neuroscience. For example, `raster2` plots a raster of spike times from two neurons. 
9. `publish-tools` This toolset is built around MATLAB's `publish` function. For details on what you can do with this, look at this [repo](https://github.com/sg-s/awesome-matlab-notebook).
10. `string-tools` tools to work with strings. For example, `randomString(100)` spits out a 100 random characters. 
11. `time-series-tools` tools to work with time series. For example, `fastFilter` speeds up convolutions using GPUs and Fourier Transforms for long time series. 

# Installation

The reccomended way to install this is to use my package manager (which is included in this repo): 

```matlab
urlwrite('http://srinivas.gs/install.m','install.m');
install sg-s/srinivas.gs_mtools
```

or you can install using `git`

```bash
git clone https://github.com/sg-s/srinivas.gs_mtools.git
```

If you do the latter, make sure you get add the paths to the subfolders to your `MATLAB` path. 


## General Notes on Usage

All functions here have help above the function definition, and you can get help about any file using `help`:

```
help raster2
```

shows:

```
  raster2.m
  makes a raster plot of two different neurons. A (or B) can be either a logical matrix with 1 where a spike occurs, or long (zero padded) matrices of spike times. The time step is assumed to be 1e-4s
  This function is designed to be faster the the original raster
  
  
  created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
  
  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
  
```

You can also call most functions with no arguments and it will return help, if at least one argument is required for that function. So `raster2` is the same as `help raster2`


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

will show you a progress bar and how many loops have evaluated. For loops that run more than a hundred times, `textbar` intelligently switches to percent completed. The progress bar is erased when the loop completes. 

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
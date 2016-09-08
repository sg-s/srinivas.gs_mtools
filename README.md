# mtools by srinivas.gs

This repository contains a bunch of useful scripts and functions that make working in MATLAB much easier. All my other MATLAB repositories depend on this. Feel free to do with functions that I have written what you will. Some functions written by others are also included here, with licenses and attribution where possible. 

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

## General Notes on Usage

All functions here have help above the function definition, and you can get help about any file using `help`:

```
>> help raster2
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

# Installation

The reccomended way to install this is to use my package manager (which is included in this repo): 

```
>> urlwrite('http://srinivas.gs/install.m','install.m');
>> install sg-s/srinivas.gs_mtools
```

or you can install using `git`

```
$ git clone https://github.com/sg-s/srinivas.gs_mtools.git
```

If you do the latter, make sure you get add the paths to the subfolders to your `MATLAB` path. 

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
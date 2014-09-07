# srinivas.gs_mtools: README

This repository contains some useful functions and scripts written in MATLAB that I've written over the years. My other repositories depend on this. Feel free to do whatever you want with this. 

## Plotting and Data visualisation 

2. autoplot.m
26. oval.m
27. Manipulate.m
28. raster2.m
29. TrialPlot.m
30. multiplot.m
31. PrettyFig.m


## Web crawling functions

13. GetLinks.m
14. ParseHTML.m

## Maths
5. convolve.m
6. ComputeOnsOffs.m7. cv.m8. FindShortestDimension.m9. FitFilter2Data.m10. GammaDist.m14. hill.m15. hill2.m16. ihill2.m17. iseven.m18. l2.m19. logistic.m20. logistic4.m23. mean2.m1. spiketimes2f.m1. rsquare.m


## publishing 

3. CleanPublish.m
4. MakePDF.m

## image processing

6. CutImage.m
7. triangle.m
7. SaturationPlane.m

## misc.

12. getComputerName.m
13. getAllFiles.m1. argoutnames.m1. RemovePointDefects.m
1. width.m1. textbar.m
1. struct2mat.m25. oss.m
## text handling
1. strkat.m
1. StripPath.m1. spellcheck.m1. RandomString.m

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

## MakePDF.m and CleanPublish.m
`MakePDF.m` is a wrapper for MATLAB's [publish](http://www.mathworks.com/help/matlab/ref/publish.html) function that accepts a script, and makes into a PDF directly. It works by first using `publish` to make a .tex file, then using `pdflatex` to compile that to a PDF. Assumes you are working on a Unix machine with pdflatex installed. 

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
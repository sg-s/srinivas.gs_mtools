# mtools by srinivas.gs

This repository contains a set of toolboxes that makes working
with MATLAB much easier. All code here is organized into different 
toolboxes, which means that:

* functions that are related to one another are grouped together
* your namespace isn't polluted by the functions in this toolbox
* you only have to add this folder to your path (and not subfolders) to access all these tools

What can you do with this? Read on:


 ## [axlib](./+axlib/)

| Name | Use |
| -------- | ------- |
|equalize|  Equalize X or Y or Z axes across multiple axes. |
|label|  Add a label to an axes. |
|separate|  Prevent axes from intersecting |
|test|  tests functions in axlib|


 ## [clusterlib](./+clusterlib/)

| Name | Use |
| -------- | ------- |
|densityPeaks|  cluster 2D data using the density peaks algorithm|
|interactive|  Interactively cluster 2D data|
|manual|  Manually cluster 2D data|


 ## [colormaps](./+colormaps/)

| Name | Use |
| -------- | ------- |
|dcol|  distinguishable colormaps |
|linspecer|  generate colormaps|


 ## [corelib](./+corelib/)

| Name | Use |
| -------- | ------- |
|argInNames|  Find names of arguments to function|
|argOutNames|  Find names of outputs of function|
|closest|  Find closest point of a vector to some value|
|cprintf|  Displays styled formatted text in the Command Window|
|getComputerName|  get the host name of the computer|
|logrange|  A more usable version of logspace|
|numcores|  Find number of cores on a CPU|
|readPref|  parse a human-readable preference file|
|swap|  swap contents of two variables in place|
|textbar|  high-performance text equivalent of waitbar|
|uid|  return a unique ID |
|vectorise|  make an array a vector |


 ## [figlib](./+figlib/)

| Name | Use |
| -------- | ------- |
|autoPlot|  automatically create subplots|
|duplicate|  creates a duplicate of the figure that you have right now|
|label|  adds labels to each subplot of a figure |
|pretty|  makes a figure prettier, and overrides MATLAB's horrible defaults. |
|shrink|  removes data in figure that is not visually relevant |
|tileFigs|  tile all open figures on the screen|


 ## [filelib](./+filelib/)

| Name | Use |
| -------- | ------- |
|abfload|  load ABF files into MATLAB|
|find|  find patterns in lines of text |
|getAll|  recursively get all files from a specific directory |
|getAllFolders|  gets all folders in a given folder, recursively searching the entire tree|
|mkdir|  make a directory if needed|
|read|  reads a text file line by line and returns the text as a cell array|
|write|  write a cell array to a text file|


 ## [geomlib](./+geomlib/)

| Name | Use |
| -------- | ------- |
|angularDifference|  angularDifference.m|
|distance|  distance.m|
|distanceFromLineToPoint|  distanceFromLineToPoint.m|


 ## [hashlib](./+hashlib/)

| Name | Use |
| -------- | ------- |
|GetMD5_helper| function S = GetMD5_helper(V)|
|md5compile|  Compile and install mdhash MEX C file|
|md5hash|  compute the md5sum of data, arrays, files|


 ## [imglib](./+imglib/)

| Name | Use |
| -------- | ------- |
|ACI|  computes the activity correlated image from a time series of images|
|andorSeq2mat|  convert image sequence to a matrix|
|cutImage|  cuts a small square of an image out a bigger image.|
|metadata2timestamps|  converts a metadata file created by Micro-Manager into timestamps|
|saturationPlane|  calculates the saturation plane from a 3-channel image. |
|triangle|  draws a equliateral triangle at a given point and orientation|


 ## [mathlib](./+mathlib/)

| Name | Use |
| -------- | ------- |
|GeometricMedian|  computes the [geometric medium](http://en.wikipedia.org/wiki/Geometric_median) of a matrix |
|aeq|  approximate equality function|
|barfit|  Finds x which minimizes |Ax - b|_1 using the Barrowdale/Roberts algorithm |
|cfinvert|  given a curve fit object cf, find x such that cf(x) = y|
|chb|  change base of number|
|elasticnet|  regress data using elasticnet regularization |
|factor2|  Returns all factors of k, including k itself.|
|gini|  compute the Gini coefficient |
|iseven|  is the number even or not?|
|isint|  returns 1 if input is an integer, 0 if otherwise|
|iswhole|  checks if a given array is a whole number|
|l1eq_pd|  finds the solution to min_x ||x||_1  s.t.  Ax = b, recast as a linear program|
|larsen|  The LARS-EN algorithm for estimating Elastic Net solutions.|
|matrixMin|  returns the minimum of a matrix, together with the array index|
|modd|  a better remainder/modulo function|
|outliers|  detect outliers in data|
|outliers_demo| function outliers_demo(N,f)|
|totient|  calculates the totient function  of any positive integer n.|


 ## [netlib](./+netlib/)

| Name | Use |
| -------- | ------- |
|copyFiles|  copies a set of files over to a remote|
|copyFun|  copies a function specified by a function handle|
|online|  checks to see if your computer is online|
|ping|  pings a remote server|


 ## [neurolib](./+neurolib/)

| Name | Use |
| -------- | ------- |
|ISIDistance|  measures the distance between pairs of ISI sets|
|ISIraster| function ISIraster(varargin)|
|geffenMeister|  performs a trial-wise analysis of model fits as done in Geffen and Meister 2009|
|raster|  plots a raster of spikes|
|staggerSpikes| function X = staggerSpikes(S, varargin)|


 ## [pathlib](./+pathlib/)

| Name | Use |
| -------- | ------- |
|ext|  ext.m|
|join|  joinPath|
|name|  name.m|


 ## [pdflib](./+pdflib/)

| Name | Use |
| -------- | ------- |
|cleanPublish|  cleanPublish removes all the junk created by MATLAB's publish() function in the html/ folder in the current directory. Make sure you compile the PDF before running this! |
|footer|  pFooter.m|
|header|  pHeader.m|
|isCodeCommitted|  showDependencyHash|
|make|  makePDF.m|
|showDependencyHash|  showDependencyHash|
|snap| function snap()|


 ## [plotlib](./+plotlib/)

| Name | Use |
| -------- | ------- |
|arrow|  create an arrow on a plot|
|breakp|  makes a plot who's y-axis skips to avoid unecessary blank space|
|cplot|  plots X and Y dots and colors each dot by a value V|
|drawDiag|  draw a diagonal line on a plot|
|errorShade|  a fast error-shading plot function|
|imagescnan|   Scale data and display as image with uncolored NaNs.|
|move|  moves the given plot up down, left or right|
|shadedErrorBar|  makes a 2-d line plot with a pretty shaded error bar made using patch. Error bar color is chosen automatically.|
|shrinkData|  throw away data in plot object that doesn't change the plot visibly |
|snap|  snap position of axes in a figure to a grid|


 ## [smrlib](./+smrlib/)

| Name | Use |
| -------- | ------- |
|SONADCToDouble| function[out,h]=SONADCToDouble(in,header)|
|SONChanList| function[ChanList]=SONChanList(fid)|
|SONChannelInfo| function [TChannel]= SONChannelInfo(fid,chan)|
|SONFileHeader| function [Head]=SONFileHeader(fid)|
|SONGetADCChannel| function[data,h]=SONGetADCChannel(fid, chan, varargin)|
|SONGetADCMarkerChannel| function[data,h]=SONGetADCMarkerChannel(fid, chan, varargin)|
|SONGetBlockHeaders| function[header]=SONGetBlockHeaders(fid,chan)|
|SONGetChannel| function[data,header]=SONGetChannel(fid, chan, varargin)|
|SONGetEventChannel| function[data,h]=SONGetEventChannel(fid, chan, varargin)|
|SONGetMarkerChannel| function[data,h]=SONGetMarkerChannel(fid, chan, varargin)|
|SONGetRealMarkerChannel| function[data,h]=SONGetRealMarkerChannel(fid, chan, varargin)|
|SONGetRealWaveChannel| function[data,h]=SONGetRealWaveChannel(fid, chan, varargin)|
|SONGetSampleInterval| function[interval, start]=SONGetSampleInterval(fid,chan)|
|SONGetSampleTicks| function[interval,start]=SONGetSampleTicks(fid,chan)|
|SONGetTextMarkerChannel| function[data,h]=SONGetTextMarkerChannel(fid, chan, varargin)|
|SONRealToADC| function[out,hout]=SONRealToADC(in,header)|
|SONTicksToSeconds| function[out,timeunits]=SONTicksToSeconds(fid, in, varargin)|
|load|  load SMR file|


 ## [statlib](./+statlib/)

| Name | Use |
| -------- | ------- |
|histogram2|  Computes the two dimensional frequency histogram of two|
|kstest_2s_2d|  Two-sample Two-diensional Kolmogorov-Smirnov |
|pdfrnd|  Generate random samples given a pdf.  The x and p(x) are specified in the arguments.  See inverse transform sampling, gaussdis, gammadis. |
|spear|  computes Spearman correlation between two vectors x and y|


 ## [strlib](./+strlib/)

| Name | Use |
| -------- | ------- |
|clean|  cleans a string of whitespace, leading numbers, etc.|
|fix|  force a string to have a fixed length|
|oval|  round off a number and convert to a string|
|rand|  makes a random string|


 ## [structlib](./+structlib/)

| Name | Use |
| -------- | ------- |
|read|  read nested field from a structure|


 ## [uxlib](./+uxlib/)

| Name | Use |
| -------- | ------- |
|chooseGroup|  creates a UX element that allows you to choose from a list of items, or enter a new one |
|disable|  disables a UX element|
|enable|  enables and shows a UX element|
|hide|  hides a UX element|
|show|  makes visible a UX object|
|toggleCheckedMenu|  toggle a menu item |


 ## [veclib](./+veclib/)

| Name | Use |
| -------- | ------- |
|bandPass|  band pass a vector using a discrete filter|
|binByPercentile|  finds n bins so that each bin has the same number of points|
|closeReturn|  computes the close return plot of a vector X|
|computeOnsOffs|  find rising and falling edges in a logical vector|
|cost2|  Euclidean cost for two vectors|
|dift|  derivative of a non-regularly sampled time series|
|getUserPath|  returns the user path of the path|
|interleave|  interleaves N vectors X1, X2, .. XN|
|labelByPercentile|  labels a vector by percentile bin|
|nanfiltfilt|  filtfilt, but works with NaNs|
|nonnans|  removes NaNs from a vector|
|percentile|  returns the value from a data vector X that is at the Pth percentile|
|pickN|  picks N elements from a vector|
|powerspec|  power spectral density of an input time series|
|shuffle|  shuffles a vector or a matrix|
|stagger|  stagger into a vector into a matrix using overlapping bins|














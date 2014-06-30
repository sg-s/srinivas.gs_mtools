# srinivas.gs_mtools: README

This repositroy contains some useful functions and scripts written in MATLAB that I've written over the years. My other repositories depend on this; feel free to do whatever you want with this. 

## List of Functions 

1. Manipulate.m
2. mulitplot.m
3. oss.m
4. oval.m
5. PrettyFig.m
6. RandomString.m
7. textbar.m

## General Notes on Usage

All functions here have help above the function definition, and you can get help about any file using `help`:

```
>> help Manipulate
```

shows:

You can also call any function with no arguments and it will return help, if at least one argument is required for that function. So `Manipulate` is the same as `help Manipulate`

I've tried to follow the style guidelines specified in `mfile style guideline.md`		
## textbar.m

`textbar` is a text-based `waitbar` replacement. Drop it into long loops:

```
for i = 1:34
	textbar(i,34)
	% do something
end
```

will show you a progress bar and how many loops have evaluated. For loops that run more than a hundred times, textbar intellgitently switches to percent completed. 


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
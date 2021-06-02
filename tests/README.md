
# veclib


The purpose of this document is to test veclib, and also to provide some documentation for it



## Contents

            
- veclib.interleave        
- veclib.chunk

## veclib.interleave


This function interleaves an arbitrary number of identically sized vectors in the order provided.



```matlab
X = ones(50,1);
Y = zeros(50,1);
Z = ones(50,1)*2;

I = veclib.interleave(X,Y,Z);
```


and we get:



```matlab
I(1:10)
```




```

ans =

     1
     0
     2
     1
     0
     2
     1
     0
     2
     1


```



## veclib.chunk


Let's imagine you have a long vector, and you want to chunk it into smaller bits for analysis. You can't simply use reshape, because the length of the vector may not be an integer multiple of your bin size. That's where `veclib.chunk` comes to the rescue.



```matlab
X = randn(129,1);
Y = veclib.chunk(X,10);
```


If we inspect the size of Y we see:



```matlab
size(Y)
```




```

ans =

    10    12


```



<sub>[Published with MATLAB R2019b]("http://www.mathworks.com/products/matlab/")</sub>
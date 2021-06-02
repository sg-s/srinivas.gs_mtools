
# tp44bec12c_99e3_4643_b040_2f3a3a0eba4d


The purpose of this document is to test veclib, and also to provide some documentation for it



## Contents

            
- veclib.interleave

## veclib.interleave


This function interleaves an arbitrary number of identically sized vectors in the order provided.



```matlab
X = ones(50,1);
Y = zeros(50,1);
Z = ones(50,1)*2;

I = veclib.interleave(X,Y,Z);
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



<sub>[Published with MATLAB R2019b]("http://www.mathworks.com/products/matlab/")</sub>
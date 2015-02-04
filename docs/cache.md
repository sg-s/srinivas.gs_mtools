# cache.m

Let's run a function. Unfortunately, it does something very complex, so it takes a long time to run:
```matlab
>> tic; [A,B] = complexCalculations(x,y); toc
Elapsed time is 126.810807 seconds.
```

Phew. Let's run it again: 

```matlab
>> tic; [A,B] = complexCalculations(x,y); toc
Elapsed time is 0.275681 seconds.
```

WHAT. HAPPENED. 

Welcome to cache.m 

`complexCalculations.m` is internally cached, as so:

```matlab
function [A,B] = complexCalculations(x,y)

% first we hash the inputs:
temp.x = x; temp.y = y;
hash = DataHash(temp);

% we ask cache if its seen this data before
cached_data = cache(hash);

if ~isempty(cached_data)
    % wow. cache.m has cached the results. let's just return that 
    A = cached_data.A;
    B = cached_data.B;
    return
end

% do some complicated calculation.
% ... 
% ...

% cache the results:
cached_data = struct;
cached_data.A = A;
cached_data.B = B;

```

Any function can be *internally cached* in this manner. You can also use cache anything by hash:

```matlab
A = hugeCalculations(B); % takes a super long time
cache(DataHash(B),A);
```

and retrieve it easily with:

```matlab
A = cache(DataHash(B)); % super fast
```

`cache` stores its cache locally in `cached.mat`. 

If cache doesn't know what to translate a hash into, it will return an empty variable. 

`cache` works best with [cryptographic hashes](http://en.wikipedia.org/wiki/Cryptographic_hash_function), but you can use it with anything:

``` matlab
cache('3kjn3242n',A)
cache('wow',B)
```

You can selectively clear entries from the hash table using

``` matlab
cache('wow',[])
```

The best part? `cache` automatically manages its own size, and intelligently removes the least-used hashes first. 


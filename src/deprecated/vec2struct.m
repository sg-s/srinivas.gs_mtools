% vec2struct
% vec2struct is the mirror of struct2vec
% vec2struct converts a vector with associated labels 
% into a structure
% it is a superset of mat2struct, which only works for 
% 1-layer deep structures.
% in constrast, vec2struct works for deeply
% nested structures too:
% names_like_this are converted into names.like.this

function S = vec2struct(S,x,names)

assert(isstruct(S),'First argument should be a struct')
assert(length(x) == length(names),'Length of 2nd and 3rd argument should be the same')
assert(isvector(x),'2nd argument should be a vector')


keyboard


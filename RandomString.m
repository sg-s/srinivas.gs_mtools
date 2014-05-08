% makes a random string
function s = RandomString(l)
seed=[(50:57) (65:90) (97:122)]; % only these values from char; zero, 1 exlcuded to avoid covnusion with 1, O (the letter)
s = char(seed(randi(length(seed),1,l)));

% randomString.m
% makes a random string
% 
% created by Srinivas Gorur-Shandilya at 2:50 , 08 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function s = RandomString(l)
seed=[(50:57) (65:90) (97:122)]; % only these values from char; zero, 1 exlcuded to avoid covnusion with 1, O (the letter)
s = char(seed(randi(length(seed),1,l)));

% for loop, specify the variable want to loop., i.e. "i", vaule will go up
% by 1 and will go up to 6, with every for need an end, in between  you have a variable that will be analyzed. FOr this example we'll use a one random number  generator function:
% use F9 as a shortcut to running scripts in matlab from the editor
%first highlight what want to run, then press F9

for i = 1:1:6
    
    j(i)=rand(1)
end


%new loop - which allows the loop to put in outputs at intervals other than
%1 as above. below the loop will go from 2 to 14, in intervals of 4.

for k = 2:4:14
    
    jj(k)= rand(1)
end

% can apply this to put in stuff into data sets, just be carefull cause the
%default numbers inbetween the entries matlab will make into zeros
%so better first to just make an NaN matrix and fill that one in and then
%combine that one with your original matrix to update the data set.
% 
% "For loop" is straight forward to run through data to do stuff, 
% and "while" is the "if" statement one

%Another loop comand is while

m =1 ;
while m<7
    var43(m,1)=m+m.^2
    m=m+1;
end

% above takes m and does the operation on it m+m2 and stores it in the row
% of matrix var43, the loop goes until m becomes bigger than 7, with every
% loop run m will be increased by 1 (line 29). Result will be the
% following:
%
%var43 =

    %2


%var43 =
% 
%      2
%      6


%var43 =

%      2
%      6
%     12


%var43 =

%      2
%      6
%     12
%     20


%var43 =

%      2
%      6
%     12
%     20
%     30
% 

%var43 =

%      2
%      6
%     12
%     20
%     30
%     4

% control + r comments out stuff in matlab - several rows together


%NEXT we have IF statements

% so will put it inside a loop taht just will count from 1 to 5, for if use
% two equal signs (to test stuff)

% will create a variable that we will analyze - t with 4 and 3 in it
test12 = [23 54 4 1 3]
% now want to see if in test12 we had a value 4 in teh matrix
for ij=1:1:5 % so will go through the matrix column by column, through all 5 columns, or what ever columns you want to look through
    
    
    
    if test12(1,ij)==4
      % then do teh following, we'll jsut use a string function for fun
      disp('the number is 4')
      
      % so if also want an "else statement" use else
      
    elseif test12(1,ij) ==3
        disp('the number is 3')
        
        % and if neither of above instructions work, if we want to put
        % another condition on it can do that as follows:
    else
        disp('the number is neither')
    end
end %make sure that you close all script commands from command to get out, other wise matlab will freeze, 
%to stop it from processing in matlab window press control+C
% The answer to above if script will be:
% % the number is neither
% % the number is neither
% % the number is 4
% % the number is neither
% % the number is 3
% >> 

% NEXT TOPIC: to find and replace stuff in data in data, use indexing:
% 
% create a vector will work with

% test_vec = [2 3 5 6 4 NaN 3 5 7 43 2 3 4]' % we transpose it for the fun of it
% now will try to find every row where the value is 5 in test_vec. First need a 
% variable name, say ind_5,and again use double ==. Use full for finding
% in which row your number of interst is. So if wanted to replace all the 5
% in test_vec, then can specify what rows to replace with something else,
% in our example 33.

ind_5 = find(test_vec ==5)

%the answer will be:
% ind_5 =
% 
%      3
%      8
test_vec(ind_5,1)=33

% now if want to find your NaNs use
ind_nan = find(isnan(test_vec)) %isnan is programmed in matlab, so now if want NaN be replaced do the following:

test_vec(ind_nan)=0

%you can also use greater than or less than too in your analysis:
%use find and in it specify all your conditions separated by AND , which in
%matlab is "&":
btw_5_10= find(test_vec>5 & test_vec<=10)

% can also imbed min and max, for exaple find values that are maximum in
% the column:
max_value = find(test_vec == max(test_vec))

%there is a shortcut to find, through indexing, if don't have to save data???

%INDEXING

%make variables first to work with (our dataset)
test_vec2 = [11 5 34 nan -19 2 3 -7 -2 38 2 1 77]'
garbage = [17 14 36 73 2 1 -3 -45 3 2 1 3 4]'

% so any row where test-vec is greatwer than 10, want to change those row
% values to NaN

test_vec2(test_vec2>10,1)=NaN %if don't specify column will run through a row, and whole column use ":"
test_vec2(test_vec>10,1)=NaN %this is different from above, in this line matlab will look at our old vector test_vec and look for rows 
%were things are less than 10, then it will go to test_vec2 and will replace in those row placements it got from test_vec with NaN
% so matlab is not working with numbers, it works with the placement of
% data in these columns

%few more useful things to keep in mind: intersect
veca=[1 8 2 7 3 6 4]'
vecb=[1 13 8 21 7 5 5 4]'

%intercept will compare any two columns to find where there are matches
%between columns in numbers, first create
[c ai bi]=intersect(veca,vecb)

% the function outputed three variables as follows:
% c =
% 
%      1
%      4
%      7
%      8
% 
% 
% ai =
% 
%      1
%      7
%      4
%      2
% 
% 
% bi =
% 
%      1
%      8
%      5
%      3
%     
%  c outputs all numbers shared by veca and vecb, the second variable ai spits out all rows where the matches listed in c occur in veca, bi does the same for vecb.
%but a trick, if the number in c appears in several rows, the ai and bi
%will only display the last row - so becareful of those.


% SIZE AND LEGTH

len_a =length(veca) % tells the legth of the largest column or row of the matrix

vecc= [veca(1:7,1) vecb(1:7,1)]

[num_rows  num_col] = size(vecc)
%OUTPUT get from above line
% num_rows =
% 
%      7
% 
% 
% num_col =
% 
%      2
%size tells the number of rows and columns in teh matrix

%LAST THING FOR TODAY: rounding numbers, it's self explanatory, just follow the notes given.
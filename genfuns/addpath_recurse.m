function addpath_recurse(directory,ignore,flag,remove)
%ADDPATH_RECURSE  Adds the specified directory and its subfolders
%   addpath_recurse(directory,ignore,flag)
%
%   By default, all hidden directories, overloaded method directories
%   (preceded by '@'), and directories marked 'private' are ignored.
%
%   Descriptions of Input Variables:
%   directory: full path to the starting directory.  All subdirectories
%       will be added to the path as well.  If this is not specified, then
%       the current directory will be used.
%   ignore: a cell array of strings specifying directory names to ignore.
%       This will cause all subdirectories beneath this directory to be
%       ignored as well.
%   flag:   as in addpath, this may be either 0/1, or 'begin','end', by
%       default the value is 'begin'
%   remove: this is a true/false flag that if set to true will run this
%       function "in reverse" and recursively remove directories from the
%       path
%
%   Descriptions of Output Variables:
%   none
%
%   Example(s):
%   >> addpath_recurse(pwd,{'.svn'}); %adds the current directory and all
%   subdirectories, ignoring the SVN-generated .svn directories
%   >> addpath_recurse(pwd,{'ignoreDir'},'',true); %removes all
%   directories beneath the current directory, except those including and
%   beneath 'ignoreDir' from the search path
%
%   See also: addpath

% Author: Anthony Kendall
% Contact: anthony [dot] kendall [at] gmail [dot] com
% Created: 2008-08-08

%Parse the inputs
if nargin<2
    if nargin==0
        directory = pwd;
    end
    ignore={''};
    flag = 0;
    remove = false;
elseif nargin==2
    if ischar(ignore)
        ignore = cell(char);
    end
    flag = 0;
    remove = false;
elseif nargin>=3
    if isempty(flag)
        flag = 0;
    end
    if ischar(flag)
        assert(any(strcmpi(flag,{'begin','end'})),'Illegal value of "flag", see HELP');
    else
        assert(isscalar(flag) && (flag==0 || flag==1),'Illegal value of "flag", see HELP');
    end
    if nargin==4
        assert(islogical(remove),'The "remove" flag must be a logical value, see HELP');
    else
        remove = false;
    end
end

%Add the current directory to the path or remove it according to 'remove'
assert(exist(directory,'dir')>0,'The input directory does not exist');
if remove
    warning off MATLAB:rmpath:DirNotFound
    rmpath(directory)
    warning on MATLAB:rmpath:DirNotFound
else
    addpath(directory,flag);
end

%Get list of directories beneath the specified directory, this two-step
%process is faster
currDir = dir([directory,filesep,'*.']);
currDir = currDir([currDir.isdir]); %This handles files without an extension

%Loop through the directory list and recursively call this function
for m = 1:length(currDir)
    if ~any(strcmpi(currDir(m).name,{'private','.','..',ignore{:}})) && ...
            ~any(strncmp(currDir(m).name,{'@','.'},1))
        addpath_recurse([directory,filesep,currDir(m).name],ignore,flag,remove);
    end
end
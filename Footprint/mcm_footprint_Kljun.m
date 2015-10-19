function [xr,xmax] = mcm_footprint_Kljun(zm,znot,h,sigmaw,ustar,r)
% See Kljun_calc_footprint.m for a description of the process and
% variables.  This is simply the function that sets it up.

% Expect data to be inputted in following format:
% zm, znot, h: can be singular values if they are constant for the whole
% r can be singular, or a vector, specifying different XCrit values that
% the user would like to run.
% All output variables will be size:  [length(sigmaw),length(r)]
% year, or else they can be a vector the same length as sigmaw and ustar.
% sigmaw and ustar: should be vectors covering an entire year

if numel(zm) == 1
    zm = zm.*ones(length(sigmaw),1);
end

if numel(znot) == 1
    znot = znot.*ones(length(sigmaw),1);
end

if numel(h) == 1
    h = h.*ones(length(sigmaw),1);
end

if isequal(length(zm), length(znot),length(h),length(sigmaw),length(ustar))==0
    disp('Something is wrong with the lengths of zm, znot, h, r, sigmaw and/or ustar.');
    return;
end

if size(r,2) > size(r,1)
    r = r';
end


xr = NaN.*ones(length(sigmaw),length(r));
xmax = NaN.*ones(length(sigmaw),length(r));
for j = 1:1:length(r)
    for i = 1:1:length(sigmaw)
        try
            [xr(i,j),xmax(i,j),~,~]=Kljun_calc_footprint(zm(i,1),znot(i,1),h(i,1),sigmaw(i,1),ustar(i,1),r(j,1));
        catch
            xr(i,j) =   NaN;
            xmax(i,j) =   NaN;
        end
    end
end
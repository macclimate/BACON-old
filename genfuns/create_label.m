function[label] = create_label(num, length);
%create_label  creates a sting padded with zeros useful for file naming
%
%    This function accepts as arguments an integer scalar or vector 'num'
%    and a integer scalar 'length'  it turns the vector 'num' into a string
%    and pads the right side with zeros.  
%
%    This is useful so that when you list the contents of a directory you
%    get:
%          file.001
%          file.002
%          file.003
%          file.004 
%              .
%              .
%              .
%
%
%    instead of 
%         file.1
%         file.10
%         file.100
%         file.11
%         file.101
%
%
%
%  try it out by copying and pasting this usage line to see what you get
%
%  LBL = create_label([1:1:200]', 3)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[L W] = size(num);
if L < W
   num = num';
end

              r = (int2str(num))';
          [L W] = size(r);
          r = fliplr(r);   
          
          z = int2str(zeros(W,1))';
          
          for i = 1:L
             tmp = deblank(r(i,:));
             tmp = ([tmp ,z]);
          o(i,:) = tmp(1,1:W);
          end
          
          m = length - L;
          
          o = flipud(o);
          for i = L+1:length
             o(i,:) = z;
          end
          o = flipud(o);
          
          o = fliplr(o);
          o = o';
          
          label = o;             
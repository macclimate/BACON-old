function [] = junk4(input)

a = rand(input,1);
try
out = junk5(a);
catch except1
    err = MException;
    id = err.identifier;
    mess = err.message;
end
disp(out)
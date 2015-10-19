function [tvec YYYY MM DD dt hhmm hh mm JD] = jjb_maketimes(year_in, time_int)

tvec = make_tv(year_in, time_int);
[YYYY JD hhmm dt] = jjb_makedate(year_in,time_int);
hh = floor(hhmm./100);
mm = rem(hhmm,100);

[MM DD] = make_Mon_Day(year_in,time_int);
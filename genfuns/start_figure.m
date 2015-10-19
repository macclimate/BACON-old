function f_out = start_figure(fig_name, fig_tag)
%%% start_figure.m
%%% usage: f_out = start_figure(fig_name, fig_tag)
%%% Checks if the figure is already open (by searching for the tag).
%%% If it is open, it simply clears the figure
%%% If it is not open, it makes a new one, with the figure handle f_out
%%% Created Sept 20, 2010 by JJB

if ~isempty(findobj('Tag',fig_tag));
    f_out = figure(findobj('Tag',fig_tag)); clf;
    
else
    f_out = figure('Name',fig_name,'Tag',fig_tag);clf;
end
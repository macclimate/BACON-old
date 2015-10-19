clear all 
close all

hyp_length = input('hypoteneuse length ');
bot_length = input('bottom length ');
height = input('height ');

if hyp_length == 0
    hyp_length = sqrt(bot_length^2+height^2)
elseif height == 0
    height = sqrt(hyp_length^2 - bot_length^2)
elseif bot_length == 0
    bot_length = sqrt(hyp_length^2 - height^2)
end
    rise_angle = (asin(height/hyp_length))/.0175

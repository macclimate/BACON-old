recips = {'s.mackay4@gmail.com'};
subject = 'Email from MATLAB - TEST';
message = ['If you are receiving this email, I have successfully sent an email ' ...
    'from within MATLAB.  MATLAB has an internal function that will automatically ' ...
    'send emails from a specified email address, with a specified subject, body and attachments.'];
attach = '/home/brodeujj/Desktop/dgQZP.jpg';

sendmail(recips,subject,message,attach)
function [] = mcm_setupsendmail()
%%% Sets up email from MATLAB (sendmail) settings:
setpref('Internet', 'E_mail', 'mac.climate@gmail.com');
setpref('Internet', 'SMTP_Username', 'mac.climate@gmail.com');
setpref('Internet', 'SMTP_Password', 'altafgrad');
setpref('Internet', 'SMTP_Server', 'smtp.gmail.com');
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port', '465');
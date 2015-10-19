
% Plot TP74 data 
% load TP74_final_2003.txt; TP74_03 = TP74_final_2003; clear TP74_final_2003
% load TP74_final_2004.txt; TP74_04 = TP74_final_2004; clear TP74_final_2004
% load TP74_final_2005.txt; TP74_05 = TP74_final_2005; clear TP74_final_2005
% load TP74_final_2006.txt; TP74_06 = TP74_final_2006; clear TP74_final_2006
% load TP74_final_2007.dat; TP74_07 = TP74_final_2007; clear TP74_final_2007

load TP74_final_2003.dat; TP74_03 = TP74_final_2003; clear TP74_final_2003
load TP74_final_2004.dat; TP74_04 = TP74_final_2004; clear TP74_final_2004
load TP74_final_2005.dat; TP74_05 = TP74_final_2005; clear TP74_final_2005
load TP74_final_2006.dat; TP74_06 = TP74_final_2006; clear TP74_final_2006
load TP74_final_2007.dat; TP74_07 = TP74_final_2007; clear TP74_final_2007

close all;

figure(7);  hold on; plot(TP74_03(:,7),'b');plot(TP74_04(:,7),'r');plot(TP74_05(:,7),'g');plot(TP74_06(:,7),'c');plot(TP74_07(:,7),'m');
figure(8);  hold on; plot(TP74_03(:,8),'b');plot(TP74_04(:,8),'r');plot(TP74_05(:,8),'g');plot(TP74_06(:,8),'c');plot(TP74_07(:,8),'m');
figure(9);  hold on; plot(TP74_03(:,9),'b');plot(TP74_04(:,9),'r');plot(TP74_05(:,9),'g');plot(TP74_06(:,9),'c');plot(TP74_07(:,9),'m');
figure(10); hold on; plot(TP74_03(:,10),'b');plot(TP74_04(:,10),'r');plot(TP74_05(:,10),'g');plot(TP74_06(:,10),'c');plot(TP74_07(:,10),'m');
figure(11); hold on; plot(TP74_03(:,11),'b');plot(TP74_04(:,11),'r');plot(TP74_05(:,11),'g');plot(TP74_06(:,11),'c');plot(TP74_07(:,11),'m');
figure(12); clf;hold on; plot(TP74_03(:,12),'b');plot(TP74_04(:,12),'r');plot(TP74_05(:,12),'g');plot(TP74_06(:,12),'c');plot(TP74_07(:,12),'m');
figure(13); clf;hold on; plot(TP74_03(:,13),'b');plot(TP74_04(:,13),'r');plot(TP74_05(:,13),'g');plot(TP74_06(:,13),'c');plot(TP74_07(:,13),'m');
figure(14); hold on; plot(TP74_03(:,14),'b');plot(TP74_04(:,14),'r');plot(TP74_05(:,14),'g');plot(TP74_06(:,14),'c');plot(TP74_07(:,14),'m');
figure(15); hold on; plot(TP74_03(:,15),'b');plot(TP74_04(:,15),'r');plot(TP74_05(:,15),'g');plot(TP74_06(:,15),'c');plot(TP74_07(:,15),'m');
figure(16); hold on; plot(TP74_03(:,16),'b');plot(TP74_04(:,16),'r');plot(TP74_05(:,16),'g');plot(TP74_06(:,16),'c');plot(TP74_07(:,16),'m');
figure(17); hold on; plot(TP74_03(:,17),'b');plot(TP74_04(:,17),'r');plot(TP74_05(:,17),'g');plot(TP74_06(:,17),'c');plot(TP74_07(:,17),'m');
figure(18); hold on; plot(TP74_03(:,18),'b');plot(TP74_04(:,18),'r');plot(TP74_05(:,18),'g');plot(TP74_06(:,18),'c');plot(TP74_07(:,18),'m');
figure(19); hold on; plot(TP74_03(:,19),'b');plot(TP74_04(:,19),'r');plot(TP74_05(:,19),'g');plot(TP74_06(:,19),'c');plot(TP74_07(:,19),'m');
figure(20); hold on; plot(TP74_03(:,20),'b');plot(TP74_04(:,20),'r');plot(TP74_05(:,20),'g');plot(TP74_06(:,20),'c');plot(TP74_07(:,20),'m');
figure(21); hold on; plot(TP74_03(:,21),'b');plot(TP74_04(:,21),'r');plot(TP74_05(:,21),'g');plot(TP74_06(:,21),'c');plot(TP74_07(:,21),'m');
figure(22); hold on; plot(TP74_03(:,22),'b');plot(TP74_04(:,22),'r');plot(TP74_05(:,22),'g');plot(TP74_06(:,22),'c');plot(TP74_07(:,22),'m');
figure(23); hold on; plot(TP74_03(:,23),'b');plot(TP74_04(:,23),'r');plot(TP74_05(:,23),'g');plot(TP74_06(:,23),'c');plot(TP74_07(:,23),'m');
figure(24); hold on; plot(TP74_03(:,24),'b');plot(TP74_04(:,24),'r');plot(TP74_05(:,24),'g');plot(TP74_06(:,24),'c');plot(TP74_07(:,24),'m');
figure(25); hold on; plot(TP74_03(:,25),'b');plot(TP74_04(:,25),'r');plot(TP74_05(:,25),'g');plot(TP74_06(:,25),'c');plot(TP74_07(:,25),'m');
figure(26); hold on; plot(TP74_03(:,26),'b');plot(TP74_04(:,26),'r');plot(TP74_05(:,26),'g');plot(TP74_06(:,26),'c');plot(TP74_07(:,26),'m');
figure(27); hold on; plot(TP74_03(:,27),'b');plot(TP74_04(:,27),'r');plot(TP74_05(:,27),'g');plot(TP74_06(:,27),'c');plot(TP74_07(:,27),'m');
figure(28); hold on; plot(TP74_03(:,28),'b');plot(TP74_04(:,28),'r');plot(TP74_05(:,28),'g');plot(TP74_06(:,28),'c');plot(TP74_07(:,28),'m');
figure(29); hold on; plot(TP74_03(:,29),'b');plot(TP74_04(:,29),'r');plot(TP74_05(:,29),'g');plot(TP74_06(:,29),'c');plot(TP74_07(:,29),'m');
figure(30); hold on; plot(TP74_03(:,30),'b');plot(TP74_04(:,30),'r');plot(TP74_05(:,30),'g');plot(TP74_06(:,30),'c');plot(TP74_07(:,30),'m');
figure(31); hold on; plot(TP74_03(:,31),'b');plot(TP74_04(:,31),'r');plot(TP74_05(:,31),'g');plot(TP74_06(:,31),'c');plot(TP74_07(:,31),'m');
figure(32); hold on; plot(TP74_03(:,32),'b');plot(TP74_04(:,32),'r');plot(TP74_05(:,32),'g');plot(TP74_06(:,32),'c');plot(TP74_07(:,32),'m');
figure(33); hold on; plot(TP74_03(:,33),'b');plot(TP74_04(:,33),'r');plot(TP74_05(:,33),'g');plot(TP74_06(:,33),'c');plot(TP74_07(:,33),'m');
figure(34); hold on; plot(TP74_03(:,34),'b');plot(TP74_04(:,34),'r');plot(TP74_05(:,34),'g');plot(TP74_06(:,34),'c');plot(TP74_07(:,34),'m');
figure(35); hold on; plot(TP74_03(:,35),'b');plot(TP74_04(:,35),'r');plot(TP74_05(:,35),'g');plot(TP74_06(:,35),'c');plot(TP74_07(:,35),'m');
figure(36); hold on; plot(TP74_03(:,36),'b');plot(TP74_04(:,36),'r');plot(TP74_05(:,36),'g');plot(TP74_06(:,36),'c');plot(TP74_07(:,36),'m');
figure(37); hold on; plot(TP74_03(:,37),'b');plot(TP74_04(:,37),'r');plot(TP74_05(:,37),'g');plot(TP74_06(:,37),'c');plot(TP74_07(:,37),'m');
figure(38); hold on; plot(TP74_03(:,38),'b');plot(TP74_04(:,38),'r');plot(TP74_05(:,38),'g');plot(TP74_06(:,38),'c');plot(TP74_07(:,38),'m');
figure(39); hold on; plot(TP74_03(:,39),'b');plot(TP74_04(:,39),'r');plot(TP74_05(:,39),'g');plot(TP74_06(:,39),'c');plot(TP74_07(:,39),'m');
figure(40); hold on; plot(TP74_03(:,40),'b');plot(TP74_04(:,40),'r');plot(TP74_05(:,40),'g');plot(TP74_06(:,40),'c');plot(TP74_07(:,40),'m');
figure(41); hold on; plot(TP74_03(:,41),'b');plot(TP74_04(:,41),'r');plot(TP74_05(:,41),'g');plot(TP74_06(:,41),'c');plot(TP74_07(:,41),'m');
figure(42); hold on; plot(TP74_03(:,42),'b');plot(TP74_04(:,42),'r');plot(TP74_05(:,42),'g');plot(TP74_06(:,42),'c');plot(TP74_07(:,42),'m');
figure(43); hold on; plot(TP74_03(:,43),'b');plot(TP74_04(:,43),'r');plot(TP74_05(:,43),'g');plot(TP74_06(:,43),'c');plot(TP74_07(:,43),'m');
figure(44); hold on; plot(TP74_03(:,44),'b');plot(TP74_04(:,44),'r');plot(TP74_05(:,44),'g');plot(TP74_06(:,44),'c');plot(TP74_07(:,44),'m');
figure(45); hold on; plot(TP74_03(:,45),'b');plot(TP74_04(:,45),'r');plot(TP74_05(:,45),'g');plot(TP74_06(:,45),'c');plot(TP74_07(:,45),'m');
figure(46); hold on; plot(TP74_03(:,46),'b');plot(TP74_04(:,46),'r');plot(TP74_05(:,46),'g');plot(TP74_06(:,46),'c');plot(TP74_07(:,46),'m');
figure(47); hold on; plot(TP74_03(:,47),'b');plot(TP74_04(:,47),'r');plot(TP74_05(:,47),'g');plot(TP74_06(:,47),'c');plot(TP74_07(:,47),'m');
figure(48); hold on; plot(TP74_03(:,48),'b');plot(TP74_04(:,48),'r');plot(TP74_05(:,48),'g');plot(TP74_06(:,48),'c');plot(TP74_07(:,48),'m');
figure(49); hold on; plot(TP74_03(:,49),'b');plot(TP74_04(:,49),'r');plot(TP74_05(:,49),'g');plot(TP74_06(:,49),'c');plot(TP74_07(:,49),'m');
figure(50); hold on; plot(TP74_03(:,50),'b');plot(TP74_04(:,50),'r');plot(TP74_05(:,50),'g');plot(TP74_06(:,50),'c');plot(TP74_07(:,50),'m');
figure(51); hold on; plot(TP74_03(:,51),'b');plot(TP74_04(:,51),'r');plot(TP74_05(:,51),'g');plot(TP74_06(:,51),'c');plot(TP74_07(:,51),'m');
figure(52); hold on; plot(TP74_03(:,52),'b');plot(TP74_04(:,52),'r');plot(TP74_05(:,52),'g');plot(TP74_06(:,52),'c');plot(TP74_07(:,52),'m');
figure(53); hold on; plot(TP74_03(:,53),'b');plot(TP74_04(:,53),'r');plot(TP74_05(:,53),'g');plot(TP74_06(:,53),'c');plot(TP74_07(:,53),'m');
figure(54); hold on; plot(TP74_03(:,54),'b');plot(TP74_04(:,54),'r');plot(TP74_05(:,54),'g');plot(TP74_06(:,54),'c');plot(TP74_07(:,54),'m');
figure(55); hold on; plot(TP74_03(:,55),'b');plot(TP74_04(:,55),'r');plot(TP74_05(:,55),'g');plot(TP74_06(:,55),'c');plot(TP74_07(:,55),'m');
figure(56); hold on; plot(TP74_03(:,56),'b');plot(TP74_04(:,56),'r');plot(TP74_05(:,56),'g');plot(TP74_06(:,56),'c');plot(TP74_07(:,56),'m');
figure(57); hold on; plot(TP74_03(:,57),'b');plot(TP74_04(:,57),'r');plot(TP74_05(:,57),'g');plot(TP74_06(:,57),'c');plot(TP74_07(:,57),'m');
figure(58); hold on; plot(TP74_03(:,58),'b');plot(TP74_04(:,58),'r');plot(TP74_05(:,58),'g');plot(TP74_06(:,58),'c');plot(TP74_07(:,58),'m');
figure(59); hold on; plot(TP74_03(:,59),'b');plot(TP74_04(:,59),'r');plot(TP74_05(:,59),'g');plot(TP74_06(:,59),'c');plot(TP74_07(:,59),'m');
figure(60); hold on; plot(TP74_03(:,60),'b');plot(TP74_04(:,60),'r');plot(TP74_05(:,60),'g');plot(TP74_06(:,60),'c');plot(TP74_07(:,60),'m');
figure(61); hold on; plot(TP74_03(:,61),'b');plot(TP74_04(:,61),'r');plot(TP74_05(:,61),'g');plot(TP74_06(:,61),'c');plot(TP74_07(:,61),'m');
figure(62); hold on; plot(TP74_03(:,62),'b');plot(TP74_04(:,62),'r');plot(TP74_05(:,62),'g');plot(TP74_06(:,62),'c');plot(TP74_07(:,62),'m');
figure(63); hold on; plot(TP74_03(:,63),'b');plot(TP74_04(:,63),'r');plot(TP74_05(:,63),'g');plot(TP74_06(:,63),'c');plot(TP74_07(:,63),'m');
figure(64); hold on; plot(TP74_03(:,64),'b');plot(TP74_04(:,64),'r');plot(TP74_05(:,64),'g');plot(TP74_06(:,64),'c');plot(TP74_07(:,64),'m');
figure(65); hold on; plot(TP74_03(:,65),'b');plot(TP74_04(:,65),'r');plot(TP74_05(:,65),'g');plot(TP74_06(:,65),'c');plot(TP74_07(:,65),'m');
figure(66); hold on; plot(TP74_03(:,66),'b');plot(TP74_04(:,66),'r');plot(TP74_05(:,66),'g');plot(TP74_06(:,66),'c');plot(TP74_07(:,66),'m');
figure(67); hold on; plot(TP74_03(:,67),'b');plot(TP74_04(:,67),'r');plot(TP74_05(:,67),'g');plot(TP74_06(:,67),'c');plot(TP74_07(:,67),'m');
figure(68); hold on; plot(TP74_03(:,68),'b');plot(TP74_04(:,68),'r');plot(TP74_05(:,68),'g');plot(TP74_06(:,68),'c');plot(TP74_07(:,68),'m');
figure(69); hold on; plot(TP74_03(:,69),'b');plot(TP74_04(:,69),'r');plot(TP74_05(:,69),'g');plot(TP74_06(:,69),'c');plot(TP74_07(:,69),'m');
figure(70); hold on; plot(TP74_03(:,70),'b');plot(TP74_04(:,70),'r');plot(TP74_05(:,70),'g');plot(TP74_06(:,70),'c');plot(TP74_07(:,70),'m');

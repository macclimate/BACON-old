
% Plot TP39 data 
% load TP39_final_2003.txt; TP39_03 = TP39_final_2003; clear TP39_final_2003
% load TP39_final_2004.txt; TP39_04 = TP39_final_2004; clear TP39_final_2004
% load TP39_final_2005.txt; TP39_05 = TP39_final_2005; clear TP39_final_2005
% load TP39_final_2006.txt; TP39_06 = TP39_final_2006; clear TP39_final_2006
% load TP39_final_2007.txt; TP39_07 = TP39_final_2007; clear TP39_final_2007

load TP39_final_2003.dat; TP39_03 = TP39_final_2003; clear TP39_final_2003
load TP39_final_2004.dat; TP39_04 = TP39_final_2004; clear TP39_final_2004
load TP39_final_2005.dat; TP39_05 = TP39_final_2005; clear TP39_final_2005
load TP39_final_2006.dat; TP39_06 = TP39_final_2006; clear TP39_final_2006
load TP39_final_2007.dat; TP39_07 = TP39_final_2007; clear TP39_final_2007





% close all;

% figure(7);  hold on; plot(TP39_03(:,7),'b');plot(TP39_04(:,7),'r');plot(TP39_05(:,7),'g');plot(TP39_06(:,7),'c');plot(TP39_07(:,7),'m');
% figure(8);  hold on; plot(TP39_03(:,8),'b');plot(TP39_04(:,8),'r');plot(TP39_05(:,8),'g');plot(TP39_06(:,8),'c');plot(TP39_07(:,8),'m');
% figure(9);  hold on; plot(TP39_03(:,9),'b');plot(TP39_04(:,9),'r');plot(TP39_05(:,9),'g');plot(TP39_06(:,9),'c');plot(TP39_07(:,9),'m');
% figure(10); hold on; plot(TP39_03(:,10),'b');plot(TP39_04(:,10),'r');plot(TP39_05(:,10),'g');plot(TP39_06(:,10),'c');plot(TP39_07(:,10),'m');
% figure(11); hold on; plot(TP39_03(:,11),'b');plot(TP39_04(:,11),'r');plot(TP39_05(:,11),'g');plot(TP39_06(:,11),'c');plot(TP39_07(:,11),'m');
% figure(12); clf; hold on; plot(TP39_03(:,12),'b');plot(TP39_04(:,12),'r');plot(TP39_05(:,12),'g');plot(TP39_06(:,12),'c');plot(TP39_07(:,12),'m');
% figure(13); clf; hold on; plot(TP39_03(:,13),'b');plot(TP39_04(:,13),'r');plot(TP39_05(:,13),'g');plot(TP39_06(:,13),'c');plot(TP39_07(:,13),'m');
% figure(14); clf;hold on; plot(TP39_03(:,14),'b');plot(TP39_04(:,14),'r');plot(TP39_05(:,14),'g');plot(TP39_06(:,14),'c');plot(TP39_07(:,14),'m');
% figure(15); hold on; plot(TP39_03(:,15),'b');plot(TP39_04(:,15),'r');plot(TP39_05(:,15),'g');plot(TP39_06(:,15),'c');plot(TP39_07(:,15),'m');
% figure(16); hold on; plot(TP39_03(:,16),'b');plot(TP39_04(:,16),'r');plot(TP39_05(:,16),'g');plot(TP39_06(:,16),'c');plot(TP39_07(:,16),'m');
% figure(17); hold on; plot(TP39_03(:,17),'b');plot(TP39_04(:,17),'r');plot(TP39_05(:,17),'g');plot(TP39_06(:,17),'c');plot(TP39_07(:,17),'m');
% figure(18); hold on; plot(TP39_03(:,18),'b');plot(TP39_04(:,18),'r');plot(TP39_05(:,18),'g');plot(TP39_06(:,18),'c');plot(TP39_07(:,18),'m');
% figure(19); hold on; plot(TP39_03(:,19),'b');plot(TP39_04(:,19),'r');plot(TP39_05(:,19),'g');plot(TP39_06(:,19),'c');plot(TP39_07(:,19),'m');
% figure(20); hold on; plot(TP39_03(:,20),'b');plot(TP39_04(:,20),'r');plot(TP39_05(:,20),'g');plot(TP39_06(:,20),'c');plot(TP39_07(:,20),'m');
% figure(21); hold on; plot(TP39_03(:,21),'b');plot(TP39_04(:,21),'r');plot(TP39_05(:,21),'g');plot(TP39_06(:,21),'c');plot(TP39_07(:,21),'m');
% figure(22); hold on; plot(TP39_03(:,22),'b');plot(TP39_04(:,22),'r');plot(TP39_05(:,22),'g');plot(TP39_06(:,22),'c');plot(TP39_07(:,22),'m');
% figure(23); hold on; plot(TP39_03(:,23),'b');plot(TP39_04(:,23),'r');plot(TP39_05(:,23),'g');plot(TP39_06(:,23),'c');plot(TP39_07(:,23),'m');
% figure(24); hold on; plot(TP39_03(:,24),'b');plot(TP39_04(:,24),'r');plot(TP39_05(:,24),'g');plot(TP39_06(:,24),'c');plot(TP39_07(:,24),'m');
% figure(25); hold on; plot(TP39_03(:,25),'b');plot(TP39_04(:,25),'r');plot(TP39_05(:,25),'g');plot(TP39_06(:,25),'c');plot(TP39_07(:,25),'m');
% figure(26); hold on; plot(TP39_03(:,26),'b');plot(TP39_04(:,26),'r');plot(TP39_05(:,26),'g');plot(TP39_06(:,26),'c');plot(TP39_07(:,26),'m');
% figure(27); hold on; plot(TP39_03(:,27),'b');plot(TP39_04(:,27),'r');plot(TP39_05(:,27),'g');plot(TP39_06(:,27),'c');plot(TP39_07(:,27),'m');
% figure(28); hold on; plot(TP39_03(:,28),'b');plot(TP39_04(:,28),'r');plot(TP39_05(:,28),'g');plot(TP39_06(:,28),'c');plot(TP39_07(:,28),'m');
% figure(29); hold on; plot(TP39_03(:,29),'b');plot(TP39_04(:,29),'r');plot(TP39_05(:,29),'g');plot(TP39_06(:,29),'c');plot(TP39_07(:,29),'m');
% figure(30); hold on; plot(TP39_03(:,30),'b');plot(TP39_04(:,30),'r');plot(TP39_05(:,30),'g');plot(TP39_06(:,30),'c');plot(TP39_07(:,30),'m');
% figure(31); hold on; plot(TP39_03(:,31),'b');plot(TP39_04(:,31),'r');plot(TP39_05(:,31),'g');plot(TP39_06(:,31),'c');plot(TP39_07(:,31),'m');
% figure(32); hold on; plot(TP39_03(:,32),'b');plot(TP39_04(:,32),'r');plot(TP39_05(:,32),'g');plot(TP39_06(:,32),'c');plot(TP39_07(:,32),'m');
% figure(33); hold on; plot(TP39_03(:,33),'b');plot(TP39_04(:,33),'r');plot(TP39_05(:,33),'g');plot(TP39_06(:,33),'c');plot(TP39_07(:,33),'m');
% figure(34); hold on; plot(TP39_03(:,34),'b');plot(TP39_04(:,34),'r');plot(TP39_05(:,34),'g');plot(TP39_06(:,34),'c');plot(TP39_07(:,34),'m');
% figure(35); hold on; plot(TP39_03(:,35),'b');plot(TP39_04(:,35),'r');plot(TP39_05(:,35),'g');plot(TP39_06(:,35),'c');plot(TP39_07(:,35),'m');
% figure(36); hold on; plot(TP39_03(:,36),'b');plot(TP39_04(:,36),'r');plot(TP39_05(:,36),'g');plot(TP39_06(:,36),'c');plot(TP39_07(:,36),'m');
% figure(37); hold on; plot(TP39_03(:,37),'b');plot(TP39_04(:,37),'r');plot(TP39_05(:,37),'g');plot(TP39_06(:,37),'c');plot(TP39_07(:,37),'m');
% figure(38); hold on; plot(TP39_03(:,38),'b');plot(TP39_04(:,38),'r');plot(TP39_05(:,38),'g');plot(TP39_06(:,38),'c');plot(TP39_07(:,38),'m');
% figure(39); hold on; plot(TP39_03(:,39),'b');plot(TP39_04(:,39),'r');plot(TP39_05(:,39),'g');plot(TP39_06(:,39),'c');plot(TP39_07(:,39),'m');
% figure(40); hold on; plot(TP39_03(:,40),'b');plot(TP39_04(:,40),'r');plot(TP39_05(:,40),'g');plot(TP39_06(:,40),'c');plot(TP39_07(:,40),'m');
% figure(41); hold on; plot(TP39_03(:,41),'b');plot(TP39_04(:,41),'r');plot(TP39_05(:,41),'g');plot(TP39_06(:,41),'c');plot(TP39_07(:,41),'m');
% figure(42); hold on; plot(TP39_03(:,42),'b');plot(TP39_04(:,42),'r');plot(TP39_05(:,42),'g');plot(TP39_06(:,42),'c');plot(TP39_07(:,42),'m');
% figure(43); hold on; plot(TP39_03(:,43),'b');plot(TP39_04(:,43),'r');plot(TP39_05(:,43),'g');plot(TP39_06(:,43),'c');plot(TP39_07(:,43),'m');
% figure(44); hold on; plot(TP39_03(:,44),'b');plot(TP39_04(:,44),'r');plot(TP39_05(:,44),'g');plot(TP39_06(:,44),'c');plot(TP39_07(:,44),'m');
% figure(45); clf;hold on; plot(TP39_03(:,45),'b');plot(TP39_04(:,45),'r');plot(TP39_05(:,45),'g');plot(TP39_06(:,45),'c');plot(TP39_07(:,45),'m');
% figure(46); hold on; plot(TP39_03(:,46),'b');plot(TP39_04(:,46),'r');plot(TP39_05(:,46),'g');plot(TP39_06(:,46),'c');plot(TP39_07(:,46),'m');
% figure(47); hold on; plot(TP39_03(:,47),'b');plot(TP39_04(:,47),'r');plot(TP39_05(:,47),'g');plot(TP39_06(:,47),'c');plot(TP39_07(:,47),'m');
% figure(48); hold on; plot(TP39_03(:,48),'b');plot(TP39_04(:,48),'r');plot(TP39_05(:,48),'g');plot(TP39_06(:,48),'c');plot(TP39_07(:,48),'m');
% figure(49); hold on; plot(TP39_03(:,49),'b');plot(TP39_04(:,49),'r');plot(TP39_05(:,49),'g');plot(TP39_06(:,49),'c');plot(TP39_07(:,49),'m');
% figure(50); hold on; plot(TP39_03(:,50),'b');plot(TP39_04(:,50),'r');plot(TP39_05(:,50),'g');plot(TP39_06(:,50),'c');plot(TP39_07(:,50),'m');
% figure(51); hold on; plot(TP39_03(:,51),'b');plot(TP39_04(:,51),'r');plot(TP39_05(:,51),'g');plot(TP39_06(:,51),'c');plot(TP39_07(:,51),'m');
% figure(52); hold on; plot(TP39_03(:,52),'b');plot(TP39_04(:,52),'r');plot(TP39_05(:,52),'g');plot(TP39_06(:,52),'c');plot(TP39_07(:,52),'m');
% figure(53); hold on; plot(TP39_03(:,53),'b');plot(TP39_04(:,53),'r');plot(TP39_05(:,53),'g');plot(TP39_06(:,53),'c');plot(TP39_07(:,53),'m');
% figure(54); hold on; plot(TP39_03(:,54),'b');plot(TP39_04(:,54),'r');plot(TP39_05(:,54),'g');plot(TP39_06(:,54),'c');plot(TP39_07(:,54),'m');
% figure(55); hold on; plot(TP39_03(:,55),'b');plot(TP39_04(:,55),'r');plot(TP39_05(:,55),'g');plot(TP39_06(:,55),'c');plot(TP39_07(:,55),'m');
% figure(56); hold on; plot(TP39_03(:,56),'b');plot(TP39_04(:,56),'r');plot(TP39_05(:,56),'g');plot(TP39_06(:,56),'c');plot(TP39_07(:,56),'m');
% figure(57); hold on; plot(TP39_03(:,57),'b');plot(TP39_04(:,57),'r');plot(TP39_05(:,57),'g');plot(TP39_06(:,57),'c');plot(TP39_07(:,57),'m');
% figure(58); hold on; plot(TP39_03(:,58),'b');plot(TP39_04(:,58),'r');plot(TP39_05(:,58),'g');plot(TP39_06(:,58),'c');plot(TP39_07(:,58),'m');
% figure(59); hold on; plot(TP39_03(:,59),'b');plot(TP39_04(:,59),'r');plot(TP39_05(:,59),'g');plot(TP39_06(:,59),'c');plot(TP39_07(:,59),'m');
% figure(60); hold on; plot(TP39_03(:,60),'b');plot(TP39_04(:,60),'r');plot(TP39_05(:,60),'g');plot(TP39_06(:,60),'c');plot(TP39_07(:,60),'m');
% figure(61); hold on; plot(TP39_03(:,61),'b');plot(TP39_04(:,61),'r');plot(TP39_05(:,61),'g');plot(TP39_06(:,61),'c');plot(TP39_07(:,61),'m');
% figure(62); hold on; plot(TP39_03(:,62),'b');plot(TP39_04(:,62),'r');plot(TP39_05(:,62),'g');plot(TP39_06(:,62),'c');plot(TP39_07(:,62),'m');
% figure(63); hold on; plot(TP39_03(:,63),'b');plot(TP39_04(:,63),'r');plot(TP39_05(:,63),'g');plot(TP39_06(:,63),'c');plot(TP39_07(:,63),'m');
% figure(64); hold on; plot(TP39_03(:,64),'b');plot(TP39_04(:,64),'r');plot(TP39_05(:,64),'g');plot(TP39_06(:,64),'c');plot(TP39_07(:,64),'m');
% figure(65); hold on; plot(TP39_03(:,65),'b');plot(TP39_04(:,65),'r');plot(TP39_05(:,65),'g');plot(TP39_06(:,65),'c');plot(TP39_07(:,65),'m');
% figure(66); hold on; plot(TP39_03(:,66),'b');plot(TP39_04(:,66),'r');plot(TP39_05(:,66),'g');plot(TP39_06(:,66),'c');plot(TP39_07(:,66),'m');
% figure(67); hold on; plot(TP39_03(:,67),'b');plot(TP39_04(:,67),'r');plot(TP39_05(:,67),'g');plot(TP39_06(:,67),'c');plot(TP39_07(:,67),'m');
figure(68); hold on; plot(TP39_03(:,68),'b');plot(TP39_04(:,68),'r');plot(TP39_05(:,68),'g');plot(TP39_06(:,68),'c');plot(TP39_07(:,68),'m');
figure(69); hold on; plot(TP39_03(:,69),'b');plot(TP39_04(:,69),'r');plot(TP39_05(:,69),'g');plot(TP39_06(:,69),'c');plot(TP39_07(:,69),'m');
% figure(70); hold on; plot(TP39_03(:,70),'b');plot(TP39_04(:,70),'r');plot(TP39_05(:,70),'g');plot(TP39_06(:,70),'c');plot(TP39_07(:,70),'m');
% figure(71); hold on; plot(TP39_03(:,71),'b');plot(TP39_04(:,71),'r');plot(TP39_05(:,71),'g');plot(TP39_06(:,71),'c');plot(TP39_07(:,71),'m');
% figure(72); hold on; plot(TP39_03(:,72),'b');plot(TP39_04(:,72),'r');plot(TP39_05(:,72),'g');plot(TP39_06(:,72),'c');plot(TP39_07(:,72),'m');
% figure(73); hold on; plot(TP39_03(:,73),'b');plot(TP39_04(:,73),'r');plot(TP39_05(:,73),'g');plot(TP39_06(:,73),'c');plot(TP39_07(:,73),'m');
% figure(74); hold on; plot(TP39_03(:,74),'b');plot(TP39_04(:,74),'r');plot(TP39_05(:,74),'g');plot(TP39_06(:,74),'c');plot(TP39_07(:,74),'m');
% figure(75); hold on; plot(TP39_03(:,75),'b');plot(TP39_04(:,75),'r');plot(TP39_05(:,75),'g');plot(TP39_06(:,75),'c');plot(TP39_07(:,75),'m');
% figure(76); hold on; plot(TP39_03(:,76),'b');plot(TP39_04(:,76),'r');plot(TP39_05(:,76),'g');plot(TP39_06(:,76),'c');plot(TP39_07(:,76),'m');
% figure(77); hold on; plot(TP39_03(:,77),'b');plot(TP39_04(:,77),'r');plot(TP39_05(:,77),'g');plot(TP39_06(:,77),'c');plot(TP39_07(:,77),'m');
% figure(78); hold on; plot(TP39_03(:,78),'b');plot(TP39_04(:,78),'r');plot(TP39_05(:,78),'g');plot(TP39_06(:,78),'c');plot(TP39_07(:,78),'m');
% figure(79); hold on; plot(TP39_03(:,79),'b');plot(TP39_04(:,79),'r');plot(TP39_05(:,79),'g');plot(TP39_06(:,79),'c');plot(TP39_07(:,79),'m');
% figure(80); hold on; plot(TP39_03(:,80),'b');plot(TP39_04(:,80),'r');plot(TP39_05(:,80),'g');plot(TP39_06(:,80),'c');plot(TP39_07(:,80),'m');
% figure(81); hold on; plot(TP39_03(:,81),'b');plot(TP39_04(:,81),'r');plot(TP39_05(:,81),'g');plot(TP39_06(:,81),'c');plot(TP39_07(:,81),'m');
% figure(82); hold on; plot(TP39_03(:,82),'b');plot(TP39_04(:,82),'r');plot(TP39_05(:,82),'g');plot(TP39_06(:,82),'c');plot(TP39_07(:,82),'m');
% figure(83); hold on; plot(TP39_03(:,83),'b');plot(TP39_04(:,83),'r');plot(TP39_05(:,83),'g');plot(TP39_06(:,83),'c');plot(TP39_07(:,83),'m');
% figure(84); hold on; plot(TP39_03(:,84),'b');plot(TP39_04(:,84),'r');plot(TP39_05(:,84),'g');plot(TP39_06(:,84),'c');plot(TP39_07(:,84),'m');
% figure(85); hold on; plot(TP39_03(:,85),'b');plot(TP39_04(:,85),'r');plot(TP39_05(:,85),'g');plot(TP39_06(:,85),'c');plot(TP39_07(:,85),'m');
% figure(86); hold on; plot(TP39_03(:,86),'b');plot(TP39_04(:,86),'r');plot(TP39_05(:,86),'g');plot(TP39_06(:,86),'c');plot(TP39_07(:,86),'m');
% figure(87); hold on; plot(TP39_03(:,87),'b');plot(TP39_04(:,87),'r');plot(TP39_05(:,87),'g');plot(TP39_06(:,87),'c');plot(TP39_07(:,87),'m');
% figure(88); hold on; plot(TP39_03(:,88),'b');plot(TP39_04(:,88),'r');plot(TP39_05(:,88),'g');plot(TP39_06(:,88),'c');plot(TP39_07(:,88),'m');
% figure(89); hold on; plot(TP39_03(:,89),'b');plot(TP39_04(:,89),'r');plot(TP39_05(:,89),'g');plot(TP39_06(:,89),'c');plot(TP39_07(:,89),'m');
% figure(90); hold on; plot(TP39_03(:,90),'b');plot(TP39_04(:,90),'r');plot(TP39_05(:,90),'g');plot(TP39_06(:,90),'c');plot(TP39_07(:,90),'m');
% figure(91); hold on; plot(TP39_03(:,91),'b');plot(TP39_04(:,91),'r');plot(TP39_05(:,91),'g');plot(TP39_06(:,91),'c');plot(TP39_07(:,91),'m');



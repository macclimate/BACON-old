function [] = mcm_ACSfixer(year, site)
num_ch = 8;
auto_flag =0;
ls = addpath_loadstart;
%%%%%%%%%%%%%%%%%
if nargin == 1
    site = year;
    year = [];
end
[year_start year_end] = jjb_checkyear(year);

if ischar(site) == false
    site = num2str(site);
end
%%%%%%%%%%%%%%%%%

%%% Declare Paths:
load_path = [ls 'Matlab/Data/Flux/ACS/' site '/Cleaned/'];
output_path = [ls 'Matlab/Data/Flux/ACS/' site '/Final_Cleaned/'];
jjb_check_dirs(output_path,0);
% header_path = [ls 'Matlab/Data/Flux/CPEC/Docs/'];
header_path = [ls 'Matlab/Config/Flux/ACS/']; % Changed 01-May-2012
met_path = [ls 'Matlab/Data/Met/Final_Cleaned/' site '/'];
% Load Header:
% header_old = jjb_hdr_read([header_path 'mcm_CPEC_Header_Master.csv'], ',', 3);
% header_tmp = mcm_get_varnames(site);
header_tmp = mcm_get_fluxsystem_info(site, 'varnames');

t = struct2cell(header_tmp);
t2 = t(2,1,:); t2 = t2(:);
% Column vector number
col_num = (1:1:length(t2))';
header = mat2cell(col_num,ones(length(t2),1),1);
header(:,2) = t2;%er_old = jjb_hdr_read([header_path 'mcm_CPEC_Header_Master.csv'], ',', 3);

% Title of variable
var_names = char(header(:,2));
num_vars = max(col_num);

%% Main Loop

for year_ctr = year_start:1:year_end
close all
yr_str = num2str(year_ctr);
    disp(['Working on year ' yr_str '.']);
% Load data:
load([load_path site '_ACS_clean_' yr_str '.mat' ]);
input_data = master.data; clear master;
output = input_data;
    
  
%% %%%%%%%%%%%%%%%% Do Automated Cleans to the data

right_cell = find(strcmp('dcdt',header(:,2))==1);
efflux_cell = find(strcmp('efflux',header(:,2))==1);
% % % % [r c] = find(output{right_cell}(:,:)==0);

% % % % output{right_cell}(r,c) = NaN;
% % % % output{efflux_cell}(r,c) = NaN;

% 1. Remove the 17th point of each day from all data (CPU restart at 8:05 UTC or 3:05am EST):
for i = 1:1:size(output,2)    
output{i}(17:48:end,:) = NaN;
end

% 2. remove dcdt and efflux data when dcdt == 0:

for j = 1:1:8
output{right_cell}(output{right_cell}(:,j)==0,j) = NaN;
output{efflux_cell}(output{right_cell}(:,j)==0,j) = NaN;   

% Remove when bad data is exactly -1.249 e-14:
output{right_cell}(output{right_cell}(:,j)>=-1e-11 & output{right_cell}(:,j)<=1e-11,j) = NaN;
output{efflux_cell}(output{efflux_cell}(:,j)>=-1e-11 & output{efflux_cell}(:,j)<=1e-11,j) = NaN;

num_good(1,j) = length(find(~isnan(output{efflux_cell}(:,j))));
end

% 3. Filter efflux by RMSE? 
rmse_cell = strcmp('rmse',header(:,2))==1;

for j = 1:1:8
output{efflux_cell}(output{rmse_cell}(:,j)>1,j) = NaN; % <---------- ROB EDIT THIS
output{right_cell}(output{rmse_cell}(:,j)>1,j) = NaN; % <---------- ROB EDIT THIS
num_good2(1,j) = length(find(~isnan(output{efflux_cell}(:,j))));
end

% [r c] = find(output{rmse_cell}(:,:)> 1);
% output{efflux_cell}(r,c) = NaN; % <---------- ROB EDIT THIS


    



%%%%%%%%%%%%%%%% Code to investigate RMSE/dcdt ratio (and potential
%%%%%%%%%%%%%%%% cleaning) -- uncomment to run %%%%%%%%%%%%%%%%%%%%%
% rmse_dcdt = output{rmse_cell}./output{right_cell};
% figure(10);clf;
% plot(rmse_dcdt); legend(num2str((1:8)'));
% axis([0 18000 -1 10])
% 
% figure(11);clf;
% subplot(211); plot(output{rmse_cell}); ylabel('RMSE');
% subplot(212); plot(output{right_cell});ylabel('dcdt');
% legend(num2str((1:8)'));
% axis([0 18000 -1 1])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Step 1: Cycle through all variables so the investigator can look at the
%%% data closely

% j = 1;
commandwindow;
resp3 = input('Do you want to scroll through variables before fixing? <y/n> ', 's');
if strcmpi(resp3,'y') == 1
        k = 1;
        while k <=num_vars
        j = 1;
        while j <= num_ch
            temp_var = output{k}(:,j);
            figure(1)
            clf;
            plot(temp_var);
            hold on;
            title([var_names(k,:) '(cell) = ' num2str(k) ', Chamber (column) = ' num2str(j)]);
            grid on;
            
            %% Gives the user a chance to change the thresholds
            if auto_flag == 1
                response = 'q';
            else
                response = input('Press enter to move forward, enter "1" to move backward, q to go straight to cleaning: ', 's');
            end
                     
            if isempty(response)==1
                j = j+1;
                
            elseif strcmp(response,'1')==1 && j > 1;
                j = j-1;
            elseif strcmp(response,'q')==1
                j = num_ch+1;
                k = num_vars+1;
            else
                j = 1;
            end
        end
        clear j response accept
        k=k+1;
        end

text(0,0,'Make changes in program now (if necessary) -exit script'); 
else
end

       

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Step 2: Specific Cleans to the Data

%%%%%%%%%%%%%% TP39 Chamber %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch site
    case 'TP39_chamber'
     switch yr_str
         case '2008'%Removing bad data based on Emily's notes in her "clean_all_efflux_data_EN.m" file
             output{6}([4780:4800 6800:8916 9344:9395 9454:9547 9642:9645 9870:9882 10444:10452 10504 10547:10572 11020 11538:11539 12314 13812 14268:14619 15816:15858 16972:17517 ],1) = NaN;
             output{6}([6800:8915 9345:9395 9454:9547 9870:9882 10504 10547:10572 11020 12313:12314 13812 14268:14619 15480:15490 15816:15858 16493:16520 16972:17420 17421:17459 17490:17515 ],2) = NaN;
             output{6}([4780:4800 6800:8915 9343:9395 9454:9547 9870:9882 10444:10452 10500:13954 13956 14265:14619 14780 15488 15816:15858 16493:16520 16972:17517 ],3) = NaN;
             output{6}([6800:8915 9343 9345:9395 9454:9547 9870:9882 10444:10452 10504 11020 11367 12267 13812 14268:14619 15816:15858 16972:17517 ],4) = NaN;
         case '2009'%Removing bad data based on Emily's notes in her "clean_all_efflux_data_EN.m" file
             output{6}([3453 816:900 339:372 479:708 2745:2747 3175:3179 3443:3445 6150:6155 6625:6635 6831:6834 7153:7158 7303:7371 7640:7650 8152:8163 8184:8200 8285:8287 8437:8452 9742:9777 8794:9813 9872:9881 10070:10073 10248:10255 10597:10601 10673:10690 11207:11218 11408:11422 11525:11796 12005:12010 14957:14958 15826:17520 390:419 530:730 869:870 880:1900 2794 6200 6660:6795 6880 7202:7206 7350:7430 7688:7691 8330:8384 8859 10120 10611 10723 11257 13893 15866:17568 ],1) = NaN;
             output{6}([339:372 480:700 821:1860 1957:1958 2682:2740 6627:6746 7307:7371 8285:8335 9760:9800 14747:15795 390:419 530:730 869:870 880:1900 2725:3486 6660:6795 7350:7430 7814 8330:8384 8859 10120 10611 10723 11257 11835:11836 13893 14799:15879 15866:15879 17063:17105 ],2) = NaN;
             output{6}([341:371 3403:3439 6621:6746 7302:7371 11787:11788 382 390:419 530:1880 1739:1740 1908 2997:3005 5978 6660:6795 7350:7430 8330:8384 9577:9605 10120 10611 10723 11257 13893 13946:13952 15866:15879 17063:17568 ],3) = NaN;
             output{6}([607:707 3406:3440 6624:6746 7305:7371 7765:7766 8284:8335 8451:8452 10399:10401 13845:13846 14957:14958 17520:17568 390:419 1560:1900 2993 3000:3003 6660:6795 7350:7430 8330:8384 8499 9934 10120 10448 10611 10723 11257 13893 15866:15879 17063:17105 ],4) = NaN;
             output{6}([6614:6750 7453:7457 7640:7766 8273:8336 13845:13847 13896:13898 15825:15828 16762 17520:17568 390:419 6660:6795 6792:7425 7350:7430 7501:7505 7688 7690 8330:8384 8782 8867 8974:8975 9262:9271 9434:9684 10120 10611 10723 11257 11835:11836 11844 13893 13945 15005 15866:15879 16810 17063:17105 ],5) = NaN;
             output{6}([7050:7059 6610:6915 7289:7766 8274:8340 8412:8762 15826:15828 16499:16596 16768:16824 17113:17115 17395:17413 17520:17568 390:419 6660:6867 6894:6962 6995:7014 7100:7108 7252 7340:7690 7837:7920 8330:8384 8458:8782 8859 8868 10120 10611 10723 11257 11845 13893 15866:15879 16551:16581 16603:16604 16620:16621 16880 17063:17105 ],6) = NaN;
         case '2010'%Removing bad data based on Emily's notes in her "clean_all_efflux_data_EN.m" file
             output{6}([390:489 2156:2332 2619:3060 3616:3728 4880:4893 5105:5360 5553:5613 6014:6015 6099:6100 6230:6240 6556:6558 6125 9248:9256 9970:9972 10155:10156 12572:12604 13344 14161:14266 16607:16608 17419 2185:2186 2660:3275 2860:2880 3670:3775 4760:4880 4925:4940 5160:5410 5603:5657 6148 6604 9299:9303 12625:12653 13392 ],1) = NaN;
             output{6}([5418:5419 5058:5065 2610:3125 3612:3730 4613:4900 5105:5400 5554:5614 6231:6233 6556:6557 7569:7570 8751:8753 9172:9293 12063 12576:12673 13326 14160:14288 14516:14521 16607:16608 17154:17467 2380:2382 2660:3275 3670:3775 4660:4916 4925:4940 5160:5410 5603:5657 7616:7618 9220:9340 9773:9775 12111 12625:12653 ],2) = NaN;
             output{6}([19:40 3608:3727 5102:5360 5554:5618 11815 12571:12606 14016:14288 16607:16608 16842:17520 48:67 477 490 1450:1471 2050:2380 2660:3275 2580:2583 3670:3775 3978 4760:4880 4925:4940 5160:5410 5603:5657 5660:10749 10710:11035 12625:12653 13467 ],3) = NaN;
             output{6}([9579:9632 379:506 2615:3060 3616:3727 4875:4893 5105:5360 5554:5612 6230:6242 6556:6557 9090:9455 12166 12572:12604 14017:14289 16607:16608 2660:3275 3670:3775 4760:4880 4925:4940 5160:5410 5603:5657 9220:9470 9773:9775 12353 12625:12653 ],4) = NaN;
             output{6}([2616:3060 3617:3728 3615:3727 4716:4893 5108:5359 5555:5611 6220:6242 7560:7570 7784 12209 12586:12604 14020:14287 16607:16608 2660:3275 3670:3775 4760:4880 4925:4940 5160:5410 5603:5657 7616:7618 9773:9775 12057 12625:12653 ],5) = NaN;
             output{6}([72:131 405:466 1345:1472 1788:1809 2624:3180 3612:3724 4879:4894 5105:5360 5553:5611 6230:6243 6555:6557 7910 8621 11230:13136 14016:14288 16607:16608 2660:3275 3670:3775 4760:4880 4925:4940 5156:5158 5160:5410 5603:5657 7616:7618 9773:9775 11280:11620 11621:13135 12625:12653 ],6) = NaN;
             output{6}([5600:6600 9247:9256 9722:9727 12287:12293 12574:12604 13157 14020:14288 16607:16608 2660:3275 3670:3775 4760:4880 4925:4940 5160:5410 5603:5657 5790:6610 7616:7618 9300 9773:9775 12338 12340 12348 12625:12653 13205 ],7) = NaN;
             output{6}([6230:10990 12453:13426 14020:14288 16607:16608 16840:17421 17450:17494 2660:3275 3670:3775 4760:4880 4925:4940 5160:5410 5603:5657 6280:10749 10710:11035 12510:13467 ],8) = NaN;
         case '2011'
             output{6}([172:497 850:1144 2714:3160 3205 4072 5118 5155:5224 8130 9913 10239 11686 12498:13009 15359:17520],1) = NaN;
             output{6}([5150:5226 4934 4976:4979 237:275 334:1147 2899:3160 3472:3531 3911 7084 10004:10796 10896:11884 12054:12063 12505:12996 14160:17520 ],2) = NaN;
             output{6}([112:472 852:1113 2628:2961 3470:4174 5150:5226 5510:5607 5654 5963:5988 7576:7909 10050:10097 10840:11055 11140:11240 11332:12087 12496:12996 14160:17520 ],3) = NaN;
             output{6}([5150:5226 703:1144 2773:2816 3007:3045 3073 3742:3775 3911 4173 5118 7084 10051 11686 12495:12996 14160:17520 ],4) = NaN;
             output{6}([328:472 916:982 2899:3162 3911 4465:4549 4788:4979 5118 5152:5226 5662 7084 10799:10858 10887:11784 12282:17520 ],5) = NaN;
             output{6}([362:472 916:982 2682:7000 7084 7685:7720 10051 10958 12494 12392 12500:13005 14160:17520 ],6) = NaN;
             output{6}([5214 4470:4546 4030 4012 3974 3961 3904 3868 3648 3633 3714 3728 3734 5150:5226 2898:3154 3359:3394 4100:4165 4790:4983 5662 7084 11051 12500:13005 14160:17520 ],7) = NaN;
             output{6}([4465:4546 3204 2848:2866 2792:2973 2776 3600:4166 169:472 885:1106 1136:1144 3472:3635 3911 4783:4983 5118 5152:5226 5599:5610 7084 9423 11686 12500:13005 14160:17520 ],8) = NaN;
         case '2012'
             output{6}([15460:1550 5792:5850 6365:6518 8620 10875:10880 14625:14867 15500:16500 17400:17520 ],1) = NaN;
             output{6}([14629:14868 5649:5852 5892:6233 6270:6287 6314:6529 7000:7524 9005 9895 10412:10415 ],2) = NaN;
             output{6}([5792:5851 6363:6517 9005 14200:14578 14625:14866 15245:16080 16260:17520 ],3) = NaN;
             output{6}([4842 5796:5850 6368:6519 7650 10411:10416 10881 11100:11300 11598 14627:14866 15800:16500 ],4) = NaN;
             output{6}([15460:15500 13500:13700 4463:4467 4625:4633 5733 5798:5850 6313:6325 6350:7530 9005 10411:10416 10881 11598 14577 14629:14866 15500:16800 ],5) = NaN;
             output{6}([13500:13700 5804:5852 6383:6518 10411:10416 10880:10883 11598 11683:12605 14629:14866 15500:16800 ],6) = NaN;
             output{6}([5798:5849 5984 8179 10411:10416 14629:14866 15500:16800 ],7) = NaN;
             output{6}([14625:14630 5794:5849 6366:6517 10411:10416 12200:12600 14629:14866 15500:16800 ],8) = NaN;
         case '2013'
             output{6}([1483:1730 5808:14160 14500:14565 14710:14790 15090:15110 15441:15537 15810:15836 15946:16215 16806:16838 ],1) = NaN;
             output{6}([729:730 5808:14160 15091:15110 15835:15847 ],2) = NaN;
             output{6}([748:750 5808:14160 14350:14850 15094:15104 15379 15725:15835 15946:16215 17427:17520 ],3) = NaN;
             output{6}([1491:1728 3005:3010 5808:14160 14500:14586 15742:15769 16571:16839 ],4) = NaN;
             output{6}([14616 695:700 1800:2200 2630:2800 6436:6470 9400:9760 11300:11460 12264:13145 13500:14150 15096:15106 15143:15161 15444:15500 15700:16300 16802:16837 ],5) = NaN;
             output{6}([16077:16097 16069 16048 16035 2663 2666 3909:3919 3992 4026 5238 5234 5223 2663 600:800 1200:1400 1569:1800 2200:2620 5189:5192 6434:6469 7760:7761 14500:15110 15450:15500 15700:15858 15950:16021 16114:16216 ],6) = NaN;
             output{6}([2660 2780 2989 3909 4183 5808:14160 15012 15792 ],7) = NaN;
             output{6}([1483:1595 5808:14160 14345:14835 15089:15111 16216 15448:15500 15724:15838 15946 16716:16836],8) = NaN;
         case '2014'
             output{6}([17482:17520 100:132 180 452 460:465 472 475 478 502 504 509 510 512 514 518 534 535 538 805:807 866:880 1180:1200 1260:1320 1700:1750 2930 2985 4322:4329 4810:5056 5354:5656 6123:6133 6242:6400 6694:6716 7250 7379 7380 8312 8500:8900 11403:11406 12018:12365 13315:13320 15480:15634 15752 ],1) = NaN;
             output{6}([17482:17520 180 452 452 460:465 472 475 478 502 504 509 510 512 514 518 534 535 538 805:807 3344 4800:5035 5352:5660 6242:6400 6690:6715 6960:10400 10780:12714 13690:13950 14050:14500 15505:15642 15752 17500:17504 ],2) = NaN;
             output{6}([9680:9700 1:75 185:600 868:872 1127 1128 1150:3000 2020:2022 2097 2868 3109 3155 3164:3184 3366:3370 4017 4506 4507 4710:4720 5352:5665 5747:6690 6735:7098 7247:7725 7779:8240 8395:8485 8625:9482 9522 9526 9529 9550:9570 9682 9685 9742:9753 9805:9806 9810:9811 9815:9820 10886:10910 11079:11100 11115:11121 11126 11278:11281 11343 11398:11511 11695:12706 13780 13785 13828 13922 14071 14208 14306:14307 14379 14457 15680:15702 15752 15782 16009 17483:17506 17511 17513 ],3) = NaN;
             output{6}([15400:17400 116 200:600 866:867 2382:2886 4000:7381 7867 7900 7939 7941 7944:7945 7949 7973 7976 8760:8860 9813 9872:10119 11419:11511 12024:12365 12629:12630 13758 13780:13785 13923 13928 14306:14307 14370:14395 14429:14445 14600:14950 15100:15200 15483:15714 15752 15985 16189 16200 ],4) = NaN;
             output{6}([105 200:600 3154:3690 4700:5000 4814:5036 5355:5657 6123:6134 6242:6400 6402:6474 6537:6553 6697:8450 7000:9449 10161:14000 11596 11626 11695 11713 12333 12600:12650 13785 13923 13928 15529 15616 15752 15781 ],5) = NaN;
             output{6}([16000:16300 114 129 200:600 830:851 1001 2114 2118 2124 2254 2256 4700:5000 5355:5657 5845 5846 6242:6717 6242:6400 7544:7636 7661:8615 8641:10064 10100:10111 10132:14000 7314 7319 7650 7733 7801 11634 11638 11642 13400:13812 14775 15416:15420 15440:15460 15486:15489 15663 15667 15669 15832 16194 16196 16199 16228 17475:17480 17503:17520 ],6) = NaN;
             output{6}([15400:15630 17477:17507 4700:5000 6242:6400 9447 11419:11511 12024:12365 50:200 200:600 1260:1320 2218:2225 2257 2265 2299:2305 2320:2370 2375:2382 2686 2716:2720 3050 3148 3165 3321:3325 3341 3352 3354 4975 5346:5656 6125:6134 6696:6715 15505:15563 15583:15587 15752 15781 ],7) = NaN;
             output{6}([15408 16180:16225 17482:17520 4700:5000 6242:6400 7000:10061 10122:12706 12862:14000 16:200 200:600 867 1160:1400 2382:2600 3154:3690 3850:3900 3894:4040 4367:8190 9100:9750 10579 11490:11503 11528:11552 11889 11892 11952:11958 11961 12002:12026 12032 12075:12085 15028 15427 15481:15667 15697:15700 15711 15752 15781 ],8) = NaN;
         case '2015'       
         case '2016'         
         case '2017'         
         case '2018'      

end
          
            
%% Plot corrected/non-corrected data to make sure it looks right:
figure(4);

 k = 1;
        while k <=num_vars
        j = 1;
        while j <= num_ch
%             temp_var = output{k}(:,j);
%             figure(1)
%             clf;
%             plot(temp_var);
%             hold on;
%             title([var_names(k,:) ', Chamber ' num2str(j)]);
%   
figure(4);clf;
plot(input_data{k}(:,j),'r'); hold on;
plot(output{k}(:,j),'b');
grid on;
title([var_names(k,:) ', column no: ' num2str(j)]);
legend('Data Removed', 'Data Kept');
grid on;
            
            %% Gives the user a chance to change the thresholds
            if auto_flag == 1
                response = 'q';
            else
                response = input('Press enter to move forward, enter "1" to move backward, q to skip all: ', 's');
            end
                     
            if isempty(response)==1
                j = j+1;
                
            elseif strcmp(response,'1')==1 && j > 1;
                j = j-1;
            elseif strcmp(response,'q')==1
                j = num_ch+1;
                k = num_vars+1;
            else
                j = 1;
            end
        end
        clear j response accept
        k=k+1;
        end


% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Compare with met data to shift data appropriately to UTC if necessary:
% 
% % %%% Set overrides for shifts here, or remove data points, or make shifts:
% switch site
%     case 'TP74'
%         shift_override = [];
%     case 'TP89'
%         shift_override = [];
%     case 'TP02'
%         shift_override = [];
% end
% 
% %%% Load the met wind speed data (to be used for comparison):
% met = load([met_path site '_met_cleaned_' yr_str '.mat']);
% MET_DAT = met.master.data(:,mcm_find_right_col(met.master.labels,'WindSpd'));
% u = output(:,mcm_find_right_col(var_names,'u')); v = output(:,mcm_find_right_col(var_names,'v'));
% CPEC_DAT = sqrt(u.^2 + v.^2); clear u v;
% u_orig = input_data(:,mcm_find_right_col(var_names,'u')); v_orig = input_data(:,mcm_find_right_col(var_names,'v'));
% CPEC_ORIG = sqrt(u_orig.^2 + v_orig.^2); clear u_orig v_orig;
% 
% num_lags = 16; 
% win_size = 500; % one-sided window size 
% increment = 100;
% 
% [pts_to_shift] = mov_window_xcorr(MET_DAT, CPEC_DAT, num_lags,win_size,increment);
% 
% %%% Plot the unshifted timeseries, along with Met data
% close(findobj('Tag','Pre-Shift'));
% figure('Name','Data_Alignment: Pre-Shift','Tag','Pre-Shift');
% figure(findobj('Tag','Pre-Shift'));clf;
% plot(MET_DAT,'b');hold on;
% plot(CPEC_ORIG,'Color',[0.8 0.8 0.8]);
% plot(CPEC_DAT,'Color',[1 0 0]);
% % plot(shifted_master(:,find_right_col(master.labels,'u_mean_ms-1')),'g');
% legend('Met WSpd', 'Orig CPEC WSpd', 'Corrected CPEC WSpd');%, 'Orig EdiRe WSpd',  'Corrected EdiRe WSpd');
% grid on;
% set(gca, 'XMinorGrid','on');
% 
% disp('Investigate Data Alignment through attached figure ');
% disp(' and by looking at output of this function.  Fix if needed.');


%% Output
% Here is the problem with outputting the data:  Right now, all data in
% /Final_Cleaned/ is saved with the extensions corresponding to the
% CCP_output program.  Alternatively, I think I am going to leave the output
% extensions the same as they are in /Organized2 and /Cleaned3, and then
% re-write the CCP_output script to work on 2008-> data in a different
% manner.


continue_flag = 0;
while continue_flag == 0;
    commandwindow;
    resp2 = input('Are you ready to print this data to /Final_Cleaned? <y/n> ','s');
    if strcmpi(resp2,'n')==1
        continue_flag = 1;
        
    elseif strcmpi(resp2,'y')==1
        continue_flag = 1;
        for i = 1:1:num_vars
            for j = 1:1:num_ch
                temp_var = output{i}(:,j);
                save([output_path site '_' yr_str '.C' num2str(j) '_' char(header{i,2})], 'temp_var','-ASCII');
                %         save([fill_path site '_' year '.' vars30_ext(i,:)], 'temp_var','-ASCII');
            end
        end
        master(1).data = output;
        master(1).labels = var_names;
        save([output_path site '_ACS_cleaned_' yr_str '.mat' ], 'master');
        
    else
        continue_flag = 0;
    end
end
commandwindow;
junk = input('Press Enter to Continue to Next Year');
end
end
mcm_start_mgmt;
end
%subfunction
% Returns the appropriate column for a specified variable name
function [right_col] = quick_find_col(names30_in, var_name_in)

right_col = find(strncmpi(names30_in,var_name_in,length(var_name_in))==1);
end
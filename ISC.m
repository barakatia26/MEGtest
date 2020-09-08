
function [ISC]=ISC
clear all
Q1 = menu ('Pick the desired condition',...
    'Charism','Dull','Open','Closed','Room','Silent');
switch Q1
    case 1
        cond='charism';
        trialsNum = 300;
    case 2
        cond='dull';
        trialsNum = 280;
    case 3
        cond='open';
        trialsNum=240;
    case 4 
        cond='closed';
        trialsNum=240;
    case 5
        cond='room';
        trialsNum=300;
    case 6
        cond='silent';
        trialsNum=300;
end

 Q2 = menu ('Pick the desired wave range? ',...
    'Alpha(8-12Hz)','Beta(13-25Hz)','Gamma(26-40Hz)','Theta(4-8Hz)','Delta(1-4Hz)','Select All(1-40Hz)');
switch Q2
        case 1
            frqBand = [8:12];
        case 2
            frqBand = [13:25];
        case 3
            frqBand = [26:40];
        case 4
            frqBand = [4:8];
        case 5
            frqBand = [1:4];
        case 6
            frqBand = [1:40];   
end

condition=['Fr_' (cond)];

for i=[1:40];
path = ['/media/megadmin/Carisma/Charisma/char_' num2str(i) '/0.14d1/date/1'];
cd(path);
subI = load ('FrqAnalysis1',(condition));
clear badpairs1 
badpairs1 = subI.(condition).badtrials;

powsub1 = sum (subI.(condition).powspctrm(:,:,frqBand),3);
clear Fr_closed
for j=[1:40];
    path = ['/media/megadmin/Carisma/Charisma/char_' num2str(j) '/0.14d1/date/1'];
cd(path);
subJ = load ('FrqAnalysis1',(condition));
badtrials=[badpairs1, subJ.(condition).badtrials];
powsub2 = sum (subJ.(condition).powspctrm(:,:,frqBand),3);
clear Fr_closed
badtrials=unique(badtrials);
str = sprintf ('Performing correlation of sub %d with %d',i,j);
disp (str)
for sen=1:248;  
    
    %this part try to find unique trials with one less time bin and add the
    %last time bin to the bad trials.
trials1 = size (subI.(condition).powspctrm,1);
trials = size (subJ.(condition).powspctrm,1);
 if (trials1 == 279) || (trials ==279);
     badtrials=[badtrials, 280];
     badtrials=unique(badtrials);
 elseif (trials1 == 299) || (trials ==299);
          badtrials=[badtrials, 300];
     badtrials=unique(badtrials);
 end

corr_vec1=(powsub1(:,sen));
corr_vec1=corr_vec1(find(not(ismember([1:trials],badtrials))));
corr_vec2=(powsub2(:,sen));
corr_vec2=corr_vec2(find(not(ismember([1:trials],badtrials))));

ISC(sen,i,j)=corr(corr_vec1,corr_vec2);
end 
end
end
answer = questdlg ('Do you want to save the variable? ',...
    'Save Correlation Map',...
    'Yes','No','No');
switch answer
    case 'Yes'
        pathtosave = cell2mat(inputdlg('Enter the path of the desired location:', ' Save Correlation Map ', [1 50]));
        cd (pathtosave)
save ((cond),'ISC','-v7.3');
end

end

clear all
path = '/Volumes/Carisma/Charisma';
sub_list=dir(path);

for i=33:52
cd ([path '/' sub_list(i).name '/0.14d1/date/1']);
delete 'dataorig.mat' 'badtrials.mat' 'Conditions.mat' 'Conditions1.mat' 'FrqAnalysis.mat' 'FrqAnalysis1.mat'
disp (sub_list(i).name);

delete dataorig.mat FreqAnalysis.mat FrqAnalysisNew.mat Conditions.mat

timewin = 1; %input ('Set time window (Seconds):');
sampwin=1017.25*timewin;
ovrlp=1017.25*timewin/2;

if exist ('xc,hb,lf_c,rfhp0.1Hz')
source='xc,hb,lf_c,rfhp0.1Hz';
else
    source='hb,xc,lf_c,rfhp0.1Hz';
end
trigVal=[202 204 220 230 240 250;202 204 240 230 220 250];
cond={'closed','open','charism','room','dull','silent'};

%read the trigger channel

p = pdf4D(source);
trig=readTrig_BIU(p);
trig=bitset(uint16(trig),12,0);
trig=bitset(uint16(trig),9,0);
unique (trig)
trigSamp=trigOnset(trig);
trigSamp(2,:)=trig(trigSamp);
TRL=[];


%creates the trl struct
    for condi=1:length(trigVal)
        condSamp=trigSamp(1,find(trigSamp(2,:)==trigVal(1,condi)));
        if length(condSamp)==1
            condSamp(2)=condSamp(1)+round(1017.25*121);
        end
        trl1=condSamp(1):sampwin:condSamp(2);
        trl2=(condSamp(1)+ovrlp):sampwin:condSamp(2);
        trl=round(sort([trl1';trl2']));
        trl(:,2)=trl+round(sampwin)-1;
        trl(:,3)=0;
        trl(:,4)=trigVal(1,condi);
        trl=trl(1:end-2,:);
TRL((size(TRL,1)+1):(size(TRL,1)+size(trl,1)),1:4)=trl;
    end
    
    %creates dataorig file
        cfg=[];
    cfg.trl=TRL;
    cfg.dataset=source;
    cfg.demean='yes';
    cfg.channel='MEG';
    cfg.feedback='no';
dataorig=ft_preprocessing(cfg);

save 'dataorig' 'dataorig'

save ('dataorig','dataorig','-v7.3')
disp('saving the file...')
cd('..')

clear dataorig
clear source
clear trigSamp
end



%%



clear all
path = '/Volumes/Carisma/Charisma';
sub_list=dir(path);
% divide into different conditions and mark bad trials. 
for i=[13:31 33:52]
cd ([path '/' sub_list(i).name '/0.14d1/date/1']);

disp (i)
delete ('Conditions.mat');

    load ('dataorig.mat');
    
    z=1;
for u=[202 204 220 230 240 250]
 numOftrials(z,:) = length(find(dataorig.trialinfo==(u)));
 z=z+1;
end

cond = {'202';'204';'charism';'230'; 'dull';'250'};
T1 = table(cond,numOftrials)
    
if T1{3,2} == 300
    
cfg=[];
cfg.trials = find (dataorig.trialinfo(:,1)==220);
charism= ft_redefinetrial (cfg, dataorig);

cfg=[];
        cfg.method='abs';
        cfg.criterion='sd';
        cfg.critval=3.5;
        close all                                                
        [good,bad]=badTrials(cfg,charism);
        
charism.badtrials = bad;

cfg=[];
cfg.trials = find (dataorig.trialinfo(:,1)==240);
dull= ft_redefinetrial (cfg, dataorig);

cfg=[];
        cfg.method='abs';
        cfg.criterion='sd';
        cfg.critval=3.5;
        close all
        [good,bad]=badTrials(cfg,dull);
        
dull.badtrials = bad;

    elseif T1{3,2} == 280
        cfg=[];
cfg.trials = find (dataorig.trialinfo(:,1)==240);
charism= ft_redefinetrial (cfg, dataorig);

cfg=[];
        cfg.method='abs';
        cfg.criterion='sd';
        cfg.critval=3.5;
        close all                                                
        [good,bad]=badTrials(cfg,charism);
        
charism.badtrials = bad;

cfg=[];
cfg.trials = find (dataorig.trialinfo(:,1)==220);
dull= ft_redefinetrial (cfg, dataorig);

cfg=[];
        cfg.method='abs';
        cfg.criterion='sd';
        cfg.critval=3.5;
        close all
        [good,bad]=badTrials(cfg,dull);
        
dull.badtrials = bad;

else
    disp ('Eroor!!!')
    break
end



cfg=[];
cfg.trials = find (dataorig.trialinfo(:,1)==250);
silent= ft_redefinetrial (cfg, dataorig);

cfg=[];
        cfg.method='abs';
        cfg.criterion='sd';
        cfg.critval=3.5;
        close all
        [good,bad]=badTrials(cfg,silent);
        
silent.badtrials = bad;

cfg=[];
cfg.trials = find (dataorig.trialinfo(:,1)==202);
closed= ft_redefinetrial (cfg, dataorig);

cfg=[];
        cfg.method='abs';
        cfg.criterion='sd';
        cfg.critval=3.5;
        close all
        [good,bad]=badTrials(cfg,closed);
        
closed.badtrials = bad;


cfg=[];
cfg.trials = find (dataorig.trialinfo(:,1)==204);
open= ft_redefinetrial (cfg, dataorig);

cfg=[];
        cfg.method='abs';
        cfg.criterion='sd';
        cfg.critval=3.5;
        close all
        [good,bad]=badTrials(cfg,open);
        
open.badtrials = bad;

cfg=[];
cfg.trials = find (dataorig.trialinfo(:,1)==230);
room= ft_redefinetrial (cfg, dataorig);

cfg=[];
        cfg.method='abs';
        cfg.criterion='sd';
        cfg.critval=3.5;
        close all
        [good,bad]=badTrials(cfg,room);
        
room.badtrials = bad;




Conditions = [];
Conditions.room=[room];
Conditions.open = [open];
Conditions.closed = [closed];
Conditions.silent = [silent];
Conditions.dull=[dull];
Conditions.charism = [charism];
% 
% 
save ('Conditions', 'Conditions', '-v7.3');
clear cfg 
close all
clear charism open room silent dull closed


    

end


%% Freq analysis


clear all
path = '/Volumes/Carisma/Charisma';
sub_list=dir(path);
% divide into different conditions and mark bad trials. 
for i=[13:52] %length (sub_list)
    disp(i)
cd ([path '/' sub_list(i).name '/0.14d1/date/1']);
load ('Conditions.mat');
    cfg=[];
    cfg.output       = 'pow';
    cfg.channel      = 'MEG';
    cfg.method       = 'mtmfft';
    cfg.taper        = 'hanning';
    cfg.foi          = 1:40;
    cfg.feedback='no';
    %cfg.trials=good;
    cfg.keeptrials='yes';
   cfg.output    = 'powandcsd';
Fr_open = ft_freqanalysis(cfg, Conditions.open);
Fr_open.badtrials = open.badtrials;
Fr_closed = ft_freqanalysis(cfg, closed);
Fr_closed.badtrials = closed.badtrials;
Fr_charism = ft_freqanalysis(cfg, charism);
Fr_charism.badtrials = charism.badtrials;
Fr_dull = ft_freqanalysis(cfg, dull);
Fr_dull.badtrials = dull.badtrials;
Fr_room = ft_freqanalysis(cfg, room);
Fr_room.badtrials = room.badtrials;
Fr_silent = ft_freqanalysis(cfg, silent);
Fr_silent.badtrials = silent.badtrials;
 

save ('FrqAnalysis.mat', '-v7.3');

clear cfg closed open room silent dull charism conditions Fr_open Fr_closed Fr_charism Fr_dull Fr_room Fr_silent
end

%% Calculate correlations for one condition.
 
clear all
for i=[1:24 26:40];
path = ['/media/megadmin/Carisma/Charisma/char_' num2str(i) '/0.14d1/date/1'];
cd(path);
load ('FrqAnalysis1','Fr_closed')
clear badpairs1 
badpairs1 = Fr_closed.badtrials;

subI = sum (Fr_closed.powspctrm(:,:,4:8),3);
clear Fr_closed
for j=[1:24 26:40];
    path = ['/media/megadmin/Carisma/Charisma/char_' num2str(j) '/0.14d1/date/1'];
cd(path);
load ('FrqAnalysis1','Fr_closed');
clear badpairs
badpairs=[badpairs1, Fr_closed.badtrials];
subJ = sum (Fr_closed.powspctrm(:,:,4:8),3);
clear Fr_closed
badpairs=unique(badpairs);
str = sprintf ('Performing correlation of sub %d with %d',i,j);
disp (str)
for sen=1:248;
    
trials1 = size (subI,1);
trials = size (subJ,1);
 if trials1 | trials ==279;
     badpairs=[badpairs, 280];
     badpairs=unique(badpairs);
 end

corr_vec1=(subI(:,sen));
corr_vec1=corr_vec1(find(not(ismember([1:trials],badpairs))));
corr_vec2=(subJ(:,sen));
corr_vec2=corr_vec2(find(not(ismember([1:trials],badpairs))));

rho(sen,i,j)=corr(corr_vec1,corr_vec2);
end 
end
end
    
cd ('/media/megadmin/Carisma/Charisma/Correlations/Theta/')
 save ('closedCorrelations','rho', '-v7.3');
 
%   eval (['Subject_' num2str(i) '=x']);
%   clear x
%   clear FrqAnalysis
% end

%% 
for cond=1:6;
    
cd ('/media/megadmin/Carisma/Charisma/Correlations/Theta')
if cond ==1;
load ('dullCorrelations.mat');
condition = 'dull';
elseif cond==2;
load ('charismCorrelations.mat');
condition = 'charism';
elseif cond==3;
load ('openCorrelations.mat');
condition = 'open';
elseif cond==4;
load ('closedCorrelations.mat');
condition = 'closed';
elseif cond==5;
load ('roomCorrelations.mat');
condition = 'room';
elseif cond==6;
load ('silentCorrelations.mat');
condition = 'silent';
end

for sen = 1:248;
    for i=[1:40];
        x=rho(sen,:,i);
        x(i)=0;
        Mean(sen,i)=mean (nonzeros(x));
        clear x
    end 
end
eval ( ['BetaAVG' (condition) '= Mean']);
clear Mean cond condition rho  
end
cd ('/media/megadmin/Carisma/Charisma/Correlations')
save ('ThetaMeans.mat', '-v7.3'); 

load ('/media/megadmin/Carisma/Charisma/Correlations/Theta/ThetaMeans.mat')

BetaAVGcharism = mean (BetaAVGcharism);
BetaAVGcharism (25) = [];
BetaAVGclosed = mean (BetaAVGclosed);
BetaAVGclosed(25)=[];
BetaAVGdull = mean (BetaAVGdull);
BetaAVGdull(25)=[];
BetaAVGopen = mean (BetaAVGopen);
BetaAVGopen(25)=[];
BetaAVGroom = mean (BetaAVGroom);
BetaAVGroom(25) = [];
BetaAVGsilent = mean (BetaAVGsilent);
BetaAVGsilent(25)=[];


Dull= mean(BetaAVGdull);
Charism = mean(BetaAVGcharism);
Open = mean(BetaAVGopen);
Closed = mean(BetaAVGclosed);
Room =  mean(BetaAVGroom);
Silent =  mean(BetaAVGsilent);
vec = [Charism,Dull,Open,Closed,Room,Silent];
figure;
subplot (3,1,1)
bar (vec)
subplot (3,1,2)
figure;
open ('/media/megadmin/Carisma/Charisma/Correlations/Beta/beta.fig')
open ('/media/megadmin/Carisma/Charisma/Correlations/Alpha/Alpha.fig')
open ('/media/megadmin/Carisma/Charisma/Correlations/Gamma/Gamma.fig')


[h,p,ci,stats] = ttest (BetaAVGcharism,BetaAVGdull)
[h,p,ci,stats] = ttest (BetaAVGopen,BetaAVGdull)
[h,p,ci,stats] = ttest (DullRvec,ClosedRvec)

c = categorical('Charism','Dull','Open');
AVGs= [ CharismRvec , DullRvec , OpenRvec];
bar (c,AVGs)


%% Different method to clalculate correlations.

sumall = zeros (99,248);
sumgood = zeros(99,1);
 for i=[1:26 28:40]
path = ['/Volumes/Carisma/Charisma/char_' num2str(i) '/0.14d1/date/1'];
cd(path);
load ('FrqAnalysisNew','Fr_silent');
powsub = sum(Fr_silent.powspctrm,3);
% s = size (powsub,1);
%if s==279
  %  badtrials = [Fr_charism.badtrials,280];
%else
    badtrials=Fr_silent.badtrials;
%end
goodtrials=ones(99,1);
goodtrials(badtrials)=0;

sumall(goodtrials==1,:)=sumall(goodtrials==1,:)+powsub(goodtrials==1,:);
sumgood(goodtrials==1)=sumgood(goodtrials==1)+1;

 end
 
 r=zeros(39,248);
 n=0;
for i=[1:26 28:40]
n=n+1;
path = ['/Volumes/Carisma/Charisma/char_' num2str(i) '/0.14d1/date/1'];
cd(path);
load ('FrqAnalysisNew','Fr_silent')
powsub = sum(Fr_silent.powspctrm,3);
% s = size (powsub,1);
% if s==279
%     powsub (280,:) = zeros(1,248);
%     badtrials=unique([badtrials 280]);
% end
goodtrials=ones(99,1);
goodtrials(unique(badtrials))=0;
avgminus=(sumall-powsub);
for j=1:99,avgminus(j,:)=avgminus(j,:)./(sumgood(j)-1);
end;
for j=1:248
    r_silent(n,j)=corr(powsub(goodtrials==1,j),avgminus(goodtrials==1,j));
end;
end

cd ('/Volumes/Carisma/CorrelationsChar')
save ('r_silent','r_silent','-v7.3');


cd ('/Volumes/Carisma/CorrelationsChar')
load ('r_charism.mat');
load ('r_dull.mat');
load ('r_closed.mat');
load ('r_open.mat');
load ('r_room.mat');
load ('r_silent.mat');


r_open = r_open;
r_closed = r_closed;
r_dull = r_dull;
r_charism=r_charism;
r_room =r_room;
r_silent=r_silent;


openAVG = mean (r_open);
closedAVG = mean (r_closed);
dullAVG = mean (r_dull);
charismAVG = mean (r_charism,2);
roomAVG = mean (r_room);
silentAVG = mean (r_silent);

mat = zeros (6,39)
mat(1,:)= openAVG;
mat(2,:)= closedAVG
mat(3,:)=dullAVG
mat(4,:)=charismAVG
mat(5,:)=roomAVG
mat(6,:)=silentAVG

MeanMat = mean (mat)
plot (MeanMat)

for i=[1:24 26:40]
cfg=[];
cfg.xlim = [i i]
cfg.layout = '4D248.lay';
cfg.interactive = 'no';
subplot (8,5,i)
ft_topoplotER (cfg, charism_tamp);
end 

Correlations2 = [];
Correlations2.charism = [charismAVG];
Correlations2.dull = [dullAVG];
Correlations2.open = [openAVG];
Correlations2.closed = [closedAVG];
Correlations2.room = [roomAVG];
Correlations2.silent = [silentAVG];

save ('Correlations2','Correlations2','-v7.3')


openVec = mean (openAVG);
closedVec = mean (closedAVG);
dullVec = mean (dullAVG);
charismVec = mean (charismAVG);
roomVec = mean (roomAVG);
silentVec = mean (silentAVG);
vec = [charismVec,dullVec,closedVec,openVec,roomVec,silentVec];
bar (vec)



%% correlation of correlations 

clear all
for i=[1:26 28:40];
path = ['/media/megadmin/Carisma/Charisma/char_' num2str(i) '/0.14d1/date/1'];
cd(path);
 load ('dataorig.mat');




    
clear all
path = '/Volumes/Carisma/Charisma';
sub_list=dir(path);
% divide into different conditions and mark bad trials. 
for i=[10:28 30:49]
cd ([path '/' sub_list(i).name '/0.14d1/date/1']);
disp (i)
delete ('Conditions1.mat');
delete ('COnditions.mat');

    load ('dataorig.mat');
 
    % this part determines which condition is the charismatic condition and dividing it accordingly 
     %according to the length of the variable. The shorter variable is the "dull" condition.
   numOftrials=find (dataorig.trialinfo(:,1)==220);
   Odd_check = size (numOftrials,1);
    if Odd_check == 92
    
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

    elseif Odd_check == 99
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

clear Odd_check
clear bad
clear good
clear clear dataorig
clear cfg

tab= [length(charism.trialinfo); length(dull.trialinfo); length(closed.trialinfo);length(open.trialinfo); length(room.trialinfo); length(silent.trialinfo)];
nam= {'charism';'dull';'closed';'open'; 'room'; 'silent'};
T1 = table(nam,tab)

save ('Conditions.mat','charism','closed', 'dull', 'open', 'room', 'silent', '-v7.3')
clear charism open room silent dull closed

% 
% Conditions = [];
% Conditions.room=[room];
% Conditions.open = [open];
% Conditions.closed = [closed];
% Conditions.silent = [silent];
% Conditions.dull=[dull];
% Conditions.charism = [charism];
% 
% 
% save ('Conditions', 'Conditions', '-v7.3');


    

end

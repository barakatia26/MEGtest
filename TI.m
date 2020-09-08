%%TI
clear all
for cond=1:3
    if  cond==1
            condition='charism';
    elseif cond==2
            condition='open';
    elseif cond==3
            condition='closed';
    elseif cond==4
        condition='dull';
    elseif cond ==5
        condition ='room';
    elseif cond ==6
        condition ='silent';
    end
    str1=['The condition is: ',condition];
    disp (str1)
    clear str1
    

fs=1017.25;
subs = [1:24 26:40];
timatrix=zeros(length(subs),length(subs),248);
hnw=hanning(2034);
for i=subs;
 path = ['/media/megadmin/Carisma/Charisma/char_' num2str(i) '/0.14d1/date/1'];
 cd(path);
 si=load ('Conditions1', [condition]);
 str= sprintf ('loading subject %d',i);
 disp(str)

matlabpool(4)
 for j=subs;
 if i~=j, 
  path = ['/media/megadmin/Carisma/Charisma/char_' num2str(j) '/0.14d1/date/1'];
  cd(path);
 sj=load ('Conditions1',[condition]);
  str= sprintf ('loading subject %d',j);
  disp (str)
  clear 'charism' 'dull' 'open' 'closed' 'room' 'silent';
  
 
  
  %% Repeat the following with all conditions changing charism for other condition
  
  trs=min(size(si.(condition).trial,2), size(sj.(condition).trial,2));
 
  tij=zeros(trs,248);
  counter = 0;
   for t=1:trs,
    x=[zeros(248,1526) si.(condition).trial{1,t} zeros(248,1526)]';
    y=[zeros(248,1526) sj.(condition).trial{1,t} zeros(248,1526)]';
    parfor sen=1:248
    cij(:,sen)=mscohere(x(:,sen),y(:,sen),hnw,0,[],fs);
    end
    tij(t,:)=(-2/fs)*sum(log(1-cij(3:63,:))); %1-30Hz
   end;
   disp ('TI and mscoherence calculation is finished')
  badt=unique([si.(condition).badtrials sj.(condition).badtrials]);
  bothgood=ones(trs,1);
  bothgood(badt)=0;
   str = sprintf ('Calculating total interdependence of sub %d with %d',i,j);
disp (str)
  timatrix(i,j,:)=mean(tij(bothgood==1,:),1);
  
 
 end; %if
 end; %%j
  clear sj;
   matlabpool close
  
 end; %%i
 cd ('/media/megadmin/Carisma/Charisma/TI')
 save ((condition),'timatrix','-v7.3')
 clear condition cond
end
 
 %% we end up with timatrix with TI scores for each pair for each sensor
 
 for cond=1:4
    if  cond==1
            condition='charism';
    elseif cond==2
        condition='dull';
    elseif cond ==3
        condition ='room';
    elseif cond ==4
        condition ='silent';
    end
     cd ('/media/megadmin/Carisma/Charisma/TI');
    
    load (condition);
 
 for sen = 1:248;
    for i=[1:40];
        x=timatrix(i,:,sen);
       
      MeanTI(i,sen)= mean (nonzeros(x));
     
        clear x 
    end 
 end
  eval ( ['TI' (condition) '= MeanTI']);
clear condition timatrix MeanTI i sen cond
 end
 save('TImeans.mat','-v7.3')
 
 
 TIcharism = mean (TIcharism);
TIcharism (25) = [];
TIdull = mean (TIdull);
TIdull(25)=[];
TIroom = mean (TIroom);
TIroom(25)=[];
TIsilent = mean (TIsilent);
TIsilent(25)=[];


MeanDull= mean(TIdull);
MeanCharism = mean(TIcharism);
MeanRoom =  mean(TIroom);
MeanSilent =  mean(TIsilent);
vec = [MeanCharism,MeanDull,MeanRoom,MeanSilent];
figure;
bar (vec)
 
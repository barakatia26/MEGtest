
frqBand=[1:40];
trialsNum=300;
sumall=zeros(300,248);
sumgood=zeros(300,1);
 for i=[1:24 26:40];
path = ['/media/megadmin/Carisma/Charisma/char_' num2str(i) '/0.14d1/date/1'];
cd(path);
subi = load ('FrqAnalysis1','Fr_charism');
powsub = sum(subi.Fr_charism.powspctrm(:,:,frqBand),3);
s = size (powsub,1);
badtrials=subi.Fr_charism.badtrials;

goodtrials=ones(trialsNum,1);
goodtrials(badtrials)=0;

sumall(goodtrials==1,:)=sumall(goodtrials==1,:)+powsub(goodtrials==1,:);
sumgood(goodtrials==1)=sumgood(goodtrials==1)+1;
clear subi
 end
 
  r=zeros(39,248);
 n=0;
for i=[1:24 26:40];
n=n+1;
path = ['/media/megadmin/Carisma/Charisma/char_' num2str(i) '/0.14d1/date/1'];
cd(path);
load ('FrqAnalysis1','Fr_charism')
powsub = sum(Fr_charism.powspctrm,3);
goodtrials=ones(300,1);
goodtrials(unique(badtrials))=0;
avgminus=(sumall-powsub);
for j=1:300
    avgminus(j,:)=avgminus(j,:)./(sumgood(j)-1);
end;
end


for j=1:248
    r_charism(n,j)=corr(powsub(goodtrials==1,j),avgminus(goodtrials==1,j));
end;
end
 
 
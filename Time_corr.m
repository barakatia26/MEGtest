clear all
num_of_subjects=[1:24 26:40];
win_size=10;
step_size=2;
frqBand=[1:40];

path = '/media/megadmin/Carisma/Charisma/char_1/0.14d1/date/1';
cd(path);
load ('FrqAnalysis1','Fr_charism');
powsub = sum(Fr_charism.powspctrm(:,:,frqBand),3);


last_valid_ind = (size(powsub,1)-(win_size-1));
num_of_lines = floor(last_valid_ind/step_size);
cache_matrix = zeros(num_of_lines,win_size,size(powsub,2),length (num_of_subjects));

for sub_ind = num_of_subjects
    disp(['Working on subject ',num2str(sub_ind)])
    path = ['/media/megadmin/Carisma/Charisma/char_' num2str(sub_ind) '/0.14d1/date/1'];
    cd(path);
    load ('FrqAnalysis1','Fr_charism');
    powsub = sum(Fr_charism.powspctrm(:,:,frqBand),3);
    powsub(Fr_charism.badtrials,:) = nan;
    for chan_ind=1:size(cache_matrix,3)
        next_ind=1;
        for ii=1:step_size:last_valid_ind
            cache_matrix(next_ind,:,chan_ind,sub_ind) = powsub(ii:(ii+win_size-1),chan_ind);
            cache_matrix(next_ind,:,chan_ind,sub_ind) = powsub(ii:(ii+win_size-1),chan_ind);
            
            next_ind = next_ind+1;
        end
    end
end

Avg_matrix = nanmean(cache_matrix,4);
% Avg_matrix = nanmean(Avg_matrix,3);

R=zeros (146,248,40);
for i=1:40
    for sen=1:248
        for j=1:146
    current_sub = cache_matrix(j,:,sen,i);
    R (j,sen,i) = corr(current_sub',(Avg_matrix(j,:,sen))');
    disp(['Working on sbject ', num2str(i) , ' sensor number ' ,num2str(sen),'/248'])
    end
    end
end




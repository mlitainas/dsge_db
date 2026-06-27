function make_getk_text(DSGE_sector, DSGE_country)
sector_nr = length(DSGE_sector);

%% Write K_co for beginning of getk
filename = 'getk_text1.m';
fid = fopen(filename,'w');

for co = 1:length(DSGE_country)
text = strcat(['K_' char(DSGE_country(co)) '=@(k) k(' string(co) '); ' newline]);   
fprintf(fid, '%s', text);
end

fclose(fid);


%% Write middle part of getk
filename = 'getk_text2.m';
fid = fopen(filename,'w');

for co=1:length(DSGE_country)
     
    text=strcat(['I_' char(DSGE_country(co)) '=@(k) delta*K_' char(DSGE_country(co)) '(k);' newline]);
    fprintf(fid, '%s', text(:,:));
    
    text=strcat(['C_' char(DSGE_country(co)) '=@(k) Y_VA_' char(DSGE_country(co)) '_ts - I_' char(DSGE_country(co)) '(k);' newline]);
    fprintf(fid, '%s', text(:,:));
    
    for s=1:sector_nr
    text=strcat(['C_' string(s) '_' char(DSGE_country(co)) '=@(k) Psi_con_' string(s) '_' char(DSGE_country(co)) '*C_' char(DSGE_country(co)) '(k);' newline]);
    fprintf(fid, '%s', text(:,:));
    end
    
    for s=1:sector_nr
    text=strcat(['I_' string(s) '_' char(DSGE_country(co)) '=@(k) Psi_inv_' string(s) '_' char(DSGE_country(co)) '*I_' char(DSGE_country(co)) '(k);' newline]);
    fprintf(fid, '%s', text(:,:));
    end
    
    %H_use
    semikolon_string = repmat({';'},sector_nr,1);
    
    for s = 1:sector_nr
    storage.store1(s,1) =  string(strcat('H_use_', num2str(s) ,'_',DSGE_country(co),'=@(k) '));
    
       for s2 = 1:sector_nr   
       storage.store2(s,s2) = string(strcat('+H_use_', num2str(s2) ,'_', num2str(s) ,'_',  DSGE_country(co),'(k)'));
       end
    end

    storage.store3 = [storage.store1  storage.store2 semikolon_string];

    for s = 1:sector_nr
    storage.store(s) = strjoin(storage.store3(s,:));
    end
    
    storage.store = storage.store';  
    
    j=1;
    store(j:j+sector_nr-1) = storage.store;
    j= j+sector_nr;
    
    fprintf(fid, '%s', store);
    
end
    
 fclose(fid);

%% Write objective functions of getk
clearvars stor*
filename = 'getk_text3.m';
fid = fopen(filename,'w');

% objective function part 2 on K
for co = 1:length(DSGE_country)   
    
   storage.(DSGE_country{co}).store1 = string(strcat('K_', DSGE_country(co), '(k)^upsi_K_', DSGE_country(co), '-( '));
    
    for se2 = 1:sector_nr   
    storage.(DSGE_country{co}).store2(se2) = string(strcat('+omega_K_', num2str(se2) ,'_',DSGE_country(co),'(k)^(1-upsi_K_', DSGE_country(co),')*K_', num2str(se2) ,'_', DSGE_country(co),'(k)^upsi_K_', DSGE_country(co)));  
    end
    
   store3 = ');';
   
   storage.(DSGE_country{co}).store4 = [storage.(DSGE_country{co}).store1 storage.(DSGE_country{co}).store2 store3];
   
   storage.(DSGE_country{co}).store = strjoin(storage.(DSGE_country{co}).store4);
   
   store(co,1) = storage.(DSGE_country{co}).store;

end
 
text = 'fun=@(k)[';
fprintf(fid, '%s', text);

fprintf(fid, '%s', store);

 
% objective function part 2 on H
clearvars stor*

for co = 1:length(DSGE_country)   
for se1 = 1:sector_nr   
   for se2 = 1:sector_nr 
       
   if (co == length(DSGE_country)) && (se1 == sector_nr) && (se2 == sector_nr)  % adjust end bracket and semicolon in last case
   storage.(DSGE_country{co}).store(se1,se2) = string(strcat('H_use_', num2str(se2) ,'_', num2str(se1) ,'_',DSGE_country(co),'(k)-H_', num2str(se2) ,'_', num2str(se1) ,'_', DSGE_country(co),'(k)];'));  
   else
   storage.(DSGE_country{co}).store(se1,se2) = string(strcat('H_use_', num2str(se2) ,'_', num2str(se1) ,'_',DSGE_country(co),'(k)-H_', num2str(se2) ,'_', num2str(se1) ,'_', DSGE_country(co),'(k);'));  
   end 
   
   end
end
  
  storage.(DSGE_country{co}).store = strjoin(storage.(DSGE_country{co}).store);
  
  store(co,1) = storage.(DSGE_country{co}).store;
end

fprintf(fid, '%s', store);

fclose(fid);

 
 
end
    
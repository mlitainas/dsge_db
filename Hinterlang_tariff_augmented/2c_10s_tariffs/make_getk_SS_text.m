function make_getk_SS_text(SS_file,DSGE_sector, DSGE_country)

sector_nr = length(DSGE_sector);

%% getk text for steady state file
fid = fopen('getk_SS_text.txt', 'w');

for co = 1:length(DSGE_country)
    text= [strcat(['K_' char(DSGE_country(co)) '_ts = kk(' string(co) ');']) newline];
    fprintf(fid, '%s', text(:,:));
end

ii=0;
for co = 1:length(DSGE_country)
for se1 = 1:sector_nr
   for se2 = 1:sector_nr
      jj =  (se1-1)*sector_nr + se2;
      text= [strcat(['H_' char(string(se1)) '_' char(string((se2))) '_' char(DSGE_country(co)) '_ts =kk(' char(string(length(DSGE_country)+ii+jj)) ');']) newline];  
      fprintf(fid, '%s', text(:,:));
   end
end
ii=ii+sector_nr^2;
end

fclose(fid);

SS_getk_text = regexp(fileread('getk_SS_text.txt'),'\n','split');


%% Remove possibly previous 'kk(' lines from SS file
SS_text = regexp(fileread(SS_file),'\n','split');
whichline_kk = find(contains(SS_text,'kk('));

if length(whichline_kk) >0
fid= fopen(SS_file, 'w');
SS_text = SS_text(:,[1:whichline_kk(1)-1, whichline_kk(end)+1:length(SS_text)]);
fprintf( fid, '%s\n', SS_text{:} );
end

%% find line where getk function is called and write new kk( lines
whichline = find(contains(SS_text,'getk'));

fid= fopen(SS_file, 'w');
    for  jj = 1 : whichline
        fprintf( fid, '%s\n', SS_text{jj} );
    end
   
    fprintf(fid, '%s\n', SS_getk_text{:} );  % write new SS_getk_text
    
    for jj = (whichline+1) : length(SS_text)
        fprintf( fid, '%s\n', SS_text{jj} );
    end
    
fclose( fid );


end







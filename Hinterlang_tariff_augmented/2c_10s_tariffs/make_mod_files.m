function make_mod_files(M_)
filename1 = 'SS_init.mod';
filename2 = 'newss.mod';

fid1=fopen(filename1,'w');
fid2=fopen(filename2,'w');


for i=1:M_.orig_endo_nbr
    S = M_.endo_names(i,:);
    S1=[S, ' = SS_init(', num2str(i),') ;\n'];    
    S2=[S, ' = newss(', num2str(i),') ;\n']; 
    fprintf(fid1,S1);
    fprintf(fid2,S2);
end
fclose(fid1);
fclose(fid2);


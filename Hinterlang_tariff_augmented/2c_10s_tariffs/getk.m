function [ k ] = getk( M_ , DSGE_sector, DSGE_country)
% get calibration
for i = 1:M_.param_nbr
    if iscell(M_.param_names)
        pname = M_.param_names{i};
    else
        pname = char(M_.param_names(i));
    end
    eval([pname ' = M_.params(i);']);
end

% for i=1:M_.param_nbr
%     eval([M_.param_names(i,:) '=M_.params(i);']);
% end

sector_nr = length(DSGE_sector);
region_nr = length(DSGE_country);

%set default return value
k=[NaN(length(DSGE_country)+length(DSGE_country)*sector_nr^2,1)];

% Initialize region-specific K 
run getk_text1.m

ii=0;
for co =1:length(DSGE_country) 
for se1 = 1:sector_nr
   for se2 = 1:sector_nr
      jj =  (se1-1)*sector_nr + se2;
      eval(['H_use_' char(string(se1)) '_' char(string((se2))) '_' char(DSGE_country(co)) ' =@(k) k( ' char(string(region_nr+ii+jj)) ');']) 
   end
end
ii=ii+sector_nr^2;
end

% Insert missing getk text
run getk_text2.m 

for co=1:length(DSGE_country)
for se1 = 1:sector_nr
    
    eval(['Y_' char(string(se1)) '_' char(DSGE_country(co)) '=@(k) (C_' char(string(se1)) '_' char(DSGE_country(co)) '(k) + I_' char(string(se1)) '_' char(DSGE_country(co)) '(k) + H_use_' char(string(se1)) '_' char(DSGE_country(co)) '(k))  ;']);  % OR: MODI
    eval(['H_' char(string(se1)) '_' char(DSGE_country(co)) '=@(k) (1-alphaH_' char(string(se1)) '_' char(DSGE_country(co)) ') * mc_' char(string(se1)) '_' char(DSGE_country(co)) '_ts * Y_' char(string(se1)) '_' char(DSGE_country(co)) '(k) ;']);  
    
      for se2 = 1:sector_nr         
       eval(['H_' char(string((se1))) '_' char(string((se2))) '_' char(DSGE_country(co)) ' = @(k) Psi_' char(string((se1))) '_' char(string((se2))) '_' char(DSGE_country(co)) '* H_' char(string(se1)) '_' char(DSGE_country(co)) '(k);']);     
      end

      eval(['rk_' char(string(se1)) '_' char(DSGE_country(co)) ' =@(k) alphaH_' char(string((se1))) '_' char(DSGE_country(co)) ' * (1-alphaN_' char(string((se1))) '_' char(DSGE_country(co)) ') * mc_' char(string((se1))) '_' char(DSGE_country(co)) '_ts * Y_' char(string((se1))) '_' char(DSGE_country(co)) '(k)/(omega_K_tild_' char(string((se1))) '_' char(DSGE_country(co)) '*K_' char(DSGE_country(co)) '(k) );']);
      eval(['omega_K_' char(string(se1)) '_' char(DSGE_country(co)) ' =@(k) omega_K_tild_' char(string((se1))) '_' char(DSGE_country(co)) ' * (rk_' char(string((se1))) '_' char(DSGE_country(co)) '(k) / rk_' char(DSGE_country(co)) '_ts)^(1/(1-upsi_K_' char(DSGE_country(co)) '));']);
      
      eval(['K_' char(string(se1)) '_' char(DSGE_country(co)) ' =@(k)  omega_K_' char(string((se1))) '_' char(DSGE_country(co)) '(k) * (rk_' char(DSGE_country(co)) '_ts/rk_' char(string(se1)) '_' char(DSGE_country(co)) '(k))^(1/(1-upsi_K_' char(DSGE_country(co)) '))*K_' char(DSGE_country(co)) '(k);']); 

end
end

options=optimset('TolFun',1e-18,'Display','iter');

% Insert text for objective function
run getk_text3.m

start_point = [repmat([20],[length(DSGE_country),1]) ; zeros(length(DSGE_country)*sector_nr^2,1)+0.01]

k=fsolve(fun, start_point, options)

end





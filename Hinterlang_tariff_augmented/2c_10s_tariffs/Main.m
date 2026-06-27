%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                       %
%    THE ENVIRONMENTAL MULTI-SECTOR DSGE MODEL EMuSe                    %
%                                                                       %
%    EMuSe has been developed by the                                    %
%    Directorate General Economics of the Deutsche Bundesbank.          %
%                                                                       %
%    Authors:                                                           %
%    Natascha Hinterlang                                                %
%    Anika Martin                                                       %
%    Oke Röhe                                                           %
%    Nikolai Stähler                                                    %
%    Johannes Strobel                                                   %
%                                                                       %
%    Contact: emuse@bundesbank.de                                       %
%                                                                       %
%    The authors are grateful to their colleagues in DG Economics,      %
%    DG Financial Stability and the Research Centre of Deutsche         %
%    Bundesbank, the Working Group on Econometric Modelling (WGEM) and  %
%    the Working Group on Forecasting (WGF) of the European System of   %
%    Central Banks (ESCB) as well as the members of the informal        %
%    network of modelling experts of the G7 Climate Change Mitigation   %
%    Working Group for their helpful discussions and valuable input     %
%    during the development of EMuSe.                                   %
%                                                                       %
%    If you use the EMuSe model, please cite                            %
%    Natascha Hinterlang, Anika Martin, Oke Röhe,                       %
%    Nikolai Stähler and Johannes Strobel (2023),                       %
%    The Environmental Multi-Sector DSGE model EMuSe:                   %
%    A technical documentation,                                         %
%    Deutsche Bundesbank Technical Paper, No. 03/2023.                  %                                                
%                                                                       %
%                                                                       %
% Access to EMuSe is only granted on the basis set out in the           %    
% accompanying End User License Agreement (EULA).                       %
% Downloading, installing or using the EMuSe model implies acceptance   % 
% of the EULA. If you do not agree to be bound by these terms,          %
% do not download, install or use the related Software and              %
% documentation. As further outlined in the EULA the Software           %
% is provided "as is", without any representation or warranty of any    %
% kind either express or implied.                                       %
%                                                                       %
% The Software and Derived Work from the Software may only be           %
% distributed and communicated together with a copy of the EULA and the %
% aforementioned notice.                                                %
%                                                                       %
%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Housekeeping
clear;
close all;
clc;
%addpath("/Applications/Dynare/6.4-arm64/matlab")

%% Multi-sector multi-region model with flexible prices and climate module

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pass objects to MATLAB that DYNARE will access later on 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% In order to match DSGE sector numbers with calibration sector codes (NACE):
NACE = string({'A','B','C','D','E','F','G_H_I','J','M_N', 'R_S'}); 
DSGE_sector = [1:size(NACE,2)];

% When solving the model, we take the calibration file as given. This file 
% contains the sectoral parameter values. 
load('Calibration_EU28_ROW_10.mat')

% Match DSGE region names with the ones specified in calibration tool:
ISO = {'Reg_a', 'Reg_b'}; % Note: EU is reg_A, RoW is Reg_b
DSGE_country = {'a', 'b'};

% Write and adjust auxiliary files in order to execute the optimization of
% intermediate inputs and capital:
SS_file = 'SS_MSMod_10S_2C.mod';   % Write name of ss file here
make_getk_text(DSGE_sector,DSGE_country);
make_getk_SS_text(SS_file, DSGE_sector,DSGE_country);

%% Execute perfect foresight exercise
% Feed P_EM, simulate changes (carbon price) in region A only! 
% Uses NGFS Below 2°C Paths for the EU!

dynare MS_2C_Mod_simul.mod ;
    
disp(['The emissions intensity in the 10S model in country A is ' num2str(ZZ_a_ts/Y_VA_a_ts)  ] );
disp(['The emissions intensity in the 10S model in country B is ' num2str(ZZ_b_ts/Y_VA_b_ts)  ] );

% Save the simulation results
Save_Results;

%%
% Generate the carbon leakage graph


%Compute sum of traded flows
for i = 1:DSGE_sector(end)
 %C + I + H from b to a  
 eval(['sum_' deblank(num2str(i)) '_a_b_noweights = (C_' deblank(num2str(i)) '_a_b_t+I_' deblank(num2str(i)) '_a_b_t+H_1_' deblank(num2str(i)) '_a_b_t+H_2_' deblank(num2str(i)) '_a_b_t+H_3_' deblank(num2str(i)) '_a_b_t+H_4_' deblank(num2str(i)) '_a_b_t+H_5_' deblank(num2str(i)) '_a_b_t+H_6_' deblank(num2str(i)) '_a_b_t+H_7_' deblank(num2str(i)) '_a_b_t+H_8_' deblank(num2str(i)) '_a_b_t+H_9_' deblank(num2str(i)) '_a_b_t+H_10_' deblank(num2str(i)) '_a_b_t );']);
  
 %C + I + H from a to b  
 eval(['sum_' deblank(num2str(i)) '_b_a_noweights = (C_' deblank(num2str(i)) '_b_a_t+I_' deblank(num2str(i)) '_b_a_t+H_1_' deblank(num2str(i)) '_b_a_t+H_2_' deblank(num2str(i)) '_b_a_t+H_3_' deblank(num2str(i)) '_b_a_t+H_4_' deblank(num2str(i)) '_b_a_t+H_5_' deblank(num2str(i)) '_b_a_t+H_6_' deblank(num2str(i)) '_b_a_t+H_7_' deblank(num2str(i)) '_b_a_t+H_8_' deblank(num2str(i)) '_b_a_t+H_9_' deblank(num2str(i)) '_b_a_t+H_10_' deblank(num2str(i)) '_b_a_t );']);
  
end   

   
% Compute carbon content sectoral flows w/o weighting by pop size; column 6
% is the carbon intensity of 2005. Note that the change in the emissions
% intensity has to be accounted for by multiplying by the change

sum_4_sectors_carbon_a_b_noweights = sum_1_a_b_noweights * mean(Calibration.Emissions.Const_frac.Reg_b{1,6}) ...
+ sum_2_a_b_noweights*mean(Calibration.Emissions.Const_frac.Reg_b{2,6}) ... 
+ sum_3_a_b_noweights*mean(Calibration.Emissions.Const_frac.Reg_b{3,6}) ...
+ sum_4_a_b_noweights*mean(Calibration.Emissions.Const_frac.Reg_b{4,6});
    
sum_4_sectors_carbon_b_a_noweights = sum_1_b_a_noweights * mean(Calibration.Emissions.Const_frac.Reg_a{1,6}) ... 
+ sum_2_b_a_noweights* mean(Calibration.Emissions.Const_frac.Reg_a{2,6}) ... 
+ sum_3_b_a_noweights* mean(Calibration.Emissions.Const_frac.Reg_a{3,6}) ...  
+ sum_4_b_a_noweights* mean(Calibration.Emissions.Const_frac.Reg_a{4,6}) ;

    
sum_10_sectors_carbon_a_b_noweights = sum_1_a_b_noweights * mean(Calibration.Emissions.Const_frac.Reg_b{1,6}) ...
+ sum_2_a_b_noweights*mean(Calibration.Emissions.Const_frac.Reg_b{2,6}) ... 
+ sum_3_a_b_noweights*mean(Calibration.Emissions.Const_frac.Reg_b{3,6}) ...
+ sum_4_a_b_noweights*mean(Calibration.Emissions.Const_frac.Reg_b{4,6}) ...
+ sum_5_a_b_noweights*mean(Calibration.Emissions.Const_frac.Reg_b{5,6}) ... 
+ sum_6_a_b_noweights*mean(Calibration.Emissions.Const_frac.Reg_b{6,6}) ...
+ sum_7_a_b_noweights*mean(Calibration.Emissions.Const_frac.Reg_b{7,6}) ...
+ sum_8_a_b_noweights*mean(Calibration.Emissions.Const_frac.Reg_b{8,6}) ... 
+ sum_9_a_b_noweights*mean(Calibration.Emissions.Const_frac.Reg_b{9,6}) ...
+ sum_10_a_b_noweights*mean(Calibration.Emissions.Const_frac.Reg_b{10,6});

sum_10_sectors_carbon_b_a_noweights =  sum_1_b_a_noweights * mean(Calibration.Emissions.Const_frac.Reg_a{1,6}) ... 
+ sum_2_b_a_noweights* mean(Calibration.Emissions.Const_frac.Reg_a{2,6}) ... 
+ sum_3_b_a_noweights* mean(Calibration.Emissions.Const_frac.Reg_a{3,6}) ...  
+ sum_4_b_a_noweights* mean(Calibration.Emissions.Const_frac.Reg_a{4,6}) ...
+ sum_5_b_a_noweights* mean(Calibration.Emissions.Const_frac.Reg_a{5,6}) ... 
+ sum_6_b_a_noweights* mean(Calibration.Emissions.Const_frac.Reg_a{6,6}) ...  
+ sum_7_b_a_noweights* mean(Calibration.Emissions.Const_frac.Reg_a{7,6}) ...
+ sum_8_b_a_noweights* mean(Calibration.Emissions.Const_frac.Reg_a{8,6}) ... 
+ sum_9_b_a_noweights* mean(Calibration.Emissions.Const_frac.Reg_a{9,6}) ...  
+ sum_10_b_a_noweights* mean(Calibration.Emissions.Const_frac.Reg_a{10,6});




%%
% Note: Now, compute the flows from region a's PoV 
% -> Introduce weights on the exports to transform to per capita quantities
weight_convert_a = size_b/size_a;

% Exports from region a to region b
X_4_sectors_carbon_a = weight_convert_a*(1+oo_.exo_simul(:,3) ) .* sum_4_sectors_carbon_b_a_noweights;

% Imports from region b to region a
M_4_sectors_carbon_a = sum_4_sectors_carbon_a_b_noweights;

% Exports from region a to region b
X_10_sectors_carbon_a = weight_convert_a*(1+oo_.exo_simul(:,3) ) .*sum_10_sectors_carbon_b_a_noweights;

% Imports from region b to region a
M_10_sectors_carbon_a = sum_10_sectors_carbon_a_b_noweights;

%% Carbon leakage graph
% 
% % Compute sum of traded flows
% 
% Carbon_content_change = M_10_sectors_carbon_a-X_10_sectors_carbon_a;
% 
% Carbon_content_change_percdev = (Carbon_content_change(2:47) / Carbon_content_change(1) - 1 )*100 ;
% 
% figure;
% plot(2005:1:2050, Carbon_content_change_percdev ,':'  );hold off
% ylabel('Change in % wrt. 2005');title('Change in carbon content of net exports from region B to A')
%  




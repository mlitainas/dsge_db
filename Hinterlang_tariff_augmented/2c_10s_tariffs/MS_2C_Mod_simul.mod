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

//*************************************************************************
// 1: Define objects that are passed to Dynare's macro processor
//*************************************************************************

// Define the index of the country/countries used in the model.
@#define country    = ["a", "b"]
@#define country2   = ["a"]
@#define countryLast= ["b"]

// Specify the number of sectors included in the model.
@#define sector     = 10
@#define sector2    = 9

//*************************************************************************
// 2: Declare the "usual suspects". Given the above specifications, Dynare's macroprocessor pre-processes the variables, parameters and shocks.
//
// 2.1: "Vars_params_MS_2C.m" specify model variables, exogenous shocks and parameters.
// 2.2: "SS_MSMod_10S_2C.mod" declare the parameter values. The computation of the steady state calls the function getk*.m that computes the aggregate capital stock.
// 2.3: "Equations_10S_2C.mod" pass the model equations  
// 2.4: "Init_Val_MSMod_10S_2C.mod" specify the inital values that are computed in "SS_MSMod_10S_2C.mod"
//*************************************************************************

// ######################################################################  

@#include "Vars_params_MS_2C.m"

@#include "SS_MSMod_10S_2C.mod"  

@#include "Equations_10S_2C.mod"

@#include "Init_Val_MSMod_10S_2C.mod"

// ######################################################################

//*************************************************************************
// 3: Run checks
//*************************************************************************
resid;
steady;
check;
//stoch_simul(order=1, nograph);

//*************************************************************************
// 4: Solve model, here under perfect Foresight
//*************************************************************************
%% Shocks
shocks;
var shock_tau_b_t; stderr 0.01;     
end;

%% IRFs
stoch_simul(irf=40,order=1) C_a_t, I_a_t, N_a_t, K_a_t, w_a_t;  


% shocks;
% var shock_P_EM_a_t;
% periods 
% 1
% 2
% 3
% 4
% 5
% 6
% 7
% 8
% 9
% 10
% 11
% 12
% 13
% 14
% 15
% 16
% 17
% 18
% 19
% 20
% 21
% 22
% 23
% 24
% 25
% 26
% 27
% 28
% 29
% 30
% 31
% 32
% 33
% 34
% 35
% 36
% 37
% 38
% 39
% 40
% 41
% 42
% 43
% 44
% 45
% 46
% 47
% 48
% 49
% 50
% 51
% 52
% 53
% 54
% 55
% 56
% 57
% 58
% 59
% 60
% 61
% 62
% 63
% 64
% 65
% 66
% 67
% 68
% 69
% 70
% 71
% 72
% 73
% 74
% 75
% 76
% 77
% 78
% 79
% 80
% 81
% 82
% 83
% 84
% 85
% 86
% 87
% 88
% 89
% 90
% 91
% 92
% 93
% 94
% 95
% 96:500
% ;
% values 
% 0
% 0.0098834
% 0.0197669
% 0.0296504
% 0.0395339
% 0.0494174
% 0.04944338
% 0.04946936
% 0.04949534
% 0.04952132
% 0.0495473
% 0.06306842
% 0.07658954
% 0.09011066
% 0.10363178
% 0.1171529
% 0.12406388
% 0.13097486
% 0.13788584
% 0.14479682
% 0.1517078
% 0.16182176
% 0.17193572
% 0.18204968
% 0.19216364
% 0.2022776
% 0.21239264
% 0.22250768
% 0.23262272
% 0.24273776
% 0.2528528
% 0.26296556
% 0.27307832
% 0.28319108
% 0.29330384
% 0.3034166
% 0.31353014
% 0.32364368
% 0.33375722
% 0.34387076
% 0.3539843
% 0.36409814
% 0.37421198
% 0.38432582
% 0.39443966
% 0.4045535
% 0.41466566
% 0.42477782
% 0.43488998
% 0.44500214
% 0.4551143
% 0.46523012
% 0.47534594
% 0.48546176
% 0.49557758
% 0.5056934
% 0.51580757
% 0.52592174
% 0.53603591
% 0.54615008
% 0.55626425
% 0.56637842
% 0.57649259
% 0.58660676
% 0.59672093
% 0.6068351
% 0.61695047
% 0.62706584
% 0.63718121
% 0.64729658
% 0.65741195
% 0.66752732
% 0.67764269
% 0.68775806
% 0.69787343
% 0.7079888
% 0.71809991
% 0.72821102
% 0.73832213
% 0.74843324
% 0.75854435
% 0.76865546
% 0.77876657
% 0.78887768
% 0.79898879
% 0.8090999
% 0.81921911
% 0.82933832
% 0.83945753
% 0.84957674
% 0.85969595
% 0.86981516
% 0.87993437
% 0.89005358
% 0.90017279
% 0.910292; 
% end;
% 
% 
% options_.simul.maxit=20;
% simul(periods=600,stack_solve_algo=0);


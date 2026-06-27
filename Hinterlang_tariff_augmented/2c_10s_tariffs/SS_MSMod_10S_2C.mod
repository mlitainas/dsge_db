%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Targets and parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

betta   = 0.992^4;                                                         // Discount factor                                          
sig     = 2;                                                               // Intertemporal elasticity of substitution
delta	= 0.025*4;                                                         // Depr. rate
Psi2    = 0.5;

Y_VA_a_ts      = 1;                                                        // Aggregate value added per capita of region A is normalized to 1
Y_VA_b_ts      = 0.5725;                                                   // Aggregate value added percapita of region B relative to region A

size_a      = 0.156;                                                      // "size" governs the population, world population is normalized to unity!
size_b      = 1-size_a;
rer_ba_ts   = 1;                                                           //Real exchange rate between countries a and b
R_w_ts      = 1/betta;

@#for co in country
epsi_@{co}_ts = 1;                                                         // Aggregate TFP shock
epsi_carb_int_@{co}_ts = 1;                                                // Emissions intensity shock process
rho_eps_@{co}   = 0.8^4;                                                   // Persistence TFP shock
rho_eps_carb_int_@{co} = 0.8^4;                                            // Persistence emission intensity shock

rho_tau_@{co}   = 0.8;                                                   // Persistence Tariff shock
lab_@{co}       = 2;                                                       // Inverse Frisch elasticity of labor supply

N_@{co}_ts      = 0.333;                                                   // Steady state hours -> 1/3 of time endowmwnt

PI_@{co}_ts = 1;                                                           // Relative price of investment basket (normalized to 1)

R_@{co}_ts  = 1/betta;                                                     // Nominal interest rate <-> real interest rate since gross inflation = 1

rk_@{co}_ts = PI_@{co}_ts/betta-(1-delta)*PI_@{co}_ts;                     // Real rental rate of capital

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Climate-related variables/parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rho_EM  = 1-0.9979^4;                                                      // Rate of decay wrt atmosph. carbon concentration

P_EM_@{co}_ts = 10^(-7);                                                   // Initial carbon price level

@#endfor


@#for co in country
Country_Index = ismember(DSGE_country, {'@{co}'}); % In order to match DSGE_country names with ISO country names in calibration

    @#for se in 1:sector
    Sector_Index = DSGE_sector==@{se};  % In order to match DSGE_sectors with NACE sector names in calibration
    
    // Constant emission per unit of output:
    set_param_value('carb_int_@{se}_@{co}', Calibration.Emissions.Const_frac.(ISO{Country_Index}){NACE(Sector_Index),6});    % Emissions per unit of output, specified using the value of 2005

    gama1_@{se}_@{co}       = 0;   % Damage function parameter (proportional)
    gama2_@{se}_@{co}       = 0;   % Damage function parameter (quadratic)
    Pen_@{se}_@{co}_ts      = 0;   % Relative sectoral output loss 
    @#endfor

@#endfor

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Production parameters and elasticities of substitution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

@#for co in country
Country_Index = ismember(DSGE_country, {'@{co}'}); % In order to match DSGE_country names with ISO country names in calibration

sigc_@{co}  = 1-1/0.9091;                                                   // Determines elasticity of substitution between sector-level consumption goods
sigi_@{co}  = 1-1/0.7511;                                                   // Determines elasticity of substitution between sector-level investment goods

upsi_K_@{co}= 2;                                                            // Determines the elasticity of substitution of capital across sectors, taken from Bouakez et al. (2023) )
upsi_N_@{co}= 2;                                                            // Determines the elasticity of substitution of labor across sectors, taken from Bouakez et al. (2023))


@#for se in 1:sector                                                     
Sector_Index = DSGE_sector==@{se};  % In order to match DSGE_sectors with NACE sector names in calibration

set_param_value('alphaN_@{se}_@{co}', Calibration.SEA.(ISO{Country_Index}).(NACE(Sector_Index)).alpha_N(6,:)); // Elasticity of output wrt labor (calibrated to WIOD 2005 data)
set_param_value('alphaH_@{se}_@{co}', Calibration.SEA.(ISO{Country_Index}).(NACE(Sector_Index)).alpha_H(6,:)); // Elasticity of output wrt intermediate-goods (calibrated to WIOD 2005 data)

set_param_value('omega_N_tild_@{se}_@{co}', Calibration.SEA.(ISO{Country_Index}).(NACE(Sector_Index)).omega_N(6,:)); // Weight attached to labor provided to sector se
set_param_value('omega_K_tild_@{se}_@{co}', Calibration.SEA.(ISO{Country_Index}).(NACE(Sector_Index)).omega_K(6,:)); // Weight attached to capital provided to sector se

set_param_value('Psi_con_@{se}_@{co}', Calibration.WIOD.y05.(ISO{Country_Index}).NA.Psi_C_I_G{NACE(Sector_Index), 'Psi_C'});  // Sectoral shares in the consumption good bundle
set_param_value('Psi_inv_@{se}_@{co}', Calibration.WIOD.y05.(ISO{Country_Index}).NA.Psi_C_I_G{NACE(Sector_Index), 'Psi_I'});  // Sectoral shares in the investment good bundle

@#endfor     


pi_cpi_@{co}_ts = 1;

@#for se in 1:sector
EM_cost_@{se}_@{co}_ts = P_EM_@{co}_ts*carb_int_@{se}_@{co};
mc_tild_@{se}_@{co}_ts = 1;
mc_@{se}_@{co}_ts = mc_tild_@{se}_@{co}_ts - EM_cost_@{se}_@{co}_ts;
@#for co2 in country
P_@{se}_@{co}_@{co2}_ts = 1;
pi_ppi_@{se}_@{co}_@{co2}_ts = 1;
@#endfor
pi_cpi_@{se}_@{co}_ts = 1;
PC_@{se}_@{co}_ts = 1;
PI_@{se}_@{co}_ts = 1; 
PH_@{se}_@{co}_ts = 1;
@#for se2 in 1:sector
PHH_@{se}_@{se2}_@{co}_ts = 1;
@#endfor
@#endfor


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inter-sector trade shares
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

@#for se in 1:sector                                                     
Sector_Index = DSGE_sector==@{se};  % Match DSGE_sectors with NACE sector names in calibration

@#for se2 in 1:sector
Sector2_Index = DSGE_sector==@{se2};
set_param_value('Psi_@{se}_@{se2}_@{co}', Calibration.WIOD.y05.(ISO{Country_Index}).IO.Psi_H{NACE(Sector2_Index), NACE(Sector_Index)}); // Weighting parameter for intermediate goods -> share of se2 used in H_se
@#endfor

@#endfor                                 



%% Substitution elasticities
sigh_1_@{co} = 1-1/0.1;
sigh_2_@{co} = 1-1/0.1;
sigh_3_@{co} = 1-1/0.1;
sigh_4_@{co} = 1-1/0.1; 
sigh_5_@{co} = 1-1/0.1; 
sigh_6_@{co} = 1-1/0.1; 
sigh_7_@{co} = 1-1/0.1; 
sigh_8_@{co} = 1-1/0.1;
sigh_9_@{co} = 1-1/0.1;
sigh_10_@{co}= 1-1/0.1;
@#endfor

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solving for the steady state values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


kk = getk(M_,DSGE_sector, DSGE_country);
K_a_ts = kk(1);
K_b_ts = kk(2);
H_1_1_a_ts =kk(3);
H_1_2_a_ts =kk(4);
H_1_3_a_ts =kk(5);
H_1_4_a_ts =kk(6);
H_1_5_a_ts =kk(7);
H_1_6_a_ts =kk(8);
H_1_7_a_ts =kk(9);
H_1_8_a_ts =kk(10);
H_1_9_a_ts =kk(11);
H_1_10_a_ts =kk(12);
H_2_1_a_ts =kk(13);
H_2_2_a_ts =kk(14);
H_2_3_a_ts =kk(15);
H_2_4_a_ts =kk(16);
H_2_5_a_ts =kk(17);
H_2_6_a_ts =kk(18);
H_2_7_a_ts =kk(19);
H_2_8_a_ts =kk(20);
H_2_9_a_ts =kk(21);
H_2_10_a_ts =kk(22);
H_3_1_a_ts =kk(23);
H_3_2_a_ts =kk(24);
H_3_3_a_ts =kk(25);
H_3_4_a_ts =kk(26);
H_3_5_a_ts =kk(27);
H_3_6_a_ts =kk(28);
H_3_7_a_ts =kk(29);
H_3_8_a_ts =kk(30);
H_3_9_a_ts =kk(31);
H_3_10_a_ts =kk(32);
H_4_1_a_ts =kk(33);
H_4_2_a_ts =kk(34);
H_4_3_a_ts =kk(35);
H_4_4_a_ts =kk(36);
H_4_5_a_ts =kk(37);
H_4_6_a_ts =kk(38);
H_4_7_a_ts =kk(39);
H_4_8_a_ts =kk(40);
H_4_9_a_ts =kk(41);
H_4_10_a_ts =kk(42);
H_5_1_a_ts =kk(43);
H_5_2_a_ts =kk(44);
H_5_3_a_ts =kk(45);
H_5_4_a_ts =kk(46);
H_5_5_a_ts =kk(47);
H_5_6_a_ts =kk(48);
H_5_7_a_ts =kk(49);
H_5_8_a_ts =kk(50);
H_5_9_a_ts =kk(51);
H_5_10_a_ts =kk(52);
H_6_1_a_ts =kk(53);
H_6_2_a_ts =kk(54);
H_6_3_a_ts =kk(55);
H_6_4_a_ts =kk(56);
H_6_5_a_ts =kk(57);
H_6_6_a_ts =kk(58);
H_6_7_a_ts =kk(59);
H_6_8_a_ts =kk(60);
H_6_9_a_ts =kk(61);
H_6_10_a_ts =kk(62);
H_7_1_a_ts =kk(63);
H_7_2_a_ts =kk(64);
H_7_3_a_ts =kk(65);
H_7_4_a_ts =kk(66);
H_7_5_a_ts =kk(67);
H_7_6_a_ts =kk(68);
H_7_7_a_ts =kk(69);
H_7_8_a_ts =kk(70);
H_7_9_a_ts =kk(71);
H_7_10_a_ts =kk(72);
H_8_1_a_ts =kk(73);
H_8_2_a_ts =kk(74);
H_8_3_a_ts =kk(75);
H_8_4_a_ts =kk(76);
H_8_5_a_ts =kk(77);
H_8_6_a_ts =kk(78);
H_8_7_a_ts =kk(79);
H_8_8_a_ts =kk(80);
H_8_9_a_ts =kk(81);
H_8_10_a_ts =kk(82);
H_9_1_a_ts =kk(83);
H_9_2_a_ts =kk(84);
H_9_3_a_ts =kk(85);
H_9_4_a_ts =kk(86);
H_9_5_a_ts =kk(87);
H_9_6_a_ts =kk(88);
H_9_7_a_ts =kk(89);
H_9_8_a_ts =kk(90);
H_9_9_a_ts =kk(91);
H_9_10_a_ts =kk(92);
H_10_1_a_ts =kk(93);
H_10_2_a_ts =kk(94);
H_10_3_a_ts =kk(95);
H_10_4_a_ts =kk(96);
H_10_5_a_ts =kk(97);
H_10_6_a_ts =kk(98);
H_10_7_a_ts =kk(99);
H_10_8_a_ts =kk(100);
H_10_9_a_ts =kk(101);
H_10_10_a_ts =kk(102);
H_1_1_b_ts =kk(103);
H_1_2_b_ts =kk(104);
H_1_3_b_ts =kk(105);
H_1_4_b_ts =kk(106);
H_1_5_b_ts =kk(107);
H_1_6_b_ts =kk(108);
H_1_7_b_ts =kk(109);
H_1_8_b_ts =kk(110);
H_1_9_b_ts =kk(111);
H_1_10_b_ts =kk(112);
H_2_1_b_ts =kk(113);
H_2_2_b_ts =kk(114);
H_2_3_b_ts =kk(115);
H_2_4_b_ts =kk(116);
H_2_5_b_ts =kk(117);
H_2_6_b_ts =kk(118);
H_2_7_b_ts =kk(119);
H_2_8_b_ts =kk(120);
H_2_9_b_ts =kk(121);
H_2_10_b_ts =kk(122);
H_3_1_b_ts =kk(123);
H_3_2_b_ts =kk(124);
H_3_3_b_ts =kk(125);
H_3_4_b_ts =kk(126);
H_3_5_b_ts =kk(127);
H_3_6_b_ts =kk(128);
H_3_7_b_ts =kk(129);
H_3_8_b_ts =kk(130);
H_3_9_b_ts =kk(131);
H_3_10_b_ts =kk(132);
H_4_1_b_ts =kk(133);
H_4_2_b_ts =kk(134);
H_4_3_b_ts =kk(135);
H_4_4_b_ts =kk(136);
H_4_5_b_ts =kk(137);
H_4_6_b_ts =kk(138);
H_4_7_b_ts =kk(139);
H_4_8_b_ts =kk(140);
H_4_9_b_ts =kk(141);
H_4_10_b_ts =kk(142);
H_5_1_b_ts =kk(143);
H_5_2_b_ts =kk(144);
H_5_3_b_ts =kk(145);
H_5_4_b_ts =kk(146);
H_5_5_b_ts =kk(147);
H_5_6_b_ts =kk(148);
H_5_7_b_ts =kk(149);
H_5_8_b_ts =kk(150);
H_5_9_b_ts =kk(151);
H_5_10_b_ts =kk(152);
H_6_1_b_ts =kk(153);
H_6_2_b_ts =kk(154);
H_6_3_b_ts =kk(155);
H_6_4_b_ts =kk(156);
H_6_5_b_ts =kk(157);
H_6_6_b_ts =kk(158);
H_6_7_b_ts =kk(159);
H_6_8_b_ts =kk(160);
H_6_9_b_ts =kk(161);
H_6_10_b_ts =kk(162);
H_7_1_b_ts =kk(163);
H_7_2_b_ts =kk(164);
H_7_3_b_ts =kk(165);
H_7_4_b_ts =kk(166);
H_7_5_b_ts =kk(167);
H_7_6_b_ts =kk(168);
H_7_7_b_ts =kk(169);
H_7_8_b_ts =kk(170);
H_7_9_b_ts =kk(171);
H_7_10_b_ts =kk(172);
H_8_1_b_ts =kk(173);
H_8_2_b_ts =kk(174);
H_8_3_b_ts =kk(175);
H_8_4_b_ts =kk(176);
H_8_5_b_ts =kk(177);
H_8_6_b_ts =kk(178);
H_8_7_b_ts =kk(179);
H_8_8_b_ts =kk(180);
H_8_9_b_ts =kk(181);
H_8_10_b_ts =kk(182);
H_9_1_b_ts =kk(183);
H_9_2_b_ts =kk(184);
H_9_3_b_ts =kk(185);
H_9_4_b_ts =kk(186);
H_9_5_b_ts =kk(187);
H_9_6_b_ts =kk(188);
H_9_7_b_ts =kk(189);
H_9_8_b_ts =kk(190);
H_9_9_b_ts =kk(191);
H_9_10_b_ts =kk(192);
H_10_1_b_ts =kk(193);
H_10_2_b_ts =kk(194);
H_10_3_b_ts =kk(195);
H_10_4_b_ts =kk(196);
H_10_5_b_ts =kk(197);
H_10_6_b_ts =kk(198);
H_10_7_b_ts =kk(199);
H_10_8_b_ts =kk(200);
H_10_9_b_ts =kk(201);
H_10_10_b_ts =kk(202);


































@#for co in country

I_@{co}_ts = delta*K_@{co}_ts;
C_@{co}_ts = Y_VA_@{co}_ts - I_@{co}_ts;

@#for se in 1:sector

C_@{se}_@{co}_ts = Psi_con_@{se}_@{co}*C_@{co}_ts;
I_@{se}_@{co}_ts = Psi_inv_@{se}_@{co}*I_@{co}_ts;


Y_@{se}_@{co}_ts = (C_@{se}_@{co}_ts+I_@{se}_@{co}_ts + ( 
@#for se2 in 1:sector
+H_@{se2}_@{se}_@{co}_ts
@#endfor
));



ZZ_@{se}_@{co}_ts = carb_int_@{se}_@{co}*Y_@{se}_@{co}_ts;

@#endfor
@#endfor

ZZ_a_ts = (
@#for se in 1:sector
+ ZZ_@{se}_a_ts
@#endfor
);

ZZ_b_ts = (
@#for se in 1:sector
+ ZZ_@{se}_b_ts
@#endfor
);


Y_a_ts = (
@#for se in 1:sector
+ Y_@{se}_a_ts
@#endfor
);

Y_b_ts = (
@#for se in 1:sector
+ Y_@{se}_b_ts
@#endfor
);


EM_ts = (
@#for co in country 
@#for se in 1:sector
+ ZZ_@{se}_@{co}_ts*size_@{co}
@#endfor
@#endfor
)/rho_EM;

@#for co in country
@#for se in 1:sector
   
gama0_@{se}_@{co} =  Pen_@{se}_@{co}_ts - gama1_@{se}_@{co}*EM_ts - gama2_@{se}_@{co}*EM_ts^2;

K_@{se}_@{co}_ts = omega_K_tild_@{se}_@{co}*K_@{co}_ts;
rk_@{se}_@{co}_ts = alphaH_@{se}_@{co}*(1-alphaN_@{se}_@{co})*mc_@{se}_@{co}_ts*Y_@{se}_@{co}_ts/K_@{se}_@{co}_ts;
omega_K_@{se}_@{co} = omega_K_tild_@{se}_@{co} *(rk_@{se}_@{co}_ts/rk_@{co}_ts)^(1/(1-upsi_K_@{co}));                                    

H_@{se}_@{co}_ts = (1-alphaH_@{se}_@{co})*mc_@{se}_@{co}_ts*Y_@{se}_@{co}_ts/PH_@{se}_@{co}_ts;

@#for se2 in 1:sector
H_@{se}_@{se2}_@{co}_ts = Psi_@{se}_@{se2}_@{co}*(PH_@{se}_@{co}_ts/P_@{se2}_@{co}_@{co}_ts)^(1/(1-sigh_@{se}_@{co}))*H_@{se}_@{co}_ts;
@#endfor

@#endfor

w_@{co}_ts = (
@#for se in 1:sector
+alphaH_@{se}_@{co}*alphaN_@{se}_@{co}*mc_@{se}_@{co}_ts*Y_@{se}_@{co}_ts/N_@{co}_ts
@#endfor
);

@#for se in 1:sector
N_@{se}_@{co}_ts = omega_N_tild_@{se}_@{co}*N_@{co}_ts;
w_@{se}_@{co}_ts = alphaH_@{se}_@{co}*alphaN_@{se}_@{co}*mc_@{se}_@{co}_ts*Y_@{se}_@{co}_ts/N_@{se}_@{co}_ts;
omega_N_@{se}_@{co} = omega_N_tild_@{se}_@{co} *(w_@{se}_@{co}_ts/w_@{co}_ts)^(1/(1-upsi_N_@{co}));                                          

epsi_@{se}_@{co}_ts   = Y_@{se}_@{co}_ts/( (1-Pen_@{se}_@{co}_t)* (N_@{se}_@{co}_ts^alphaN_@{se}_@{co}*K_@{se}_@{co}_ts^(1-alphaN_@{se}_@{co}))^alphaH_@{se}_@{co}*H_@{se}_@{co}_ts^(1-alphaH_@{se}_@{co}));


@#endfor

lambda_@{co}_ts = C_@{co}_ts^(-sig);

kappaN_@{co}    = lambda_@{co}_ts*w_@{co}_ts/(N_@{co}_ts^lab_@{co});

@#endfor


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Multi-country part
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


@#for co in country
@#for se in 1:sector
TB_@{se}_@{co}_ts           = 0;
PC_@{se}_@{co}_ts           = 1;
PI_@{se}_@{co}_ts           = 1;
PHH_@{se}_@{co}_ts          = 1;

sigc_@{se}_@{co}            = 1-1/0.9;
sigi_@{se}_@{co}            = 1-1/0.9;
sighh_@{se}_@{co}           = 1-1/0.9;


@#endfor
@#endfor 

@#for co in country 
TB_@{co}_ts = (
@#for se in 1:sector
+ TB_@{se}_@{co}_ts
@#endfor
);
NFA_@{co}_ts = TB_@{co}_ts;
@#endfor


@#for co in country
Country_Index = ismember(DSGE_country, {'@{co}'}); % in order to match DSGE_country names with ISO country names in calibration
    @#for se in 1:sector
    Sector_Index = DSGE_sector==@{se};  % in order to match DSGE_sectors with NACE sector names in calibration

        @#for se2 in 1:sector
        Sector2_Index = DSGE_sector==@{se2};  % in order to match DSGE_sectors with NACE sector names in calibration
        set_param_value('hb_hhh_@{se}_@{se2}_@{co}_@{co}', Calibration.WIOD.y05.(ISO{Country_Index}).IO.Biases_hhh.(ISO{Country_Index}){NACE(Sector2_Index), NACE(Sector_Index)}); 
       H_@{se}_@{se2}_@{co}_@{co}_ts = hb_hhh_@{se}_@{se2}_@{co}_@{co}*H_@{se}_@{se2}_@{co}_ts;
        @#endfor

    @#endfor
@#endfor 

@#for se in 1:sector
    @#for se2 in 1:sector
hb_hhh_@{se}_@{se2}_a_b = 1-hb_hhh_@{se}_@{se2}_a_a;
hb_hhh_@{se}_@{se2}_b_a = 1-hb_hhh_@{se}_@{se2}_b_b;
H_@{se}_@{se2}_a_b_ts = hb_hhh_@{se}_@{se2}_a_b*H_@{se}_@{se2}_a_ts;
H_@{se}_@{se2}_b_a_ts = hb_hhh_@{se}_@{se2}_b_a*H_@{se}_@{se2}_b_ts;
    @#endfor
@#endfor


@#for co in country
Country_Index = ismember(DSGE_country, {'@{co}'}); 
    @#for se in 1:sector
    Sector_Index = DSGE_sector==@{se};  
    set_param_value('hb_con_@{se}_@{co}_@{co}', Calibration.WIOD.y05.(ISO{Country_Index}).NA.Biases_C_I.(ISO{Country_Index}){NACE(Sector_Index), 'HB_C'}); 
    set_param_value('hb_inv_@{se}_@{co}_@{co}', Calibration.WIOD.y05.(ISO{Country_Index}).NA.Biases_C_I.(ISO{Country_Index}){NACE(Sector_Index), 'HB_I'}); 
    @#endfor
@#endfor 


@#for se in 1:sector
hb_con_@{se}_a_b = 1-hb_con_@{se}_a_a;
% hb_con_@{se}_b_a = 1-hb_con_@{se}_b_b;

hb_inv_@{se}_a_b = 1-hb_inv_@{se}_a_a;
% hb_inv_@{se}_b_a = 1-hb_inv_@{se}_b_b;
@#endfor


@#for co in country
@#for se in 1:sector
C_@{se}_@{co}_@{co}_ts = hb_con_@{se}_@{co}_@{co}*C_@{se}_@{co}_ts;
I_@{se}_@{co}_@{co}_ts = hb_inv_@{se}_@{co}_@{co}*I_@{se}_@{co}_ts;

@#for co2 in country
C_@{se}_@{co}_@{co2}_ts = hb_con_@{se}_@{co}_@{co2}*C_@{se}_@{co}_ts;
I_@{se}_@{co}_@{co2}_ts = hb_inv_@{se}_@{co}_@{co2}*I_@{se}_@{co}_ts;
@#endfor
@#endfor
@#endfor 

@#for se in 1:sector
Aux_@{se}_b_a_ts = size_a/size_b*(C_@{se}_a_b_ts+I_@{se}_a_b_ts
@#for se2 in 1:sector
+H_@{se2}_@{se}_a_b_ts
@#endfor
);
@#endfor


@#for co in countryLast
@#for se in 1:sector
@#for co2 in country2
hb_con_@{se}_@{co}_@{co2} = Aux_@{se}_@{co}_@{co2}_ts/(C_@{se}_@{co}_ts+I_@{se}_@{co}_ts + (
@#for se2 in 1:sector
+H_@{se2}_@{se}_@{co}_ts
@#endfor
));
hb_inv_@{se}_@{co}_@{co2} = hb_con_@{se}_@{co}_@{co2};
@#for se2 in 1:sector
hb_hhh_@{se2}_@{se}_@{co}_@{co2} = hb_con_@{se}_@{co}_@{co2};
@#endfor
@#endfor
@#endfor
@#endfor

@#for se in 1:sector
hb_con_@{se}_b_b = 1-hb_con_@{se}_b_a; 
hb_inv_@{se}_b_b = hb_con_@{se}_b_b;
@#for se2 in 1:sector
hb_hhh_@{se2}_@{se}_b_b = hb_con_@{se}_b_b;
@#endfor
@#endfor

@#for co in countryLast
@#for se in 1:sector
@#for co2 in country2
C_@{se}_@{co}_@{co}_ts = hb_con_@{se}_@{co}_@{co}*C_@{se}_@{co}_ts;
I_@{se}_@{co}_@{co}_ts = hb_inv_@{se}_@{co}_@{co}*I_@{se}_@{co}_ts;
@#for se2 in 1:sector
H_@{se2}_@{se}_@{co}_@{co}_ts = hb_hhh_@{se2}_@{se}_@{co}_@{co}*H_@{se2}_@{se}_b_ts;
@#endfor
C_@{se}_@{co}_@{co2}_ts = hb_con_@{se}_@{co}_@{co2}*C_@{se}_@{co}_ts;
I_@{se}_@{co}_@{co2}_ts = hb_inv_@{se}_@{co}_@{co2}*I_@{se}_@{co}_ts;
@#for se2 in 1:sector
H_@{se2}_@{se}_@{co}_@{co2}_ts = hb_hhh_@{se2}_@{se}_@{co}_@{co2}*H_@{se2}_@{se}_b_ts;
@#endfor
@#endfor
@#endfor
@#endfor

@#for se in 1:sector
MM_@{se}_a_b_ts = (C_@{se}_a_b_ts+I_@{se}_a_b_ts
@#for se2 in 1:sector
+H_@{se2}_@{se}_a_b_ts
@#endfor
)*carb_int_@{se}_b;
@#endfor


@#for se in 1:sector
XX_@{se}_b_a_ts = carb_int_@{se}_a * size_b/size_a*(C_@{se}_b_a_ts+I_@{se}_b_a_ts
@#for se2 in 1:sector
+H_@{se2}_@{se}_b_a_ts
@#endfor
);
@#endfor
































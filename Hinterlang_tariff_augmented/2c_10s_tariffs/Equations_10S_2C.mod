model(bytecode);

// ######################################################################### 
// Climate variables
// #########################################################################

@#for co in country 
P_EM_@{co}_t = P_EM_@{co}_ts + shock_P_EM_@{co}_t;
log(epsi_@{co}_t/epsi_@{co}_ts) = rho_eps_@{co} * log(epsi_@{co}_t(-1)/epsi_@{co}_ts) + shock_epsi_@{co}_t;
tau_@{co}_t = rho_tau_@{co} * tau_@{co}_t(-1) + shock_tau_@{co}_t;
@#endfor

EM_t = (1-rho_EM)*EM_t(-1) + (
@#for co in country 
@#for se in 1:sector
+ ZZ_@{se}_@{co}_t*size_@{co}
@#endfor
@#endfor
);

@#for co in country 
@#for se in 1:sector
Pen_@{se}_@{co}_t = gama0_@{se}_@{co} + gama1_@{se}_@{co}*EM_t + gama2_@{se}_@{co}*EM_t^2;
ZZ_@{se}_@{co}_t = (1 + shock_epsi_carb_int_@{co}_t)*carb_int_@{se}_@{co}*Y_@{se}_@{co}_t;
@#endfor
@#endfor


ZZ_a_t =(
@#for se in 1:sector
+ ZZ_@{se}_a_t
@#endfor
);

ZZ_b_t =(
@#for se in 1:sector
+ ZZ_@{se}_b_t
@#endfor
);

// ######################################################################### 
// Domestic aggregates
// #########################################################################

@#for co in country 
log(R_@{co}_t/R_@{co}_ts) = 0.9^4*log(R_@{co}_t(-1)/R_@{co}_ts) + (1-0.9^4) * 1.5*log(pi_cpi_@{co}_t(-1));

K_@{co}_t = (1-delta)*K_@{co}_t(-1) + I_@{co}_t;

lambda_@{co}_t = C_@{co}_t^(-sig);

1 = betta*lambda_@{co}_t(+1)/lambda_@{co}_t*R_@{co}_t/pi_cpi_@{co}_t(+1);

1 = betta*lambda_@{co}_t(+1)/lambda_@{co}_t*(rk_@{co}_t(+1)+(1-delta)*PI_@{co}_t(+1))/PI_@{co}_t;

lambda_@{co}_t*w_@{co}_t = kappaN_@{co}*N_@{co}_t^lab_@{co};

1 = (
@#for se in 1:sector
+ Psi_con_@{se}_@{co}*PC_@{se}_@{co}_t^(-sigc_@{co}/(1-sigc_@{co}))
@#endfor
)^(-(1-sigc_@{co})/sigc_@{co});

pi_cpi_@{co}_t = (
@#for se in 1:sector
+ Psi_con_@{se}_@{co}*(pi_cpi_@{se}_@{co}_t*PC_@{se}_@{co}_t(-1))^(-sigc_@{co}/(1-sigc_@{co}))
@#endfor
)^(-(1-sigc_@{co})/sigc_@{co});

PI_@{co}_t = (
@#for se in 1:sector
+ Psi_inv_@{se}_@{co}*PI_@{se}_@{co}_t^(-sigi_@{co}/(1-sigi_@{co}))
@#endfor
)^(-(1-sigi_@{co})/sigi_@{co});

w_@{co}_t = (
@#for se in 1:sector
+  omega_N_@{se}_@{co}*w_@{se}_@{co}_t^(-upsi_N_@{co}/(1-upsi_N_@{co}))
@#endfor
)^(-(1-upsi_N_@{co})/upsi_N_@{co});

rk_@{co}_t = (
@#for se in 1:sector
+  omega_K_@{se}_@{co}*rk_@{se}_@{co}_t^(-upsi_K_@{co}/(1-upsi_K_@{co}))
@#endfor
)^(-(1-upsi_K_@{co})/upsi_K_@{co});

Y_VA_@{co}_t = C_@{co}_t + PI_@{co}_t*I_@{co}_t + TB_@{co}_t ;
@#endfor

Y_a_t =(
@#for se in 1:sector
+ Y_@{se}_a_t
@#endfor
);

Y_b_t =(
@#for se in 1:sector
+ Y_@{se}_b_t
@#endfor
);


// ######################################################################### 
// Consumption and investmend demand for different goods, relative prices
// ######################################################################### 
@#for co in country 
@#for se in 1:sector
C_@{se}_@{co}_t = Psi_con_@{se}_@{co}*(1/PC_@{se}_@{co}_t)^(1/(1-sigc_@{co}))*C_@{co}_t;
I_@{se}_@{co}_t = Psi_inv_@{se}_@{co}*(PI_@{co}_t/PI_@{se}_@{co}_t)^(1/(1-sigi_@{co}))*I_@{co}_t;   
N_@{se}_@{co}_t = omega_N_@{se}_@{co}*(w_@{co}_t/w_@{se}_@{co}_t)^(1/(1-upsi_N_@{co}))*N_@{co}_t; 
K_@{se}_@{co}_t = omega_K_@{se}_@{co}*(rk_@{co}_t(+1)/rk_@{se}_@{co}_t(+1))^(1/(1-upsi_K_@{co}))*K_@{co}_t; % *(rk_@{co}_t/rk_@{se}_@{co}_t)^(1/(1-upsi_K_@{co}))*

P_@{se}_@{co}_@{co}_t*Y_@{se}_@{co}_t  = PC_@{se}_@{co}_t*C_@{se}_@{co}_t + PI_@{se}_@{co}_t*I_@{se}_@{co}_t + TB_@{se}_@{co}_t + ( 
@#for se2 in 1:sector
+PHH_@{se2}_@{se}_@{co}_t*H_@{se2}_@{se}_@{co}_t
@#endfor
);

Y_@{se}_@{co}_t = epsi_@{co}_t * epsi_@{se}_@{co}_t*(1-Pen_@{se}_@{co}_t)*(N_@{se}_@{co}_t^alphaN_@{se}_@{co}*K_@{se}_@{co}_t(-1)^(1-alphaN_@{se}_@{co}))^alphaH_@{se}_@{co}*H_@{se}_@{co}_t^(1-alphaH_@{se}_@{co});
EM_cost_@{se}_@{co}_t = P_EM_@{co}_t*(1 + shock_epsi_carb_int_@{co}_t)*carb_int_@{se}_@{co};
mc_tild_@{se}_@{co}_t = EM_cost_@{se}_@{co}_t + mc_@{se}_@{co}_t;
P_@{se}_@{co}_@{co}_t = mc_tild_@{se}_@{co}_t;

w_@{se}_@{co}_t  = alphaH_@{se}_@{co}*alphaN_@{se}_@{co}*mc_@{se}_@{co}_t*Y_@{se}_@{co}_t/N_@{se}_@{co}_t;
rk_@{se}_@{co}_t = alphaH_@{se}_@{co}*(1-alphaN_@{se}_@{co})*mc_@{se}_@{co}_t*Y_@{se}_@{co}_t/K_@{se}_@{co}_t(-1);
PH_@{se}_@{co}_t = (1-alphaH_@{se}_@{co})*mc_@{se}_@{co}_t*Y_@{se}_@{co}_t/H_@{se}_@{co}_t;

PH_@{se}_@{co}_t  = (
@#for se2 in 1:sector
+ Psi_@{se}_@{se2}_@{co}*PHH_@{se}_@{se2}_@{co}_t^(-sigh_@{se}_@{co}/(1-sigh_@{se}_@{co}))
@#endfor
)^(-(1-sigh_@{se}_@{co})/sigh_@{se}_@{co});

@#for se2 in 1:sector
H_@{se}_@{se2}_@{co}_t = Psi_@{se}_@{se2}_@{co}*(PH_@{se}_@{co}_t/PHH_@{se}_@{se2}_@{co}_t)^(1/(1-sigh_@{se}_@{co}))*H_@{se}_@{co}_t;
@#endfor

log(epsi_@{se}_@{co}_t/epsi_@{se}_@{co}_ts) = rho_eps_@{co}*log(epsi_@{se}_@{co}_t(-1)/epsi_@{se}_@{co}_ts) + shock_epsi_@{se}_@{co}_t;

// ######################################################################### 
// Multi-country part
// ######################################################################### 

@#for co2 in country
@#for se2 in 1:sector
H_@{se}_@{se2}_@{co}_@{co2}_t = hb_hhh_@{se}_@{se2}_@{co}_@{co2}*(PHH_@{se}_@{se2}_@{co}_t/P_@{se2}_@{co}_@{co2}_t)^(1/(1-sighh_@{se}_@{co}))*H_@{se}_@{se2}_@{co}_t;
@#endfor
I_@{se}_@{co}_@{co2}_t = hb_inv_@{se}_@{co}_@{co2}*(PI_@{se}_@{co}_t/P_@{se}_@{co}_@{co2}_t)^(1/(1-sigi_@{se}_@{co}))*I_@{se}_@{co}_t;
%C_@{se}_@{co}_@{co2}_t = hb_con_@{se}_@{co}_@{co2}*(PC_@{se}_@{co}_t/P_@{se}_@{co}_@{co2}_t)^(1/(1-sigc_@{se}_@{co}))*C_@{se}_@{co}_t;
C_@{se}_@{co}_@{co2}_t = hb_con_@{se}_@{co}_@{co2}*(PC_@{se}_@{co}_t/((1+tau_@{co}_t)*P_@{se}_@{co}_@{co2}_t))^(1/(1-sigc_@{se}_@{co}))*C_@{se}_@{co}_t;
@#endfor

PC_@{se}_@{co}_t = (
@#for co2 in country
+ hb_con_@{se}_@{co}_@{co2}*P_@{se}_@{co}_@{co2}_t^(-sigc_@{se}_@{co}/(1-sigc_@{se}_@{co}))
@#endfor
)^(-(1-sigc_@{se}_@{co})/sigc_@{se}_@{co});

pi_cpi_@{se}_@{co}_t*PC_@{se}_@{co}_t(-1) = (
@#for co2 in country
+ hb_con_@{se}_@{co}_@{co2}*(pi_ppi_@{se}_@{co}_@{co2}_t*P_@{se}_@{co}_@{co2}_t(-1))^(-sigc_@{se}_@{co}/(1-sigc_@{se}_@{co}))
@#endfor
)^(-(1-sigc_@{se}_@{co})/sigc_@{se}_@{co});


@#for se2 in 1:sector
PHH_@{se}_@{se2}_@{co}_t = (
@#for co2 in country
+ hb_hhh_@{se}_@{se2}_@{co}_@{co2}*P_@{se2}_@{co}_@{co2}_t^(-sighh_@{se}_@{co}/(1-sighh_@{se}_@{co}))
@#endfor
)^(-(1-sighh_@{se}_@{co})/sighh_@{se}_@{co});
@#endfor


PI_@{se}_@{co}_t = (
@#for co2 in country
+ hb_inv_@{se}_@{co}_@{co2}*P_@{se}_@{co}_@{co2}_t^(-sigi_@{se}_@{co}/(1-sigi_@{se}_@{co}))
@#endfor
)^(-(1-sigi_@{se}_@{co})/sigi_@{se}_@{co});

@#endfor
@#endfor


@#for se in 1:sector
P_@{se}_b_a_t = rer_ba_t*P_@{se}_a_a_t;     % Note that rer_ba_t = cpi_a/cpi_b and analogously for others
P_@{se}_a_b_t = P_@{se}_b_b_t*(1/rer_ba_t);

pi_ppi_@{se}_a_b_t = pi_ppi_@{se}_b_b_t*(rer_ba_t(-1)/rer_ba_t);
pi_ppi_@{se}_b_a_t = pi_ppi_@{se}_a_a_t*(rer_ba_t/rer_ba_t(-1));
@#endfor

@#for co in country
@#for se in 2:sector
1 = pi_ppi_@{se}_@{co}_@{co}_t/pi_ppi_1_@{co}_@{co}_t*(P_1_@{co}_@{co}_t/P_@{se}_@{co}_@{co}_t)*(P_@{se}_@{co}_@{co}_t(-1)/P_1_@{co}_@{co}_t(-1)); 
@#endfor
@#endfor

// ######################################################################### 
// Trade balance (sector-spercific and aggregates) and net foreig assets
// #########################################################################

@#for co in country 
@#for se in 1:sector
TB_@{se}_@{co}_t = 
@#for co2 in country
+P_@{se}_@{co}_@{co}_t/size_@{co}*(size_@{co2}*C_@{se}_@{co2}_@{co}_t+size_@{co2}*I_@{se}_@{co2}_@{co}_t
@#for se2 in 1:sector
+size_@{co2}*H_@{se2}_@{se}_@{co2}_@{co}_t
@#endfor
)
@#endfor
@#for co2 in country
-P_@{se}_@{co}_@{co2}_t*(C_@{se}_@{co}_@{co2}_t+I_@{se}_@{co}_@{co2}_t
@#for se2 in 1:sector
+H_@{se2}_@{se}_@{co}_@{co2}_t
@#endfor
)
@#endfor
;
@#endfor
@#endfor

@#for co in country 
TB_@{co}_t = (
@#for se in 1:sector
+ TB_@{se}_@{co}_t
@#endfor
);
@#endfor

@#for se in 1:sector
MM_@{se}_a_b_t = carb_int_@{se}_b*(1 + shock_epsi_carb_int_b_t) *(C_@{se}_a_b_t+I_@{se}_a_b_t
@#for se2 in 1:sector
+H_@{se2}_@{se}_a_b_t
@#endfor
);
@#endfor

@#for se in 1:sector
XX_@{se}_b_a_t = carb_int_@{se}_a*(1 + shock_epsi_carb_int_a_t) * size_b/size_a*(C_@{se}_b_a_t+I_@{se}_b_a_t
@#for se2 in 1:sector
+H_@{se2}_@{se}_b_a_t
@#endfor
);
@#endfor


NFA_a_t = R_w_t(-1)/pi_cpi_a_t*exp(-Psi2*(NFA_a_t(-1)-NFA_a_ts)/Y_VA_a_t(-1))*NFA_a_t(-1) + TB_a_t;
R_a_t = R_w_t*exp(-Psi2*(NFA_a_t-NFA_a_ts)/Y_VA_a_t);
R_b_t/pi_cpi_b_t(+1) = R_w_t/pi_cpi_a_t(+1) * (rer_ba_t(+1)/rer_ba_t) *exp(-Psi2*(NFA_b_t*rer_ba_t-NFA_b_ts)/Y_VA_b_t);

NFA_b_t*size_b = -NFA_a_t*size_a;

end;




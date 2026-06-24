% Set parameter values
rho_tau = 0.07;

omega_d = 0.15;
omega_f = 0.85;

beta_d = 0.998;
beta_f = 0.998;

sigma_d = 1;
sigma_f = 1;

phi_d = 2;
phi_f = 2;

delta_d = 0.025;
delta_f = 0.025;

xi_d = 5;
xi_f = 5;

gamma_d = 0.6;
gamma_f = 0.6;

zeta_d = 0.001;
zeta_f = 0.001;

chi_d = 0.8;
chi_f = 0.8;

vN_d = 1;
vN_f = 1;

omega_n_d_1 = 0.6;
omega_n_d_2 = 0.4;
omega_n_f_1 = 0.6;
omega_n_f_2 = 0.4;

vK_d = 1;
vK_f = 1;

omega_k_d_1 = 0.4;
omega_k_d_2 = 0.6;
omega_k_f_1 = 0.4;
omega_k_f_2 = 0.6;


psi_w_d_1 =15;
psi_w_d_2 = 15;
psi_w_f_1 =15;
psi_w_f_2 = 15;

epsilon_w_d_1 = 0.65;
epsilon_w_d_2 = 0.65;
epsilon_w_f_1 = 0.65;
epsilon_w_f_2 = 0.65;

% Markups
Mw_d_1 = epsilon_w_d_1/( 1 - epsilon_w_d_1);
Mw_d_2 = epsilon_w_d_2/( 1 - epsilon_w_d_2);

Mw_f_1 = epsilon_w_f_1/( 1 - epsilon_w_f_1);
Mw_f_2 = epsilon_w_f_2/( 1 - epsilon_w_f_2);

sigmaC_d = 2;
sigmaC_f  = 2;

omega_c_d_1 = 0.5;
omega_c_d_2 = 0.5;

omega_c_f_1 = 0.5;
omega_c_f_2 = 0.5;

sigmaI_d = 2;
sigmaI_f = 2;

omega_i_d_1 = 0.5;
omega_i_d_2 = 0.5;

omega_i_f_1 = 0.5;
omega_i_f_2 = 0.5;

sigmaM_d = 0.1;
sigmaM_f = 0.1;

omega_m_d_1_1 = 0.5;
omega_m_d_1_2 = 0.5;

omega_m_d_2_1 = 0.5;
omega_m_d_2_2 = 0.5;

omega_m_f_1_1 = 0.5;
omega_m_f_1_2 = 0.5;

omega_m_f_2_1 = 0.5;
omega_m_f_2_2 = 0.5;

etaC_d_1 = 0.7;
etaC_d_2 = 0.3;

lambdaC_d_1 = 3;
lambdaC_d_2 = 3;

etaC_f_1 = 0.3;
etaC_f_2 = 0.7;

lambdaC_f_1 = 3;
lambdaC_f_2 = 3;

etaI_d_1 = 0.5;
etaI_d_2 = 0.5;
etaI_f_1 = 0.5;
etaI_f_2 = 0.5;


lambdaI_d_1 = 3;
lambdaI_d_2 = 3;
lambdaI_f_1 = 3;
lambdaI_f_2 = 3;

etaM_d_1_1 = 0.5;
etaM_d_1_2 = 0.5;
etaM_d_2_1 = 0.5;
etaM_d_2_2 = 0.5;


lambdaM_f_1 = 3;
lambdaM_f_2 = 3;
lambdaM_d_1 = 3;
lambdaM_d_2 = 3;

etaM_f_1_1 = 0.5;
etaM_f_1_2 = 0.5;
etaM_f_2_1 = 0.5;
etaM_f_2_2 = 0.5;


alphaL_d_1 = 0.4;
alphaL_d_2 = 0.6;

alphaM_d_1 = 0.5;
alphaM_d_2 = 0.4;

alphaL_f_1 = 0.4;
alphaL_f_2 = 0.6;

alphaM_f_1 = 0.5;
alphaM_f_2 = 0.4;

% Markups

epsilon_p_d_1 = 0.6;
epsilon_p_d_2 = 0.6;
epsilon_p_f_1 = 0.6;
epsilon_p_f_2 = 0.6;

Mp_d_1 = epsilon_p_d_1/( 1 - epsilon_p_d_1);
Mp_d_2 = epsilon_p_d_2/( 1 - epsilon_p_d_2);

Mp_f_1 = epsilon_p_f_1/( 1 - epsilon_p_f_1);
Mp_f_2 = epsilon_p_f_2/( 1 - epsilon_p_f_2);


psi_p_d_1 = 15;
psi_p_d_2 = 15;
psi_p_f_1 = 15;
psi_p_f_2 = 15;


rho_R_d = 0.85;
rho_R_f = 0.85;

phi_pi_d = 1.9;
phi_pi_f = 1.9;

phi_y_d = 0.1;
phi_y_f = 0.1;



R_ss_d = 1/beta_d -1;
picpi_ss_d = 1;
Y_VA_ss_d  = 1;

R_ss_f =  1/beta_f -1;
picpi_ss_f = 1;
Y_VA_ss_f  = 1;


% 1. Tariff SS values (free trade)
tauC_d_1_ss=0; tauC_d_2_ss=0; tauC_f_1_ss=0; tauC_f_2_ss=0;
tauM_d_1_ss=0; tauM_d_2_ss=0; tauM_f_1_ss=0; tauM_f_2_ss=0;

rho_tauC_d_1 = 0.95;
rho_tauC_d_2 = 0.95;

rho_tauC_f_1 = 0.95;
rho_tauC_f_2 = 0.95;


rho_tauM_d_1 = 0.95;
rho_tauM_d_2 = 0.95;

rho_tauM_f_1 = 0.95;
rho_tauM_f_2 = 0.95;

% 2. Taylor rule output targets (must match solved Y_VA)
Yd_VA_ss_d = 5.1139425136;
Yd_VA_ss_f = 0.4831015566;

% 3. NFA targets
a_df_ss = -2086.2708786608;
a_fd_ss =  368.1654491754;


save par
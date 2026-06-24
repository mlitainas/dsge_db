parameters

beta_d beta_f
sigma_d sigma_f
gamma_d gamma_f

chi_d chi_f
phi_d phi_f

delta_d delta_f
xi_d xi_f

zeta_d zeta_f

a_df_ss
a_fd_ss

vN_d
vN_f

vK_d
vK_f
omega_n_d_1 omega_n_d_2
omega_n_f_1 omega_n_f_2

omega_k_d_1 omega_k_d_2
omega_k_f_1 omega_k_f_2

epsilon_w_d_1 epsilon_w_d_2
epsilon_w_f_1 epsilon_w_f_2

Mw_d_1 Mw_d_2 
Mw_f_1 Mw_f_2

psi_w_d_1 psi_w_d_2
psi_w_f_1 psi_w_f_2

sigmaC_d
sigmaC_f
sigmaI_d
sigmaI_f
sigmaM_d
sigmaM_f

omega_c_d_1 omega_c_d_2
omega_c_f_1 omega_c_f_2

omega_i_d_1 omega_i_d_2
omega_i_f_1 omega_i_f_2

omega_m_d_1_1 omega_m_d_1_2
omega_m_d_2_1 omega_m_d_2_2

omega_m_f_1_1 omega_m_f_1_2
omega_m_f_2_1 omega_m_f_2_2

etaC_d_1 etaC_d_2
etaC_f_1 etaC_f_2

lambdaC_d_1 lambdaC_d_2
lambdaC_f_1 lambdaC_f_2


etaI_d_1 etaI_d_2
etaI_f_1 etaI_f_2

lambdaI_d_1 lambdaI_d_2
lambdaI_f_1 lambdaI_f_2

etaM_d_1_1 etaM_d_1_2
etaM_d_2_1 etaM_d_2_2

etaM_f_1_1 etaM_f_1_2
etaM_f_2_1 etaM_f_2_2

lambdaM_d_1 lambdaM_d_2
lambdaM_f_1 lambdaM_f_2


alphaL_d_1 alphaL_d_2
alphaL_f_1 alphaL_f_2

alphaM_d_1 alphaM_d_2
alphaM_f_1 alphaM_f_2

epsilon_p_d_1 epsilon_p_d_2
epsilon_p_f_1 epsilon_p_f_2

Mp_d_1 Mp_d_2
Mp_f_1 Mp_f_2

psi_p_d_1 psi_p_d_2
psi_p_f_1 psi_p_f_2

R_ss_d R_ss_f
picpi_ss_d picpi_ss_f

rho_R_d rho_R_f

phi_pi_d phi_pi_f
phi_y_d  phi_y_f

Yd_VA_ss_d
Yd_VA_ss_f

omega_d
omega_f


% persistence parameters
rho_tauC_d_1  rho_tauC_d_2  rho_tauC_f_1  rho_tauC_f_2
rho_tauM_d_1  rho_tauM_d_2  rho_tauM_f_1  rho_tauM_f_2

% steady-state values (typically 1 if tariff = 1 means no tariff, 
% or 1+tau if tau is the ad valorem rate)
tauC_d_1_ss  tauC_d_2_ss  tauC_f_1_ss  tauC_f_2_ss
tauM_d_1_ss  tauM_d_2_ss  tauM_f_1_ss  tauM_f_2_ss
;

load par;
for jj = 1:length(M_.param_names)
    pname = M_.param_names{jj};
    if exist(pname, 'var')
        set_param_value(pname, eval(pname));
    else
        warning('Parameter %s not found in workspace', pname);
    end
end
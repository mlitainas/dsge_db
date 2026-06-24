% ============================================================
% STEADY STATE FOR main.mod
% Computed analytically from model structure.
%
% Key SS assumptions:
%   - Free trade: all tariffs = 0
%   - Symmetric exchange rates: E_d = E_f = 1
%   - All inflation = 1 (zero net inflation)
%   - Balanced trade: A_df = A_fd = 0
%   - Prices normalised: P_d_s = P_f_s = 1
%   - RK_d_s and RK_f_s differ across sectors (heterogeneous capital intensity)
%   - RK_d = RK_f = delta + R_ss (from aggregate Tobin q)
% ============================================================

% ---- Add to load_parameters.m ----
% Tariff SS values (free trade baseline)
% tauC_d_1_ss = 0; tauC_d_2_ss = 0; tauC_f_1_ss = 0; tauC_f_2_ss = 0;
% tauM_d_1_ss = 0; tauM_d_2_ss = 0; tauM_f_1_ss = 0; tauM_f_2_ss = 0;
% AR(1) persistence
% rho_tauC_d_1=0.9; rho_tauC_d_2=0.9; rho_tauC_f_1=0.9; rho_tauC_f_2=0.9;
% rho_tauM_d_1=0.9; rho_tauM_d_2=0.9; rho_tauM_f_1=0.9; rho_tauM_f_2=0.9;
% Yd_VA_ss_d (used in Taylor rule — set equal to Y_VA_d computed below)
% Yd_VA_ss_d = 12.30821052; Yd_VA_ss_f = 2.13442810;
% a_df_ss = 0; a_fd_ss = 0;
% psi_w_d_1=15; psi_w_d_2=15; psi_w_f_1=15; psi_w_f_2=15;
% vN = 1; vK = 1;
% sigmaC = 2; sigmaI = 2; sigmaM = 0.1;
% omega_m_d_2_1=0.5; omega_m_d_2_2=0.5; omega_m_f_2_1=0.5; omega_m_f_2_2=0.5;

% ============================================================
% USE THIS AS initval BLOCK  (or convert to steady_state_model)
% ============================================================

initval;

% --- Outputs ---
Y_d_1 = 11.35970534;
Y_d_2 = 7.89178937;
Y_f_1 = 1.44051833;
Y_f_2 = 1.95680429;

% --- Aggregate consumption & investment ---
C_d = 0.03125044;
C_f = 3.33228726;
I_d = 2.88265720;
I_f = 0.45995900;

% --- Capital stocks ---
K_d = 115.30628814;
K_f = 18.39835981;
K_d_1 = 62.29323831;
K_d_2 = 46.43977552;
K_f_1 = 8.86094065;
K_f_2 = 9.23717398;

% --- Labour ---
N_d = 3.30367798;
N_f = 0.34484285;
N_d_1 = 2.43772354;
N_d_2 = 5.19575991;   % Note: N_d_2 > N_d because sector 2 is labour-intensive
N_f_1 = 0.26019885;
N_f_2 = 1.49223164;
L_d_1 = 2.43772354;
L_d_2 = 5.19575991;
L_f_1 = 0.26019885;
L_f_2 = 1.49223164;

% --- Intermediates (aggregate) ---
M_d_1 = 3.78656845;
M_d_2 = 3.15671575;
M_f_1 = 0.48017278;
M_f_2 = 0.78272172;

% --- Intermediate bundles (sector s used by sector j) ---
M_d_1_1 = 1.89328422;
M_d_1_2 = 1.89328422;
M_d_2_1 = 1.57835787;
M_d_2_2 = 1.57835787;
M_f_1_1 = 0.24008639;
M_f_1_2 = 0.24008639;
M_f_2_1 = 0.39136086;
M_f_2_2 = 0.39136086;

% --- Sectoral consumption demands ---
C_d_1 = 0.01562522;
C_d_2 = 0.01562522;
C_f_1 = 1.66614363;
C_f_2 = 1.66614363;

% --- Sectoral investment demands ---
I_d_1 = 1.44132860;
I_d_2 = 1.44132860;
I_f_1 = 0.22997950;
I_f_2 = 0.22997950;

% --- International consumption demands ---
C_d_d_1 = 0.01093765;
C_d_d_2 = 0.00468757;
C_d_f_1 = 0.00468757;
C_d_f_2 = 0.01093765;
C_f_d_1 = 1.16630054;
C_f_d_2 = 0.49984309;
C_f_f_1 = 0.49984309;
C_f_f_2 = 1.16630054;

% --- International investment demands ---
I_d_d_1 = 0.72066430;
I_d_d_2 = 0.72066430;
I_d_f_1 = 0.72066430;
I_d_f_2 = 0.72066430;
I_f_f_1 = 0.11498975;
I_f_f_2 = 0.11498975;
I_f_d_1 = 0.11498975;
I_f_d_2 = 0.11498975;

% --- International intermediate demands ---
M_d_d_1_1 = 0.94664211;
M_d_d_1_2 = 0.94664211;
M_d_d_2_1 = 0.78917894;
M_d_d_2_2 = 0.78917894;
M_d_f_1_1 = 0.94664211;
M_d_f_1_2 = 0.94664211;
M_d_f_2_1 = 0.78917894;
M_d_f_2_2 = 0.78917894;
M_f_f_1_1 = 0.12004319;
M_f_f_1_2 = 0.12004319;
M_f_f_2_1 = 0.19568043;
M_f_f_2_2 = 0.19568043;
M_f_d_1_1 = 0.12004319;
M_f_d_1_2 = 0.12004319;
M_f_d_2_1 = 0.19568043;
M_f_d_2_2 = 0.19568043;

% --- Trade balances ---
TB_d = 9.39430288;
TB_f = -1.65781815;
TB_d_1 = 6.43110942;
TB_d_2 = 2.96319345;
TB_f_1 = -1.08705205;
TB_f_2 = -0.57076611;

% --- Value added output (for Taylor rule) ---
Y_VA_d = 12.30821052;
Y_VA_f = 2.13442810;

% --- Marginal utilities ---
mu_d = 32.09555254;
mu_f = 0.30099446;

% --- Wages (firm-posted) ---
W_d_1 = 0.62132861;
W_d_2 = 0.24302245;
W_f_1 = 0.73816279;
W_f_2 = 0.20981239;

% --- Wages (household-received, net of union markup) ---
WC_d_1 = 0.33456156;
WC_d_2 = 0.13085824;
WC_f_1 = 0.39747227;
WC_f_2 = 0.11297590;
WC_d = 0.27204487;
WC_f = 0.31606320;

% --- Marginal costs ---
MC_d_1 = 0.66666667;
MC_d_2 = 0.66666667;
MC_f_1 = 0.66666667;
MC_f_2 = 0.66666667;

% --- Rental rates (sector-specific, differ due to capital intensity) ---
RK_d = 0.02700401;
RK_f = 0.02700401;
RK_d_1 = 0.03647171;
RK_d_2 = 0.01812651;
RK_f_1 = 0.03251389;
RK_f_2 = 0.02259628;

% --- Interest rates ---
R_d = 0.00200401;
R_f = 0.00200401;
Ra  = 0.00200401;

% --- Tobin q ---
q_d = 1.0;
q_f = 1.0;

% --- Sector prices (normalised) ---
P_d_1 = 1.0;   P_d_2 = 1.0;
P_f_1 = 1.0;   P_f_2 = 1.0;

% --- Retail price indices (all = 1 when sector prices = 1, tau = 0, E = 1) ---
PC_d = 1.0;    PC_f = 1.0;
PI_d = 1.0;    PI_f = 1.0;
PC_d_1 = 1.0;  PC_d_2 = 1.0;
PC_f_1 = 1.0;  PC_f_2 = 1.0;
PI_d_1 = 1.0;  PI_d_2 = 1.0;
PI_f_1 = 1.0;  PI_f_2 = 1.0;
PM_d_1 = 1.0;  PM_d_2 = 1.0;
PM_f_1 = 1.0;  PM_f_2 = 1.0;
PM_d_1_1 = 1.0; PM_d_1_2 = 1.0;
PM_d_2_1 = 1.0; PM_d_2_2 = 1.0;
PM_f_1_1 = 1.0; PM_f_1_2 = 1.0;
PM_f_2_1 = 1.0; PM_f_2_2 = 1.0;

% --- Exchange rates ---
E_d = 1.0;
E_f = 1.0;

% --- Inflation (gross rates = 1 at zero inflation SS) ---
picpi_d = 1.0;   picpi_f = 1.0;
pippi_d_1 = 1.0; pippi_d_2 = 1.0;
pippi_f_1 = 1.0; pippi_f_2 = 1.0;
pi_wage_d_1 = 1.0; pi_wage_d_2 = 1.0;
pi_wage_f_1 = 1.0; pi_wage_f_2 = 1.0;

% --- Foreign assets (balanced trade SS) ---
a_df = 0.0;
a_fd = 0.0;
A_df = 0.0;
A_fd = 0.0;

% --- Tariffs (free trade baseline) ---
tauC_d_1 = 0.0;  tauC_d_2 = 0.0;
tauC_f_1 = 0.0;  tauC_f_2 = 0.0;
tauM_d_1 = 0.0;  tauM_d_2 = 0.0;
tauM_f_1 = 0.0;  tauM_f_2 = 0.0;

end;

steady;
%resid(1);
check;

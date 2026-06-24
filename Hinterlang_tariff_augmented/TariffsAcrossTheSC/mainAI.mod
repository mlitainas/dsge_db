% =========================================================================
% REPLICATION: Gnocato, Montes-Galdon, Stamato (2025/2026)
% "Tariffs across the supply chain" -- ECB WP 3081
%
% TWO-REGION (h = EU, f = RoW), TWO-SECTOR (1 = Agri/Mining, 2 = Manuf)
%
% Naming convention (all explicit -- Dynare has no loops):
%   Regions  : _h  (home/EU)   |  _f  (foreign/RoW)
%   Sectors  : _1  (sector 1)  |  _2  (sector 2)
%   Cross    : _h1 = home region, sector 1, etc.
%
% Equation numbers refer to the paper's Section 2.
%
% STATUS: scaffold / template -- parameters and steady-state block
%         need your calibration numbers. IRF shock block at the end.
% =========================================================================

% -------------------------------------------------------------------------
% 1. VARIABLES
% -------------------------------------------------------------------------
var

    %--- Consumption, investment, labour, capital (per region) ---
    C_h     C_f         % aggregate consumption  (eq. 21 aggregator output)
    I_h     I_f         % aggregate investment
    N_h     N_f         % aggregate labour
    K_h     K_f         % aggregate capital stock

    %--- Sectoral consumption quantities ---
    C_h1    C_h2        % home household sectoral consumption bundles
    C_f1    C_f2        % foreign household sectoral consumption bundles

    %--- Sectoral investment quantities ---
    I_h1    I_h2
    I_f1    I_f2

    %--- Sectoral labour and capital (supplied to each sector) ---
    N_h1    N_h2
    N_f1    N_f2
    K_h1    K_h2        % capital rented to sector s, region i (eq. 13)
    K_f1    K_f2

    %--- Intermediate input bundles (sector s uses inputs from x) ---
    % M_is,t: total intermediate bundle used in sector s of region i
    M_h1    M_h2
    M_f1    M_f2
    % Domestic vs imported intermediates: sector s=1 uses from x=1 and x=2
    M_hh11  M_hh12      % home sector 1 using home inputs from sector 1 and 2
    M_hh21  M_hh22      % home sector 2 using home inputs from sector 1 and 2
    M_hf11  M_hf12      % home sector 1 using foreign inputs from sector 1 and 2
    M_hf21  M_hf22      % home sector 2 using foreign inputs from sector 1 and 2
    M_fh11  M_fh12      % foreign sector 1 using home inputs
    M_fh21  M_fh22
    M_ff11  M_ff12
    M_ff21  M_ff22

    %--- Consumption bundles: domestic vs imported ---
    C_hh1   C_hh2       % home consumption of home-produced goods, sectors 1,2
    C_hf1   C_hf2       % home consumption of foreign goods
    C_fh1   C_fh2       % foreign consumption of home goods
    C_ff1   C_ff2

    %--- Investment bundles: domestic vs imported ---
    I_hh1   I_hh2
    I_hf1   I_hf2
    I_fh1   I_fh2
    I_ff1   I_ff2

    %--- Sectoral output ---
    Y_h1    Y_h2
    Y_f1    Y_f2

    %--- Prices: PPI (producer), CPI aggregates ---
    P_h1    P_h2        % producer prices (nominal, domestic currency)
    P_f1    P_f2
    PC_h    PC_f        % CPI  (eq. 23)
    PI_h    PI_f        % investment price index (eq. 26)
    PC_h1   PC_h2       % sectoral consumption price (eq. 32)
    PC_f1   PC_f2
    PI_h1   PI_h2       % sectoral investment price
    PI_f1   PI_f2
    PM_h1   PM_h2       % intermediate input price bundle (eq. 28)
    PM_f1   PM_f2

    %--- Wages and rental rates ---
    W_h1    W_h2        % sectoral wages (nominal, home currency)
    W_f1    W_f2
    Wc_h    Wc_f        % aggregate wage index (eq. 11)
    RK_h1   RK_h2       % sectoral capital rental rates (eq. 14)
    RK_f1   RK_f2
    RKc_h   RKc_f       % aggregate rental rate index

    %--- Marginal costs ---
    MC_h1   MC_h2
    MC_f1   MC_f2

    %--- Inflation rates (gross) ---
    PiPPI_h1  PiPPI_h2  % PPI inflation (eq. 50)
    PiPPI_f1  PiPPI_f2
    PiCPI_h   PiCPI_f   % CPI inflation
    PiW_h1    PiW_h2    % wage inflation (eq. 20)
    PiW_f1    PiW_f2

    %--- Monetary policy ---
    R_h     R_f         % nominal interest rate (Taylor rule, eq. 52)

    %--- Exchange rate and international assets ---
    E_hf                % bilateral nominal exchange rate (h per unit of f)
    A_fh                % net foreign assets of f (denominated in f currency, eq. 59)
    TB_h    TB_f        % trade balance

    %--- Marginal utility of consumption ---
    mu_h    mu_f        % mu_i,t in eq. (7)

    %--- Tobin's q (investment, eq. 6) ---
    q_h     q_f

    %--- GDP ---
    GDP_h   GDP_f       % eq. 56

    %--- Tariff shocks (exogenous AR1, eq. 93) ---
    % tau^c_{i,s,t}: tariff on consumption goods of sector s imported by i
    % tau^m_{i,x,t}: tariff on intermediate goods of sector x imported by i
    tau_c_h1  tau_c_h2  % home tariff on consumption goods from sectors 1,2
    tau_c_f1  tau_c_f2  % foreign tariff on consumption goods
    tau_m_h1  tau_m_h2  % home tariff on intermediate inputs from sectors 1,2
    tau_m_f1  tau_m_f2  % foreign tariff on intermediates
;

% -------------------------------------------------------------------------
% 2. EXOGENOUS SHOCKS
% -------------------------------------------------------------------------
varexo
    eps_tauc_h1  eps_tauc_h2
    eps_tauc_f1  eps_tauc_f2
    eps_taum_h1  eps_taum_h2
    eps_taum_f1  eps_taum_f2
;

% -------------------------------------------------------------------------
% 3. PARAMETERS
% -------------------------------------------------------------------------
parameters

    %--- Preferences ---
    betta           % discount factor (beta, Table 1: 0.998)
    sigma           % inverse EIS (Table 1: 1)
    phi_par         % inverse Frisch (Table 1: 2)
    gam             % habit persistence (Table 1: 0.6)
    zeta            % portfolio adj. cost (Table 1: 0.001)

    %--- Capital ---
    delta           % depreciation (Table 1: 0.025)
    xi              % investment adj. cost (Table 1: 5)

    %--- Relative sizes ---
    omega_h  omega_f % region shares in world GDP (0.15, 0.85)

    %--- Sectoral weights in consumption/investment bundles ---
    % omega^c_{i,s}: weight of sector s in region i consumption basket (eq. 21)
    omegac_h1  omegac_h2
    omegac_f1  omegac_f2
    omegaI_h1  omegaI_h2
    omegaI_f1  omegaI_f2

    %--- Labour and capital supply weights across sectors (eq. 9, 12) ---
    omegan_h1  omegan_h2
    omegan_f1  omegan_f2
    omegak_h1  omegak_h2
    omegak_f1  omegak_f2

    %--- Input-output weights (eq. 27) ---
    % omega^m_{i,sx}: weight of sector x in intermediate bundle of sector s, region i
    omegam_h11  omegam_h12   % home sector 1 intermediate weights
    omegam_h21  omegam_h22   % home sector 2 intermediate weights
    omegam_f11  omegam_f12
    omegam_f21  omegam_f22

    %--- Home biases ---
    % eta^c_{i,s}: home bias in consumption (eq. 29)
    etac_h1  etac_h2
    etac_f1  etac_f2
    % eta^I_{i,s}: home bias in investment (eq. 33)
    etaI_h1  etaI_h2
    etaI_f1  etaI_f2
    % eta^m_{i,sx}: home bias in intermediate inputs (eq. 37)
    etam_h11  etam_h12   % home sector 1 sourcing from sectors 1 and 2
    etam_h21  etam_h22   % home sector 2 sourcing
    etam_f11  etam_f12
    etam_f21  etam_f22

    %--- Armington elasticities ---
    lambda_c        % between domestic/foreign CONSUMPTION goods (Table 1: 3)
    lambda_I        % between domestic/foreign INVESTMENT goods  (Table 1: 0.75)
    lambda_m        % between domestic/foreign INTERMEDIATE inputs (Table 1: 0.1)

    %--- Within-region elasticities of substitution ---
    sigma_c         % across sectoral consumption (Table 1: 2)
    sigma_I         % across sectoral investment  (Table 1: 2)
    sigma_m         % across sectoral intermediate inputs (Table 1: 0.1)
    nu_n            % across sectoral labour supply (Table 1: 1)
    nu_k            % across sectoral capital supply (Table 1: 1)

    %--- Production: factor intensities ---
    % alpha^m_{i,s}: intermediate input share in production (eq. 43)
    alpham_h1  alpham_h2
    alpham_f1  alpham_f2
    % alpha^k_{i,s}: capital share in value-added bundle
    alphak_h1  alphak_h2
    alphak_f1  alphak_f2

    %--- Markups and Rotemberg price adjustment costs ---
    MP_h1  MP_h2       % steady-state price markups (Table 1: 1.18 - 1.86)
    MP_f1  MP_f2
    psiP_h1  psiP_h2   % Rotemberg price adj. cost (Table B.1)
    psiP_f1  psiP_f2

    %--- Wage markdown and Rotemberg wage adj. cost ---
    Mw              % steady-state wage markdown (Table 1: 0.77)
    psiW            % Rotemberg wage adj. cost (Table 1: 75)

    %--- Labour/capital supply elasticities across sectors ---
    % Already captured by nu_n, nu_k above

    %--- Monetary policy (Taylor rule, eq. 52) ---
    rhoR            % smoothing (Table 1: 0.85)
    phi_pi          % inflation weight (Table 1: 1.9)
    phi_y           % GDP weight (Table 1: 0.1)

    %--- Tariff AR(1) persistence ---
    rho_tau         % common persistence for all tariff shocks (paper: 0.95)

    %--- Productivity (normalised to 1 in SS) ---
    A_h1  A_h2
    A_f1  A_f2
;

% -------------------------------------------------------------------------
% 4. PARAMETER VALUES
%    Fill from Table 1 and Table B.1/B.2 of the paper.
%    Two-sector mapping: sector 1 = Agriculture (A), sector 2 = Manufacturing (C)
% -------------------------------------------------------------------------

%--- Aggregate preferences and technology ---
betta   = 0.998;
sigma   = 1;
phi_par = 2;
gam     = 0.6;
zeta    = 0.001;
delta   = 0.025;
xi      = 5;

%--- Region sizes ---
omega_h = 0.15;
omega_f = 0.85;

%--- Armington elasticities ---
lambda_c = 3;       % Bajzik et al. (2020) median
lambda_I = 0.75;    % within-region sigma_I used as proxy
lambda_m = 0.1;     % Boehm et al. (2019)

%--- Within-region substitution elasticities ---
sigma_c = 2;
sigma_I = 2;
sigma_m = 0.1;
nu_n    = 1;
nu_k    = 1;

%--- Monetary policy ---
rhoR    = 0.85;
phi_pi  = 1.9;
phi_y   = 0.1;

%--- Tariff persistence ---
rho_tau = 0.95;

%--- Productivity (normalised) ---
A_h1 = 1;  A_h2 = 1;
A_f1 = 1;  A_f2 = 1;

%--- Wage markdown ---
Mw   = 0.77;
psiW = 75;

%--- SECTOR-SPECIFIC: markups (Table B.1) ---
% Sector 1 = Agriculture: markup 1.20
% Sector 2 = Manufacturing: markup 1.18
MP_h1 = 1.20;   MP_h2 = 1.18;
MP_f1 = 1.20;   MP_f2 = 1.18;

%--- SECTOR-SPECIFIC: Rotemberg price adj. costs (Table B.1) ---
% Computed as psi = theta / [(MP-1)(1-theta)(1-beta*theta)]
% theta_EU: Agri=0.42, Manuf=0.73
psiP_h1 = 6.30;    psiP_h2 = 54.85;   % from Table B.1
psiP_f1 = 0.82;    psiP_f2 = 11.92;

%--- SECTOR-SPECIFIC: factor intensities (Table B.2, EU rows) ---
% alpha^m (intermediate input share in gross output)
alpham_h1 = 0.577;   alpham_h2 = 0.712;
alpham_f1 = 0.420;   alpham_f2 = 0.752;
% alpha^k (capital share in value-added)
alphak_h1 = 0.344;   alphak_h2 = 0.391;
alphak_f1 = 0.228;   alphak_f2 = 0.512;

%--- SECTOR-SPECIFIC: consumption and investment weights (Table B.2) ---
omegac_h1 = 0.029;   omegac_h2 = 0.331;   % sectors don't sum to 1 in 10-sector
% NOTE: with only 2 sectors, renormalise so they sum to 1:
omegac_h1 = 0.029/(0.029+0.331);
omegac_h2 = 0.331/(0.029+0.331);
omegac_f1 = 0.068/(0.068+0.344);
omegac_f2 = 0.344/(0.068+0.344);

omegaI_h1 = 0.004/(0.004+0.309);
omegaI_h2 = 0.309/(0.004+0.309);
omegaI_f1 = 0.006/(0.006+0.266);
omegaI_f2 = 0.266/(0.006+0.266);

%--- SECTOR-SPECIFIC: labour and capital weights (Table B.2) ---
omegan_h1 = 0.153/(0.153+0.156);
omegan_h2 = 0.156/(0.153+0.156);
omegan_f1 = 0.844/(0.844+0.141);   % RoW agriculture heavily labour-intensive
omegan_f2 = 0.141/(0.844+0.141);
omegak_h1 = 0.142/(0.142+0.177);
omegak_h2 = 0.177/(0.142+0.177);
omegak_f1 = 0.069/(0.069+0.259);
omegak_f2 = 0.259/(0.069+0.259);

%--- INPUT-OUTPUT weights: restrict to 2x2 from Table B.3 ---
% omega^m_{i,sx}: share of sector x in intermediate bundle of sector s
% Row=using sector, col=supplying sector. Extract [A,C] block and renormalise.
% EU:
raw_h11 = 0.266;  raw_h12 = 0.422;   % sector 1 (Agri) using Agri and Manuf
raw_h21 = 0.058;  raw_h22 = 0.558;   % sector 2 (Manuf) using Agri and Manuf
omegam_h11 = raw_h11/(raw_h11+raw_h12);
omegam_h12 = raw_h12/(raw_h11+raw_h12);
omegam_h21 = raw_h21/(raw_h21+raw_h22);
omegam_h22 = raw_h22/(raw_h21+raw_h22);
% RoW:
raw_f11 = 0.348;  raw_f12 = 0.414;
raw_f21 = 0.074;  raw_f22 = 0.593;
omegam_f11 = raw_f11/(raw_f11+raw_f12);
omegam_f12 = raw_f12/(raw_f11+raw_f12);
omegam_f21 = raw_f21/(raw_f21+raw_f22);
omegam_f22 = raw_f22/(raw_f21+raw_f22);

%--- HOME BIASES in consumption and investment (Table B.2) ---
etac_h1 = 0.875;   etac_h2 = 0.813;
etac_f1 = 0.979;   etac_f2 = 0.935;
etaI_h1 = 0.957;   etaI_h2 = 0.794;
etaI_f1 = 0.995;   etaI_f2 = 0.909;

%--- HOME BIASES in intermediate inputs (Table B.4, [A,C] diagonal) ---
% eta^m_{i,sx}: home bias in sector s of region i sourcing from sector x
% Using the diagonal (self-supply) and off-diagonal from Table B.4:
etam_h11 = 0.912;   etam_h12 = 0.876;   % sector 1 sourcing from x=1 and x=2
etam_h21 = 0.892;   etam_h22 = 0.828;   % sector 2 sourcing
etam_f11 = 0.982;   etam_f12 = 0.972;
etam_f21 = 0.985;   etam_f22 = 0.972;

% -------------------------------------------------------------------------
% 5. MODEL EQUATIONS
%    All equations in LEVELS. Dynare will log-linearise around the
%    steady state defined in the initval/steady_state block below.
% -------------------------------------------------------------------------
model;

% =========================================================================
% BLOCK A: HOUSEHOLD OPTIMALITY -- HOME REGION
% Equations (4)-(8), (9)-(14)
% =========================================================================

% --- A1. Labour supply (eq. 4), FOC wrt aggregate labour ---
% chi * N^phi = mu * Wc/PC  -- here chi=1 (absorbed into steady state)
N_h^phi_par = mu_h * (Wc_h / PC_h);

% --- A2. Marginal utility of consumption (with habit, eq. below eq. 8) ---
% mu_{i,t} = (C - gamma*C(-1))^{-sigma} - gamma*beta*E[(C(+1)-gamma*C)^{-sigma}]
mu_h = (C_h - gam*C_h(-1))^(-sigma) - gam*betta*((C_h(+1) - gam*C_h)^(-sigma));

% --- A3. Euler equation -- domestic bond (eq. 7) ---
1 = betta * (mu_h(+1)/mu_h) * (R_h / PiCPI_h(+1));

% --- A4. Euler equation -- foreign asset (eq. 8) ---
% Asset denominated in f's currency; E_hf = home per foreign
% Risk premium: [1 + zeta*(a_fh - abar)]^{-1}
% In zero-inflation SS: a_fh = A_fh*E_hf/PC_h = 0 (NFA=0)
1 = betta * (mu_h(+1)/mu_h) * (E_hf(+1)/E_hf) * R_f / PiCPI_h(+1)
    * (1 + zeta*(A_fh*E_hf/PC_h));        % sign: h holds foreign asset -> use R_f

% --- A5. Tobin's q -- capital valuation (eq. 6) ---
q_h = betta * (mu_h(+1)/mu_h) * ( RKc_h(+1)/PC_h(+1) + (1-delta)*q_h(+1) );

% --- A6. Investment Euler (eq. 5) -- from investment FOC ---
PI_h/PC_h = q_h * (1 - xi/2*(I_h/I_h(-1)-1)^2
                     - xi*(I_h/I_h(-1)-1)*(I_h/I_h(-1)))
           + betta*(mu_h(+1)/mu_h)*q_h(+1)*xi*(I_h(+1)/I_h-1)*(I_h(+1)/I_h)^2;

% --- A7. Capital accumulation (eq. 3) ---
K_h = (1-delta)*K_h(-1) + I_h*(1 - xi/2*(I_h/I_h(-1)-1)^2);

% --- A8. Sectoral labour supply (eq. 10) ---
N_h1 = omegan_h1 * (W_h1/Wc_h)^nu_n * N_h;
N_h2 = omegan_h2 * (W_h2/Wc_h)^nu_n * N_h;

% --- A9. Aggregate wage index (eq. 11) ---
Wc_h^(1+nu_n) = omegan_h1*W_h1^(1+nu_n) + omegan_h2*W_h2^(1+nu_n);

% --- A10. Sectoral capital supply (eq. 13) ---
K_h1 = omegak_h1 * (RK_h1/RKc_h)^nu_k * K_h;
K_h2 = omegak_h2 * (RK_h2/RKc_h)^nu_k * K_h;

% --- A11. Aggregate rental rate index (eq. 14) ---
RKc_h^(1+nu_k) = omegak_h1*RK_h1^(1+nu_k) + omegak_h2*RK_h2^(1+nu_k);

% =========================================================================
% BLOCK A (mirror): HOUSEHOLD OPTIMALITY -- FOREIGN REGION
% =========================================================================

N_f^phi_par = mu_f * (Wc_f / PC_f);

mu_f = (C_f - gam*C_f(-1))^(-sigma) - gam*betta*((C_f(+1) - gam*C_f)^(-sigma));

1 = betta * (mu_f(+1)/mu_f) * (R_f / PiCPI_f(+1));

% Foreign Euler for foreign asset (f's perspective -- E_fh = 1/E_hf)
1 = betta * (mu_f(+1)/mu_f) * ((1/E_hf(+1))/(1/E_hf)) * R_h / PiCPI_f(+1)
    * (1 + zeta*(-A_fh/PC_f));            % f holds -A_fh in home currency

q_f = betta * (mu_f(+1)/mu_f) * ( RKc_f(+1)/PC_f(+1) + (1-delta)*q_f(+1) );

PI_f/PC_f = q_f * (1 - xi/2*(I_f/I_f(-1)-1)^2
                     - xi*(I_f/I_f(-1)-1)*(I_f/I_f(-1)))
           + betta*(mu_f(+1)/mu_f)*q_f(+1)*xi*(I_f(+1)/I_f-1)*(I_f(+1)/I_f)^2;

K_f = (1-delta)*K_f(-1) + I_f*(1 - xi/2*(I_f/I_f(-1)-1)^2);

N_f1 = omegan_f1 * (W_f1/Wc_f)^nu_n * N_f;
N_f2 = omegan_f2 * (W_f2/Wc_f)^nu_n * N_f;

Wc_f^(1+nu_n) = omegan_f1*W_f1^(1+nu_n) + omegan_f2*W_f2^(1+nu_n);

K_f1 = omegak_f1 * (RK_f1/RKc_f)^nu_k * K_f;
K_f2 = omegak_f2 * (RK_f2/RKc_f)^nu_k * K_f;

RKc_f^(1+nu_k) = omegak_f1*RK_f1^(1+nu_k) + omegak_f2*RK_f2^(1+nu_k);

% =========================================================================
% BLOCK B: DOMESTIC RETAILERS -- CES AGGREGATION
% Equations (21)-(28)
% =========================================================================

% --- B1. Sectoral consumption demand (eq. 22) ---
C_h1 = omegac_h1 * (PC_h1/PC_h)^(-sigma_c) * C_h;
C_h2 = omegac_h2 * (PC_h2/PC_h)^(-sigma_c) * C_h;
C_f1 = omegac_f1 * (PC_f1/PC_f)^(-sigma_c) * C_f;
C_f2 = omegac_f2 * (PC_f2/PC_f)^(-sigma_c) * C_f;

% --- B2. CPI aggregator (eq. 23) ---
PC_h^(1-sigma_c) = omegac_h1*PC_h1^(1-sigma_c) + omegac_h2*PC_h2^(1-sigma_c);
PC_f^(1-sigma_c) = omegac_f1*PC_f1^(1-sigma_c) + omegac_f2*PC_f2^(1-sigma_c);

% --- B3. Sectoral investment demand (eq. 25) ---
I_h1 = omegaI_h1 * (PI_h1/PI_h)^(-sigma_I) * I_h;
I_h2 = omegaI_h2 * (PI_h2/PI_h)^(-sigma_I) * I_h;
I_f1 = omegaI_f1 * (PI_f1/PI_f)^(-sigma_I) * I_f;
I_f2 = omegaI_f2 * (PI_f2/PI_f)^(-sigma_I) * I_f;

% --- B4. Investment price index (eq. 26) ---
PI_h^(1-sigma_I) = omegaI_h1*PI_h1^(1-sigma_I) + omegaI_h2*PI_h2^(1-sigma_I);
PI_f^(1-sigma_I) = omegaI_f1*PI_f1^(1-sigma_I) + omegaI_f2*PI_f2^(1-sigma_I);

% --- B5. Intermediate input demand across sectors (eq. 27) ---
% M_{h,s,x}: sector s in home buys from sector x
% s=1:
M_hh11 = omegam_h11 * (PM_h1/PM_h1)^(-sigma_m) * M_h1;  % own-price normalised
M_hh12 = omegam_h12 * (PM_h2/PM_h1)^(-sigma_m) * M_h1;  % TODO: check price index
% s=2:
M_hh21 = omegam_h21 * (PM_h1/PM_h2)^(-sigma_m) * M_h2;
M_hh22 = omegam_h22 * (PM_h2/PM_h2)^(-sigma_m) * M_h2;

% Foreign (symmetric):
M_ff11 = omegam_f11 * (PM_f1/PM_f1)^(-sigma_m) * M_f1;
M_ff12 = omegam_f12 * (PM_f2/PM_f1)^(-sigma_m) * M_f1;
M_ff21 = omegam_f21 * (PM_f1/PM_f2)^(-sigma_m) * M_f2;
M_ff22 = omegam_f22 * (PM_f2/PM_f2)^(-sigma_m) * M_f2;

% --- B6. Intermediate input price bundle (eq. 28) ---
PM_h1^(1-sigma_m) = omegam_h11*PM_h1^(1-sigma_m) + omegam_h12*PM_h2^(1-sigma_m);
PM_h2^(1-sigma_m) = omegam_h21*PM_h1^(1-sigma_m) + omegam_h22*PM_h2^(1-sigma_m);
PM_f1^(1-sigma_m) = omegam_f11*PM_f1^(1-sigma_m) + omegam_f12*PM_f2^(1-sigma_m);
PM_f2^(1-sigma_m) = omegam_f21*PM_f1^(1-sigma_m) + omegam_f22*PM_f2^(1-sigma_m);

% =========================================================================
% BLOCK C: INTERNATIONAL RETAILERS -- ARMINGTON NESTS + TARIFFS
% Equations (29)-(40)
% =========================================================================

% --- C1. Sectoral consumption prices: domestic vs import (eq. 32) ---
% Home region, sector 1:
PC_h1^(1-lambda_c) = etac_h1 * P_h1^(1-lambda_c)
                   + (1-etac_h1) * ((1+tau_c_h1)*P_f1*E_hf)^(1-lambda_c);
% Home region, sector 2:
PC_h2^(1-lambda_c) = etac_h2 * P_h2^(1-lambda_c)
                   + (1-etac_h2) * ((1+tau_c_h2)*P_f2*E_hf)^(1-lambda_c);
% Foreign region, sector 1 (E_fh = 1/E_hf):
PC_f1^(1-lambda_c) = etac_f1 * P_f1^(1-lambda_c)
                   + (1-etac_f1) * ((1+tau_c_f1)*P_h1/E_hf)^(1-lambda_c);
% Foreign region, sector 2:
PC_f2^(1-lambda_c) = etac_f2 * P_f2^(1-lambda_c)
                   + (1-etac_f2) * ((1+tau_c_f2)*P_h2/E_hf)^(1-lambda_c);

% --- C2. Demand for domestic vs imported consumption (eqs. 30-31) ---
% Home sector 1: demand for home-produced vs foreign
C_hh1 = etac_h1 * (P_h1/PC_h1)^(-lambda_c) * C_h1;
C_hf1 = (1-etac_h1) * ((1+tau_c_h1)*P_f1*E_hf/PC_h1)^(-lambda_c) * C_h1;
% Home sector 2:
C_hh2 = etac_h2 * (P_h2/PC_h2)^(-lambda_c) * C_h2;
C_hf2 = (1-etac_h2) * ((1+tau_c_h2)*P_f2*E_hf/PC_h2)^(-lambda_c) * C_h2;
% Foreign sector 1:
C_ff1 = etac_f1 * (P_f1/PC_f1)^(-lambda_c) * C_f1;
C_fh1 = (1-etac_f1) * ((1+tau_c_f1)*P_h1/E_hf/PC_f1)^(-lambda_c) * C_f1;
% Foreign sector 2:
C_ff2 = etac_f2 * (P_f2/PC_f2)^(-lambda_c) * C_f2;
C_fh2 = (1-etac_f2) * ((1+tau_c_f2)*P_h2/E_hf/PC_f2)^(-lambda_c) * C_f2;

% --- C3. Sectoral investment prices (eq. 36) ---
% NOTE: paper has no tariff on investment goods -- set tau^I = 0 implicitly
PI_h1^(1-lambda_I) = etaI_h1 * P_h1^(1-lambda_I)
                   + (1-etaI_h1) * (P_f1*E_hf)^(1-lambda_I);
PI_h2^(1-lambda_I) = etaI_h2 * P_h2^(1-lambda_I)
                   + (1-etaI_h2) * (P_f2*E_hf)^(1-lambda_I);
PI_f1^(1-lambda_I) = etaI_f1 * P_f1^(1-lambda_I)
                   + (1-etaI_f1) * (P_h1/E_hf)^(1-lambda_I);
PI_f2^(1-lambda_I) = etaI_f2 * P_f2^(1-lambda_I)
                   + (1-etaI_f2) * (P_h2/E_hf)^(1-lambda_I);

% --- C4. Investment demand: domestic vs imported (eqs. 34-35) ---
I_hh1 = etaI_h1 * (P_h1/PI_h1)^(-lambda_I) * I_h1;
I_hf1 = (1-etaI_h1) * (P_f1*E_hf/PI_h1)^(-lambda_I) * I_h1;
I_hh2 = etaI_h2 * (P_h2/PI_h2)^(-lambda_I) * I_h2;
I_hf2 = (1-etaI_h2) * (P_f2*E_hf/PI_h2)^(-lambda_I) * I_h2;
I_ff1 = etaI_f1 * (P_f1/PI_f1)^(-lambda_I) * I_f1;
I_fh1 = (1-etaI_f1) * (P_h1/E_hf/PI_f1)^(-lambda_I) * I_f1;
I_ff2 = etaI_f2 * (P_f2/PI_f2)^(-lambda_I) * I_f2;
I_fh2 = (1-etaI_f2) * (P_h2/E_hf/PI_f2)^(-lambda_I) * I_f2;

% --- C5. Intermediate input prices with tariff wedge (eq. 40) ---
% Home sector s sourcing from foreign sector x: tau^m_{h,x,t}
% s=1 using x=1 (home sources from foreign sector 1):
PM_h1^(1-lambda_m) = etam_h11 * P_h1^(1-lambda_m)
                   + (1-etam_h11) * ((1+tau_m_h1)*P_f1*E_hf)^(1-lambda_m);
% Note: PM_h1 is the price of the intermediate bundle for sector 1 in home.
% With 2 supplying sectors, we need the cross-sector Armington nest.
% SIMPLIFICATION for 2x2: treat PM_{i,s} as 2-good Armington nest over
% (domestic sector 1, domestic sector 2), and then each of those is itself
% an Armington nest over (home, foreign). This follows the paper's
% factored structure. For now implement the within-region nest (eq. 28)
% using effective prices that already embed the domestic/foreign split.

% PLACEHOLDER -- replace with full nested CES when calibrating:
% For the cross-border dimension of intermediates (eq. 39):
M_hf11 = (1-etam_h11)*((1+tau_m_h1)*P_f1*E_hf/PM_h1)^(-lambda_m) * M_h1;
M_hf12 = (1-etam_h12)*((1+tau_m_h2)*P_f2*E_hf/PM_h1)^(-lambda_m) * M_h1;
M_hf21 = (1-etam_h21)*((1+tau_m_h1)*P_f1*E_hf/PM_h2)^(-lambda_m) * M_h2;
M_hf22 = (1-etam_h22)*((1+tau_m_h2)*P_f2*E_hf/PM_h2)^(-lambda_m) * M_h2;

M_fh11 = (1-etam_f11)*(P_h1/E_hf/PM_f1)^(-lambda_m) * M_f1;
M_fh12 = (1-etam_f12)*(P_h2/E_hf/PM_f1)^(-lambda_m) * M_f1;
M_fh21 = (1-etam_f21)*(P_h1/E_hf/PM_f2)^(-lambda_m) * M_f2;
M_fh22 = (1-etam_f22)*(P_h2/E_hf/PM_f2)^(-lambda_m) * M_f2;

% =========================================================================
% BLOCK D: FIRMS -- PRODUCTION AND MARGINAL COST
% Equations (43)-(47)
% =========================================================================

% --- D1. Nominal marginal cost (eq. 47) ---
% MC_{i,s} = (1/A_{i,s}) * (PM_{i,s}/alpha^m)^{alpha^m}
%            * [(1/(1-alpha^m)) * (RK_{i,s}/alpha^k)^{alpha^k}
%               * (W_{i,s}/(1-alpha^k))^{1-alpha^k}]^{1-alpha^m}
MC_h1 = (1/A_h1)
      * (PM_h1/alpham_h1)^alpham_h1
      * ((RK_h1/alphak_h1)^alphak_h1
         * (W_h1/(1-alphak_h1))^(1-alphak_h1))^(1-alpham_h1)
      * (1/(1-alpham_h1))^(1-alpham_h1);

MC_h2 = (1/A_h2)
      * (PM_h2/alpham_h2)^alpham_h2
      * ((RK_h2/alphak_h2)^alphak_h2
         * (W_h2/(1-alphak_h2))^(1-alphak_h2))^(1-alpham_h2)
      * (1/(1-alpham_h2))^(1-alpham_h2);

MC_f1 = (1/A_f1)
      * (PM_f1/alpham_f1)^alpham_f1
      * ((RK_f1/alphak_f1)^alphak_f1
         * (W_f1/(1-alphak_f1))^(1-alphak_f1))^(1-alpham_f1)
      * (1/(1-alpham_f1))^(1-alpham_f1);

MC_f2 = (1/A_f2)
      * (PM_f2/alpham_f2)^alpham_f2
      * ((RK_f2/alphak_f2)^alphak_f2
         * (W_f2/(1-alphak_f2))^(1-alphak_f2))^(1-alpham_f2)
      * (1/(1-alpham_f2))^(1-alpham_f2);

% --- D2. Input demands (eqs. 44-46), aggregate over varieties ---
% Intermediate:
M_h1 = alpham_h1 * (MC_h1/PM_h1) * Y_h1;
M_h2 = alpham_h2 * (MC_h2/PM_h2) * Y_h2;
M_f1 = alpham_f1 * (MC_f1/PM_f1) * Y_f1;
M_f2 = alpham_f2 * (MC_f2/PM_f2) * Y_f2;
% Capital:
K_h1(-1) = (1-alpham_h1)*alphak_h1 * (MC_h1/RK_h1) * Y_h1;
K_h2(-1) = (1-alpham_h2)*alphak_h2 * (MC_h2/RK_h2) * Y_h2;
K_f1(-1) = (1-alpham_f1)*alphak_f1 * (MC_f1/RK_f1) * Y_f1;
K_f2(-1) = (1-alpham_f2)*alphak_f2 * (MC_f2/RK_f2) * Y_f2;
% Labour:
N_h1 = (1-alpham_h1)*(1-alphak_h1) * (MC_h1/W_h1) * Y_h1;
N_h2 = (1-alpham_h2)*(1-alphak_h2) * (MC_h2/W_h2) * Y_h2;
N_f1 = (1-alpham_f1)*(1-alphak_f1) * (MC_f1/W_f1) * Y_f1;
N_f2 = (1-alpham_f2)*(1-alphak_f2) * (MC_f2/W_f2) * Y_f2;

% =========================================================================
% BLOCK E: PRICE SETTING -- NEW KEYNESIAN PHILLIPS CURVES (ROTEMBERG)
% Equation (50) for prices, (20) for wages
% =========================================================================

% --- E1. Sectoral NK Phillips Curves (eq. 50) ---
% (Pi^PPI - 1)*Pi^PPI = (eps/psi)*[MC/P - 1/MP] + beta*E[(mu+1/mu)*(Pi+1-1)*Pi+1^2 * Y+1/Y]
(PiPPI_h1-1)*PiPPI_h1
    = (1/MP_h1)/psiP_h1 * (MC_h1/P_h1 - 1/MP_h1)
    + betta*(mu_h(+1)/mu_h)*(PiPPI_h1(+1)-1)*PiPPI_h1(+1)^2
      *(Y_h1(+1)/Y_h1)/PiCPI_h(+1);

(PiPPI_h2-1)*PiPPI_h2
    = (1/MP_h2)/psiP_h2 * (MC_h2/P_h2 - 1/MP_h2)
    + betta*(mu_h(+1)/mu_h)*(PiPPI_h2(+1)-1)*PiPPI_h2(+1)^2
      *(Y_h2(+1)/Y_h2)/PiCPI_h(+1);

(PiPPI_f1-1)*PiPPI_f1
    = (1/MP_f1)/psiP_f1 * (MC_f1/P_f1 - 1/MP_f1)
    + betta*(mu_f(+1)/mu_f)*(PiPPI_f1(+1)-1)*PiPPI_f1(+1)^2
      *(Y_f1(+1)/Y_f1)/PiCPI_f(+1);

(PiPPI_f2-1)*PiPPI_f2
    = (1/MP_f2)/psiP_f2 * (MC_f2/P_f2 - 1/MP_f2)
    + betta*(mu_f(+1)/mu_f)*(PiPPI_f2(+1)-1)*PiPPI_f2(+1)^2
      *(Y_f2(+1)/Y_f2)/PiCPI_f(+1);

% --- E2. PPI inflation definitions ---
PiPPI_h1 = P_h1 / P_h1(-1);
PiPPI_h2 = P_h2 / P_h2(-1);
PiPPI_f1 = P_f1 / P_f1(-1);
PiPPI_f2 = P_f2 / P_f2(-1);

% --- E3. CPI inflation definitions ---
PiCPI_h = PC_h / PC_h(-1);
PiCPI_f = PC_f / PC_f(-1);

% --- E4. Sectoral Wage Phillips Curves (eq. 20) ---
% Union FOC: Pi^W*(Pi^W-1) = (eps^w/psi^w)*(Wc/W - Mw)*L
%            + beta*E[(mu+1/mu)*Pi^W+1*(Pi^W+1-1)*Pi^W+1/Pi^CPI+1]
% Mw = 1 - 1/eps^w (steady-state wage markdown given in paper as 0.77)
PiW_h1*(PiW_h1-1)
    = (Mw/psiW) * (Wc_h/W_h1 - Mw) * N_h1
    + betta*(mu_h(+1)/mu_h)*PiW_h1(+1)*(PiW_h1(+1)-1)
      *PiW_h1(+1)/PiCPI_h(+1);

PiW_h2*(PiW_h2-1)
    = (Mw/psiW) * (Wc_h/W_h2 - Mw) * N_h2
    + betta*(mu_h(+1)/mu_h)*PiW_h2(+1)*(PiW_h2(+1)-1)
      *PiW_h2(+1)/PiCPI_h(+1);

PiW_f1*(PiW_f1-1)
    = (Mw/psiW) * (Wc_f/W_f1 - Mw) * N_f1
    + betta*(mu_f(+1)/mu_f)*PiW_f1(+1)*(PiW_f1(+1)-1)
      *PiW_f1(+1)/PiCPI_f(+1);

PiW_f2*(PiW_f2-1)
    = (Mw/psiW) * (Wc_f/W_f2 - Mw) * N_f2
    + betta*(mu_f(+1)/mu_f)*PiW_f2(+1)*(PiW_f2(+1)-1)
      *PiW_f2(+1)/PiCPI_f(+1);

% --- E5. Wage inflation definitions ---
PiW_h1 = W_h1 / W_h1(-1);
PiW_h2 = W_h2 / W_h2(-1);
PiW_f1 = W_f1 / W_f1(-1);
PiW_f2 = W_f2 / W_f2(-1);

% =========================================================================
% BLOCK F: MONETARY POLICY -- TAYLOR RULES (eq. 52)
% =========================================================================

% Home Taylor rule (targeting domestic component of CPI = PPI-weighted avg)
R_h/steady_state(R_h) = (R_h(-1)/steady_state(R_h))^rhoR
                       * (PiCPI_h)^(phi_pi*(1-rhoR))
                       * (GDP_h/steady_state(GDP_h))^(phi_y*(1-rhoR));

R_f/steady_state(R_f) = (R_f(-1)/steady_state(R_f))^rhoR
                       * (PiCPI_f)^(phi_pi*(1-rhoR))
                       * (GDP_f/steady_state(GDP_f))^(phi_y*(1-rhoR));

% =========================================================================
% BLOCK G: MARKET CLEARING
% Equations (53)-(56)
% =========================================================================

% --- G1. Labour market (eq. 53) ---
% Already imposed via input demands (Block D) -- no additional equation needed
% since N_{i,s} = L_{i,s} by assumption.

% --- G2. Goods market clearing (eq. 54) ---
% y_{i,s} = domestic consumption + domestic investment + domestic intermediates
%          + (omega_j/omega_i) * (foreign consumption + investment + intermediates)
%          + Rotemberg waste
Y_h1 = C_hh1 + I_hh1 + M_hh11 + M_hh21     % home demand for home good 1
     + (omega_f/omega_h)*(C_fh1 + I_fh1 + M_fh11 + M_fh21)  % foreign demand
     + psiP_h1/2 * (PiPPI_h1-1)^2 * Y_h1;  % price adj. cost (eq. 54)

Y_h2 = C_hh2 + I_hh2 + M_hh12 + M_hh22
     + (omega_f/omega_h)*(C_fh2 + I_fh2 + M_fh12 + M_fh22)
     + psiP_h2/2 * (PiPPI_h2-1)^2 * Y_h2;

Y_f1 = C_ff1 + I_ff1 + M_ff11 + M_ff21
     + (omega_h/omega_f)*(C_hf1 + I_hf1 + M_hf11 + M_hf21)
     + psiP_f1/2 * (PiPPI_f1-1)^2 * Y_f1;

Y_f2 = C_ff2 + I_ff2 + M_ff12 + M_ff22
     + (omega_h/omega_f)*(C_hf2 + I_hf2 + M_hf12 + M_hf22)
     + psiP_f2/2 * (PiPPI_f2-1)^2 * Y_f2;

% --- G3. GDP definition (eq. 56) ---
GDP_h = C_h + (PI_h/PC_h)*I_h + TB_h/PC_h;
GDP_f = C_f + (PI_f/PC_f)*I_f + TB_f/PC_f;

% --- G4. Trade balance (eq. 55, sectoral then summed) ---
TB_h = P_h1*(omega_f/omega_h)*(C_fh1 + I_fh1 + M_fh11 + M_fh21)
     + P_h2*(omega_f/omega_h)*(C_fh2 + I_fh2 + M_fh12 + M_fh22)
     - P_f1*E_hf*((1+tau_c_h1)*C_hf1 + I_hf1 + (1+tau_m_h1)*(M_hf11+M_hf21))
     - P_f2*E_hf*((1+tau_c_h2)*C_hf2 + I_hf2 + (1+tau_m_h2)*(M_hf12+M_hf22));

TB_f = -TB_h/E_hf;   % global trade balance (Walras)

% --- G5. International asset evolution (eq. 59) ---
A_fh = R_f * A_fh(-1) + TB_f + (P_f1*tau_c_f1*C_fh1 + P_f2*tau_c_f2*C_fh2
       + P_f1*tau_m_f1*(M_fh11+M_fh21) + P_f2*tau_m_f2*(M_fh12+M_fh22))/PC_f;
% NOTE: TR_f (tariff revenue rebated to HH) nets out; here we keep
%       the net asset position dynamics from current account.

% =========================================================================
% BLOCK H: TARIFF SHOCK PROCESSES (eq. 93)
% =========================================================================

% Consumption tariff shocks
tau_c_h1 = rho_tau * tau_c_h1(-1) + eps_tauc_h1;
tau_c_h2 = rho_tau * tau_c_h2(-1) + eps_tauc_h2;
tau_c_f1 = rho_tau * tau_c_f1(-1) + eps_tauc_f1;
tau_c_f2 = rho_tau * tau_c_f2(-1) + eps_tauc_f2;

% Intermediate input tariff shocks
tau_m_h1 = rho_tau * tau_m_h1(-1) + eps_taum_h1;
tau_m_h2 = rho_tau * tau_m_h2(-1) + eps_taum_h2;
tau_m_f1 = rho_tau * tau_m_f1(-1) + eps_taum_f1;
tau_m_f2 = rho_tau * tau_m_f2(-1) + eps_taum_f2;

end;

% =========================================================================
% 6. STEADY STATE
%    Zero inflation: PiCPI = PiPPI = PiW = 1, tau = 0.
%    Set prices so that: P_h = P_f = PC = PI = PM = W = 1 (normalise)
%    Then back out quantities from resource constraints and factor demands.
% =========================================================================

initval;

% --- Inflation and nominal rates at SS ---
PiPPI_h1 = 1;    PiPPI_h2 = 1;
PiPPI_f1 = 1;    PiPPI_f2 = 1;
PiCPI_h  = 1;    PiCPI_f  = 1;
PiW_h1   = 1;    PiW_h2   = 1;
PiW_f1   = 1;    PiW_f2   = 1;

% --- Prices (normalised at 1 in SS, zero inflation) ---
P_h1  = 1;    P_h2  = 1;
P_f1  = 1;    P_f2  = 1;
PC_h  = 1;    PC_f  = 1;
PI_h  = 1;    PI_f  = 1;
PC_h1 = 1;    PC_h2 = 1;
PC_f1 = 1;    PC_f2 = 1;
PI_h1 = 1;    PI_h2 = 1;
PI_f1 = 1;    PI_f2 = 1;
PM_h1 = 1;    PM_h2 = 1;
PM_f1 = 1;    PM_f2 = 1;

% --- Exchange rate normalised to 1 ---
E_hf = 1;

% --- Tariffs zero in SS ---
tau_c_h1 = 0;    tau_c_h2 = 0;
tau_c_f1 = 0;    tau_c_f2 = 0;
tau_m_h1 = 0;    tau_m_h2 = 0;
tau_m_f1 = 0;    tau_m_f2 = 0;

% --- Nominal interest rate: 1/beta (Fisher equation at zero inflation) ---
R_h = 1/betta;
R_f = 1/betta;

% --- Wages and rental rates ---
% From markup pricing in SS: MC = P/MP -> with P=1, MC_h1 = 1/MP_h1
% From labour FOC: W = MC*(1-alpha^m)*(1-alpha^k)*Y/N
% Start with W = 1, RK = delta (from capital Euler in SS)
W_h1  = 1;    W_h2  = 1;
W_f1  = 1;    W_f2  = 1;
Wc_h  = 1;    Wc_f  = 1;
RK_h1 = (1/betta - (1-delta));    % = delta + r_ss
RK_h2 = (1/betta - (1-delta));
RK_f1 = (1/betta - (1-delta));
RK_f2 = (1/betta - (1-delta));
RKc_h = (1/betta - (1-delta));
RKc_f = (1/betta - (1-delta));

% --- Marginal costs: P/MP in SS ---
MC_h1 = 1/MP_h1;    MC_h2 = 1/MP_h2;
MC_f1 = 1/MP_f1;    MC_f2 = 1/MP_f2;

% --- Tobin's q = 1 in SS (no investment adj. cost at SS) ---
q_h = 1;    q_f = 1;

% --- Marginal utility of consumption ---
% mu = C^{-sigma} * (1 - gam*betta) / (1 - gam) approximately
% For now set C=1 and back out mu
mu_h = 1;    mu_f = 1;

% --- Quantities (rough initialisations -- solver will find exact SS) ---
C_h = 0.6;    C_f = 0.6;
I_h = 0.15;   I_f = 0.15;
N_h = 1.0;    N_f = 1.0;
K_h = I_h/delta;    K_f = I_f/delta;

C_h1 = omegac_h1*C_h;    C_h2 = omegac_h2*C_h;
C_f1 = omegac_f1*C_f;    C_f2 = omegac_f2*C_f;
I_h1 = omegaI_h1*I_h;    I_h2 = omegaI_h2*I_h;
I_f1 = omegaI_f1*I_f;    I_f2 = omegaI_f2*I_f;

N_h1 = omegan_h1*N_h;    N_h2 = omegan_h2*N_h;
N_f1 = omegan_f1*N_f;    N_f2 = omegan_f2*N_f;
K_h1 = omegak_h1*K_h;    K_h2 = omegak_h2*K_h;
K_f1 = omegak_f1*K_f;    K_f2 = omegak_f2*K_f;

% Output (rough -- will be solved in SS):
Y_h1 = 0.3;    Y_h2 = 0.7;
Y_f1 = 0.3;    Y_f2 = 0.7;
Y_f1 = 0.3;    Y_f2 = 0.7;

M_h1 = alpham_h1*(MC_h1/PM_h1)*Y_h1;
M_h2 = alpham_h2*(MC_h2/PM_h2)*Y_h2;
M_f1 = alpham_f1*(MC_f1/PM_f1)*Y_f1;
M_f2 = alpham_f2*(MC_f2/PM_f2)*Y_f2;

% Domestic/foreign splits at home bias shares:
C_hh1 = etac_h1*C_h1;    C_hf1 = (1-etac_h1)*C_h1;
C_hh2 = etac_h2*C_h2;    C_hf2 = (1-etac_h2)*C_h2;
C_ff1 = etac_f1*C_f1;    C_fh1 = (1-etac_f1)*C_f1;
C_ff2 = etac_f2*C_f2;    C_fh2 = (1-etac_f2)*C_f2;

I_hh1 = etaI_h1*I_h1;    I_hf1 = (1-etaI_h1)*I_h1;
I_hh2 = etaI_h2*I_h2;    I_hf2 = (1-etaI_h2)*I_h2;
I_ff1 = etaI_f1*I_f1;    I_fh1 = (1-etaI_f1)*I_f1;
I_ff2 = etaI_f2*I_f2;    I_fh2 = (1-etaI_f2)*I_f2;

M_hh11 = etam_h11*omegam_h11*M_h1;    M_hf11 = (1-etam_h11)*omegam_h11*M_h1;
M_hh12 = etam_h12*omegam_h12*M_h1;    M_hf12 = (1-etam_h12)*omegam_h12*M_h1;
M_hh21 = etam_h21*omegam_h21*M_h2;    M_hf21 = (1-etam_h21)*omegam_h21*M_h2;
M_hh22 = etam_h22*omegam_h22*M_h2;    M_hf22 = (1-etam_h22)*omegam_h22*M_h2;
M_ff11 = etam_f11*omegam_f11*M_f1;    M_fh11 = (1-etam_f11)*omegam_f11*M_f1;
M_ff12 = etam_f12*omegam_f12*M_f1;    M_fh12 = (1-etam_f12)*omegam_f12*M_f1;
M_ff21 = etam_f21*omegam_f21*M_f2;    M_fh21 = (1-etam_f21)*omegam_f21*M_f2;
M_ff22 = etam_f22*omegam_f22*M_f2;    M_fh22 = (1-etam_f22)*omegam_f22*M_f2;

TB_h = 0;    TB_f = 0;
A_fh = 0;

GDP_h = C_h + I_h;    GDP_f = C_f + I_f;

end;

% Run steady-state solver
steady;
check;    % check BK conditions (eigenvalues)

% =========================================================================
% 7. SHOCKS AND IRFs
%    Replicates Figure 5 (import tariff on final goods vs. intermediates)
%    and Figure 7 (retaliation scenarios).
% =========================================================================

shocks;

% --- Scenario A: Import tariff on CONSUMPTION goods (home only, both sectors)
var eps_tauc_h1;  stderr 0.01;   % 1 p.p. shock (in level terms)
var eps_tauc_h2;  stderr 0.01;

% --- Scenario B: Import tariff on INTERMEDIATE inputs (home only)
% (Uncomment to switch scenario; comment out Scenario A above)
% var eps_taum_h1;  stderr 0.01;
% var eps_taum_h2;  stderr 0.01;

% --- Scenario C: FOREIGN tariff on home exports + no retaliation (Fig. 7)
% var eps_tauc_f1;  stderr 0.01;   % foreign imposes tariff on home goods
% var eps_tauc_f2;  stderr 0.01;
% var eps_taum_f1;  stderr 0.01;
% var eps_taum_f2;  stderr 0.01;

end;

% =========================================================================
% 8. SOLUTION AND OUTPUT
% =========================================================================

stoch_simul(order=1, irf=20, periods=0,
            irf_plot_threshold=0,
            graph_format=pdf)
    GDP_h GDP_f
    PiCPI_h PiCPI_f
    PiPPI_h1 PiPPI_h2
    R_h R_f
    E_hf
    TB_h
    C_h I_h
;

% =========================================================================
% NOTES FOR COMPLETION
% =========================================================================
% 1. STEADY STATE: the initval block gives starting values. You likely need
%    a steady_state_model block with analytical expressions or a MATLAB
%    helper file (gnocato2025_2s_steadystate.m) for Dynare to converge.
%    Key SS conditions:
%      - MC_ss = P_ss/MP (markup pricing)
%      - RK_ss = 1/beta - (1-delta) (capital Euler)
%      - W_ss from labour FOC: N^phi = mu*(W/PC) with mu = C^{-sigma}*(1-gam*beta)/(1-gam)
%      - K_ss = (alpha^k*(1-alpha^m)/RK_ss) * (MC_ss/P_ss) * Y_ss
%      - Y_ss from goods market clearing (iterate)
%
% 2. INTERMEDIATE PRICE NESTS (Block B5/C5): the 2x2 IO structure means
%    PM_{i,s} is a CES over (P_{i,1}, P_{i,2}) -- domestic -- plus foreign
%    equivalents with tariff wedge. The current implementation separates
%    the within-region (sigma_m) and cross-border (lambda_m) nests.
%    You may want to collapse these into a single effective price index.
%
% 3. WAGE WPC (Block E4): check the exact Rotemberg FOC scaling in eq. (20).
%    The paper defines eps^w and psi^w separately; here Mw=1-1/eps^w is used
%    directly as the target markdown.
%
% 4. WALRAS: with N equations and N unknowns, one market-clearing condition
%    is redundant (Walras' Law). Drop TB_f = -TB_h/E_hf and let it be
%    residually verified, or drop one asset equation.
% =========================================================================

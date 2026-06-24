
model;

% --------------------------------------------------------------------------------
% ----------------------- Domestic  Households -----------------------------------
% --------------------------------------------------------------------------------
  
% Auxilliary equations

%--------------- Stochastic discount factor -----------------------------
mu_d = ( C_d - gamma_d * C_d(-1) )^(-sigma_d) - gamma_d * beta_d * ( C_d(+1) - gamma_d*C_d )^(-sigma_d) ;
mu_f = ( C_f - gamma_f * C_f(-1) )^(-sigma_f) - gamma_f * beta_f * ( C_f(+1) - gamma_f*C_f )^(-sigma_f) ;

%--------------- CPI Inflation Rate  -----------------------------
picpi_d = PC_d / PC_d(-1);
picpi_f = PC_f / PC_f(-1);

% real foreign assets adjsuted for correct currency 
a_df = A_df * Ed / PC_d;
a_fd = A_fd * Ef / PC_f; 

% Nominal Exchage rates link
E_d = 1 / E_f;


% ---------------------Intertemporal problem --------------------------------- 
  

% --------------------------------------------------------------------------------
% ----------------------- Domestic  Households -----------------------------------
% --------------------------------------------------------------------------------
  

% ------------------------------------------------------
% (52) Capital LoM 
K_d = (1-delta_d) * K_d(-1) + I_d* ( 1 - xi_d/2*(I_d/I_d(-1) - 1)^2 )

% ------------------------------------------------------
% (53) Labour supply: 
chi_d * N_d^phi_d = mu_d * W_d / PC_d;

% ------------------------------------------------------
% (54) Investment Euler (q-equation with adjustment costs)
PI_d / PC_d   =  q_d * ( 1 - xi_d/2 * ( I_d/I_d(-1) - 1 ) * ( 3*I_d/I_d(-1) - 1 ) ) + xi_d * beta_d * ( mu_d(+1)/mu_d ) * q_d(+1) * ( I_d(+1)/I_d - 1 ) * ( I_d(+1)/I_d )^2;

% ------------------------------------------------------
% (55) Definition of q_i (Tobin's q)
q_d  =  beta_d * ( mu_d(+1)/mu_d) * ( RK_d/PC_d + (1-delta_d) * q_d(+1) ) ;

% ------------------------------------------------------
% (56) Domestic bond Euler equation
1 = beta_d * ( mu_d(+1)/mu_d) * ( R_d / picpi_d(+1) ); 

% ------------------------------------------------------
% (57) Foreign asset Euler equation
1 = beta_d * ( mu_d(+1)/mu_d  * E_d(+1)/E_d ) * Ra_d / ( 1 + zeta_d*(a_df - a_df_ss ) ) * picpi_d(+1);


%-----------------------------------------------
%  Foreign Households
%-----------------------------------------------

% ------------------------------------------------------
% (52) Capital LoM 
K_f = (1-delta_f) * K_f(-1) + I_f* ( 1 - xi_f/2*(I_f/I_f(-1) - 1)^2 )

% ------------------------------------------------------
% (53) Labour supply: 
chi_f * N_f^phi_f = mu_f * W_f / PC_f;

% ------------------------------------------------------
  % (54) Investment Euler (q-equation with adjustment costs)
PI_f / PC_f   =  q_f * ( 1 - xi_f/2 * ( I_f/I_f(-1) - 1 ) * ( 3*I_f/I_f(-1) - 1 ) ) + xi_f * beta_f * ( mu_f(+1)/mu_f ) * q_f(+1) * ( I_f(+1)/I_f - 1 ) * ( I_f(+1)/I_f )^2;

% ------------------------------------------------------
% (55) Definition of q_i (Tobin's q)
q_f  =  beta_f * ( mu_f(+1)/mu_f) * ( RK_f/PC_f + (1-delta_f) * q_f(+1) ) ;

% ------------------------------------------------------
% (56) Domestic bond Euler equation
1 = beta_f * ( mu_f(+1)/mu_f) * ( R_f / picpi_f(+1) ); 

% ------------------------------------------------------
% (57) Foreign asset Euler equation
1 = beta_f * ( mu_f(+1)/mu_f  * E_f(+1)/E_f ) * Ra_f / ( 1 + zeta_f*(a_fd - a_fd_ss ) ) * picpi_f(+1);


% ---------------------Intra-temporal problem --------------------------------- 
  
% --------------------------------------------------------------------------------
% ----------------------- Domestic  Households -----------------------------------
% --------------------------------------------------------------------------------
  
% (58) CES aggregator for Labour 
N_d = (omega_n_d_1^(-1/vN) * N_d_1^(1+1/vN) + omega_n_d_2^(-1/vN) * N_d_2^(1+1/vN))^(vN/(1+vN));

% ------------------------------------------------------
% (60) Wage aggregator
WC_d = (omega_n_d_1* WC_d_1^(1+vN) + omega_n_d_2* WC_d_2^(1+vN))^(1/(1+vN));

% ------------------------------------------------------
% (59) Sectoral labour supply 
N_d_1  = omega_n_d_1 * (WC_d_1/WC_d )^(vN) * N_d ;
N_d_2  = omega_n_d_2 * (WC_d_2/WC_d)^(vN) * N_d ;

% ------------------------------------------------------
% (61) CES Capital aggregator 
K_d = (omega_k_d_1^(-1/vK) * K_d_1^(1+1/vK) + omega_k_d_2^(-1/vK) * K_d_2^(1+1/vK))^( vK/(1+vK) );

% ------------------------------------------------------
% (63) Capital Rental Rate aggregator
RK_d = (omega_k_d_1 * RK_d_1^(1+vK) + omega_k_d_2 * RK_d_2^(1+vK))^(1/(1+vK));

% ------------------------------------------------------
% (62) Sectoral capital supply 
K_d_1  = omega_k_d_1 * (RK_d_1/RK_d)^(vK) * K_d;
K_d_2  = omega_k_d_2 * (RK_d_2/RK_d)^(vK) * K_d;



% --------------------------------------------------------------------------------
% ----------------------- Foreign  Households -----------------------------------
% --------------------------------------------------------------------------------
  
% (58) CES aggregator for Labour 
N_f = (omega_n_f_1^(-1/vN) * N_f_1^(1+1/vN) + omega_n_f_2^(-1/vN) * N_f_2^(1+1/vN))^(vN/(1+vN));

% ------------------------------------------------------
  % (60) Wage aggregator
WC_f = (omega_n_f_1* WC_f_1^(1+vN) + omega_n_f_2* WC_f_2^(1+vN))^(1/(1+vN));

% ------------------------------------------------------
% (59) Sectoral labour supply 
N_f_1  = omega_n_f_1 * (WC_f_1/WC_f) ^(vN) * N_f ;
N_f_2  = omega_n_f_2 * (WC_f_2/WC_f) ^(vN) * N_f ;

% ------------------------------------------------------
% (61) CES Capital aggregator 
K_f = (omega_k_f_1^(-1/vK) * K_f_1^(1+1/vK) + omega_k_f_2^(-1/vK) * K_f_2^(1+1/vK))^(vK/(1+vK));

% ------------------------------------------------------
% (63) Capital Rental Rate aggregator
RK_f = (omega_k_f_1 * RK_f_1^(1+vK) + omega_k_f_2 * RK_f_2^(1+vK))^( 1/(1+vK) );

% ------------------------------------------------------
% (62) Sectoral labour supply 
K_f_1  = omega_k_f_1 * (RK_f_1/RK_f)^(vK) * K_f;
K_f_2  = omega_k_f_2 * (RK_f_2/RK_f)^(vK) * K_f;





% ---------------------- Labour Unions ----------------------------------------

% -----------------------------------------------------------------------------
% -------------------   Domestic  Labour Unions -------------------------------
% -----------------------------------------------------------------------------
% Markups
Mw_d_1 = epsilon_w_d_1/( 1 - epsilon_w_d_1);
Mw_d_2 = epsilon_w_d_2/( 1 - epsilon_w_d_2);

% Wage inflation
pi_wage_d_1 = W_d_1/W_d_1(-1);
pi_wage_d_2 = W_d_2/W_d_2(-1);

%(69) wage Phillips curves
pi_wage_d_1*(pi_wage_d_1-1) = (epsilon_w_d_1/psi_w_d_1) * ((WC_d_1/W_d_1)-(1/Mw_d_1))* L_d_1 + beta_d* (pi_wage_d_1(+1)*(pi_wage_d_1(+1) - 1)*(pi_wage_d_1(+1)/picpi_d(+1)));
pi_wage_d_2*(pi_wage_d_2-1) = (epsilon_w_d_2/psi_w_d_2) * ((WC_d_2/W_d_2)-(1/Mw_d_2))* L_d_2 + beta_d* (pi_wage_d_2(+1)*(pi_wage_d_2(+1) - 1)*(pi_wage_d_2(+1)/picpi_d(+1)));

% -----------------------------------------------------------------------------
% --------------------  Foreign  Labour Unions --------------------------------
% -----------------------------------------------------------------------------
% Markups
Mw_f_1 = epsilon_w_f_1/(1 - epsilon_w_f_1);
Mw_f_2 = epsilon_w_f_2/(1 - epsilon_w_f_2);

% Wage inflation
pi_wage_f_1 = W_f_1/W_f_1(-1);
pi_wage_f_2 = W_f_2/W_f_2(-1);

%(69) wage Phillips curves
pi_wage_f_1*(pi_wage_f_1-1) = (epsilon_w_f_1/psi_w_f_1)*((WC_f_1/W_f_1)-(1/Mw_f_1))*L_f_1+ beta_f*(pi_wage_f_1(+1)*(pi_wage_f_1(+1)-1)*(pi_wage_f_1(+1)/picpi_f(+1)));
pi_wage_f_2*(pi_wage_f_2-1) = (epsilon_w_f_2/psi_w_f_2)*((WC_f_2/W_f_2)-(1/Mw_f_2))*L_f_2+ beta_f*(pi_wage_f_2(+1)*(pi_wage_f_2(+1)-1)*(pi_wage_f_2(+1)/picpi_f(+1)));






% -----------------------------------------------------------------------------
% -------- Domestic Retailers of Consumption bundles --------------------------
% -----------------------------------------------------------------------------

% ------------------------------------------------------
% (72) CES Consumption Price aggregator 
PC_d = (omega_c_d_1*PC_d_1^(1-sigmaC)+omega_c_d_2*PC_d_2^(1-sigmaC))^(sigmaC/(sigmaC-1));

% ------------------------------------------------------
% (71) Sectoral consumption demand
C_d_1 = omega_c_d_1*(PC_d_1/PC_d)^(-sigmaC)*C_d;
C_d_2 = omega_c_d_2*(PC_d_2/PC_d)^(-sigmaC)*C_d; 


% -----------------------------------------------------------------------------
% -------- Foreign Retailers of domestic Consumption bundles -----------------
/ -----------------------------------------------------------------------------

% ------------------------------------------------------
% (72) CES Consumption Price aggregator 
PC_f  = ( omega_c_f_1  * PC_f_1^(1-sigmaC) + omega_c_f_2 * PC_f_2^(1-sigmaC) )^( sigmaC/(sigmaC-1) );

% ------------------------------------------------------
% (71) Sectoral consumption demand
C_f_1 = omega_c_f_1 * (PC_f_1/PC_f )^(-sigmaC) * C_f;
C_f_2 = omega_c_f_2 * (PC_f_2/PC_f )^(-sigmaC) * C_f;




% -----------------------------------------------------------------------------
% -------- Domestic Retailers of Investment bundles ---------------------------
% -----------------------------------------------------------------------------

% ------------------------------------------------------
% (72) CES Investment Price aggregator 
PI_d = (omega_i_d_1*PI_d_1^(1-sigmaI)+omega_i_d_2*PI_d_2^(1-sigmaI))^(sigmaI/(sigmaI-1));

% ------------------------------------------------------
% (71) Sectoral Investment demand
I_d_1 = omega_i_d_1*(PI_d_1/PI_d)^(-sigmaI)*I_d;
I_d_2 = omega_i_d_2*(PI_d_2/PI_d)^(-sigmaI)*I_d;


% -----------------------------------------------------------------------------
% -------- Foreign Retailers of Investment bundles ---------------------------
% -----------------------------------------------------------------------------

% ------------------------------------------------------
% (72) CES Investment Price aggregator 
PI_f  = (omega_i_f_1*PI_f_1^(1-sigmaI) + omega_i_f_2 * PI_f_2^(1-sigmaI) )^( sigmaI/(sigmaI-1) );

% ------------------------------------------------------
  % (71) Sectoral Investment demand
I_f_1 = omega_i_f_1 * (PI_f_1/PI_f )^(-sigmaI) * I_f;
I_f_2 = omega_i_f_2 * (PI_f_2/PI_f )^(-sigmaI) * I_f; 




% -----------------------------------------------------------------------------
% ---------- Domestic Retailers of Intermediate Inputs bundles ----------------
% -----------------------------------------------------------------------------

% ------------------------------------------------------
% (72) CES Intermediates Price aggregator 
% Total Price of intermediate inputs bundle for each sector
PM_d_1  = (omega_m_d_1_1*PM_d_1_1^(1-sigmaM)+omega_m_d_1_2*PM_d_1_2^(1-sigmaM))^(1/(1-sigmaM));
PM_d_2  = (omega_m_d_2_1*PM_d_2_1^(1-sigmaM)+omega_m_d_2_2*PM_d_2_2^(1-sigmaM))^(1/(1-sigmaM));

% ------------------------------------------------------
% (71) Sectoral product demand as Intermediate 
M_d_1_1 = omega_m_d_1_1 * (PM_d_1_1/PM_d_1)^(-sigmaM)*M_d_1;
M_d_1_2 = omega_m_d_1_2 * (PM_d_1_2/PM_d_1)^(-sigmaM)*M_d_1;

M_d_2_1 = omega_m_d_2_1 * (PM_d_2_1/PM_d_2)^(-sigmaM)*M_d_2; 
M_d_2_2 = omega_m_d_2_2 * (PM_d_2_2/PM_d_2)^(-sigmaM)*M_d_2; 

% -----------------------------------------------------------------------------
% ---------- Foreign Retailers of Intermediate Inputs bundles -----------------
% -----------------------------------------------------------------------------


% ------------------------------------------------------
% (72) CES Intermediates Price aggregator 
% Total Price of intermediate inputs bundle for each sector
PM_f_1  = (omega_m_f_1_1*PM_f_1_1^(1-sigmaM)+omega_m_f_1_2*PM_f_1_2^(1-sigmaM))^(1/(1-sigmaM));
PM_f_2  = (omega_m_f_2_1*PM_f_2_1^(1-sigmaM)+omega_m_f_2_2*PM_f_2_2^(1-sigmaM))^(1/(1-sigmaM));

% ------------------------------------------------------
% (71) Sectoral product demand as Intermediate 
M_f_1_1 = omega_m_f_1_1 * (PM_f_1_1/PM_f_1)^(-sigmaM)*M_f_1;
M_f_1_2 = omega_m_f_1_2 * (PM_f_1_2/PM_f_1)^(-sigmaM)*M_f_1;

M_f_2_1 = omega_m_f_2_1 * (PM_f_2_1/PM_f_2)^(-sigmaM)*M_f_2; 
M_f_2_2 = omega_m_f_2_2 * (PM_f_2_2/PM_f_2)^(-sigmaM)*M_f_2; 











% ----------------------- International Retailers -----------------------------

% -----------------------------------------------------------------------------
% ------------ Domestic International Consumption Retailers -------------------
% -----------------------------------------------------------------------------
  

% ------------------------------------------------------
% (81) CES aggregator of international consumption goods Prices in each sector
PC_d_1 = (  etaC_d_1 * ( P_d_1^(1 - lambdaC_d_1) )   +   (1 - etaC_d_1) * ( ((1 + tauC_d_1) * P_f_1 * E_d)^(1 - lambdaC_d_1) ))^( 1 / (1 - lambdaC_d_1) );
PC_d_2 = (  etaC_d_2 * ( P_d_2^(1 - lambdaC_d_2) )   +   (1 - etaC_d_2) * ( ((1 + tauC_d_2) * P_f_2 * E_d)^(1 - lambdaC_d_2) ))^( 1 / (1 - lambdaC_d_2) );

% ------------------------------------------------------
% Consumption demand for domestic and imported goods in each sector (number of equations = NumberOfSecotrs * 2 )

%(79) Domestic demand for sectors 1 and 2
C_d_d_1 = etaC_d_1 * ( (P_d_1 / PC_d_1)^(-lambdaC_d_1) ) * C_d_1;
C_d_d_2 = etaC_d_2 * ( (P_d_2 / PC_d_2)^(-lambdaC_d_2) ) * C_d_2;

%(80) Imported
C_d_f_1 = (1-etaC_d_1) * ( ( (1 + tauC_d_1) * P_d_1 * E_d ) / PC_d_1)^(-lambdaC_d_1) ) * C_d_1;
C_d_f_2 = (1-etaC_d_2) * ( ( (1 + tauC_d_2) * P_d_2 * E_d ) / PC_d_2)^(-lambdaC_d_2) ) * C_d_2;

% -----------------------------------------------------------------------------
% ------------ Foreign International Consumption Retailers --------------------
% -----------------------------------------------------------------------------
  

% ------------------------------------------------------
% (81) CES aggregator of international consumption goods Prices in each sector
PC_f_1 = (  etaC_f_1 * ( P_f_1^(1 - lambdaC_f_1) )   +   (1 - etaC_f_1) * ( ((1 + tauC_f_1) * P_d_1 * E_f)^(1 - lambdaC_f_1) ))^( 1 / (1 - lambdaC_f_1) );
PC_f_2 = (  etaC_f_2 * ( P_f_2^(1 - lambdaC_f_2) )   +   (1 - etaC_f_2) * ( ((1 + tauC_f_2) * P_d_2 * E_f)^(1 - lambdaC_f_2) ))^( 1 / (1 - lambdaC_f_2) );

% ------------------------------------------------------
% Consumption demand for domestic and imported goods in each sector (number of equations = NumberOfSecotrs * 2 )

% (79) Domestic demand for sectors 1 and 2
C_f_f_1 = etaC_f_1 * ( (P_f_1 / PC_f_1)^(-lambdaC_f_1) ) * C_f_1;
C_f_f_2 = etaC_f_2 * ( (P_f_2 / PC_f_2)^(-lambdaC_f_2) ) * C_f_2;

% (80) Demand for Imports
C_f_d_1 = (1-etaC_f_1) * ( ( (1 + tauC_f_1) * P_f_1 * E_f ) / PC_f_1)^(-lambdaC_f_1) ) * C_f_1;
C_f_d_2 = (1-etaC_f_2) * ( ( (1 + tauC_f_2) * P_f_2 * E_f ) / PC_f_2)^(-lambdaC_f_2) ) * C_f_2;


% -----------------------------------------------------------------------------
% ------------ Domestic International Investment Retailers --------------------
% -----------------------------------------------------------------------------
  
% (85) CES aggregator of international consumption goods Prices in each sector
PI_d_1 = (  etaI_d_1 * ( P_d_1^(1 - lambdaI_d_1) )   +   (1 - etaI_d_1) * ( ( P_f_1 * E_d)^(1 - lambdaI_d_1) ))^( 1 / (1 - lambdaI_d_1) );
PI_d_2 = (  etaI_d_2 * ( P_d_2^(1 - lambdaI_d_2) )   +   (1 - etaI_d_2) * ( ( P_f_2 * E_d)^(1 - lambdaI_d_2) ))^( 1 / (1 - lambdaI_d_2) );

% ------------------------------------------------------
% Investment demand for domestic and imported goods in each sector (number of equations = NumberOfSecotrs * 2 )

% (83) Domestic demand for sectors 1 and 2
I_d_d_1 = etaI_d_1 * ( (P_d_1 / PI_d_1)^(-lambdaI_d_1) ) * I_d_1;
I_d_d_2 = etaI_d_2 * ( (P_d_2 / PI_d_2)^(-lambdaI_d_2) ) * I_d_2;

% (84) Imported
I_d_f_1 = (1-etaI_d_1) * ( ( P_d_1 * E_d ) / PI_d_1)^(-lambdaI_d_1) ) * I_d_1;
I_d_f_2 = (1-etaI_d_2) * ( ( P_d_2 * E_d ) / PI_d_1)^(-lambdaI_d_2) ) * I_d_2;

% -----------------------------------------------------------------------------
% ------------ Domestic International Investment Retailers --------------------
% -----------------------------------------------------------------------------
  
% (85) CES aggregator of international consumption goods Prices in each sector
PI_f_1 = (  etaI_f_1 * ( P_f_1^(1 - lambdaI_f_1) )   +   (1 - etaI_f_1) * ( ( P_f_1 * E_f)^(1 - lambdaI_f_1) ))^( 1 / (1 - lambdaI_f_1) );
PI_f_2 = (  etaI_f_2 * ( P_f_2^(1 - lambdaI_f_2) )   +   (1 - etaI_f_2) * ( ( P_f_2 * E_f)^(1 - lambdaI_f_2) ))^( 1 / (1 - lambdaI_f_2) );

% -----------------------------------------------------------------------------
% Investment demand for domestic and imported goods in each sector (number of equations = NumberOfSecotrs * 2 )

% (83) Domestic demand for sectors 1 and 2
I_f_f_1 = etaI_f_1 * ( (P_f_1 / PI_f_1)^(-lambdaI_f_1) ) * I_f_1;
I_f_f_2 = etaI_f_2 * ( (P_f_2 / PI_f_2)^(-lambdaI_f_2) ) * I_f_2;

% (84) Imported
I_f_d_1 = (1-etaI_f_1) * ( ( P_f_1 * E_f ) / PI_f_1)^(-lambdaI_f_1) ) * I_f_1;
I_f_d_2 = (1-etaI_f_2) * ( ( P_f_2 * E_f ) / PI_f_1)^(-lambdaI_f_2) ) * I_f_2;






% -----------------------------------------------------------------------------
% ---------- Domestic International Intermediate Inputs Retailers -------------
% -----------------------------------------------------------------------------

% (89) CES aggregator of international intermediates Prices in each sector
PM_d_1_1 = (  etaM_d_1_1 *  P_d_1^(1 - lambdaM_d_1) )  + (1 - etaM_d_1_1) * (  (1 + tauM_d_1) * P_f_1 * E_d )^(1 - lambdaM_d_1) )^( 1 / (1 - lambdaM_d_1) )
PM_d_1_2 = (  etaM_d_1_2 *  P_d_2^(1 - lambdaM_d_1) )  + (1 - etaM_d_1_2) * (  (1 + tauM_d_2) * P_f_2 * E_d )^(1 - lambdaM_d_1) )^( 1 / (1 - lambdaM_d_1) )
                          
PM_d_2_1 = (  etaM_d_2_1 *  P_d_1^(1 - lambdaM_d_2) )  + (1 - etaM_d_2_1) * (  (1 + tauM_d_1) * P_f_1 * E_d )^(1 - lambdaM_d_2) )^( 1 / (1 - lambdaM_d_2) )
PM_d_2_2 = (  etaM_d_2_2 *  P_d_2^(1 - lambdaM_d_2) )  + (1 - etaM_d_2_2) * (  (1 + tauM_d_2) * P_f_2 * E_d )^(1 - lambdaM_d_2) )^( 1 / (1 - lambdaM_d_2) )

% (88) Intermediates demand for domestic and imported goods in each sector (num of equaitons = NumberOfSecotrs * 2 )

% Domestic demand for sectors 1 and 2
M_d_d_1_1 = etaM_d_1_1 * ( P_d_1 / PM_d_1_1) ^(-lambdaM_d_1) *  M_d_1_1;
M_d_d_1_2 = etaM_d_1_2 * ( P_d_2 / PM_d_1_2) ^(-lambdaM_d_1) *  M_d_1_1;

M_d_d_2_1 = etaM_d_2_1 * ( P_d_1 / PM_d_2_1) ^(-lambdaM_d_2) *  M_d_2_1;
M_d_d_2_2 = etaM_d_2_2 * ( P_d_2 / PM_d_2_2) ^(-lambdaM_d_2) *  M_d_2_2;


% Import Demand for Intermediates
M_d_f_1_1 =   (1 - etaM_d_1_1) * ( (1+tauM_d_1 ) * P_f_1 * E_d / PM_d_1_1) ^(-lambdaM_d_1) *  M_d_1_1;
M_d_f_1_2 =   (1 - etaM_d_1_2) * ( (1+tauM_d_2 ) * P_f_2 * E_d / PM_d_1_2) ^(-lambdaM_d_1) *  M_d_1_2;

M_d_f_2_1 = (1 - etaM_d_2_1) * ( (1+tauM_d_1 ) * P_f_1 * E_d / PM_d_2_1) ^(-lambdaM_d_2) *  M_d_2_1;
M_d_f_2_2 = (1 - etaM_d_2_2) * ( (1+tauM_d_2 ) * P_f_2 * E_d / PM_d_2_2) ^(-lambdaM_d_2) *  M_d_2_2;


% -----------------------------------------------------------------------------
% ---------- Foreign International Intermediate Inputs Retailers -------------
% -----------------------------------------------------------------------------
  
% (89) CES aggregator of international intermediates Prices in each sector
PM_f_1_1 = (  etaM_f_1_1 *  P_f_1^(1 - lambdaM_f_1) )  + (1 - etaM_f_1_1) * (  (1 + tauM_f_1) * P_f_1 * E_f )^(1 - lambdaM_f_1) )^( 1 / (1 - lambdaM_f_1) )
PM_f_1_2 = (  etaM_f_1_2 *  P_f_2^(1 - lambdaM_f_1) )  + (1 - etaM_f_1_2) * (  (1 + tauM_f_2) * P_f_2 * E_f )^(1 - lambdaM_f_1) )^( 1 / (1 - lambdaM_f_1) )

PM_f_2_1 = (  etaM_f_2_1 *  P_f_1^(1 - lambdaM_f_2) )  + (1 - etaM_f_2_1) * (  (1 + tauM_f_1) * P_f_1 * E_f )^(1 - lambdaM_f_2) )^( 1 / (1 - lambdaM_f_2) )
PM_f_2_2 = (  etaM_f_2_2 *  P_f_2^(1 - lambdaM_f_2) )  + (1 - etaM_f_2_2) * (  (1 + tauM_f_2) * P_f_2 * E_f )^(1 - lambdaM_f_2) )^( 1 / (1 - lambdaM_f_2) )

% (88) Intermediates demand for domestic and imported goods in each sector (num of equaitons = NumberOfSecotrs * 2 )

% Domestic demand for sectors 1 and 2
M_f_f_1_1 = etaM_f_1_1 * ( P_f_1 / PM_f_1_1) ^(-lambdaM_f_1) *  M_f_1_1;
M_f_f_1_2 = etaM_f_1_2 * ( P_f_2 / PM_f_1_2) ^(-lambdaM_f_1) *  M_f_1_1;

M_f_f_2_1 = etaM_f_2_1 * ( P_f_1 / PM_f_2_1) ^(-lambdaM_f_2) *  M_f_2_1;
M_f_f_2_2 = etaM_f_2_2 * ( P_f_2 / PM_f_2_2) ^(-lambdaM_f_2) *  M_f_2_2;


% Import Demand for Intermediates
M_f_d_1_1 = (1 - etaM_f_1_1) * ( (1+tauM_f_1) * P_d_1 * E_f / PM_f_1_1 )^(-lambdaM_f_1) * M_f_1_1;
M_f_d_1_2 = (1 - etaM_f_1_2) * ( (1+tauM_f_2) * P_d_2 * E_f / PM_f_1_2 )^(-lambdaM_f_1) * M_f_1_2;

M_f_d_2_1 = (1 - etaM_f_2_1) * ( (1+tauM_f_1) * P_d_1 * E_f / PM_f_2_1 )^(-lambdaM_f_2) * M_f_2_1;
M_f_d_2_2 = (1 - etaM_f_2_2) * ( (1+tauM_f_2) * P_d_2 * E_f / PM_f_2_2 )^(-lambdaM_f_2) * M_f_2_2;


%------------------------------ Domestic Producers --------------------------------------------------------------------

%(92) -------------------- Production functions ---------------------------------------------------------------
  
Y_d_1 = ( (K_d_1(-1)^(1 - alphaL_d_1)) * (L_d_1^(alphaL_d_1)) )^(alphaM_d_1) * ( M_d_1^(1 - alphaM_d_1) );
Y_d_2 = ( (K_d_2(-1)^(1 - alphaL_d_2)) * (L_d_2^(alphaL_d_2)) )^(alphaM_d_2) * ( M_d_2^(1 - alphaM_d_2) );


%(93-95) -------------------- Marginal Products ----------------------------------------------------------------
% 
K_d_1 = ( alphaM_d_1 * (1 - alphaL_d_1) / RK_d_1 ) * MC_d_1 * Y_d_1;
K_d_2 = ( alphaM_d_1 * (1 - alphaL_d_2) / RK_d_2 ) * MC_d_2 * Y_d_2;

L_d_1 = ( alphaM_d_1 * alphaL_d_1 / W_d_1 ) * MC_d_2 * Y_d_1;
L_d_2 = ( alphaM_d_2 * alphaL_d_2 / W_d_2 ) * MC_d_2 * Y_d_2;

M_d_1 = ( (1 - alphaM_d_1) / PM_d_1 ) * MC_d_1 * Y_d_1;
M_d_2 = ( (1 - alphaM_d_2) / PM_d_2 ) * MC_d_2 * Y_d_2;

% (96) Marginal Costs -------------------------------------------------------------------------------------------
  
MC_d_1 = ( ( (RK_d_1/(1 - alphaL_d_1))^(1 - alphaL_d_1) )  * ( (W_d_1/alphaL_d_1)^(alphaL_d_1) ) )^(alphaM_d_1) * ( (PM_d_1/(1 - alphaM_d_1))^(1 - alphaM_d_1) );
MC_d_2 = ( ( (RK_d_2/(1 - alphaL_d_2))^(1 - alphaL_d_2) )  * ( (W_d_2/alphaL_d_2)^(alphaL_d_2) ) )^(alphaM_d_2) * ( (PM_d_2/(1 - alphaM_d_2))^(1 - alphaM_d_2) );

% (99) Phillips Curve -------------------------------------------------------------------------------------------
Mp_d_1 = epsilon_p_d_1/( 1 - epsilon_p_d_1)
Mp_d_2 = epsilon_p_d_2/( 1 - epsilon_p_d_2)

pippi_d_1 = P_d_1 / P_d_1(-1)
pippi_d_2 = P_d_2 / P_d_2(-1)

(pippi_d_1 - 1)* pippi_d_1 = ( epsilon_p_d_1/psi_p_d_1 ) * ( (MC_d_1/P_d_1) - (1/Mp_d_1) ) + beta_d * ((mu_d(+1)/mu_d) * (pippi_d_1(+1) - 1) * (pippi_d_1(+1)^2)/ (picpi_d(+1) * Y_d_1(+1) / Y_d_1) );
(pippi_d_2 - 1)* pippi_d_2 = ( epsilon_p_d_2/psi_p_d_2 ) * ( (MC_d_2/P_d_2) - (1/Mp_d_2) ) + beta_d * ( (mu_d(+1)/mu_d) * (pippi_d_2(+1) - 1) * (pippi_d_2(+1)^2) / (picpi_d(+1) * Y_d_2(+1) / Y_d_2) );

                                                                                                                                                                                                              

                                                                                                         
                                                                                                         
                                                                                                         
%------------------------------ Foreign Producers --------------------------------------------------------------------
%(92) -------------------- Production functions ---------------------------------------------------------------
Y_f_1 = ( (K_f_1(-1)^(1 - alphaL_f_1)) * (L_f_1^(alphaL_f_1)) )^(alphaM_f_1) * ( M_f_1^(1 - alphaM_f_1) );
Y_f_2 = ( (K_f_2(-1)^(1 - alphaL_f_2)) * (L_f_1^(alphaL_f_2)) )^(alphaM_f_2) * ( M_f_2^(1 - alphaM_f_2) );
                                                                                                       
                                                                                                       
%(93-95) -------------------- Marginal Products ----------------------------------------------------------------
K_f_1 = ( alphaM_f_1 * (1 - alphaL_f_1) / RK_f_1 ) * MC_f_1 * Y_f_1;
K_f_2 = ( alphaM_f_1 * (1 - alphaL_f_2) / RK_f_2 ) * MC_f_2 * Y_f_2;
                                                                                                       
L_f_1 = ( alphaM_f_1 * alphaL_f_1 / W_f_1 ) * MC_f_2 * Y_f_1;
L_f_2 = ( alphaM_f_2 * alphaL_f_2 / W_f_2 ) * MC_f_2 * Y_f_2
                                                                                                       
M_f_1 = ( (1 - alphaM_f_1) / PM_f_1 ) * MC_f_1 * Y_f_1;
M_f_2 = ( (1 - alphaM_f_2) / PM_f_2 ) * MC_f_2 * Y_f_2;

                                                                                                       
% (96) Marginal Costs -------------------------------------------------------------------------------------------
MC_f_1 = ( ( (RK_f_1/(1 - alphaL_f_1))^(1 - alphaL_f_1) )  * ( (W_f_1/alphaL_f_1)^(alphaL_f_1) ) )^(alphaM_f_1) * ( (PM_f_1/(1 - alphaM_f_1))^(1 - alphaM_f_1) );
MC_f_2 = ( ( (RK_f_2/(1 - alphaL_f_2))^(1 - alphaL_f_2) )  * ( (W_f_2/alphaL_f_2)^(alphaL_f_2) ) )^(alphaM_f_2) * ( (PM_f_2/(1 - alphaM_f_2))^(1 - alphaM_f_2) );
                                                                                                       
% (99) Phillips Curve -------------------------------------------------------------------------------------------
Mp_f_1 = epsilon_p_f_1/( 1 - epsilon_p_f_1)
Mp_f_2 = epsilon_p_f_2/( 1 - epsilon_p_f_2)
                                                                                                       
pippi_f_1 = P_f_1 / P_f_1(-1)
pippi_f_2 = P_f_2 / P_f_2(-1)
                                                                                                       
(pippi_f_1 - 1)* pippi_f_1 = ( epsilon_p_f_1/psi_p_f_1 ) * ( (MC_f_1/P_f_1) - (1/Mp_f_1) ) + beta_f * ( (mu_f(+1)/mu_f) * (pippi_f_1(+1) - 1) * (pippi_f_1(+1)^2)/(picpi_f(+1) * Y_f_1(+1)/ Y_f_1);
(pippi_f_2 - 1)* pippi_f_2 = ( epsilon_p_f_2/psi_p_f_2 ) * ( (MC_f_2/P_f_2) - (1/Mp_f_2) ) + beta_f * ( (mu_f(+1)/mu_f) * (pippi_f_2(+1) - 1) * (pippi_f_2(+1)^2)/(picpi_f(+1) * Y_f_2(+1)/ Y_f_2);                                                                                                                                                                                                                                                                                                                                                                                                                         
                                                                                                       
                                                                                                       
                                                                                                       
                                                                                                       
                                                                                                        
                                                                                                       
% (100) Monetary policy rule -------------------------------------------------------------------------------------------
R_d / R_ss_d = ( (R_d(-1) / R_ss_d)^rho_R_d ) * (   ((picpi_d / picpi_ss_d)^phi_pi_d)  *  ((Y_VA_d / Yd_VA_ss_d)^phi_y_d) )^(1 - rho_R_d);
R_f / R_ss_f = ( (R_f(-1) / R_ss_f)^rho_R_f ) * (   ((picpi_d / picpi_ss_d)^phi_pi_f)  *  ((Y_VA_f / Yd_VA_ss_f)^phi_y_f) )^(1 - rho_R_f);

% Market Clearing conditions -------------------------------------------------------------------------------------------
                                                                                                                                                                                                                
% Labour markets
N_d_1 = L_d_1
N_d_2 = L_d_2
                                                                                                                                                                                                              
%-----------------------------------------------
%  Domestic Trade Balance
%-----------------------------------------------
                                                                                                                                                                                                                
% --- Goods market clearing: Home, Sector 1 --- % intermediate from sector 1 used in sector 1, and 2 in 1....
TB_d_1 = P_d_1 *(omega_f/omega_d) * ( C_f_d_1 + I_f_d_1 + M_f_d_1_1 + M_f_d_2_1 ) - P_f_1 * E_d * ( C_d_f_1 + I_d_f_1 + M_d_f_1_1 + M_d_f_2_1 );
%                                         Exports 							  Imports
TB_d_2 = P_d_2 *(omega_f/omega_d) * ( C_f_d_2 + I_f_d_2 + M_f_d_1_2 + M_f_d_2_2 ) - P_f_1 * E_d * ( C_d_f_2 + I_d_f_2 + M_d_f_1_2 + M_d_f_2_2 );
%                                         Exports 							  Imports
TB_d = TB_d_1 + TB_d_2

%-----------------------------------------------
%  Foreign Trade Balance
%-----------------------------------------------
TB_f_1 = ( P_f_1*( C_d_f_1 + I_d_f_1 + M_d_f_1_1 + M_d_f_1_2 ) )/omega_d - ( P_d_1*Ef*( C_f_d_1 + I_f_d_1 + M_f_d_1_1 + M_f_d_1_2 ) )/omega_f;
TB_f_2 = ( P_f_2*( C_d_f_2 + I_d_f_2 + M_d_f_2_1 + M_d_f_2_2 ) )/omega_d - ( P_d_2*Ef*( C_f_d_2 + I_f_d_2 + M_f_d_2_1 + M_f_d_2_2 ) )/omega_f;
TB_f = TB_f_1 + TB_f_2;
                                                                                                                                                                                                              
                                                                                                                                                                                                              
% Market clearing for domestic sectors
P_d_1 * Y_d_1 =  PC_d_1 * C_d_1 + PI_d_1 * I_d_1 + PM_d_1_1 * M_d_1_1 + PM_d_2_1 * M_d_2_1 + TB_d_1 + + (psi_p_d_1/2) * (piPPI_d_1 - 1)^2 * P_d_1 * Y_d_1;
P_d_1 * Y_d_1 =  PC_d_1 * C_d_1 + PI_d_1 * I_d_1 + PM_d_1_1 * M_d_1_1 + PM_d_2_1 * M_d_2_1 + TB_d_1 + + (psi_p_d_1/2) * (piPPI_d_1 - 1)^2 * P_d_1 * Y_d_1;

% Market clearing for foreign sectors
P_f_1 * Y_f_1 =  PC_f_1 * C_f_1 + PI_f_1 * I_f_1 + PM_f_1_1 * M_f_1_1 + PM_f_2_1 * M_f_2_1 + TB_f_1 + + (psi_p_f_1/2) * (piPPI_f_1 - 1)^2 * P_f_1 * Y_f_1;
P_f_1 * Y_f_1 =  PC_f_1 * C_f_1 + PI_f_1 * I_f_1 + PM_f_1_1 * M_f_1_1 + PM_f_2_1 * M_f_2_1 + TB_f_1 + + (psi_p_f_1/2) * (piPPI_f_1 - 1)^2 * P_f_1 * Y_f_1;

Y_VA_d = C_d + (PI_d/PC_d)*I_d + (TB_d/PC_d);
Y_VA_f = C_f + (PI_f/PC_f)*I_f + (TB_f/PC_f);
omega_d * A_d + omega_f * A_f = 0;

A_f = Ra(-1) * A_f(-1) + TB_f;


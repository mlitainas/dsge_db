%%--------------------------------------------------------------------------
% The RBC Model - a baseline version, similar to ESims notes
%--------------------------------------------------------------------------
 
% MLitainas - May 2026

% Baseline RBC model 
% CRRA utility, capital accumulation (No investment adjustment cost)


% ~~~~~~~~~~~~~~~~~~~~~ Endogenous Variables ~~~~~~~~~~~~~~~~~~~~~~~~~~   
var
    c             % 1.consumption 
    rk            % 2.rental rate of capital 
    r             % 3.real interest rate
    w             % 4.real wage
    h             % 5.hours 
    k             % 6.capital
    y             % 7.output
    i             % 8.investment
    g             % 9.public spending
    a             % 10.TFP      
;

%%%%%%%%%%%%%%%%%%%%%%%Exogenous Variables%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
varexo 
va   % productivity shock
vg   % public spending shock
;  
    
%%
%%%%%%%%%%%%%%%%%%%%%%%Parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parameters

beta 
alpha
delta
sigma
phi
kappaL 
gss 
ass
rhoa
rhog 
;


load par;  % load mat file created in console
for jj=1:length(M_.param_names)
    set_param_value(M_.param_names{jj},eval(M_.param_names{jj})); 
end; 


%%
%%%%%%%%%%%%%%%%%%%%%%%Non-Linear Model%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

model;
% Households
% Euler Bonds  - FOC consumption -plus- FOC bonds
    c^(-sigma) = beta * c(+1)^(-sigma) * r;
% Euler Capital- FOC consumption -plus- FOC capital    
    c^(-sigma) = beta * c(+1)^(-sigma) * (rk(+1) + (1-delta));
% Labour Supply 
    kappaL*h^(phi) = w * c^(-sigma);
% LoM for capital    
k = (1-delta)*k(-1) + i;

% Firm
% Priduction function 
    y = a*k(-1)^alpha*h^(1-alpha);
% MPL - Labour demand
    w = (1-alpha)*y/h;
% MPK - Capital Demand
    rk = alpha*y/k(-1);
% Market clearing
% In the HH budget constrain set Bt+j = 0 and G = T
    y = c + i + g;
% Shocks
    log(a) = (1-rhoa)*log(ass) + rhoa*log(a(-1)) + va;
    log(g) = (1-rhog)*log(gss) + rhog*log(g(-1)) + vg;
end;

%% Steady State

steady_state_model;
    y   = 1;
    h   = 1/3;
    r   = 1/beta;
    rk  = 1/beta-(1-delta);            % solved
    % MPK - Capital Demand
    k   = alpha*y/rk;
    i   = delta*k;
    w   = (1-alpha)*y/h;
    a = ass;
    g = gss;
    c = y - i - g;
end;

steady;
%% Shocks
shocks;
var va; stderr 0.01;     
var vg; stderr 0.01;    

end;

%% IRFs
stoch_simul(irf=40,order=1) y c i rk r w ;  
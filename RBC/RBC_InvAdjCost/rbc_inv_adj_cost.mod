%--------------------------------------------------------------------------
% The RBC Model - the baseline version  
%--------------------------------------------------------------------------

% Mlitainas May 2026
%%
%%%%%%%%%%%%%%%%%%%%%%%Endogenous Variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var
c             % consumption 
rk            % rental rate of capital 
r             % real interest rate
w             % real wage
h             % hours 
k             % capital
y             % output
q             % Tobin Q
i             % investment
lambda        % marginal utility of consumption
g             % public spending
a             % TFP
     
;
%%
%%%%%%%%%%%%%%%%%%%%%%%Exogenous Variables%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
varexo 
va   % productivity shock
vg   % public spending shock
;  
    

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
kappaI 
rhoa
rhog 
;

load par;  % load mat file created in console
for jj=1:length(M_.param_names)
set_param_value(M_.param_names{jj},eval(M_.param_names{jj})); 
end; 


%---------------------------Non-Linear Model---------------------------
model;

    % Households
    lambda=c^-sigma;  
    1=beta*lambda(1)/lambda*r;
    1=beta*lambda(1)/lambda*(rk(1)+(1-delta)*q(1))/q;
    kappaL*h^(phi)=w*lambda;        
    k=(1-delta)*k(-1)+(1-kappaI/2*(i/i(-1)-1)^2)*i;
    1=q*(1-kappaI/2*(i/i(-1)-1)^2-kappaI*(i/i(-1)-1)*i/i(-1))+kappaI*beta*lambda(1)/lambda*q(1)*(i(1)/i-1)*(i(1)/i)^2;    
    
    % Firms
    y=a*k(-1)^alpha*h^(1-alpha);
    (1-alpha)*y=w*h;
    alpha*y=rk*k(-1);
    
    % Market clearing
    y=c+i+g;
    
    % Shocks
    log(a)=(1-rhoa)*log(ass)+rhoa*log(a(-1))+va;  
    log(g)=(1-rhog)*log(gss)+rhog*log(g(-1))+vg; 

end;

%% Steady State

steady_state_model;
    y=1;
    h=1/3;                       
    r=1/beta;                   
    q=1;                         
    rk=1/beta-(1-delta);        
    k=alpha*y/rk;                
    w=(1-alpha)*y/h;            
    i=delta*k;
    g=gss;
    a=ass;
    c=y-i-g;                    
    lambda=c^(-sigma);           
end;

steady;
check;

%% Shocks
shocks;
  var va; stderr 0.01;     
  var vg; stderr 0.01;    
end;

%% IRFs
stoch_simul(irf=40,order=1) y c i rk r w ; 


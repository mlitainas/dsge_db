%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% The Open-Economy NK Model %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Author: Valerio Nispi Landi
% First version: 27/11/2018
% This version: 04/04/2021
% Variables with the z refer to the Foreign economy (Starred variables in the handout notation)

close all;
warning off
%%
%%%%%%%%%%%%%%%%%%%%%%%Endogenous Variables%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var
c    cz          % consumption
h    hz          % hours
k    kz          % capital 
q    qz          % Tobin q 
i    iz          % investment
w    wz          % real wage
yH   yFz         % output
pH   pHz         % price of H good
pF   pFz         % price of F good
r    rz          % nominal interest rate 
rr   rrz         % real interest rate
mc   mcz         % real marginal cost
lambda lambdaz   % marginal utility of consumption
rk   rkz         % rental rate of capital
bH   bHz         % H bond
bF   bFz         % F bond
pi   piz         % CPI inflation
piH  piFz        % producer inflation
tb   tbz         % trade balance
gdp  gdpz        % gross domestic product
g    gz          % government spending 
a    az          % total factor productivity
ki   kiz         % capital inflows
ko   koz         % capital outflows
fa  faz          % financial account
nfa nfaz         % net financial asset position
s                % real exchange rate
De               % depreciation of H currency
proof            % it should be always zero, otherwise something is wrong


% log variables to have IRFs in percentage deviations from the ss
clog 
hlog
klog
ilog
slog       
czlog
hzlog
kzlog
izlog
gdpzlog
;
%%
%%%%%%%%%%%%%%%%%%%%%%%Exogenous Variables%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
varexo 
va   vaz   % productivity shock
vg   vgz   % public spending shock
vm   vmz   % monetary policy shock

;  
    
%%
%%%%%%%%%%%%%%%%%%%%%%%Parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parameters

beta 
alpha
delta
sigma
phi
eta
gamma
gammaz
kappaL
epsilon
n
gss
gzss
piss
pizss
ass
azss
bFss
bHzss
pHss
gdpzss
rss
rzss 
kappaI
kappaP
kappaD
phipi
phiy
phie
rhoa
rhog
rhom  
;

load par;  % load mat file created in console_tcm
for jj=1:length(M_.param_names)
set_param_value(M_.param_names{jj},eval(M_.param_names{jj})); 
end; 


%%
%%%%%%%%%%%%%%%%%%%%%%%Non-Linear Model%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

model;
% Households
lambda= (c) ^-sigma;
lambdaz=(cz)^-sigma; 

1=beta*lambda(1) /lambda *r/ pi(1);
1=beta*lambdaz(1)/lambdaz*rz/piz(1);

1=beta*lambda(1) /lambda *rz/piz(1)*s(1)/s   -kappaD*(bF-bFss);
1=beta*lambdaz(1)/lambdaz*r /pi(1) *s   /s(1)-kappaD*(bHz-bHzss);

1=beta*lambda(1) /lambda *(rk(1)+(1-delta) *q(1)) /q;
1=beta*lambdaz(1)/lambdaz*(rkz(1)+(1-delta)*qz(1))/qz;

kappaL*h^(phi) =lambda* w;        
kappaL*hz^(phi)=lambdaz*wz;

k= (1-delta)*k(-1)+ (1-kappaI/2*(i /i(-1)-1)^2) *i;
kz=(1-delta)*kz(-1)+(1-kappaI/2*(iz/iz(-1)-1)^2)*iz;

1=q *(1-kappaI/2*(i /i(-1)-1) ^2-kappaI*(i /i(-1)-1) *i /i(-1)) +kappaI*beta*lambda(1) /lambda *q(1) *(i(1) /i-1) *(i(1) /i) ^2;    
1=qz*(1-kappaI/2*(iz/iz(-1)-1)^2-kappaI*(iz/iz(-1)-1)*iz/iz(-1))+kappaI*beta*lambdaz(1)/lambdaz*qz(1)*(iz(1)/iz-1)*(iz(1)/iz)^2;    

% Firms
yH =a *k(-1) ^alpha*h ^(1-alpha);
yFz=az*kz(-1)^alpha*hz^(1-alpha);

(1-alpha)*mc* yH =w *h;
(1-alpha)*mcz*yFz=wz*hz;

alpha*mc *yH =rk* k(-1);
alpha*mcz*yFz=rkz*kz(-1);

(piH -piss) *piH =beta*(lambda(1) /lambda *pH(1) *yH(1) /(pH *yH) *piH(1) *(piH(1) -piss)) +epsilon/kappaP*(mc /pH -(epsilon-1)/epsilon);
(piFz-pizss)*piFz=beta*(lambdaz(1)/lambdaz*pFz(1)*yFz(1)/(pFz*yFz)*piFz(1)*(piFz(1)-pizss))+epsilon/kappaP*(mcz/pFz-(epsilon-1)/epsilon);

% Market clearing
yH= (1-gamma) *pH^(-eta) *(c+i)  +g +(1-n)/n*gammaz*pHz^(-eta)*(cz+iz)+(kappaP/2*(piH -piss) ^2) *yH;
yFz=(1-gammaz)*pFz^(-eta)*(cz+iz)+gz+ n/(1-n)*gamma *pF^(-eta)*(c+i)  +(kappaP/2*(piFz-pizss)^2)*yFz;
n*bH+(1-n)*bHz=0;
n*bF+(1-n)*bFz=0;
gdp=c+i+pH*g+tb+pH*yH*(kappaP/2*(piH-piss)^2); 

% Prices
1=(1-gamma) *pH ^(1-eta)+gamma *pF ^(1-eta);
1=(1-gammaz)*pFz^(1-eta)+gammaz*pHz^(1-eta);
pH=s*pHz;
pF=s*pFz;
piH= pH /pH (-1) *pi;
piFz=pFz/pFz(-1)*piz;
s/s(-1)=De*piz/pi;

% Policy
r/ (rss)= ((pi /piss) ^(phipi)*(gdp)       ^(phiy)*(De*pizss /piss)^phie )^(1-rhom)*(r (-1)/rss) ^(rhom)*exp(vm);
rz/(rzss)=((piz/pizss)^(phipi)*(gdpz/gdpzss)^(phiy)*(De*pizss/piss)^-phie)^(1-rhom)*(rz(-1)/rzss)^(rhom)*exp(vmz);

% Shocks
log(a) =(1-rhoa)*log(ass) +rhoa*log(a(-1)) +va;
log(az)=(1-rhoa)*log(azss)+rhoa*log(az(-1))+vaz;

log(g)= (1-rhog)*log(gss)+ rhog*log(g(-1)) +vg;  
log(gz)=(1-rhog)*log(gzss)+rhog*log(gz(-1))+vgz;  

% Auxiliary variables
rr=r/pi(1); 
rrz=rz/piz(1); 
gdp=pH*yH; 
gdpz=pFz*yFz;
tb=bH+s*bF-r(-1)/pi*bH(-1)-s*rz(-1)/piz*bF(-1)+kappaD/2*s*(bF-bFss)^2-(1-n)/n*kappaD/2*(bHz-bHzss)^2;
tbz=bFz+bHz/s-rz(-1)/piz*bFz(-1)-1/s*r(-1)/pi*bHz(-1)+kappaD/(2*s)*(bHz-bHzss)^2-n/(1-n)*kappaD/2*(bF-bFss)^2;
ki=-(bH-bH(-1)); 
kiz=-(bFz-bFz(-1));
ko=s*(bF-bF(-1));
koz=(bHz-bHz(-1))/s;
fa=ki-ko; 
faz=kiz-koz;
nfa=(bH+s*bF)/gdp;
nfaz=(bHz/s+bFz)/gdpz;
proof=gdpz-(cz+iz+pFz*gz+tbz+(kappaP/2*(piFz-pizss)^2)*pFz*yFz);

% Log variables
clog=log(c); 
hlog=log(h); 
klog=log(k); 
ilog=log(i);
slog=log(s);
czlog=log(cz);
hzlog=log(hz);
kzlog=log(kz); 
izlog=log(iz); 
gdpzlog=log(gdpz);


end;

%% Steady State

steady_state_model;
pH=pHss;
gdp=1;
gdpz=gdpzss;
g=gss; 
gz=gzss;
h=1/3;
pi=piss; 
piz=pizss;  
piH=piss; 
piFz=pizss; 
rr=1/beta;                       
rrz=1/beta;                     
r=pi/beta;                       
rz=piz/beta;
q=1;                               
qz=1;                            
rk=1/beta-(1-delta);             
rkz=1/beta-(1-delta);            
pF=(1/gamma*(1-(1-gamma)*pH^(1-eta)))^(1/(1-eta)); 
s=(gammaz*pH^(1-eta)+(1-gammaz)*pF^(1-eta))^(1/(1-eta));
pHz=pH/s;                   
pFz=pF/s;                   
bF=bFss;
bHz=bHzss; 
bH=-(1-n)/n*bHzss; 
bFz=-n/(1-n)*bFss; 
mc=pH*(epsilon-1)/epsilon; 
mcz=pFz*(epsilon-1)/epsilon;
yH=gdp/pH;                            
yFz=gdpz/pFz;                        
k=alpha*yH*mc/rk;           
kz=alpha*yFz*mcz/rkz;      
i=delta*k;                  
iz=delta*kz;                
tb=bH*(1-1/beta)+bF*s*(1-1/beta); 
c=gdp-i-pH*g-tb;      
cz=1/((1-gammaz)*pFz^(-eta))*(yFz-gz-n/(1-n)*gamma*pF^(-eta)*(c+i))-iz; 
w=(1-alpha)*yH*mc/h;         
lambda=(c)^(-sigma);         
lambdaz=(cz)^(-sigma);        
hz=(lambdaz*(1-alpha)/kappaL*mcz*yFz)^(1/(1+phi));       
wz=kappaL*hz/lambdaz;         
a=ass;
az=azss; 
tbz=gdpz-cz-delta*kz-pFz*gz;
De=pi/piz;
clog=log(c); 
hlog=log(h); 
klog=log(k); 
ilog=log(i);
slog=log(s);
czlog=log(cz);
hzlog=log(hz);
kzlog=log(kz); 
izlog=log(iz); 
gdpzlog=log(gdpz);
nfa=(-(1-n)/n*bHz+s*bF);
nfaz=(bHz/s-n/(1-n)*bF)/gdpz;
end;

steady;
check;

%% Shocks
shocks;
var va; stderr 0.01;     
var vg; stderr 0.01;    
var vm; stderr 0.0025; 
var vaz; stderr 0.01;     
var vgz; stderr 0.01;    
var vmz; stderr 0.0025;    
end;

%% IRFs
stoch_simul(irf=40,order=1, hp_filter=1600,pruning)
gdp
gdpzlog
slog 
clog 
czlog 
pi 
piz 
nfa 
nfaz
proof
;
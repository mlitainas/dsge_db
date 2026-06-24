clc; clear all; close all

%% This code computes the steady state of a 2-country NK model
% Author: Valerio Nispi Landi
% First version: 25/11/2018
% This version: 04/04/2021

%% Structural Parameters or calibrated steady-state values (quarterly calibration)
beta=0.99;                    % discount factor
alpha=0.33;                   % elasticity of production wrt capital
epsilon=6;                    % elasticity of substitution btw differentiated goods
delta=0.025;                  % depreciation rate
sigma=2;                      % relative risk aversion
phi=1;                        % inverse of Frisch elasticity
eta=1.5;                      % elasticity of intratemporal substitution
omega=0.3;                    % trade openness
D=0;                          % H external GROSS debt/GDP yearly ratio
Dz=0.1;                       % F external GROSS debt/GDP yearly ratio
psi=1.1;                      % gdpz/gdp ratio
n=0.2;                        % relative population of Home economy
gdp=1;                        % gross domestic product
pi=1;                         % H inflation targeting (quarterly calibration)
piz=1;                        % F inflation targeting (quarterly calibration)      
h=1/3;                        % hours of work
gamma=omega*(1-n)*psi/(n+(1-n)*psi); % F good weigh in H bundle
gammaz=omega*n/(n+(1-n)*psi); % H good weigh in F bundle
gshare=0.2;                   % public spending share in GDP
gsharez=0.2;      


%% Steady State (analytical expressions)
rr=1/beta;                       % H real interest rate
rrz=1/beta;                      % F real interest rate
r=pi/beta;                       % H nominal interest rate
rz=piz/beta;                     % F nominal interest rate
q=1;                             % H marginal value of investment (in terms of lambda)  
qz=1;                            % F marginal value of investment (in terms of lambda)  
rk=1/beta-(1-delta);             % H rental rate of capital in H
rkz=1/beta-(1-delta);            % F rental rate of capital in F
g=gshare*gdp;                    % H public spending


%% Steady State (numerical computation)
options = optimoptions('fsolve','MaxFunEvals',300000,'MaxIter',30000,'TolFun',1e-15);

pH0=1;                       % Initial guess

x = fsolve(@(pp) find_steady(pp,alpha,beta,gamma,gammaz,delta,epsilon,eta,n,D,Dz,gdp,rk,rkz,g,gsharez,psi),pH0,options);

pH=x;                       % Price of H good
pF=(1/gamma*(1-(1-gamma)*pH^(1-eta)))^(1/(1-eta)); % Price of F good
s=(gammaz*pH^(1-eta)+(1-gammaz)*pF^(1-eta))^(1/(1-eta)); % Real Fx rate
gdpz=psi*gdp/s;             % F GDP
gz=gsharez*gdpz;            % F government spending
pHz=pH/s;                   % Price of H good (in terms of F CPI)
pFz=pF/s;                   % Price of F good (in terms of F CPI)
bF=-4*gdp*D/s;              % H investment in F bond
bHz=-4*s*gdpz*Dz;           % F investment in H bond
bH=-(1-n)/n*bHz;            % H investment in H bond
bFz=-n/(1-n)*bF;            % F investment in F bond
mc=pH*(epsilon-1)/epsilon;  % H Real margingal cost
mcz=pFz*(epsilon-1)/epsilon;% F Real margingal cost
yH=gdp/pH;                  % H output           
yFz=gdpz/pFz;               % F output            
k=alpha*yH*mc/rk;           % H capital 
kz=alpha*yFz*mcz/rkz;       % F capital 
i=delta*k;                  % H investment
iz=delta*kz;                % F investment
tb=bH*(1-1/beta)+bF*s*(1-1/beta); % F trade balance
c=gdp-delta*k-pH*g-tb;       % H consumption
cz=1/((1-gammaz)*pFz^(-eta))*(yFz-gz-n/(1-n)*gamma*pF^(-eta)*(c+i))-iz; % F consumption
w=(1-alpha)*yH*mc/h;         % H wage
lambda=(c)^(-sigma);          % H marginal utlity of consumption
lambdaz=(cz)^(-sigma);        % F marginal utlity of consumption
kappaL=lambda*w/(h^phi);      % labor supply shifter
hz=(lambdaz*(1-alpha)/kappaL*mcz*yFz)^(1/(1+phi));       % F Hours 
wz=kappaL*hz/lambdaz;         % F wage

a=yH/(k^(alpha)*h^(1-alpha));          % H tfp
az=yFz/(kz^(alpha)*hz^(1-alpha));      % F tfp
tbz=bFz*(1-1/beta)+bHz/s*(1-1/beta);   % F trade balance
proof=gdpz-(cz+iz+pFz*gz+tbz);         % If 0, the solution is not wrong

%% Steady-state values
gss=g;
gzss=gz;
ass=a;
azss=az;
piss=pi;
pizss=piz;
rss=r;
rzss=rz;
bFss=bF;
bHzss=bHz;
gdpzss=gdpz;
pHss=pH;

%% Parameters not affecting the steady state
phipi=1.5;                % mp response to inflation
phiy=0.125;               % mp response to output
phie=0;                   % mp response to exchange rate
kappaI=2.48;              % investment adjustment cost (as in CEE). If 0, q is constant
kappaD=0.01;              % usually calibrated at a small value. If 0, the model has a unit root
rhoa=0.9;                 % tfp persistence
rhog=0.9;                 % public spending persistence
rhom=0.8;                 % monetary policy inertia
calvo=0.66;               % price rigidity in calvo framework

% adjusment cost coefficient to have the same linear Phillips Curve of the Calvo framework
kappaP=(epsilon-1)*calvo/(piss^2*(1-calvo)*(1-beta*calvo)); 

%% Save parameters
save par beta alpha delta sigma phi eta gamma gammaz kappaL psi epsilon n...
gss gzss piss pizss ass azss bFss bHzss pHss gdpzss rss rzss phipi phiy phie kappaI kappaD...
rhoa rhog rhom kappaP


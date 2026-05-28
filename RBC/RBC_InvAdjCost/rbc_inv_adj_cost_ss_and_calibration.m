%--------------------------------------------------------------------------
% The RBC Model - the baseline version  
%--------------------------------------------------------------------------
% Similar to Nipsi-Landi notes
% MLitainas - May 2026
% This file sets the parameters of the model, calculates the SS and
% calibrates certain parameters when needed

clc; clear all;

% Structural Parameters
beta=0.99;                      % discount factor
alpha=0.33;                     % PF capital intensity
delta=0.025;                    % capital depreciation rate
sigma=2;                        % relative risk aversion - 
phi=1;                          % inverse of Frisch elasticity
g=0.2;                          % share of public spending in ss

% Steady State
y=1;                            % gdp
h=1/3;                          % hours of work
r=1/beta;                      % real interest rate
q=1;                            % marginal value of investment (in terms of lambda)  
rk=1/beta-(1-delta);            % rental rate of capital
k=alpha*y/rk;                   % stock of capital
w=(1-alpha)*y/h;                % real wage
i=delta*k;                      % investment
c=y-i-g;                        % consumption
lambda=c^(-sigma);              % marginal utlity of consumption
a=y/(k^(alpha)*h^(1-alpha));    % tfp
kappaL=w/(h^(phi)*c^(sigma));   % labor preference parameter calibrated so ss solves
gss=g;
ass=a;
kappaI=0;                       % investment adjustment cost
rhoa=0.9;                       % tfp persistence
rhog=0.9;                 % public spending persistence

%% Save parameters 
save par beta alpha delta sigma phi gss ass kappaL kappaI rhoa rhog


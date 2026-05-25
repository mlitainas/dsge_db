%--------------------------------------------------------------------------
% The RBC Model - a baseline version, similar to ESims notes
%-------------------------------------------------------------------------- 
% MLitainas - May 2026

% This file sets the parameters of the model, calculates the SS and
% calibrates certain parameters when needed

clc;clear all;

% Structural Parameters
beta=0.99;                    % discount factor
alpha=0.33;                   % PF capital intensity
delta=0.025;                  % capital depreciation rate
sigma=2;                      % relative risk aversion - 
phi=1;                        % inverse of Frisch elasticity
g=0.2;                        % share of public spending in ss
rhoa=0.9;                 % tfp persistence
rhog=0.9;                 % public spending persistence


% Steady State
y   = 1;
h   = 1/3;
r   = 1/beta;
rk  = 1/beta-(1-delta);            % solved
k   = alpha*y/rk;
i   = delta*k;
w   = (1-alpha)*y/h;
a   = y / (k^alpha*h^(1-alpha));
gss = g;
c = y - i - g;
kappaL = w * c^(-sigma)/h^(phi); 
ass = a;
% Save parameters 
save par beta alpha delta sigma phi gss ass kappaL rhoa rhog;

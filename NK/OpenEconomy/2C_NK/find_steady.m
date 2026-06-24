% This function computes the steady state of the model. It is called in console_tcm
% Author: Valerio Nispi Landi
% First version: 25/11/2018
% This version: 21/03/2021

function [ F ]  = find_steady(pp,alpha,beta,gamma,gammaz,delta,epsilon,eta,n,D,Dz,gdp,rk,rkz,g,gsharez,psi)
pH=pp;
pF=(1/gamma*(1-(1-gamma)*pH^(1-eta)))^(1/(1-eta));
s=(gammaz*pH^(1-eta)+(1-gammaz)*pF^(1-eta))^(1/(1-eta));
gdpz=psi*gdp/s;
gz=gsharez*gdpz;
pHz=pH/s; 
pFz=pF/s;
bF=-4*gdp*D/s; 
bHz=-4*s*gdpz*Dz;
bH=-(1-n)/n*bHz;
mc=pH*(epsilon-1)/epsilon;
mcz=pFz*(epsilon-1)/epsilon;
yH=gdp/pH;                        
yFz=gdpz/pFz;
k=alpha*yH*mc/rk;
kz=alpha*yFz*mcz/rkz;
tb=bH*(1-1/beta)+bF*s*(1-1/beta);
c=gdp-delta*k-pH*g-tb;
cz=1/((1-gammaz)*pFz^(-eta))*(yFz-gz-n/(1-n)*gamma*pF^(-eta)*(c+delta*k))-delta*kz;

F=(1-gamma)*pH^(-eta)*(c+delta*k)+g+(1-n)/n*gammaz*pHz^(-eta)*(cz+delta*kz)-yH;
end


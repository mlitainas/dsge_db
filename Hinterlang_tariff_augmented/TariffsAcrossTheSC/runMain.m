clear; clc;
addpath("/Applications/Dynare/6.4-arm64/matlab")
load_parameters
dynare main
model_diagnostics(M_);

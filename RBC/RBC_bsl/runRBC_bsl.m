% cell file to run the model
%addpath("/Applications/Dynare/6.4-arm64/matlab")
clear all; clc;
rbc_bsl_ss_and_calibration;
dynare rbc_bsl

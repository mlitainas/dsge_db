
TenS_var_names = M_.endo_names;
TenS_param_names = M_.param_names;
TenS_param_values = M_.params;

simulationnames = str2mat('FlexPrice_Orderly');

TenS_Sim_ss = oo_.steady_state;
TenS_Sim_results=oo_.endo_simul;

FILENAME = str2mat(['TenS_Aonly_Open_SimulResults_' deblank(simulationnames(1,:)) '_PEM.mat']);

cd Results
save([FILENAME], 'TenS_var_names', 'TenS_param_names', 'TenS_param_values', 'TenS_Sim_ss', 'TenS_Sim_results' );
cd ..
var     
        @#for co in country
        C_@{co}_t, I_@{co}_t, N_@{co}_t, K_@{co}_t, w_@{co}_t,
        rk_@{co}_t, lambda_@{co}_t, Y_@{co}_t, Y_VA_@{co}_t, PI_@{co}_t,
        TB_@{co}_t, NFA_@{co}_t, R_@{co}_t, pi_cpi_@{co}_t, tau_@{co}_t,
        
        P_EM_@{co}_t, 
        ZZ_@{co}_t, epsi_@{co}_t,
        
        @#for se in 1:sector
        C_@{se}_@{co}_t, I_@{se}_@{co}_t, N_@{se}_@{co}_t, K_@{se}_@{co}_t, Y_@{se}_@{co}_t,
        w_@{se}_@{co}_t, epsi_@{se}_@{co}_t, rk_@{se}_@{co}_t, H_@{se}_@{co}_t,
        PH_@{se}_@{co}_t, PC_@{se}_@{co}_t, PI_@{se}_@{co}_t, TB_@{se}_@{co}_t,
        mc_@{se}_@{co}_t, pi_cpi_@{se}_@{co}_t,
        
        ZZ_@{se}_@{co}_t, Pen_@{se}_@{co}_t, EM_cost_@{se}_@{co}_t, mc_tild_@{se}_@{co}_t,
        
        @#for co2 in country
        C_@{se}_@{co}_@{co2}_t, I_@{se}_@{co}_@{co2}_t, P_@{se}_@{co}_@{co2}_t, pi_ppi_@{se}_@{co}_@{co2}_t,
        @#for se2 in 1:sector
        H_@{se}_@{se2}_@{co}_@{co2}_t,
        @#endfor
        @#endfor
        
        @#for se2 in 1:sector
        PHH_@{se}_@{se2}_@{co}_t, H_@{se}_@{se2}_@{co}_t, 
        @#endfor
        
        @#endfor
        @#endfor
        
        @#for se in 1:sector
         MM_@{se}_a_b_t, XX_@{se}_b_a_t,  
        @#endfor
        
        rer_ba_t, R_w_t, EM_t
        ;
        
        
varexo
        @#for co in country
        shock_epsi_@{co}_t, shock_P_EM_@{co}_t, shock_epsi_carb_int_@{co}_t, shock_tau_@{co}_t               

        @#for se in 1:sector
        shock_epsi_@{se}_@{co}_t
        @#endfor
        @#endfor
        ;
        


parameters  
        @#for co in country
        C_@{co}_ts, I_@{co}_ts, N_@{co}_ts, K_@{co}_ts, w_@{co}_ts,
        rk_@{co}_ts, lambda_@{co}_ts, Y_VA_@{co}_ts, Y_@{co}_ts, TB_@{co}_ts, NFA_@{co}_ts,
        R_@{co}_ts, PI_@{co}_ts, pi_cpi_@{co}_ts, 

        P_EM_@{co}_ts, 
        ZZ_@{co}_ts, epsi_@{co}_ts, 
        
        kappaN_@{co}, lab_@{co}, rho_eps_@{co}, size_@{co}, rho_tau_@{co},
        
        @#for se in 1:sector
        C_@{se}_@{co}_ts, I_@{se}_@{co}_ts, N_@{se}_@{co}_ts, K_@{se}_@{co}_ts, Y_@{se}_@{co}_ts, 
        w_@{se}_@{co}_ts, epsi_@{se}_@{co}_ts, rk_@{se}_@{co}_ts, H_@{se}_@{co}_ts,
        PH_@{se}_@{co}_ts, PC_@{se}_@{co}_ts, PI_@{se}_@{co}_ts, TB_@{se}_@{co}_ts,
        mc_@{se}_@{co}_ts, pi_cpi_@{se}_@{co}_ts, 

        ZZ_@{se}_@{co}_ts, Pen_@{se}_@{co}_ts, EM_cost_@{se}_@{co}_ts, mc_tild_@{se}_@{co}_ts,
        
        @#for co2 in country
        C_@{se}_@{co}_@{co2}_ts, I_@{se}_@{co}_@{co2}_ts, P_@{se}_@{co}_@{co2}_ts, pi_ppi_@{se}_@{co}_@{co2}_ts,
        @#for se2 in 1:sector
        H_@{se}_@{se2}_@{co}_@{co2}_ts,
        @#endfor
        @#endfor        
        
        @#for se2 in 1:sector
        PHH_@{se}_@{se2}_@{co}_ts, H_@{se}_@{se2}_@{co}_ts,
        @#endfor
        
        Psi_con_@{se}_@{co}, Psi_inv_@{se}_@{co}, omega_N_@{se}_@{co}, omega_K_@{se}_@{co}, omega_N_tild_@{se}_@{co}, omega_K_tild_@{se}_@{co}, alphaN_@{se}_@{co},
        sigh_@{se}_@{co}, alphaH_@{se}_@{co}, sigc_@{se}_@{co}, sigi_@{se}_@{co}, sighh_@{se}_@{co},
        
        gama0_@{se}_@{co}, gama1_@{se}_@{co}, gama2_@{se}_@{co}, carb_int_@{se}_@{co},
        
        @#for co2 in country
        hb_con_@{se}_@{co}_@{co2}, hb_inv_@{se}_@{co}_@{co2}, 
        @#for se2 in 1:sector
        hb_hhh_@{se}_@{se2}_@{co}_@{co2},
        @#endfor
        @#endfor 
        
        @#for se2 in 1:sector
        Psi_@{se}_@{se2}_@{co},
        @#endfor
        @#endfor
        sigc_@{co}, sigi_@{co}, upsi_K_@{co}, upsi_N_@{co},
     
        @#endfor
        
        @#for se in 1:sector
        Aux_@{se}_b_a_ts, MM_@{se}_a_b_ts, XX_@{se}_b_a_ts, 
        @#endfor
        
        sig, delta, betta, Psi2, rho_EM, EM_ts,
        
        rer_ba_ts,  R_w_ts
        ;
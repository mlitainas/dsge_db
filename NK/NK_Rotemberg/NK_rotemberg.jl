using MacroModelling
import StatsPlots

@model NK begin

    # Households
    lambda[0] = c[0]^(-sigma)
    1 = beta * lambda[1] / lambda[0] * r[0] / pi[1]
    1 = beta * lambda[1] / lambda[0] *  (rk[1] + (1 - delta) * q[1]) / q[0]
    kappaL * h[0]^phi = w[0] * lambda[0]
    k[0] = (1 - delta) * k[-1] + (1 - kappaI / 2 * (i[0] / i[-1] - 1)^2) * i[0]
    1 = ( q[0] * (1 - kappaI / 2 * (i[0] / i[-1] - 1)^2 - kappaI * (i[0] / i[-1] - 1) * i[0] / i[-1]) + kappaI * beta * lambda[1] / lambda[0] * q[1] * (i[1] / i[0] - 1) * (i[1] / i[0])^2 )

    # # Firms
    y[0] = a[0] * k[-1]^alpha * h[0]^(1 - alpha)
    (1 - alpha) * mc[0] * y[0] = w[0] * h[0]
    alpha * mc[0] * y[0] = rk[0] * k[-1]
    (pi[0] - piss) * pi[0] = ( beta * lambda[1] / lambda[0] * y[1] / y[0] * pi[1] * (pi[1] - piss) + epsilon / kappaP * (mc[0] - (epsilon - 1) / epsilon) )

    # # Market clearing
    y[0] = ( c[0] + i[0] + g[0] + kappaP / 2 * (pi[0] - piss)^2 * y[0]  )

    # # Monetary policy
    r[0] / rss = ( ((pi[0] / piss)^phipi * y[0]^phiy)^(1 - rhom) * (r[-1] / rss)^rhom * exp( std_m * vm[x]) )

    # # Productivity and government spending
    log(a[0]) = ( (1 - rhoa) * log(ass) + rhoa * log(a[-1]) + std_a * va[x] )

    log(g[0]) = ( (1 - rhog) * log(gss) + rhog * log(g[-1]) + std_g * vg[x] )

    # Auxiliary variables
    rr[0] = r[0] / pi[1]

    clog[0] = log(c[0])
    wlog[0] = log(w[0])
    hlog[0] = log(h[0])
    klog[0] = log(k[0])
    ilog[0] = log(i[0])

end;

 NK

@parameters NK begin
    
    piss = 1.0
    rss  = piss / beta
    alpha   = 0.33
    beta    = 0.99
    epsilon = 6.0
    delta   = 0.025
    sigma   = 2.0
    phi     = 1.0
    gss       = 0.2
    phipi = 1.5
    phiy = 0.125
    kappaI = 2.48
    rhoa = 0.9
    rhog = 0.9
    rhom = 0.8
    kappaP = 1
    kappaL = 1
    std_m = 0.025
    std_g = 0.025
    std_a = 0.025
    ass = 1
end


plot_irf(NK, parameters = :α => 0.5, variables = [:a,:y,:i,:r,:w,:c], shocks = :va)

# Policy function
get_solution(NK)

plot_solution(NK,:k)

 # get_steady_state
get_steady_state(NK)
get_irf(NK)

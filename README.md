# Multivariate Outbreak Simulation

### Author: Andreas Hicketier

This R project simulates outbreaks into several time series, extending the simulations done in Noufaily 2012 <https://onlinelibrary.wiley.com/doi/abs/10.1002/sim.5595>.

When an outbreak occurs we can usually see signals in several closely related infection time series, i.e. neighbouring counties, similar ages. Noufaily 2012 only simulates independent time series. Here we simulate outbreaks in several adjacent time series. This will help us to develop new algorithms that can combine signals from several time series.

See the file `R/run.R` for some examples. It contains:

-   example simulations

-   reproductions of some of the scenarios from the paper

-   examples of an adjacency matrix and a multivariate outbreak simulation

### Comment the parametrization of the negative Binomial Distribution

It is difficult to reproduce Figure 2(d), Szenario 17 in Noufaily 2012. This might be because of how the negative binomial distribution is parametrized. Details are in German below. Different parametrizations are available as function argument `parametrization` in the function`simulate_negbin_ts`.

Ich vermute, dass das daran liegt, dass die Parametrisierung der NegBinom-Verteiliung im Paper falsch ist. Dort ist mu der Erwartungswert und die Varianz ist ist gegeben durch mu\*sigma, wobei sigma ein Dispersion Parameter ist. Normalerweise wird der Dispersionsparameter aber k genannt und die Varianz ist mu+mu^2/k (siehe z.B. die Hilfe für rnbinom in R). Ich vermute, dass das im Paper mit der quasi-Poissonverteilung verwechselt wurde. Siehe z.B. hier für eine passende Parametrisierung: <https://en.wikipedia.org/wiki/Poisson_regression#Overdispersion_and_zero_inflation>

Wenn man mu\*sigma = mu + mu^2/k nach k auflöst, bekommt man k = mu/(sigma-1). Wenn ich das benutze, bekomme ich auch das Szenario 17 viel passender zum Paper simuliert. Allerdings passen dann meiner Meinung nach die Szenarien 10 und 12, also b) und c) in Fig 2, nicht mehr.

Ich weiß nicht, wie man in R von der quasi-Poisson Verteilung zieht und habe nur diesen einen halbseidenen blogpost gefunden, der meinen Vorschlag oben nutzt. <https://www.r-bloggers.com/2012/08/generate-quasi-poisson-distribution-random-variable/> Hier ist es angeblich implementiert, aber die Formel ist falsch angegeben: <https://rdrr.io/cran/predint/man/rqpois.html>

### Possible ways to continue

-   make the multivariate outbreaks depend on the variance of the endemic time series, as is the case for univariate time series. In the univariate case `sd_ti <- mean_ti+mean_ti^2/sigma` in function `add_outbreaks_to_ts`calculates the variance of the underlying endemic time series und uses this to simulate an outbreak. We then only need a factor `k` to scale this variance. This is elegant because we don't need to specify outbreak sizes exactly, instead they scale with the endemic time series. See also section 3.2 of the paper.

-   include polymod adjacency matrix for age group interactions

-   include different spatial adjacency matrices for Germany

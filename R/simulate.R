library(dplyr)
library(ggplot2)


simulate_negbin_ts <- function(length_ts = 624, theta, beta, gamma_1, gamma_2, sigma, m){
  # Simulate a time series from a negative binomial distribution.
  # See Noufaily 2013 for details
  t <- 1:length_ts
  seasonality <- 0
  for (j in 1:m) {
    seasonality <- seasonality +
      gamma_1*cos(2*pi*j*t/52) + gamma_2*sin(2*pi*j*t/52)
  }
  mean <- exp(theta + beta*t + seasonality)
  overdispersion <- sigma
  # overdispersion <- mean/(sigma-1+0.0001)
  ts <- tibble(t,mean) %>%
    rowwise() %>%
    mutate(
      cases = rnbinom(n = 1, size = overdispersion, mu = mean) # size = dispersion parameter
    )
  return(ts)
}

add_outbreaks_to_ts <- function(ts, k, ti, sigma, delay){
  # Add Poisson distributed outbreaks to a time series
  # Add a label to the data frame when outbreaks happen
  mean_ti <- ts[ti, ][["mean"]]
  sd_ti <- mean_ti+mean_ti^2/sigma
  outbreak_size <- rpois(1, lambda = k*sd_ti)
  outbreak_distribution <- round(lognormDiscrete()*outbreak_size,0)
  len_ts <- nrow(ts)
  outbreak_vec <- c(rep(0,ti+delay),outbreak_distribution) # pad front
  outbreak_vec <- c(outbreak_vec, rep(0,len_ts-length(outbreak_vec))) # pad back #TODO
  ts$outbreak <- outbreak_vec
  ts$cases <- ts$cases+ts$outbreak
  return(ts)
}


plot_ts <- function(ts){
  p <- ggplot(ts, aes(x=t,y = cases)) +
    geom_line() +
    theme_Publication()
  return(p)
}

add_outbreak_to_multivariate_ts <- function(multivariate_ts, adjacency_matrix, outbreak_ts){
  # multivariate_ts: data frame of time series in long format
  # adjacency_matrix. describes the dependency structure between time series.
  #   each [row] says what proportion of outbreak cases in [ts] to assign 
  #   to itself (diagonal elements) or to other ts
  # outbreak_ts: time series of outbreaks
  proportions <- adjacency_matrix[unique(outbreak_ts$source),]
  out <- list()
  for (i in seq_along(proportions)) {
    cases <- proportions[i]*outbreak_ts$cases
    multivariate_ts[multivariate_ts$type == names(proportions)[[i]], "outbr_cases"] <- cases
  }
  multivariate_ts <- 
    multivariate_ts %>%
    mutate(endemic_cases = cases,
           cases = endemic_cases+outbr_cases)
  
  return(multivariate_ts)
}

lognormDiscrete <- function(Dmax=20,logmu=0,sigma=0.5){
  # From Surveillance package
  Fd <- plnorm(0:Dmax, meanlog = logmu, sdlog = sigma)
  FdDmax <- plnorm(Dmax, meanlog = logmu, sdlog = sigma)
  
  #Normalize
  prob <- diff(Fd)/FdDmax
  return(prob)
}


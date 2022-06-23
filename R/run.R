source("R/simulate.R")
source("R/plotting_helpers.R")

ts_scenario8 <- simulate_negbin_ts(
  length_ts = 624,
  theta = -2,
  beta = 0,
  gamma_1 = 0.1,
  gamma_2 = 0.3,
  sigma = 2,
  m = 1
)
plot_ts(ts_scenario8)
ggsave("output/scenario8_simple.png",  width = 14, height = 9)
ts_scenario10 <- simulate_negbin_ts(
  length_ts = 624,
  theta = -2,
  beta = 0.005,
  gamma_1 = 0,
  gamma_2 = 0,
  sigma = 2,
  m = 0
)
plot_ts(ts_scenario10)
ggsave("output/scenario10_alternate.png",  width = 14, height = 9)
ts_scenario12 <- simulate_negbin_ts(
  length_ts = 624,
  theta = -2,
  beta = 0.005,
  gamma_1 = 0.1,
  gamma_2 = 0.3,
  sigma = 2,
  m = 2
)
plot_ts(ts_scenario12)
ggsave("output/scenario12_alternate.png",  width = 14, height = 9)
ts_scenario16 <- simulate_negbin_ts(
  length_ts = 624,
  theta = 1.5,
  beta = 0.003,
  gamma_1 = 0,
  gamma_2 = 0,
  sigma = 1,
  m = 0
)
plot_ts(ts_scenario16)

ts_scenario17 <- simulate_negbin_ts(
  length_ts = 624,
  theta = 1.5,
  beta = 0.003,
  gamma_1 = 0.2,
  gamma_2 = -0.4,
  sigma = 1,
  m = 1
)
plot_ts(ts_scenario17)
ggsave("output/scenario17_alternate.png",  width = 14, height = 9)
ts_scenario17 <- add_outbreaks_to_ts(
  ts = ts_scenario17,
  k = 1,
  ti = 100,
  sigma = 1,
  delay = 2
)
ts_scenario17 <- add_outbreaks_to_ts(
  ts = ts_scenario17,
  k = 0.2,
  ti = 300,
  sigma = 1,
  delay = 2
)
plot_ts(ts_scenario17)
ggsave("output/scenario17_two_outbreaks.png",  width = 14, height = 9)


ts_scenario18 <- simulate_negbin_ts(
  length_ts = 624,
  theta = 1.5,
  beta = 0.003,
  gamma_1 = 0.2,
  gamma_2 = -0.4,
  sigma = 1,
  m = 2
)
plot_ts(ts_scenario18)


####
# simulate two together
####

ts_1 <- simulate_negbin_ts(
  length_ts = 624,
  theta = 1.5,
  beta = 0.003,
  gamma_1 = 0.2,
  gamma_2 = -0.4,
  sigma = 1,
  m = 1
)
ts_2 <- simulate_negbin_ts(
  length_ts = 624,
  theta = 1.5,
  beta = 0.003,
  gamma_1 = 0.2,
  gamma_2 = -0.4,
  sigma = 1,
  m = 1
)
ts_3 <- simulate_negbin_ts(
  length_ts = 624,
  theta = 1.5,
  beta = 0.003,
  gamma_1 = 0.2,
  gamma_2 = -0.4,
  sigma = 1,
  m = 1
)
ts_1 <- add_outbreaks_to_ts(
  ts = ts_1,
  k = 1.5,
  ti = 100,
  sigma = 1,
  delay = 2
)
ts_1 <- add_outbreaks_to_ts(
  ts = ts_1,
  k = 0.5,
  ti = 300,
  sigma = 1,
  delay = 2
)
ts_2 <- add_outbreaks_to_ts(
  ts = ts_2,
  k = 1,
  ti = 100,
  sigma = 1,
  delay = 2
)
ts_2 <- add_outbreaks_to_ts(
  ts = ts_2,
  k = 0.5,
  ti = 300,
  sigma = 1,
  delay = 2
)
ts_3 <- add_outbreaks_to_ts(
  ts = ts_3,
  k = 1,
  ti = 100,
  sigma = 1,
  delay = 2
)
ts_3 <- add_outbreaks_to_ts(
  ts = ts_3,
  k = 1,
  ti = 300,
  sigma = 1,
  delay = 2
)

ts_1$type <- "ts_1"
ts_2$type <- "ts_2"
ts_3$type <- "ts_3"

ts_comb <- bind_rows(ts_1, ts_2, ts_3)

ggplot(ts_comb, aes(x=t,y = cases)) +
  geom_line() +
  facet_wrap(vars(type), nrow = 3) +
  theme_Publication()
ggsave("output/three_ts_with_outbreak.png", width = 14, height = 9)

adjacency_matrix <- matrix(c(.9,.1,.1,0,.5,.5,0,.5,.5), nrow=3, ncol=3, byrow=TRUE)
row.names(adjacency_matrix) <- colnames(adjacency_matrix) <-  c("ts_1", "ts_2", "ts_3")
outbreak_ts <-
  tibble(t = 1:624,
         cases = c(rep(0, 100), 600, 300, rep(0, 100), 300, 400, rep(0, 420)),
         source = "ts_2")

multivariate_ts <- add_outbreak_to_multivariate_ts(ts_comb, adjacency_matrix, outbreak_ts)
ggplot(multivariate_ts, aes(x=t,y = cases)) +
  geom_line() +
  facet_wrap(vars(type), nrow = 3) +
  theme_Publication()
ggsave("output/three_ts_with_outbreak_0.5.5.png", width = 14, height = 9)

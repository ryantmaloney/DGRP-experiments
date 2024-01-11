data {
  int<lower=0> J;         // number of schools
  vector<lower=0, upper=1>[J] x;              // estimated treatment effects
  vector<lower=0, upper=1>[J] y;              // estimated treatment effects
}
parameters {
  real alpha;                // population treatment effect
  real<lower=0> sigma;      // standard deviation in treatment effects
}

model {
  y ~ normal(alpha * x, sigma);
}

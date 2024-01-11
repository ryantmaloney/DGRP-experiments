data {
//   int<lower=0> N;         // Number of flies
  int<lower=0> S; //Number of Strains

  int<lower=0> t1_obs;
  int<lower=0> t2_obs;
  int<lower=0> t1_mis;
  int<lower=0> t2_mis;
  
  array[t1_obs] int<lower=1, upper=t1_obs+t1_mis> t1i_obs; //indexes of t1 with real data
  array[t2_obs] int<lower=1, upper=t2_obs+t2_mis> t2i_obs; //indexes of t2 with real data
  array[t1_mis] int<lower=1, upper=t1_obs+t1_mis> t1i_mis; //indexes of t1 with real data
  array[t2_mis] int<lower=1, upper=t2_obs+t2_mis> t2i_mis; //indexes of t2 with real data
  
  array[t1_obs] int<lower=0> x1_obs;              // num right turns
  array[t2_obs] int<lower=0> x2_obs;              // num right turns
  array[t1_obs+t1_mis] int<lower=0, upper=S> s;   //strain ID for each 
  array[t1_obs] int<lower=1> n1_obs;
  array[t2_obs] int<lower=1> n2_obs;
}

transformed data {
  int<lower=0> N = t1_obs+t1_mis;
}

parameters {
  array[t1_obs] real<lower=0, upper=1> R1_obs;                // True bias
  array[t2_obs] real<lower=0, upper=1> R2_obs;                // True bias      
  array[S] real<lower=0, upper=10> D; //
  // real<lower=0, upper=10> D; //
  array[t1_mis] real<lower=0, upper=1> R1_mis;
  array[t2_mis] real<lower=0, upper=1> R2_mis;
}

transformed parameters {

  array[N] real<lower=0, upper=1> R1;
  array[N] real<lower=0, upper=1> R2;

  R1[t1i_obs]= R1_obs;
  R1[t1i_mis]= R1_mis;
  R2[t2i_obs]= R2_obs;
  R2[t2i_mis]= R2_mis;
//   // R1[t1iobs]
}

model {
  // R1_obs ~ normal(.5, 1);
  // R2_obs ~ normal(.5, 1);
  // R1_mis ~ normal(.5, 1);
  // R2_mis ~ normal(.5, 1);

  R1 ~ normal(.5, 1);
  R2 ~ normal(.5, 1);

  x1_obs ~ binomial(n1_obs, R1_obs); //Something funky here with the successes being more than N...
  x2_obs ~ binomial(n2_obs, R2_obs);

  // R2 ~ normal(R1, D);

  for (i in 1:S){
    for (j in 1:N){
      if (s[j]==i){
        R2[j] ~ normal(R1[j], D[i]);
        }
      }
  }
  // R2 ~ normal(R1, D)
  // for (j in 1:N){
  //       R2[j] ~ normal(R1[j], D);
  // }
}
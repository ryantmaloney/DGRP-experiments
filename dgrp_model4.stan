data {
  int<lower=0> N;         // Number of flies
  int<lower=0> T; //Number of Days

  int<lower=0> S; //Number of Strains
  array[N] int<lower=0, upper=S> s;   //strain ID for each 


  int<lower=0> t_obs;
  int<lower=0> t_mis;

  array[t_obs] int<lower=0, upper=t_obs> fly_i_obs; //indexes of for which fly goes to which data
  array[t_obs] int<lower=0, upper=t_obs> time_i_obs; //indexes for which time goes to which data

  array[t_mis] int<lower=0, upper=t_obs> fly_i_mis; //indexes of for which fly goes to which data
  array[t_mis] int<lower=0, upper=t_obs> time_i_mis; //indexes for which time goes to which data

  array[t_obs] int<lower=0> x_obs;              // num right turns for each obs
  array[t_obs] int<lower=0> n_obs; // Num turns for each obs
}

// transformed data {
//   int<lower=0> N = t1_obs+t1_mis;
// }

parameters {
  array[t_obs] real<lower=0, upper=1> R_obs;                // True bias
  array[S] real<lower=0> D; //
  array[S] real<lower=0> BH; //
  array[t_mis] real<lower=0, upper=1> R_mis;
}

transformed parameters {
  array[N, T] real<lower=0, upper=1> R;
  // array[N] real<lower=0, upper=1> R2;


  for (i in 1:t_obs){
    R[fly_i_obs[i], time_i_obs[i]]= R_obs[i];
  }
  
  for (i in 1:t_mis){
    R[fly_i_mis[i], time_i_mis[i]]= R_mis[i];
  }
}

model {
  R_mis~normal(.5, 1.0);
  D~inv_gamma(3, 1);
  BH~inv_gamma(3, 1);


  x_obs ~ binomial(n_obs, R_obs); 

  for (i in 1:S){
    for (j in 1:N){
      if (s[j]==i){
        R[j,1] ~ normal(.5, BH[i]);
        for (t in 2:T){
          R[j, t] ~ normal(R[j, t-1], D[i]);
        }
        }
      }
  }

}
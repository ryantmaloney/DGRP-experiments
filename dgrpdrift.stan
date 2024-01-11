data {
  int<lower=0> N;         // Number of flies
  int<lower=1> S; //Number of Strains
    
  int<lower=0> t1_obs;
  int<lower=0> t2_obs;
  
  int<lower=1> t1i_obs[t1_obs]; //indexes of t1 with real data
  int<lower=1> t2i_obs[t2_obs]; //indexes of t2 with real data
  
  int<lower=0> x1[t1_obs];              // num right turns
  int<lower=0> x2[t2_obs];              // num right turns
  array[N] int<lower=0, upper=S> s; //strain ID for each 
  int<lower=1> n1[t1_obs];
  int<lower=1> n2[t2_obs];
}


parameters {
  vector<lower=0, upper=1>[N] R1;                // True bias
  vector<lower=0, upper=1>[N] R2;                // True bias      
    
  array[S] real<lower=0> D;
}

model {
  D ~ normal(0,2);
  R1 ~ normal(.5, 1);
  R2 ~ normal(.5, 1);
  x1 ~ binomial(n1, R1[t1i_obs]);
  x2 ~ binomial(n2, R2[t2i_obs]);
  for (i in 1:S){
      for (j in 1:N){
          if (s[j]==i){
              R2[j] ~ normal(R1[j], D[i]);
          }
      }
  }
  
}
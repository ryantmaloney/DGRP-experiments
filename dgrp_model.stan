data {
  int<lower=0> N;         // Number of flies
  int<lower=1> S; //Number of Strains

  int<lower=0> t1_obs;
  int<lower=0> t2_obs;
  int<lower=0> t1_mis;
  int<lower=0> t2_mis;
  
  array[t1_obs] int<lower=1> t1i_obs; //indexes of t1 with real data
  array[t2_obs] int<lower=1> t2i_obs; //indexes of t2 with real data
  array[t1_mis] int<lower=1> t1i_mis; //indexes of t1 with real data
  array[t2_mis] int<lower=1> t2i_mis; //indexes of t2 with real data
  
  array[t1_obs] int<lower=0> x1_obs;              // num right turns
  array[t2_obs] int<lower=0> x2_obs;              // num right turns
  array[N] int<lower=0, upper=S> s; //strain ID for each 
  array[t1_obs] int<lower=1> n1_obs;
  array[t2_obs] int<lower=1> n2_obs;
}

transformed data {
  int<lower=0> t1_mis= n - t1_obs;
  int<lower=0> t2_mis= n-t2_obs;
}

parameters {
  // vector<lower=0, upper=1>[N] R1;                // True bias
  // vector<lower=0, upper=1>[N] R2;                // True bias      
  array[S] real<lower=0> D; //
  array[t1_mis] int<lower=1> x1_mis;
  array[t2_mis] int<lower=1> x2_mis;
  array[t1_mis] int<lower=1> n1_mis;
  array[t2_mis] int<lower=1> n2_mis;
  real <lower=0, upper=1> R1[N];                // True bias
  real <lower=0, upper=1> R2[N];                // True bias   
}

transformed parameters {
  vector<lower=0>[N] x1;               
  vector<lower=0>[N] x2;                   
  vector<lower=0>[N] n1;                   
  vector<lower=0>[N] n2; 
  x1[t1i_obs]= x1_obs;
  x1[t1i_mis]= x1_mis;
  x2[t2i_obs]= x2_obs;
  x2[t2i_mis]= x2_mis;       
  // R1[t1iobs]
}

model {
  D ~ normal(0,2);
  R1 ~ normal(.5, 1);
  R2 ~ normal(.5, 1);
  x1 ~ binomial(n1, R1);
  x2 ~ binomial(n2, R2);
  for (i in 1:S){
      for (j in 1:N){
          if (s[j]==i){
              R2[j] ~ normal(R1[j], D[i]);
          }
      }
  }
  
}
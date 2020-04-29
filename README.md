# Bayesian linear regression model (BLRM)

We compared four allometric models to estimate the leaf area of arabica coffee ‘Catuaí Vermelho’ available in the literature (Barros et al. 1973, Antunes et al. 2008, Schmidt et al. 2014) and an allometric model from a simple linear regression with Bayesian statistics adjustment based on Markov chain Monte Carlo (MCMC) to estimate the leaf area (LA) of Coffea arabica genotype ‘Catuaí Vermelho’ (n = 563). Multiplication of the maximum values between length and width (LW) and leaf area (LA) values for each leaf, were measured. This _R_ project details the Bayesian linear regression model (BLRM).The relationship between LA and LW of both cultivars were adjusted by a Bayesian linear regression model (_LA = β0 + β1 LW_) based on Markov chain Monte Carlo (MCMC) with the help of the R “brms” package. The following parameters (prior) were used after a frequentist linear regression adjustment: Gaussian prior for the intercept and slope, _β0∼N(0.9,4)_ and _β1∼N(0.7,4)_, respectively; and half-Cauchy prior for the variance _σ∼Cauchy(0.4)_ (Gelman, 2006; Polson and Scott 2012). The initial reference values before running the model were: interactions = 10000, warm-up = 5000 (_i.e._, first 5000 interactions are discarded), and chains = 4 (more details see Bürkner, 2017; 2018).



### BLRM 

![Bayesian linear regression model](https://github.com/JPASTORPM/Project_BLRM/blob/master/Results/Fig.%20BLRM.png)

> _Parameters (β0-intercept and β1-slope; *A*) from performance fit of Bayesian linear regression with MCMC (A1 and A3: gray marked area represents 95% confidence interval and horizontal line show mean; A2 and A4 are density curves, vertical line show mean) for the relationship between LW and LA for two cultivars of C. arabica genotype Catuí Vermelho (IAC44, black circles; and 19/08, white circles; B). The relationship between measured and predicted LA values from the predicted values calculated for the Bayesian linear regression (LA= β0 + β1 LW; C)._


## Built With

* [brms](https://www.rdocumentation.org/packages/brms) - Bilinear interpolations between the piezometers


## Authors

* **Junior Pastor Pérez-Molina** - *Laboratorio de Ecología Funcional y Ecosistemas Tropicales (LEFET), Escuela de Ciencias Biológicas, Universidad Nacional, Costa Rica* - [ORCID](https://orcid.org/0000-0002-3396-0599) - [GitHub](https://github.com/JPASTORPM)

# Bayesian linear regression model (BLRM)

We compared four allometric models to estimate the leaf area of arabica coffee ‘Catuaí Vermelho’ available in the literature (Barros et al. 1973, Antunes et al. 2008, Schmidt et al. 2014) and an allometric model from a simple linear regression with Bayesian statistics adjustment based on Markov chain Monte Carlo (MCMC) to estimate the leaf area (LA) of Coffea arabica genotype ‘Catuaí Vermelho’ (n = 563). Multiplication of the maximum values between length and width (LW) and leaf area (LA) values for each leaf, were measured. This _R_ project details the Bayesian linear regression model (BLRM). The relationship between LA and LW of both cultivars were adjusted by a Bayesian linear regression model (_LA = β0 + β1 LW_) based on Markov chain Monte Carlo (MCMC) with the help of the R “brms” package. The following parameters (prior) were used after a frequentist linear regression adjustment: Gaussian prior for the intercept and slope, _β0∼N(0.9,4)_ and _β1∼N(0.7,4)_, respectively; and half-Cauchy prior for the variance _σ∼Cauchy(0.4)_ (Polson and Scott 2012). The initial reference values before running the model were: interactions = 10000, warm-up = 5000 (_i.e._, first 5000 interactions are discarded), and chains = 4 (more details see Bürkner, 2017, 2018).

![Bayesian linear regression model](https://github.com/JPASTORPM/Project_BLRM/blob/master/Results/Fig.%20BLRM.png)
> _Parameters (β0-intercept and β1-slope; *A*) from performance fit of Bayesian linear regression with MCMC (A1 and A3: gray marked area represents 95% confidence interval and horizontal line show mean; A2 and A4 are density curves, vertical line show mean) for the relationship between LW and LA for two cultivars of C. arabica genotype Catuí Vermelho (IAC44, black circles; and 19/08, white circles; B). The relationship between measured and predicted LA values from the predicted values calculated for the Bayesian linear regression (LA= β0 + β1 LW; C)._

## Getting Started

This work was designed by a project in R, for proper operation must download all the "BLRM-project" uncompress folder and then open the project in R by double clip in **MAIN.R**, then load the **Script - Bayesian linear regression model** in _Script_ folder, by default all database and folders will be linked, it will not be necessary to change any work address (_i.e._ _C:\Users\BLRM-project_).

### Prerequisites

- R 3.6.1 version
- RStudio version 1.2.5019


### Automated Package Installation

To the processing of the database and execution of all statistical and graphical analysis, all the following _R_ packages must be installed.

```
if (!"devtools" %in% installed.packages()[,"Package"]) 
    install.packages("devtools")
library(devtools)
```

```
pkg <- c("brms","broom","coda", "ggplot2", "Metrics")
```

```
out <- lapply(pkg, function(y) {
    if (!y %in% installed.packages()[, "Package"]) 
        install.packages(y)
    require(y, character.only = T)
})
```

## MCMC diagnostics: Bayesian Regression Models using 'Stan'

```
data.brms = brm( LA ~  LW, data = database, 
                 iter = 10000, 
                 warmup = 5000, 
                 chains = 4, 
                 cores= 8,
                 thin = 2, 
                 refresh = 0, 
                 prior = c(prior(normal(0.9, 4), class = "Intercept"),
                           prior(normal(0.7, 4), class = "b"),
                           prior(cauchy(0, 4), class = "sigma")))

print(data.brms)

tidyMCMC(data.brms$fit, conf.int = TRUE, conf.method = "HPDinterval")

mcmc = as.mcmc(data.brms)
plot(mcmc)

raftery.diag(data.brms)

posterior_interval(as.matrix(data.brms), prob = 0.95)
```

## Model validation

```
resid = resid(data.brms)[, "Estimate"]
fit = fitted(data.brms)[, "Estimate"]
ggplot() + geom_point(data = NULL, aes(y = resid, x = fit))

resid = resid(data.brms)[, "Estimate"]
fit = fitted(data.brms)[, "Estimate"]
ggplot() + geom_point(data = NULL, aes(y = resid, x = LW))

resid = resid(data.brms)[, "Estimate"]
sresid = resid/sd(resid)
fit = fitted(data.brms)[, "Estimate"]
ggplot() + geom_point(data = NULL, aes(y = sresid, x = fit))

plot(conditional_effects(data.brms), points = TRUE)
```

## Built With

* [brms](https://www.rdocumentation.org/packages/brms) - Bayesian Regression Models using 'Stan'

## Reference

* Antunes WC, Pompelli MF, Carretero DM, DaMatta FM (**2008**) Allometric models for non-destructive leaf area estimation in coffee (Coffea arabica and Coffea canephora). _Annals of Applied Biology_, 153:33-40.
* Barros RS, Maestri M, Vieira M, Braga-Filho LJ (**1973**) Determinação de área de folhas do café (Coffea arabica L. cv. ‘Bourbon Amarelo’). _Revista Ceres_, 20:44-52.
* Bürkner P (**2017**) brms: An R Package for Bayesian Multilevel Models Using Stan. _Journal of Statistical Software_, 80(1):1-28.
* Bürkner P (**2018**) Advanced Bayesian Multilevel Modeling with the R Package brms. _The R Journal_, 10(1):395-411.
* Polson NG & Scott JG (**2012**) On the half-Cauchy prior for a global scale parameter. _Bayesian Analysis_, 7(4):887-902.
* Schmidt ER, Amaral JAT, Schmidt O, Santos JS (**2014**) Análise comparativa de equações para estimativa da área foliar em cafeeiros. _Coffee Science_, 9:155-167.

## Authors

* **Junior Pastor Pérez-Molina** - [ORCID](https://orcid.org/0000-0002-3396-0599) - [GitHub](https://github.com/JPASTORPM)
* **Marcelo Schramm Mielke** - [ORCID](https://orcid.org/)
* **Gabriel Oliveira Santos** - [ORCID](https://orcid.org/)
* **Emile Caroline Silva Lopes** - [ORCID](https://orcid.org/)
* **Ana Cristina Schilling** - [ORCID](https://orcid.org/)
* **Martielly Santana dos Santos** - [ORCID](https://orcid.org/)

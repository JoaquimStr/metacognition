analysis <- function(data_run, tp, table_model1){
  # for this first model the dependent variable is the PD trustworthiness scores;
  # subjects are a random effect, drowsiness and difficulty are fixed effects
  # (discuss to see if we integrate RT)
  
model.drodif = lmer(y ~ drowsiness*difficulty + (1|subject), data=data_run, REML=FALSE)

results_1 <- print(anova(model.drodif))

return(results_1)

}


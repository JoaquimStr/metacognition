analysis <- function(data_run, tp, table_model_2){
  
# for this second model, the dependent variable is the confidence rating (i.e., joystick data),
# subjects constitute a random effect, trustworthiness is the main predictor, and difficulty and possibly
# RT are other fixed factors (see if we keep RT or not, collinearity with drowsiness):

model.two = lmer(y ~ trustworthiness*drowsiness*difficulty + (1|subject), data=data_run, REML=FALSE)

results_2 <- print(anova(model.two))

return(results_2)

}

library(lme4)
library(effects)
library(dplyr)
library(car)
library(lmerTest) # for mixed model set-up
library(multcomp) # for multiple comparisons
library(bayestestR) # for Bayesian hierarchical modeling
library(lsr)
library(ggpubr)# qqplot
library(merTools)
library(reghelper)

# set your path:
setwd("")

# set your data files:
data_run<-read.csv("")
neural_scores<-read.csv("")
table_model1 <-read.csv("")
table_model2 <-read.csv("")


tp = 0

timewind <- 1:47; # 47 time windows of ~47ms
for(val in timewind){

# model 1:
  
tp = tp + 1;
data_run$trustworthiness <- neural_scores[2:7607, tp]

data_run$y <- data_run$trustworthiness

source('mixed_model1.R')
results_1 <- analysis(data_run, tp, table_model1)

fstat_drowsy <- results_1[1, 5]
p_1_drowsy <- results_1[1, 6]
fstat_dif <- results_1[2, 5]
p_1_dif <- results_1[2, 6]
fstat_drodif <- results_1[3, 5]
p_1_drodif <- results_1[3, 6]

table_model1[1, tp] <- fstat_drowsy
table_model1[2, tp] <- p_1_drowsy
table_model1[3, tp] <- fstat_dif
table_model1[4, tp] <- p_1_dif
table_model1[5, tp] <- fstat_drodif
table_model1[6, tp] <- p_1_drodif



# model 2:

tp = tp + 1;
data_run$trustworthiness <- neural_scores[2:7607, tp]

data_run$y <- data_run$joystick

source('mixed_model2.R')
results_2 <- analysis(data_run, tp, table_model_2)

fstat_neural <- results_2[1, 5]
pvalue_neural <- results_2[1, 6]
fstat_drowsy <- results_2[2, 5]
pvalue_drowsy <- results_2[2, 6]
fstat_dif <- results_2[3, 5]
pvalue_dif <- results_2[3, 6]
fstat_trudro <- results_2[4, 5]
pvalue_trudro <- results_2[4, 6]
fstat_trudif <- results_2[5, 5]
pvalue_trudif <- results_2[5, 6]
fstat_drodif <- results_2[6, 5]
pvalue_drodif <- results_2[6, 6]
fstat_trudrodif <- results_2[7, 5]
pvalue_trudrodif <- results_2[7, 6]

table_model2[1, tp] <- fstat_neural
table_model2[2, tp] <- pvalue_neural
table_model2[3, tp] <- fstat_drowsy
table_model2[4, tp] <- pvalue_drowsy
table_model2[5, tp] <- fstat_dif
table_model2[6, tp] <- pvalue_dif
table_model2[7, tp] <- fstat_trudro
table_model2[8, tp] <- pvalue_trudro
table_model2[9, tp] <- fstat_trudif
table_model2[10, tp] <- pvalue_trudif
table_model2[11, tp] <- fstat_drodif
table_model2[12, tp] <- pvalue_drodif
table_model2[13, tp] <- fstat_trudrodif
table_model2[14, tp] <- pvalue_trudrodif

}

# model 1 correction, save and graph 
p_1_drowsy <- table_model1[2,1:47]
p_1_dif <- table_model1[4,1:47]
p_1_drodif <- table_model1[6,1:47]
table_model1[2,1:47] <- corrected_1_drowsy
table_model1[4,1:47] <- corrected_1_dif
table_model1[6,1:47] <- corrected_1_drodif

write.csv(table_model1,"results_model1.csv", row.names = FALSE)

vec = 1:47
vec = vec * 46.8
vec = vec - 200
plot_1 <- plot(vec, table_model1[1, 1:47], main = "Impact of alertness and difficulty on the neural scores \nfrom the perceptual decision decoding over time", xlab = "ms", ylab = "F", "o", col = "blue")
lines(vec,table_model1[3, 1:47], "o", col="red")
lines(vec,table_model1[5, 1:47], "o", col="green")
legend("topright", c("alertness", "difficulty", "interaction"), col = c("blue", "red", "green"), lty=1, cex=0.8)

graphics.off()


# model 2 correction, save and graph 
p_2_neural <- table_model2[2,1:47]
p_2_drowsy <- table_model2[4,1:47]
p_2_dif <- table_model2[6,1:47]
p_2_trudro <- table_model2[8,1:47]
p_2_trudif <- table_model2[10,1:47]
p_2_drodif <- table_model2[12,1:47]
p_2_trudrodif <- table_model2[14,1:47]

table_model2[2,1:47] <- corrected_2_neural
table_model2[4,1:47] <- corrected_2_drowsy
table_model2[6,1:47] <- corrected_2_dif
table_model2[8,1:47] <- corrected_2_trudro
table_model2[10,1:47] <- corrected_2_trudif
table_model2[12,1:47] <- corrected_2_drodif
table_model2[14,1:47] <- corrected_2_trudrodif

write.csv(table_model2,"results_model2.csv", row.names = FALSE)

vec = 1:47
vec = vec * 46.8
vec = vec - 200
plot_2 <- plot(vec, table_model2[1, 1:47], main = "Impact of neural scores, drowsiness and difficulty \non confidence rating over time", xlab = "ms", ylab = "F", "o", col = "orange", ylim = c(0,52))
# plot_2 <- plot(vec, table_model2[1, 1:47], main = "Impact of neural scores\non confidence rating over time", xlab = "ms", ylab = "F", "o", col = "orange", ylim = c(0,10))
lines(vec,table_model2[3, 1:47], "o", col="blue")
lines(vec,table_model2[5, 1:47], "o", col="red")
lines(vec,table_model2[7, 1:47], "o", col="purple")
lines(vec,table_model2[9, 1:47], "o", col="grey")
lines(vec,table_model2[11, 1:47], "o", col="green")
lines(vec,table_model2[13, 1:47], "o", col="pink")
legend("topleft", c("neural scores", "alertness", "difficulty", "neural x alertness", "neural x difficulty", "alertness x difficulty", "neural x alertness x difficulty"), col = c("orange", "blue", "red", "purple", "grey", "green", "pink"), lty=1, cex=0.8)

graphics.off()


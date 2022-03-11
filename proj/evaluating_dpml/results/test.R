library(ggplot2)
library(dplyr)
#library(hrbrthemes)

v <- read.csv2("data.csv", sep = "|", stringsAsFactors = F)
v$train_cc = as.numeric(v$train_cc)
v$test_cc = as.numeric(v$test_cc)
v$ppv_diff = as.numeric(v$ppv_diff)

nodp <- v[1, ]
dp <- v[-1,] %>% dplyr::select(-1, -train_cc)
dp

v_test <- dplyr::select(dp, 1,2,3)

ggplot2::ggplot(v_test, aes(x=z, y=test_cc, group=c, color=c)) +
  ggplot2::geom_line() +
  geom_hline(yintercept=nodp$test_cc, linetype="dashed") +
  ggtitle("") +
  xlab("Noise randomizer") +
  ylab("Accuracy")

v_ppv <- dplyr::select(dp, 1,2,4)
#v_ppv$ppv_diff = v_ppv$ppv_diff - nodp$ppv_diff

ggplot2::ggplot(v_ppv, aes(x=z, y=ppv_diff, group=c, color=c)) +
  ggplot2::geom_line() +
  geom_hline(yintercept=nodp$ppv_diff, linetype="dashed") +
  ggtitle("") +
  xlab("Noise randomizer") +
  ylab("PPV")

v_test

v_ppv

nodp
str(dp)

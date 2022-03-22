library(ggplot2)
library(dplyr)
library(tidyr)
library(tibble)
library(stringr)
library(grid)

v <- read.csv2("paper.csv", sep = "|", stringsAsFactors = F)
v$accuracy = as.numeric(v$accuracy)
v$adv = as.numeric(v$adv)
v$file <- gsub("nn_grad_pert", "dp", v$file)
v$file <- gsub("nn_no_privacy", "nondp_0.0_Non-DP", v$file)

v[c("tbr", "run", "file")] <- str_split_fixed(v$file, "/", 3)
v[c("dp", "z", "cbr")] <- str_split_fixed(v$file, "_", 3)
v[c("c", "br")] <- str_split_fixed(v$cbr, ".p", 3)
v <- dplyr::select(v, -file, -tbr, -cbr, -br, -dp)

v <- filter(v, z != "0.01")
v <- filter(v, z != "0.2")
v <- filter(v, z != "0.7")

z <- filter(v, c == "Non-DP")
k <- filter(v, c != "Non-DP")

v_test <- dplyr::select(k, z,accuracy,c)
v_test <- group_by(v_test, z, c) %>% summarise(accuracy = mean(accuracy))
v_test$z <- as.numeric(v_test$z)
v_test <- arrange(v_test, z, c) %>% as.data.frame
v_test$z <- factor(v_test$z, levels = unique(v_test$z))

options(repr.P.width = 4, repr.p.height = 4)

ggplot2::ggplot(v_test, aes(x=z, y=accuracy, group=c, colour=c)) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  geom_line(aes(linetype = c, colour = c)) +
  geom_point() +
  geom_hline(yintercept = sum(z$accuracy) / nrow(z),
             linetype = "dashed") +
  ggtitle("") +
  xlab("Epsilon") +
  ylab("Accuracy") +
  scale_x_discrete(labels = c("1693543.06",
                              "93048.55",
                              "47.42",
                              "6.71",
                              "0.81", "0.38", "0.18")) +
  annotation_custom(grob = textGrob("Non-dp model",
                                    gp = gpar(fontsize = 10)),
                    xmin=4.7, ymin = 0.760)




v_adv <- dplyr::select(k, z,adv,c)
v_adv <- group_by(v_adv, z, c) %>% summarise(adv = mean(adv))
v_adv$z <- as.numeric(v_adv$z)
v_adv <- arrange(v_adv, z, c) %>% as.data.frame
v_adv$z <- factor(v_adv$z, levels = unique(v_adv$z))

ggplot2::ggplot(v_adv, aes(x=z, y=adv, group=c, color=c)) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  geom_line(aes(linetype = c, colour = c)) +
  geom_point() +
  geom_hline(yintercept = sum(z$adv) / nrow(z),
             linetype = "dashed") +
  ggtitle("") +
  xlab("Epsilon") +
  ylab("Advantage") +
  scale_fill_discrete(name = "Clip-scale") +
  scale_x_discrete(labels = c("1693543.06",
                              "93048.55",
                              "47.42",
                              "6.71",
                              "0.81", "0.38", "0.18")) +
  annotation_custom(grob = textGrob("Non-dp model",
                                    gp = gpar(fontsize = 10)),
                    xmin=4.7, ymin = 0.025)


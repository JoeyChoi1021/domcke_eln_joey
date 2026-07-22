## ----libs---------------------------------------------------------------------
library(ggplot2)
library(pals)


## ----config-------------------------------------------------------------------
RESULTS_DIR <- path.expand("~/domcke_eln_joey/Project/ATAC-qPCR/20260722_NC_eff_test")
CSV_PATH <- file.path(RESULTS_DIR, "admin_2026-07-22 12-49-45_782BR21735.csv")

pal <- trubetskoy(5)
names(pal) <- NULL
pal <- c(
  "MyoD-prom" = pal[1],
  "MyoD-prom-upstr" = pal[2],
  "RBFOX3-pro" = pal[3],
  "RBFOX3-enhan" = pal[4],
  "Maria_GAPDH" = pal[5]
)

dir.create(RESULTS_DIR, recursive = TRUE, showWarnings = FALSE)


## ----read---------------------------------------------------------------------
dat <- read.csv(CSV_PATH, skip = 19, header = TRUE, stringsAsFactors = FALSE)
dat <- dat[, c("Well", "Target", "Content", "Sample", "Cq", "Melt.Temperature")]

dat$Cq <- as.numeric(dat$Cq)                 # "NaN" strings -> NA
dat$Melt.Temperature <- as.numeric(dat$Melt.Temperature)  # "None" strings -> NA
dat$ng <- as.numeric(sub("ng", "", dat$Sample))
dat$log_ng <- log10(dat$ng)
dat


## ----fit----------------------------------------------------------------------
myod_prom  <- dat[dat$Target == "MyoD-prom", ]
myod_upstr <- dat[dat$Target == "MyoD-prom-upstr", ]
rbfox3_pro <- dat[dat$Target == "RBFOX3-pro", ]
rbfox3_enh <- dat[dat$Target == "RBFOX3-enhan", ]
mgapdh     <- dat[dat$Target == "Maria_GAPDH", ]

fit_myod_prom  <- lm(Cq ~ log_ng, data = myod_prom)
fit_myod_upstr <- lm(Cq ~ log_ng, data = myod_upstr)
fit_rbfox3_pro <- lm(Cq ~ log_ng, data = rbfox3_pro)
fit_rbfox3_enh <- lm(Cq ~ log_ng, data = rbfox3_enh)
fit_mgapdh     <- lm(Cq ~ log_ng, data = mgapdh)

eff_myod_prom  <- (10^(-1 / coef(fit_myod_prom)[2])  - 1) * 100
eff_myod_upstr <- (10^(-1 / coef(fit_myod_upstr)[2]) - 1) * 100
eff_rbfox3_pro <- (10^(-1 / coef(fit_rbfox3_pro)[2]) - 1) * 100
eff_rbfox3_enh <- (10^(-1 / coef(fit_rbfox3_enh)[2]) - 1) * 100
eff_mgapdh     <- (10^(-1 / coef(fit_mgapdh)[2])     - 1) * 100

eff_tbl <- data.frame(
  Target = c("MyoD-prom", "MyoD-prom-upstr", "RBFOX3-pro", "RBFOX3-enhan", "Maria_GAPDH"),
  slope = c(coef(fit_myod_prom)[2], coef(fit_myod_upstr)[2], coef(fit_rbfox3_pro)[2],
            coef(fit_rbfox3_enh)[2], coef(fit_mgapdh)[2]),
  R2 = c(summary(fit_myod_prom)$r.squared, summary(fit_myod_upstr)$r.squared,
         summary(fit_rbfox3_pro)$r.squared, summary(fit_rbfox3_enh)$r.squared,
         summary(fit_mgapdh)$r.squared),
  Efficiency = c(eff_myod_prom, eff_myod_upstr, eff_rbfox3_pro, eff_rbfox3_enh, eff_mgapdh),
  MeltTm = c(mean(myod_prom$Melt.Temperature, na.rm = TRUE),
             mean(myod_upstr$Melt.Temperature, na.rm = TRUE),
             mean(rbfox3_pro$Melt.Temperature, na.rm = TRUE),
             mean(rbfox3_enh$Melt.Temperature, na.rm = TRUE),
             mean(mgapdh$Melt.Temperature, na.rm = TRUE))
)
rownames(eff_tbl) <- NULL
eff_tbl

write.csv(eff_tbl, file.path(RESULTS_DIR, "efficiency_table_20260722.csv"), row.names = FALSE)


## ----plot, fig.cap="Cq vs log10 gDNA input for the four candidate negative-control primers, with Maria_GAPDH as reference."----
plot_df <- dat[!is.na(dat$Cq), ]
plot_df$Target <- factor(plot_df$Target,
  levels = c("MyoD-prom", "MyoD-prom-upstr", "RBFOX3-pro", "RBFOX3-enhan", "Maria_GAPDH"))

p_std <- ggplot(plot_df, aes(x = log_ng, y = Cq, colour = Target)) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 0.6) +
  geom_point(size = 2, alpha = 0.9) +
  scale_colour_manual(values = pal, name = "Primer") +
  labs(x = "log10(gDNA input, ng)", y = "Cq",
       title = "Negative-control primer standard curves (Maria gDNA, PowerUp SYBR)") +
  theme_bw(base_size = 10)
p_std

ggsave(file.path(RESULTS_DIR, "standard_curves_20260722.png"), p_std, width = 7.6, height = 5.4, dpi = 150)
ggsave(file.path(RESULTS_DIR, "standard_curves_20260722.pdf"), p_std, width = 7.6, height = 5.4)

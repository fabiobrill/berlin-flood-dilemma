library(cowplot)
source("figures/fig1.R")
source("figures/fig2.R")
source("figures/fig3.R")

x11()
png("figures/figurev29.png", width=22, height=25, units="cm", res=300, type="cairo", antialias = "subpixel", pointsize = 5)
cowplot::plot_grid(p1, p2, p3, nrow=3, labels=c("A", "B", "C"), label_x=0, label_y=1.02, scale=c(0.97, 0.97, 0.97))
dev.off()

pdf("figures/figure16.pdf", width=9, height=12)
cowplot::plot_grid(p1, p2, p3, nrow=3)
dev.off()

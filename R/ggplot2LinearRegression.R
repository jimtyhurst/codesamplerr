# Displays and prints graphs of system performance of a micro-service
# based on monitoring data gathered from the server.

library(ggplot2)
library(cowplot)

title <- "Microservice Performance\nOct-Dec 2016"
performance <- data.frame(
  "week" =
    c(as.Date('2016-10-02'),
      as.Date('2016-10-09'),
      as.Date('2016-10-16'),
      as.Date('2016-10-23'),
      as.Date('2016-10-30'),
      as.Date('2016-11-06'),
      as.Date('2016-11-13'),
      as.Date('2016-11-20'),
      as.Date('2016-11-27'),
      as.Date('2016-12-04'),
      as.Date('2016-12-11'),
      as.Date('2016-12-18')),
  "requests.thousands" = c(1360,1280,1290,1290,1360,1400,1470,1600,1360,1320,1310,1280),
  "error.rate" = c(0.0008,0.0014,0.0018,0.0016,0.0029,0.0027,0.0033,0.0044,0.0017,0.0021,0.0014,0.002),
  "response.time.ms" = c(1.83,1.65,1.93,1.66,2.35,2.71,3.44,3.62,2.24,2.03,2.23,2.04)
)
performance
plotErrorRate <- ggplot(data = performance) +
  geom_point(mapping = aes(requests.thousands, error.rate),
             colour = "blue",
             stat = "identity"
  ) +
  geom_smooth(mapping = aes(requests.thousands, error.rate),
              method = lm) +
  ggtitle(title) +
  xlab("Requests (1,000s)") +
  ylab("Error Rate")
plotResponseTime <- ggplot(data = performance) +
  geom_point(mapping = aes(requests.thousands, response.time.ms),
             colour = "black",
             stat = "identity"
  ) +
  geom_smooth(mapping = aes(requests.thousands, response.time.ms),
              colour = "black",
              method = lm) +
  ggtitle(title) +
  xlab("Requests (1,000s)") +
  ylab("Response Time (msec)")

cowplot::plot_grid(plotErrorRate, plotResponseTime, align = "h")

cowplot::ggsave2("ggsave-output.pdf", width = 6, height = 6, units = "in")

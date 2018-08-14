library(grid)
library(ggplot2)

# Shows how to plot the "Empirical Cumulative Distribution Function"
# for a sample, using ggplot2's stat_ecdf,
# and compares that to a histogram of the sample.

# Creates data from different distributions.
df_normal <- data.frame(x = rnorm(50, mean = 5, sd = 1))
df_chisq <- data.frame(x = rchisq(50, df = 3, ncp = 5))

# Calculates the bounds for plotting, so that all of the plots
# will have the same domain, which makes them more comparable.
min_x_to_plot <- floor(min(df_normal$x, df_chisq$x))
max_x_to_plot <- ceiling(max(df_normal$x, df_chisq$x))

# Plots each sample on their own separate ECDF plot.
ggplot(df_normal, aes(x)) + stat_ecdf()
ggplot(df_chisq, aes(x)) + stat_ecdf()

# Plots each array in the same layer on one plot.
plot_ecdf <- ggplot(mapping = aes(x)) +
  xlim(min_x_to_plot, max_x_to_plot) +
  stat_ecdf(data = df_normal, color = 'blue') +
  stat_ecdf(data = df_chisq, color = 'red')
plot_ecdf

# Another way to plot both samples on one plot.
# I don't like this style as well, because it handles the two
# data.frames in different ways.
ggplot(df_normal, aes(x)) +
  stat_ecdf(color = 'blue') +
  stat_ecdf(data = df_chisq, color = 'red')

# Plots histograms for comparison:
plot_hist_normal <- ggplot(mapping = aes(x)) +
  xlim(min_x_to_plot, max_x_to_plot) +
  geom_histogram(data = df_normal, color = 'blue')
plot_hist_chisq <- ggplot(mapping = aes(x)) +
  xlim(min_x_to_plot, max_x_to_plot) +
  geom_histogram(data = df_chisq, color = 'red')

# Plots histograms and ECDF side-by-side
pushViewport(viewport(layout = grid.layout(1, 3)))
print(plot_hist_normal, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
print(plot_hist_chisq, vp = viewport(layout.pos.row = 1, layout.pos.col = 2))
print(plot_ecdf, vp = viewport(layout.pos.row = 1, layout.pos.col = 3))
popViewport()

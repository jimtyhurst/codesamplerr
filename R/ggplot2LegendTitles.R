# Experimenting with legend titles in R package 'ggplot2'.
# See:
#   http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/
#   http://docs.ggplot2.org/dev/vignettes/themes.html
library(ggplot2)
sales <-
  data.frame(
    day = c(4, 4, 5, 5, 6, 6),
    sales = c(200, 1500, 300, 1800, 700, 2300),
    order_type = c('a', 'b', 'a', 'b', 'a', 'b')
  )
sales
p <-
  ggplot(sales, aes(
    x = day,
    y = sales,
    group = order_type,
    color = order_type
  )) +
  geom_line() +
  ggtitle("Ticket Sales") +
  xlab("Sale Date") +
  ylab("Qty Sold")
# Expect graph with two lines, one for order_type a, one for order_type b.
# There should be a legend on the right side of the graph.
p
# Sets legend title and legend labels:
p + scale_color_discrete(
  name = "Source Type",
  breaks = c("a", "b"), # a, b are the values in sales$order_type
  labels = c("A Sales", "B Sales")
)
# Other ways to set the legend title, but not the legend labels
# (I gave a different title value on each line to see it change in the plot):
p + labs(color = "Order Type")
p + guides(color = guide_legend(title = "Days"))
p + scale_color_discrete(guide = guide_legend("Sources"))

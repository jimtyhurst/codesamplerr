# T-tests when mean and standard error are known.

#' t-test for means and standard errors, assuming unpooled variance.
#'
#' @param mean.x Mean of sample of random variable X.
#' @param se.x Standard error of sample of random variable X.
#' @param mean.y Mean of sample of random variable Y.
#' @param se.y Standard error of sample of random variable Y.
#' @param alternative a character string specifying the alternative hypothesis,
#' must be one of "two.sided" (default), "greater", or "less".
#'
#' @details Assumptions: The two samples are drawn from normal distributions.
#' The two samples do not need to have the same variance.
#'
#' @return List of the 't' statistic and boolean 'isSignificant',
#' which is calculated at the 95\% confidence level,
#' i.e. within 1.96 standard deviations of the mean.
#'
#' @note Standard error = (standard deviation ^ 2) / N, i.e. the square of
#' the standard deviation divided by the size of the sample.
#' @export
tMeanTest <- function(mean.x,
                       se.x,
                       mean.y,
                       se.y,
                       alternative = "two.sided") {
  t <- (mean.x - mean.y) / sqrt((se.x ^ 2) + (se.y ^ 2))
  cutoff <- 1.96  # 95% confidence level
  isSignificant <- (switch(
    alternative,
    "two.sided" = abs(t) >= cutoff,
    "less" = t <= -cuttoff,
    "greater" = t >= cutoff
  ))
  return (list(t = t, isSignificant = isSignificant))
}

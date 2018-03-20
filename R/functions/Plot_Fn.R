# convenience function for histograms
HistFn <- function(dt, x, nb, title, xlab){
  p <-
    dt %>%
    ggplot() +
    aes_string(x, "..density..") +
    xlab(xlab) +
    ylab("Density") +
    ggtitle(title) +
    geom_histogram(
      bins = nb,
      col = azure,
      fill = azure,
      alpha = .3) +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5))
  return(p)
}

# convenience function for plotting CRSP data availability
CRSPPlot <- function(dt, title) {
  p <-
    dt %>%
    ggplot() +
    aes(caldt, N) +
    ylab("#share classes") +
    ggtitle(title) +
    geom_line(colour = azure) +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5))
  return(p)
}

# convenience function for plotting DiD
DidPlot <- function(dt, y, ylabel, title, theme.type = c("bw", "minimal", "classic"), refline = FALSE) {
  p <-
    dt %>%
    ggplot() +
    aes_string("caldt", y, group = "high.exposure") +
    xlab("Date") +
    ylab(ylabel) +
    ggtitle(title)

    # what kind of theme?
    if (theme.type == "bw") {
      p <- p + theme_bw()
    }
    if (theme.type == "minimal") {
      p <- p + theme_minimal()
    }
    if (theme.type == "classic") {
      p <- p + theme_classic()
    }

    # reference line instead of shaded area?
    if (refline) {
    p <- p +
      geom_vline(xintercept = as.Date(c("2003-08-15", "2004-10-15")),
                 colour = "red", linetype = 3)
    } else {
      p <- p +
        annotate("rect", xmin=as.Date("2003-08-15"), xmax=as.Date("2004-10-15"),
          ymin=-Inf, ymax=Inf, alpha=0.15, fill="red")
    }

    # add time series lines
  p <- p +
    geom_line(aes(linetype = high.exposure, colour = high.exposure)) +
    scale_linetype_manual("", values = c("solid", "longdash")) +
    scale_colour_manual("", values = c(azure, orangebrown)) +
    theme(
      # fix legend
      legend.position = "bottom",
      # center title
      plot.title = element_text(hjust = 0.5),
      # show only major grid
      panel.grid.minor = element_blank())

  # output plot
  return(p)
}


# convenience function for plotting DiD
DidBarPlot <- function(dt, y, ylabel, title, theme.type = c("bw", "minimal", "classic"), refline = FALSE) {
  p <-
    dt %>%
    ggplot() +
    aes_string("caldt", y) +
    xlab("Date") +
    ylab(ylabel) +
    ggtitle(title)

    # reference line instead of shaded area?
    if (refline) {
      p <- p +
        geom_vline(xintercept = as.Date(c("2003-08-15", "2004-10-15")),
                   colour = "red", linetype = 3)
    } else {
      p <- p +
        annotate("rect", xmin = as.Date("2003-08-15"), xmax=as.Date("2004-10-15"),
                 ymin=-Inf, ymax=Inf, alpha=0.15, fill="red")
    }

    # what kind of theme?
    if (theme.type == "bw") {
      p <- p + theme_bw()
    }
    if (theme.type == "minimal") {
      p <- p + theme_minimal()
    }
    if (theme.type == "classic") {
      p <- p + theme_classic()
    }

    # add bars for data
  p <- p +
    geom_col(col = azure, fill = azure, alpha = .3) +
    scale_linetype_manual("", values = c("solid", "longdash")) +
    scale_colour_manual("", values = c(azure, orangebrown)) +
    theme(
      # fix legend
      legend.position = "bottom",
      # center title
      plot.title = element_text(hjust = 0.5),
      # show only major grid
      panel.grid.minor = element_blank())

  # output plot
  return(p)
}

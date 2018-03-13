# What it Eats:
#   (i)  a string of felm regression specification
#   (ii) a string specifying the data to use in the estimation
#
# What it Does:
#   runs a fixed effects regression according to (i) using data (ii)
#
# What it Gives:
#   an list containing the output from felm
FeedFERegData <- function(reg.txt, dt.txt) {
  # clean regression text input
  reg.txt <- as.formula(gsub("\\s+", "", reg.txt))
  # estimate regression
  reg.res <- felm(reg.txt, eval(parse(text = dt.txt)))
  # output regression
  return(reg.res)
}

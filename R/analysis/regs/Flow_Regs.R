# Flows ------------------------------------------------------------------------

flow.models <- c(
  "flow ~ postXscan | wficn + date | 0 | wficn + date.port.grp",
  "flow ~ postXscan | wficn + benchmark.X.date | 0 | wficn + benchmark.X.date",
  "flow ~ scandal.outflow | wficn + date | 0 | wficn + date.port.grp",
  "flow ~ scandal.outflow | wficn + benchmark.X.date | 0 | wficn + benchmark.X.date"

)




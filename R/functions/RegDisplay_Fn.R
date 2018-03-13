# P-Values to Stars ------------------------------------------------------------
#
# Assign significance stars to p-values.
# One to three possible symbols.
# User can assign the symbols to be used.
# Order of provided symbols must go from most to least significant.
# Breakpoints can be provided by the user (in any order)

PvalToStar <- function(p.val,
                       sig.levels = c(0.01, 0.05, 0.1),
                       sig.symbols = c("***", "**", "*")) {
  # make sure breakpoints are in ascending order
  sig.levels <- sort(sig.levels)
  # placeholder for significance
  star.out <- rep("", length(p.val))
  star.out[p.val < sig.levels[3]] <- sig.symbols[3]
  star.out[p.val < sig.levels[2]] <- sig.symbols[2]
  star.out[p.val < sig.levels[1]] <- sig.symbols[1]
  return(star.out)
}


# RegToDT -------------------------------------------------------
#
# Converts standard regression output into a data.table of relevant outputs.
RegToDT <- function(reg.model,
                    digits = 3,
                    print.tstat = FALSE,
                    sig.levels = c(0.01, 0.05, 0.1),
                    sig.symbols = c("***", "**", "*")) {

    # reg summary
    reg.model.sum <- summary(reg.model)
    reg.model.vars <- rownames(reg.model.sum$coefficients)
    if (any(grepl("^_SE_", reg.model.vars))) {
      stop("Please do not start variable names with _SE_")
    }
    reg.model.coef <- reg.model.sum$coefficients[, 1]
    reg.model.se   <- reg.model.sum$coefficients[, 2]
    reg.model.t    <- reg.model.sum$coefficients[, 3]
    reg.model.p    <- reg.model.sum$coefficients[, 4]

    # number of obs
    out.N <- NA
    try(
      out.N <- format(reg.model$N, big.mark = ","), silent = TRUE
      )
    try(
      out.N <- format(nobs(reg.model), big.mark = ","), silent = TRUE
      )

    # R-squared
    out.r2 <- formatC(
      round(reg.model.sum$r.squared, digits), digits, format = "f")

    # R-squared of projected model, if available
    if (!is.null(reg.model.sum$P.r.squared)) {
      out.r2.proj <- formatC(
        round(reg.model.sum$P.r.squared, digits), digits, format = "f")
    }

    # first stage F-stat, if available
    if (!is.null(reg.model.sum$E.fstat)) {
      out.Fstat <- formatC(
        round(reg.model.sum$E.fstat[["F"]], 1), 1, format = "f")
    }

    # coefficients, with significance stars
    out.coef <- paste0(formatC(
      round(reg.model.coef, digits), digits, format = "f"),
      PvalToStar(reg.model.p, sig.levels, sig.symbols))

    if (!print.tstat) {
      # standard errors, with parentheses
      out.se <- paste0("(", formatC(
        round(reg.model.se, digits), digits, format = "f"), ")")
    } else {
      # t-stats, with parentheses
      out.se <- paste0("(", formatC(
        round(reg.model.t, 2), 2, format = "f"), ")")
    }

    # add a space after each variable label
    out.vars <- c(rbind(reg.model.vars, paste0("_SE_", reg.model.vars)))

    # put together the table
    out.body <- c(rbind(out.coef, out.se), out.N)
    out.lab  <- c(out.vars, "Observations")

    # if first stage F-stat is available, report it instead of R^2
    if (!is.null(reg.model.sum$E.fstat)) {
      out.body <- c(out.body, out.Fstat)
      out.lab  <- c(out.lab, "F (first stage)")
    # if no first stage F-stat, report R^2
    } else {
      out.body <- c(out.body, out.r2)
      out.lab  <- c(out.lab, "$R^2$")
      # add R^2 of projected model if available
      if (!is.null(reg.model.sum$P.r.squared)) {
        out.body <- c(out.body, out.r2.proj)
        out.lab  <- c(out.lab, "$R^2$ (proj. model)")
      }
    }

    # output
    out <- data.table(Variable = out.lab, Estimate = out.body)
    return(out)
  }


# RegTable ---------------------------------------------------------------------
#
# Eats a list of reg outputs, and spits out a formatted regression table.
# Output is a matrix of RHS variable names (as rownames), NObs, R2.
# Allows the user to set
#   - digits: Number of digits displayed
#   - single.reg: is the input a single regression (as opposed to a list of several)
#   - fe.list: Label fixed effects
#              (needs to be a vector or matrix of appropriate dim)
#   - coef.lab.dt: data.table dictionary for relabeling. Must consist of:
#     ... "old.name": variable name in dataset
#     ... "new.name": variable name to display in reg table
#
#   - print.tstat: Print t-stats instead of se (not yet implemented)
#   - sig.levels: Thresholds for significance stars, if any
#   - sig.symbols: Significance stars, from most to least significant, if any
#
RegTable <- function(reg.list,
                     digits = 3,
                     fe.list = NULL,
                     coef.lab.dt = NULL,
                     col.names = NULL,
                     print.tstat = FALSE,
                     sig.levels = c(0.01, 0.05, 0.1),
                     sig.symbols = c("***", "**", "*")) {

  # format each individual regression as a data.table of coefs
  reg.dt.list <- lapply(reg.list, RegToDT,
                        digits = digits,
                        print.tstat = print.tstat,
                        sig.levels = sig.levels,
                        sig.symbols = sig.symbols)

  # construct the reg table
  reg.num <- 1
  reg.table <- reg.dt.list[[1]]
  reg.dt.list[[1]] <- NULL

  setnames(reg.table, "Estimate", paste0("(", reg.num,")"))
  # loop through reg outputs, merging them into the table
  while (length(reg.dt.list) > 0) {
    reg.table <- merge(
      reg.table, reg.dt.list[[1]], on = "Variable", all = TRUE, sort = FALSE)
    reg.num <- reg.num + 1
    setnames(reg.table, "Estimate", paste0("(", reg.num,")"))
    reg.dt.list[[1]] <- NULL
  }

  # coefficients and sd
  coef.sd <- reg.table[!Variable %in%
    c("Observations", "$R^2$", "$R^2$ (proj. model)", "F (first stage)")]
  coef.sd[
    # group by variable
    , coef.grp := gsub("^_SE_", "", Variable)][
    # identify if row is a standard deviation (or tstat)
    , is.SE := grepl("^_SE", Variable)]

  # observations, R2
  obs.r2 <- reg.table[Variable %in%
    c("Observations", "$R^2$", "$R^2$ (proj. model)", "F (first stage)")]

  # custom coefficient labels and ordering
  if (!is.null(coef.lab.dt)) {
    coef.lab.dt[, position := .I]
    coef.sd <- coef.sd[
      # add in custom labels
      coef.lab.dt, on = c(coef.grp = "old.name"), nomatch = 0][
      # update labels
      , Variable := new.name]
    # custom sort
    setkey(coef.sd, position, is.SE)
  }
  # format variable labels
  coef.sd[is.SE == TRUE, Variable := ""]
  coef.sd <- coef.sd[, 1:(ncol(obs.r2))]

  # add fixed effect labels
  if (!is.null(fe.list)) {
    colnames(fe.list) <- names(obs.r2)
    obs.r2 <- rbind(fe.list, obs.r2)
  }

  # paste together output
  out.dt <- rbind(coef.sd, obs.r2)
  # replace NAs with blank
  out.dt[is.na(out.dt)] <- ""

  # remove unnecessary label
  setnames(out.dt, "Variable", "")
  # name columns if supplied
  if (!is.null(col.names)) {
    setnames(out.dt, c("", col.names))
  }

  # output table
  return(out.dt)
}


# ------------------------------------------------------------------------------
# same as above, but designed to handle a single regression instead of a list
OneRegTable <- function(reg.list,
                        digits = 3,
                        fe.list = NULL,
                        coef.lab.dt = NULL,
                        print.tstat = FALSE,
                        sig.levels = c(0.01, 0.05, 0.1),
                        sig.symbols = c("***", "**", "*")) {

  # format each individual regression as a data.table of coefs
  reg.dt.list <- RegToDT(reg.list,
                         digits = digits,
                         print.tstat = print.tstat,
                         sig.levels = sig.levels,
                         sig.symbols = sig.symbols)

  # construct the reg table
  reg.table <- reg.dt.list
  setnames(reg.table, "Estimate", paste0("(", reg.num,")"))

  # format output
  # observations, R2
  obs.r2 <- reg.table[Variable %in% c("Observations", "$R^2$")]
  # coefficients and sd
  coef.sd <- reg.table[!Variable %in% c("Observations", "$R^2$")]
  coef.sd[
    # group by variable
    , coef.grp := gsub("^_SE_", "", Variable)][
      # identify if row is a standard deviation (or tstat)
      , is.SE := grepl("^_SE", Variable)]

  # custom coefficient labels and ordering
  if (!is.null(coef.lab.dt)) {
    coef.sd <- coef.sd[
      # add in custom labels
      coef.lab.dt, on = c(coef.grp = "old.name"), nomatch = 0][
        # update labels
        , Variable := new.name]
    # custom sort
    setkey(coef.sd, position, is.SE)
  }
  # format variable labels
  coef.sd[is.SE == TRUE, Variable := ""]
  coef.sd <- coef.sd[, 1:(ncol(obs.r2))]

  # add fixed effect labels
  if (!is.null(fe.list)) {
    colnames(fe.list) <- names(obs.r2)
    obs.r2 <- rbind(fe.list, obs.r2)
  }

  # paste together output and convert to matrix
  out.dt <- rbind(coef.sd, obs.r2)
  out.mat <- as.matrix(out.dt[, 2:ncol(out.dt)])
  rownames(out.mat) <- out.dt$Variable
  colnames(out.mat) <- "(1)"
  # replace NAs with blank
  out.mat[is.na(out.mat)] <- ""

  # output table
  return(out.mat)
}

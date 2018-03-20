# Competition and Capital Allocation {#sec:portfolio}



## Decreasing Returns to Competitor Scale

I develop empirical tests of hypotheses 1 and 2, using competitor scale as the external constraint on the profitability of investment opportunities. This choice is motivated by both the extant literature and novel evidence from my sample. @pst15 give time series evidence that funds suffer from decreasing returns to aggregate industry scale. In recent work, @hkp17 provide cross-sectional evidence of decreasing profitability due to inter-fund competition. I explore a cross between the two approaches, by running within-fund tests of decreasing returns to competitor scale. Appendix \@ref(sec:CSandPerformance) provides the details of my investigation. The following is a brief summary of the results.

- A one standard deviation increase in competitor size is associated with a 76bp decrease in annual Fama-French three factor adjusted returns.
- Competitor size subsumes the negative effect of aggregate industry size in a head to head horse race.
- The negative impact of competitor size is smaller for funds which on average hold more liquid portfolios. This is consistent with liquidity constraints as the channel for decreasing returns to competitor scale. 
- The negative impact of competitor size is smaller when funds tilt toward more liquid portfolios. These results suggest that increased portfolio liquidity shelters funds from the pernicious effects of decreasing returns to scale.
- Holding skill fixed, funds make more when they hold less liquid portfolios. One interpretation is that funds increase portfolio concentration when they perceive favorable investment opportunities in their core competence.


## Empirical Strategy

 
Motivated by decreasing returns to competitor scale, I parametrize the profitability of the fund's time $t$ investment opportunities as 
\begin{equation}
g(x_{i,t})=CompetitorSize_{i,t}^{-\gamma}. 
(\#eq:muParam)
\end{equation}
This is a sensible choice in that the fund's alpha before transaction costs is a decreasing function of competitor scale, asymptoting to zero as the market approaches perfect competition.

The fraction of assets under active management in @bg04 is similar in spirit to active share (denoted $AS$) from @cp09, @petajisto13.^[@cremers17 shows that for funds that do not short or use leverage, active share is equal to one minus the sum of holdings that overlap with the benchmark. Letting $J$ be the set of stocks held by the fund and $B$ the set of stocks in the benchmark $b$, we have $$ ActiveShare=1-\sum_{j\in J\cap B} \min\{ w_{i,j},w_{b,j} \}.$$] The @pst17L portfolio choice maps directly into data on turnover and fund holdings. Therefore, letting $y_{i,t}\in\{AS_{i,t},\left(TL^{-1/2}\right)_{i,t}\}$, the equilibrium relation (with potential information asymmetry) in equation \@ref(eq:csEQa) implies the regression model
\begin{equation}
\ln(y_{i,t})=\alpha_t + \eta_1 \ln(FundSize_{i,t}) +\eta_2 \ln(f_{i,t}) + \gamma\ln(CompetitorSize_{i,t}) + \varepsilon_{i,t}.
(\#eq:regCS)
\end{equation}
$y$ and $CompetitorSize$ are both calculated based on the same portfolio weights. To ensure that my findings are not an artifact of measurement, I consider quarter end holding reports only, and calculate the log change in $CompetitorSize$, holding constant previous quarter-end similarity weights. That is, let $t$ be quarter end dates, and define
\begin{equation}
\Delta CS_{i,t}=\ln \left(\sum_{j\neq i} \psi_{i,j,t-1} FundSize_{j,t}\right) - \ln \left(\sum_{j\neq i} \psi_{i,j,t-1} FundSize_{j,t-1}\right).
\end{equation}
Note that the fund's change in capital allocation from $t-1$ to $t$ has no mechanical effect on $\Delta CS$, as it is determined only by changes in other fund size, holding similarity fixed.

I then estimate equation \@ref(eq:regCS) in quarterly first differences as
\begin{equation}
\Delta\ln(y_{i,t})=\alpha_t + \eta_1 \Delta\ln(FundSize_{i,t}) +\eta_2 \Delta\ln(f_{i,t}) + \gamma\Delta CS_{i,t} + \Delta\varepsilon_{i,t}.
(\#eq:fdReg)
\end{equation}
I double cluster standard errors by fund and date $\times$ portfolio group.\footnote{
Fund portfolios are grouped using k-means cluster analysis of raw portfolio weights. Each month, this process constructs $k=10$ archetypal portfolios (serving as cluster centers). These model portfolios are constructed and then funds are assigned to them such that the sum of squared differences between the weights of fund portfolios and their assigned model portfolio is minimized.
} 
Under the hypothesis of symmetrically informed outside investors, $\gamma=0$. Under the joint hypothesis of decreasing returns to competitor scale and asymmetric information, $\gamma<0$. I also perform the analysis separating out portfolio liquidity and its components. In these regressions, the joint hypothesis of decreasing returns to competitor scale and asymmetric information implies $\gamma>0$.


## Results

Table \@ref(tab:fundResponse) presents results from empirical tests evaluating hypothesis 1 against hypothesis 2. The statistically significant coefficients on $\Delta CS$ provide a rejection of the hypothesis that managers and outside investors are symmetrically informed of investment opportunities captured by changes in the scale of competing funds.

The results are consistent with managers reacting optimally to decreasing returns to own and competitor scale by scaling back active management. A one percent increase in competitor size is associated with a -0.04bp change in active share, and a -0.52bp change in the turnover to portfolio liquidity ratio. Increases in competitor scale are associated with statistically significant increases in each component of portfolio liquidity. A one percent increase in own size is associated with a -0.02bp change in active share, and a -0.11bp change in turnover to portfolio liquidity. 


\begin{table}[ht]
\centering
\caption{Capital Allocation and Competitor Size} 
\label{tab:fundResponse}
\begingroup\scriptsize
\begin{tabularx}{0.975\textwidth}{lYYYYYYY}
  \multicolumn{8}{p{.975\textwidth}}{\scriptsize Observations are first differences at the fund $\times$ quarter level, from 1980-2016. Dependent variables are noted in the column headers. $AS$ is active share relative to self-declared benchmarks \citep{cp09, petajisto13}, covering years 1980-2009. $TL^{-1/2}$ is the turnover to portfolio liquidity ratio, as in \citet{pst17L}. $S$, $D$, $C$, and $B$ are the components of portfolio liquidity, namely stock liquidity, diversification, coverage, and balance (each calculated with respect to all U.S. equity). $\Delta CS_{i,t}=\ln\left(\sum_{j\neq i} \psi_{i,j,t-1} FundSize_{j,t} \right) - \ln\left(\sum_{j\neq i} \psi_{i,j,t-1} FundSize_{j,t-1}\right)$ is the change in log competitor size, holding previous quarter end similarity weights fixed. Standard errors are double clustered by fund and portfolio group $\times$ quarter, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.} \\ \addlinespace \toprule
Dep. Var.: & $\Delta\ln(AS)$ & $\Delta\ln(TL^{-1/2})$ & $\Delta\ln(L)$ & $\Delta\ln(S)$ & $\Delta\ln(D)$ & $\Delta\ln(C)$ & $\Delta\ln(B)$ \\ 
  \midrule
$\Delta CS$ & -0.045** & -0.521*** & 0.797*** & 0.627*** & 0.601*** & 0.181*** & 0.516*** \\ 
   & (0.018) & (0.058) & (0.076) & (0.072) & (0.065) & (0.028) & (0.061) \\ 
  $\Delta\ln(FundSize)$ & -0.016*** & -0.109*** & 0.183*** & 0.101*** & 0.163*** & 0.098*** & 0.100*** \\ 
   & (0.002) & (0.012) & (0.012) & (0.010) & (0.011) & (0.007) & (0.009) \\ 
  $\Delta\ln(f)$ & -0.021 & 0.038 & 0.038* & -0.011 & 0.052** & 0.029** & 0.034* \\ 
   & (0.017) & (0.027) & (0.021) & (0.019) & (0.022) & (0.012) & (0.019) \\ 
  $\Delta \ln(T)$ &  &  & -0.005 & -0.004 & -0.003 & 0.002 & -0.006* \\ 
   &  &  & (0.004) & (0.003) & (0.004) & (0.003) & (0.003) \\ 
  $\Delta\ln(D)$ &  &  &  & -0.355*** &  &  &  \\ 
   &  &  &  & (0.020) &  &  &  \\ 
  $\Delta\ln(S)$ &  &  &  &  & -0.632*** & -0.194*** & -0.539*** \\ 
   &  &  &  &  & (0.017) & (0.014) & (0.023) \\ 
  $\Delta\ln(B)$ &  &  &  &  &  & -0.126*** &  \\ 
   &  &  &  &  &  & (0.011) &  \\ 
  $\Delta\ln(C)$ &  &  &  &  &  &  & -0.292*** \\ 
   &  &  &  &  &  &  & (0.023) \\ 
  Fixed Effects &  &  &  &  &  &  &  \\ 
  $\bullet$ Quarter & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  Observations & 35,311 & 57,284 & 57,284 & 57,284 & 57,284 & 57,284 & 57,284 \\ 
  $R^2$ & 0.025 & 0.020 & 0.047 & 0.252 & 0.245 & 0.098 & 0.218 \\ 
  $R^2$ (proj. model) & 0.004 & 0.007 & 0.031 & 0.233 & 0.231 & 0.077 & 0.209 \\ 
   \bottomrule
\end{tabularx}
\endgroup
\end{table}

@pst17L argue that unit trading costs might vary by fund segment, implying a model with segment $\times$ time fixed effects. To accommodate segment level variation in trading costs, I redo the analysis with benchmark $\times$ quarter fixed effects in Table \@(tab:fundResponseMXBim). The results remain similar. 

Overall, my findings are consistent with fund managers reacting optimally to short-term changes in investment opportunities that are not immediately apparent to outside investors. This interpretation fits in with a growing literature on the adjustments managers make in response to time variations in the investment opportunity set. @knv16 show that managers are better at timing factors during recessions when the covariance between asset returns is high. @pst17 provide evidence that funds increase trading when faced with more favorable opportunities.

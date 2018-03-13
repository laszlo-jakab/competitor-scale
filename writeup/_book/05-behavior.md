# Competition and Capital Allocation {#sec:portfolio}



## Decreasing Returns to Competitor Scale

I develop empirical tests of hypotheses 1 and 2, using competitor scale as the external constraint on the profitability of investment opportunities. This choice is motivated by both the extant literature and novel evidence from my sample. @pst15 give time series evidence that funds suffer from decreasing returns to aggregate industry scale. In recent work, @hkp17 provide cross-sectional evidence of decreasing profitability due to inter-fund competition. I explore a cross between the two approaches, by running within-fund tests of decreasing returns to competitor scale. Appendix \@ref(sec:CSandPerformance) provides the details of my investigation. The following is a brief summary of the results.

- A one standard deviation increase in competitor size is associated with a 78bp decrease in annual Fama-French three factor adjusted returns.
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

The results are consistent with managers reacting optimally to decreasing returns to own and competitor scale by scaling back active management. A one percent increase in competitor size is associated with a -0.05bp change in active share, and a -0.47bp change in the turnover to portfolio liquidity ratio. Increases in competitor scale are associated with statistically significant increases in each component of portfolio liquidity. A one percent increase in own size is associated with a -0.02bp change in active share, and a -0.18bp change in turnover to portfolio liquidity. 


<table class="table table-striped table-hover" style="font-size: 11px; margin-left: auto; margin-right: auto;">
<caption style="font-size: initial !important;">(\#tab:fundResponse)Capital Allocation and Competitor Size</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Dep. Var.: </th>
   <th style="text-align:center;"> $\Delta\ln(AS)$ </th>
   <th style="text-align:center;"> $\Delta\ln(TL^{-1/2})$ </th>
   <th style="text-align:center;"> $\Delta\ln(L)$ </th>
   <th style="text-align:center;"> $\Delta\ln(S)$ </th>
   <th style="text-align:center;"> $\Delta\ln(D)$ </th>
   <th style="text-align:center;"> $\Delta\ln(C)$ </th>
   <th style="text-align:center;"> $\Delta\ln(B)$ </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> $\Delta CS$ </td>
   <td style="text-align:center;"> -0.051*** </td>
   <td style="text-align:center;"> -0.472*** </td>
   <td style="text-align:center;"> 0.788*** </td>
   <td style="text-align:center;"> 0.659*** </td>
   <td style="text-align:center;"> 0.533*** </td>
   <td style="text-align:center;"> 0.173*** </td>
   <td style="text-align:center;"> 0.435*** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.020) </td>
   <td style="text-align:center;"> (0.064) </td>
   <td style="text-align:center;"> (0.083) </td>
   <td style="text-align:center;"> (0.088) </td>
   <td style="text-align:center;"> (0.061) </td>
   <td style="text-align:center;"> (0.035) </td>
   <td style="text-align:center;"> (0.052) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> $\Delta\ln(FundSize)$ </td>
   <td style="text-align:center;"> -0.016*** </td>
   <td style="text-align:center;"> -0.184*** </td>
   <td style="text-align:center;"> 0.218*** </td>
   <td style="text-align:center;"> 0.108*** </td>
   <td style="text-align:center;"> 0.196*** </td>
   <td style="text-align:center;"> 0.115*** </td>
   <td style="text-align:center;"> 0.115*** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.003) </td>
   <td style="text-align:center;"> (0.016) </td>
   <td style="text-align:center;"> (0.018) </td>
   <td style="text-align:center;"> (0.013) </td>
   <td style="text-align:center;"> (0.016) </td>
   <td style="text-align:center;"> (0.012) </td>
   <td style="text-align:center;"> (0.011) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> $\Delta\ln(f)$ </td>
   <td style="text-align:center;"> -0.018 </td>
   <td style="text-align:center;"> 0.063 </td>
   <td style="text-align:center;"> -0.009 </td>
   <td style="text-align:center;"> -0.025 </td>
   <td style="text-align:center;"> 0.005 </td>
   <td style="text-align:center;"> 0.023 </td>
   <td style="text-align:center;"> -0.015 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.014) </td>
   <td style="text-align:center;"> (0.041) </td>
   <td style="text-align:center;"> (0.032) </td>
   <td style="text-align:center;"> (0.026) </td>
   <td style="text-align:center;"> (0.031) </td>
   <td style="text-align:center;"> (0.024) </td>
   <td style="text-align:center;"> (0.026) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> $\Delta \ln(T)$ </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> -0.013* </td>
   <td style="text-align:center;"> -0.006 </td>
   <td style="text-align:center;"> -0.011* </td>
   <td style="text-align:center;"> 0.001 </td>
   <td style="text-align:center;"> -0.014*** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> (0.007) </td>
   <td style="text-align:center;"> (0.005) </td>
   <td style="text-align:center;"> (0.006) </td>
   <td style="text-align:center;"> (0.004) </td>
   <td style="text-align:center;"> (0.005) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> $\Delta\ln(D)$ </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> -0.340*** </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> (0.018) </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> $\Delta\ln(S)$ </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> -0.570*** </td>
   <td style="text-align:center;"> -0.194*** </td>
   <td style="text-align:center;"> -0.458*** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> (0.017) </td>
   <td style="text-align:center;"> (0.013) </td>
   <td style="text-align:center;"> (0.021) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> $\Delta\ln(B)$ </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> -0.114*** </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> (0.011) </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> $\Delta\ln(C)$ </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> -0.229*** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> (0.021) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fixed Effects </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> $\bullet$ Quarter </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Observations </td>
   <td style="text-align:center;"> 34,984 </td>
   <td style="text-align:center;"> 57,146 </td>
   <td style="text-align:center;"> 57,146 </td>
   <td style="text-align:center;"> 57,146 </td>
   <td style="text-align:center;"> 57,146 </td>
   <td style="text-align:center;"> 57,146 </td>
   <td style="text-align:center;"> 57,146 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> $R^2$ </td>
   <td style="text-align:center;"> 0.025 </td>
   <td style="text-align:center;"> 0.028 </td>
   <td style="text-align:center;"> 0.059 </td>
   <td style="text-align:center;"> 0.218 </td>
   <td style="text-align:center;"> 0.224 </td>
   <td style="text-align:center;"> 0.101 </td>
   <td style="text-align:center;"> 0.180 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> $R^2$ (proj. model) </td>
   <td style="text-align:center;"> 0.005 </td>
   <td style="text-align:center;"> 0.018 </td>
   <td style="text-align:center;"> 0.045 </td>
   <td style="text-align:center;"> 0.202 </td>
   <td style="text-align:center;"> 0.209 </td>
   <td style="text-align:center;"> 0.081 </td>
   <td style="text-align:center;"> 0.171 </td>
  </tr>
</tbody>
<tfoot>
<tr><td style="padding: 0; border: 0;" colspan="100%"><strong>Note: </strong></td></tr>
<tr><td style="padding: 0; border: 0;" colspan="100%">
<sup></sup> Observations are first differences at the fund $\times$ quarter level, from 1980-2016. Dependent variables are noted in the column headers. $AS$ is active share relative to self-declared benchmarks [@cp09; petajisto13], covering years 1980-2009. $TL^{-1/2}$ is the turnover to portfolio liquidity ratio, as in @pst17L. $S$, $D$, $C$, and $B$ are the components of portfolio liquidity, namely stock liquidity, diversification, coverage, and balance (each calculated with respect to all U.S. equity). $\Delta CS_{i,t}=\ln\left(\sum_{j\neq i} \psi_{i,j,t-1} FundSize_{j,t} \right) - \ln\left(\sum_{j\neq i} \psi_{i,j,t-1} FundSize_{j,t-1}\right)$ is the change in log competitor size, holding previous quarter end similarity weights fixed. Standard errors are double clustered by fund and portfolio group $\times$ quarter, and reported in parentheses. Asterisks denote statistical significance: $\ast\ast\ast$ p$&lt;$0.01, $\ast\ast$ p$&lt;$0.05, $\ast$ p$&lt;$0.1.</td></tr>
</tfoot>
</table>

@pst17L argue that unit trading costs might vary by fund segment, implying a model with segment $\times$ time fixed effects. To accommodate segment level variation in trading costs, I redo the analysis with benchmark $\times$ quarter fixed effects in Table \@(tab:fundResponseMXBim). The results remain similar. 

Overall, my findings are consistent with fund managers reacting optimally to short-term changes in investment opportunities that are not immediately apparent to outside investors. This interpretation fits in with a growing literature on the adjustments managers make in response to time variations in the investment opportunity set. @knv16 show that managers are better at timing factors during recessions when the covariance between asset returns is high. @pst17 provide evidence that funds increase trading when faced with more favorable opportunities.

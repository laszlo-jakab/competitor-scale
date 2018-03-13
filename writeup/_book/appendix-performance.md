# Competitor Size and Fund Performance {#sec:CSandPerformance}





## Benchmarking Returns {#sec:benchmark}

Ideally, I would like to benchmark mutual fund returns by factors that are both near costlessly tradeable for funds, and span dimensions of risk that are of concern to investors. In the absence of such an ideal benchmark, I employ the conventional option of benchmarking returns with Fama-French factors. Define three factor benchmark adjusted gross returns as 
\begin{equation}
R^{FF3}_{i,t} = R_{i,t} - \left[ \hat{\beta}^{RMRF}_i RMRF_t + \hat{\beta}^{SMB}_i SMB_t + \hat{\beta}^{HML}_i HML_t \right],
\end{equation}
where $R_{i,t}$ is the gross return of fund $i$ at month $t$ in excess of the risk free rate, expressed in percentages. $RMRF$, $SMB$, and $HML$ are the usual market, size, and value factors. The beta hats are the sample estimates of each fund's exposure to the respective factors, estimated by fund level regressions of the form
\begin{equation}
R_{i,t} = \alpha_i + \beta^{RMRF}_i RMRF_t + \beta^{SMB}_i SMB_t + \beta^{HML}_i HML_t + \varepsilon_{i,t}.
\end{equation}
Therefore, $R^{FF3}_{i,t} = \hat{\alpha}_i + \hat{\varepsilon}_{i,t}$, i.e. each period's benchmark adjusted returns are equal to the sum of the fund's estimated gross alpha and the given month's residual from the Fama-French time series regressions.

Benchmarking with a factor model has some shortcomings and advantages. 
The long-short SMB and HML portfolios are not tradeable for mutual funds. @bvb15 argue that at each point in time the performance of active funds ought to be measured against the returns of the lowest cost passive funds readily available to retail investors. This is an eminently sensible suggestion for studying funds' value added for retail investors, but not an obviously superior method for testing whether fund alpha is decreasing in competitor scale. @cpz12 note that Fama-French benchmarks imply nonzero alphas for a number of mainstream passive benchmarks. My results are robust to following their suggestion of benchmarking with index-based factors. Unlike self-designated benchmarks, Fama-French factors are not gameable by funds. They are also widely available.^[As argued by @pst15, Morningstar benchmarks share the feature of non-gameability, but are proprietary.] Unlike characteristic based benchmarks, factor based benchmarks are not subject to errors in holdings  data, are available monthly, and account for the unobserved actions of funds. Lastly, regardless of whether size and value correspond to risk, Fama-French factors capture a large fraction of variance in cross-sectional returns. 


## Regression Setup

I implement within-fund regression specifications of the following form to test for decreasing returns to competitor scale:
\begin{equation}
R^{FF3}_{i,t+1} = \alpha_i + \gamma CompetitorSize_{i,t} + \mathbf{X}_{i,t}\Gamma + \varepsilon_{i,t+1},
(\#eq:regSpec)
\end{equation}
where $\alpha_i$ are firm fixed effects, and $\mathbf{X}_{i,t}$ is a vector of controls including $IndustrySize$ and year-month fixed effects.^[Since $IndustrySize$ only varies in the time series, it is omitted in regressions featuring year-month fixed effects. Similarly, $FundAge$ is fully absorbed by the combination of fund and year-month fixed effects.] The coefficient of interest is $\gamma$. To make the economic magnitude of the coefficient easier to interpret, I annualize returns and divide $CompetitorSize$ and $IndustrySize$ by their respective standard deviations before performing the regressions. I re-scale $FundSize$ by the difference between the 50$^\text{th}$ and 10$^\text{th}$ percentiles of its distribution.

I include fund fixed effects throughout to take into account the possibility that baseline fund skill and average competitor size are related in the cross-section, i.e. $\text{Cov}(\alpha_i, \overline{CompetitorSize}_i)\neq 0$. We would expect talented managers to be endogenously allocated where they are most capable of taking advantage of investment opportunities. Bolstering this view, @bbl17 show that fund families funnel capital toward skilled managers. A mechanical concern is that in the cross-section $CompetitorSize$ tends to be higher for funds in large cap sectors. Since more liquid market segments can absorb a larger amount of active investment, not all cross-sectional variation of $CompetitorSize$ reflects variation in the effective inter-fund competition for investment opportunities. Controlling for fund fixed effects is a parsimonious way of controlling for such fixed differences in funds' operating environment.

For the specifications including fund fixed effects only, deviations of $CompetitorSize$ from its within-fund mean provide the variation identifying the coefficient of interest. For regressions including both fund and year-month fixed effects, the coefficient of interest is identified based on deviations of $CompetitorSize$ from its within-fund mean, relative to the average within-fund deviation at each date. Year-month fixed effects control nonparametrically for common time series variation in returns and industry competition, ruling out the possibility that the identified effect of competitor size is an artifact of other aggregate developments, such as shared time-varying exposure to competition from hedge funds. However, including overly fine cross-sectional dummy variables would risk soaking up the variation of interest.

I include $IndustrySize$ to demonstrate that $CompetitorSize$ captures distinct variation in decreasing returns faced by funds. Controlling for $FundSize$ is relevant for separating industry-level decreasing returns to scale from fund-level decreasing returns to scale.^[Interpreting the coefficient on $FundSize$ is problematic in within-fund regressions of returns. To be unbiased, within-fund regressions require strict exogeneity of the regressors [@chamberlain82; stambaugh99], meaning $\text{Cov}(x_{i,t},\varepsilon_{i,s})=0 \ \forall s\in\{1,2,\ldots,T_i\}$. Since past idiosyncratic high (low) returns mechanically increase (decrease) total net assets, we will typically have $\text{Cov}(FundSize_{i,t},\varepsilon_{i,s})>0$ for $s<t$, and a downward bias in the estimated coefficient. In simulations, @hl17 estimate the bias around 14\%. @pst15 propose a recursive demeaning (RD) procedure for eliminating this bias. The point estimates they report with the RD procedure are similar to those from the fixed effects OLS regressions, but the standard errors increase almost twenty-fold. Given that estimating the magnitude of decreasing returns to own size is not the focus of this study and the unfavorable tradeoff between bias and variance, I choose to not implement the RD procedure.]

For constructing standard errors, each month I sort funds into ten mutually exclusive (but not necessarily equal sized) portfolio groups based on their most recently reported holdings.^[Funds are grouped using k-means cluster analysis of raw portfolio weights. Each month, this process constructs $k=10$ archetypal portfolios (serving as cluster centers). These model portfolios are constructed and then funds are assigned to them such that the sum of squared differences between the weights of fund portfolios and their assigned model portfolio is minimized.] I double cluster standard errors by fund and year-month $\times$ portfolio group, to account for both within-fund and cross-sectional correlation in errors. In practice, I find that clustering by fund in regressions of returns is essentially irrelevant, as within-fund correlation in the error term is negligible. On the other hand, the cross-sectional correlation structure of regression errors is substantive. The number of portfolio groups is similar to the number of Morningstar sectors. Each month's largest portfolio group cluster on average accounts for over a third of observations. Therefore, portfolio group $\times$ month clusters allow for extensive within month correlation of errors, without reducing the number of clusters unreasonably.


## Results

Table \@ref(tab:mainResults) presents results from the equation \@ref(eq:regSpec) regression specifications. There is a consistently negative, statistically significant within fund relation between $CompetitorSize$ and fund performance. Coefficients range from -1.06 in the univariate within-fund regression to -0.78 in the specification featuring the full set of fund and year-month fixed effects and own size. While $IndustrySize$ is associated with a statistically significant -0.39 coefficient in the specification with no other controls (column (2)), adding $CompetitorSize$ to the specification (column (3)) subsumes its negative effect, with the coefficient on $IndustrySize$ dropping to an insignificant 0.10. 
Although coefficients associated with own fund size are consistently negative and statistically significant, they are known to be biased and should be interpreted with caution.^[Consistent with @hl17, I find much larger estimates of decreasing returns to own size when using a log transform of $FundSize$.]


<table class="table table-striped table-hover" style="font-size: 11px; margin-left: auto; margin-right: auto;">
<caption style="font-size: initial !important;">(\#tab:mainResults)Decreasing Returns to Competitor Scale</caption>
 <thead>
  <tr>
   <th style="text-align:left;">  </th>
   <th style="text-align:center;"> \left(1\right) </th>
   <th style="text-align:center;"> \left(2\right) </th>
   <th style="text-align:center;"> \left(3\right) </th>
   <th style="text-align:center;"> \left(4\right) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> $CompetitorSize$ </td>
   <td style="text-align:center;"> -0.983*** </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> -1.059*** </td>
   <td style="text-align:center;"> -0.775*** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.178) </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> (0.225) </td>
   <td style="text-align:center;"> (0.142) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> $IndustrySize$ </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> -0.392** </td>
   <td style="text-align:center;"> 0.097 </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> (0.178) </td>
   <td style="text-align:center;"> (0.224) </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> $FundSize$ </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> -0.024*** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> (0.009) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Fixed Effects </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> $\bullet$ Fund </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> $\bullet$ Month </td>
   <td style="text-align:center;"> No </td>
   <td style="text-align:center;"> No </td>
   <td style="text-align:center;"> No </td>
   <td style="text-align:center;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Observations </td>
   <td style="text-align:center;"> 363,203 </td>
   <td style="text-align:center;"> 363,203 </td>
   <td style="text-align:center;"> 363,203 </td>
   <td style="text-align:center;"> 363,203 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> $R^2$ </td>
   <td style="text-align:center;"> 0.012 </td>
   <td style="text-align:center;"> 0.012 </td>
   <td style="text-align:center;"> 0.012 </td>
   <td style="text-align:center;"> 0.102 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> $R^2$ (proj. model) </td>
   <td style="text-align:center;"> 0.001 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.001 </td>
   <td style="text-align:center;"> 0.001 </td>
  </tr>
</tbody>
<tfoot>
<tr><td style="padding: 0; border: 0;" colspan="100%"><strong>Note: </strong></td></tr>
<tr><td style="padding: 0; border: 0;" colspan="100%">
<sup></sup> The regression sample contains actively managed domestic equity mutual funds from 1980 to 2016. The dependent variable is three-factor adjusted gross returns, in annualized percentages. Size variables are as defined in Section \@ref(sec:CompetitorSize). $CompetitorSize$ and $IndustrySize$ are normalized by their respective sample standard deviations. $FundSize$ is normalized by the difference between the 50th and 10th percentile of its distribution. Each fund is assigned to one of ten portfolio group clusters each month based on k-means clustering of most recent portfolio holdings. Standard errors are double clustered by fund and year-month $\times$ portfolio group, and reported in parentheses. Asterisks denote statistical significance: $\ast\ast\ast$ p$&lt;$0.01, $\ast\ast$ p$&lt;$0.05, $\ast$ p$&lt;$0.1.</td></tr>
</tfoot>
</table>


Expense ratios provide an informative comparison for the magnitude of the $CompetitorSize$ coefficients. The mean expense ratio in my sample is 1.23% per year, with an interquartile range of 0.49\%. A one standard deviation increase in $CompetitorSize$ is associated with a drop in performance on the order of two thirds the typical fund expense ratio. Decreasing returns to competitor scale are a meaningful impediment to sustainable profitable operations for funds. 


## The Role of Portfolio Liquidity {#sec:heterogeneity}

Economic reasoning dictates that decreasing returns to competitor scale operate through the price impact of competing funds. Therefore, we would expect decreasing returns to be more severe for funds relying on less liquid strategies. I test this by comparing the magnitude of decreasing returns across funds with different levels of average portfolio liquidity.
Specifically, I run regressions of the form
\begin{align}
\begin{split}
R^{FF3}_{i,t+1} = \alpha_i + \alpha_t &+ \gamma_1 CompetitorSize_{i,t} + \gamma_2 \left( CompetitorSize_{i,t} \times \overline{PortLiq}_{i} \right) \\ 
&+ \eta_1 FundSize_{i,t} + \eta_2 \left( FundSize_{i,t} \times \overline{PortLiq}_i \right) + \varepsilon_{i,t+1},
\end{split}
(\#eq:AvgLiqReg)
\end{align}
where $\overline{Port.Liq}_i$ is either the fund-level average portfolio liquidity measure proposed by @pst17L, or any of its sub-components of stock liquidity (average relative market capitalization of holdings), coverage (number of stocks held relative to total stocks in the market), and balance (a measure of how closely portfolio weights track market weights of stocks in the portfolio). Diversification is the product of coverage and balance. I re-scale each variable so that a unit increase corresponds to the interquartile range of within-fund means. If decreasing returns to scale are rooted in liquidity constraints, we expect $\gamma_2>0$. 


Panel A of Table \@ref(tab:roleOfLiquidity) presents results from the regressions. All $\gamma_2$ coefficients are positive and three out of five are statistically significant. The economic magnitudes are large as well. Increasing average portfolio liquidity from the 25^th^ to the 75^th^ percentile of its distribution changes the impact of a one standard deviation increase in $CompetitorSize$ by 0.23bp in annualized returns. Decomposing portfolio liquidity into its components demonstrates that the majority of the effect is attributable to stock liquidity, with a lesser amount attributable to diversification, including coverage and balance.^[In unreported results, I find a similar pattern of more severe decreasing returns for funds employing less liquid strategies using ad hoc measures of portfolio liquidity such as the portfolio-weighted average market weight of holdings, number of stocks held, share of largest five holdings, the Herfindahl-Hischman Index of portfolio weights, as well as own size and turnover.]


<table class="table table-striped table-hover" style="font-size: 11px; margin-left: auto; margin-right: auto;">
<caption style="font-size: initial !important;">(\#tab:roleOfLiquidity)The Role of Portfolio Liquidity</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> $X=$ </th>
   <th style="text-align:center;"> $L$ </th>
   <th style="text-align:center;"> $S$ </th>
   <th style="text-align:center;"> $D$ </th>
   <th style="text-align:center;"> $C$ </th>
   <th style="text-align:center;"> $B$ </th>
  </tr>
 </thead>
<tbody>
  <tr grouplength="14"><td colspan="6" style="text-align: center;"><strong>Panel A: Fund Level Average Portfolio Liquidity</strong></td></tr>
<tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> $Comp.Size \times \bar{X}$ </td>
   <td style="text-align:center;"> 0.232*** </td>
   <td style="text-align:center;"> 0.324 </td>
   <td style="text-align:center;"> 0.048*** </td>
   <td style="text-align:center;"> 0.068*** </td>
   <td style="text-align:center;"> 0.308 </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1">  </td>
   <td style="text-align:center;"> (0.075) </td>
   <td style="text-align:center;"> (0.279) </td>
   <td style="text-align:center;"> (0.017) </td>
   <td style="text-align:center;"> (0.020) </td>
   <td style="text-align:center;"> (0.191) </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> $FundSize \times \bar{X}$ </td>
   <td style="text-align:center;"> 0.028*** </td>
   <td style="text-align:center;"> 0.010 </td>
   <td style="text-align:center;"> 0.006** </td>
   <td style="text-align:center;"> 0.004* </td>
   <td style="text-align:center;"> 0.005 </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1">  </td>
   <td style="text-align:center;"> (0.010) </td>
   <td style="text-align:center;"> (0.022) </td>
   <td style="text-align:center;"> (0.003) </td>
   <td style="text-align:center;"> (0.002) </td>
   <td style="text-align:center;"> (0.015) </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> $CompetitorSize$ </td>
   <td style="text-align:center;"> -1.189*** </td>
   <td style="text-align:center;"> -1.089*** </td>
   <td style="text-align:center;"> -0.869*** </td>
   <td style="text-align:center;"> -0.934*** </td>
   <td style="text-align:center;"> -1.287*** </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1">  </td>
   <td style="text-align:center;"> (0.207) </td>
   <td style="text-align:center;"> (0.309) </td>
   <td style="text-align:center;"> (0.152) </td>
   <td style="text-align:center;"> (0.162) </td>
   <td style="text-align:center;"> (0.359) </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> $FundSize$ </td>
   <td style="text-align:center;"> -0.075*** </td>
   <td style="text-align:center;"> -0.030 </td>
   <td style="text-align:center;"> -0.034*** </td>
   <td style="text-align:center;"> -0.036*** </td>
   <td style="text-align:center;"> -0.032 </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1">  </td>
   <td style="text-align:center;"> (0.021) </td>
   <td style="text-align:center;"> (0.022) </td>
   <td style="text-align:center;"> (0.011) </td>
   <td style="text-align:center;"> (0.013) </td>
   <td style="text-align:center;"> (0.027) </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> Fixed Effects </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> $\bullet$ Fund </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> $\bullet$ Month </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> Observations </td>
   <td style="text-align:center;"> 363,203 </td>
   <td style="text-align:center;"> 363,203 </td>
   <td style="text-align:center;"> 363,203 </td>
   <td style="text-align:center;"> 363,203 </td>
   <td style="text-align:center;"> 363,203 </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> $R^2$ </td>
   <td style="text-align:center;"> 0.103 </td>
   <td style="text-align:center;"> 0.102 </td>
   <td style="text-align:center;"> 0.102 </td>
   <td style="text-align:center;"> 0.102 </td>
   <td style="text-align:center;"> 0.102 </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> $R^2$ (proj. model) </td>
   <td style="text-align:center;"> 0.001 </td>
   <td style="text-align:center;"> 0.001 </td>
   <td style="text-align:center;"> 0.001 </td>
   <td style="text-align:center;"> 0.001 </td>
   <td style="text-align:center;"> 0.001 </td>
  </tr>
  <tr grouplength="16"><td colspan="6" style="text-align: center;"><strong>Panel B: Real Time Portfolio Liquidity</strong></td></tr>
<tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> $Comp.Size \times X$ </td>
   <td style="text-align:center;"> 0.159*** </td>
   <td style="text-align:center;"> -0.240 </td>
   <td style="text-align:center;"> 0.039** </td>
   <td style="text-align:center;"> 0.057*** </td>
   <td style="text-align:center;"> 0.421*** </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1">  </td>
   <td style="text-align:center;"> (0.041) </td>
   <td style="text-align:center;"> (0.246) </td>
   <td style="text-align:center;"> (0.019) </td>
   <td style="text-align:center;"> (0.020) </td>
   <td style="text-align:center;"> (0.130) </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> $FundSize \times X$ </td>
   <td style="text-align:center;"> 0.008** </td>
   <td style="text-align:center;"> 0.002 </td>
   <td style="text-align:center;"> 0.011*** </td>
   <td style="text-align:center;"> 0.006** </td>
   <td style="text-align:center;"> 0.015** </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1">  </td>
   <td style="text-align:center;"> (0.004) </td>
   <td style="text-align:center;"> (0.008) </td>
   <td style="text-align:center;"> (0.002) </td>
   <td style="text-align:center;"> (0.003) </td>
   <td style="text-align:center;"> (0.007) </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> $X$ </td>
   <td style="text-align:center;"> -0.737** </td>
   <td style="text-align:center;"> -1.032* </td>
   <td style="text-align:center;"> -0.046 </td>
   <td style="text-align:center;"> 0.037 </td>
   <td style="text-align:center;"> -1.681*** </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1">  </td>
   <td style="text-align:center;"> (0.302) </td>
   <td style="text-align:center;"> (0.566) </td>
   <td style="text-align:center;"> (0.091) </td>
   <td style="text-align:center;"> (0.067) </td>
   <td style="text-align:center;"> (0.283) </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> $CompetitorSize$ </td>
   <td style="text-align:center;"> -0.887*** </td>
   <td style="text-align:center;"> -0.474* </td>
   <td style="text-align:center;"> -0.905*** </td>
   <td style="text-align:center;"> -0.968*** </td>
   <td style="text-align:center;"> -1.102*** </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1">  </td>
   <td style="text-align:center;"> (0.204) </td>
   <td style="text-align:center;"> (0.266) </td>
   <td style="text-align:center;"> (0.157) </td>
   <td style="text-align:center;"> (0.164) </td>
   <td style="text-align:center;"> (0.287) </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> $FundSize$ </td>
   <td style="text-align:center;"> -0.050*** </td>
   <td style="text-align:center;"> -0.026** </td>
   <td style="text-align:center;"> -0.052*** </td>
   <td style="text-align:center;"> -0.043*** </td>
   <td style="text-align:center;"> -0.048*** </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1">  </td>
   <td style="text-align:center;"> (0.014) </td>
   <td style="text-align:center;"> (0.013) </td>
   <td style="text-align:center;"> (0.010) </td>
   <td style="text-align:center;"> (0.012) </td>
   <td style="text-align:center;"> (0.015) </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> Fixed Effects </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> $\bullet$ Fund </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> $\bullet$ Month </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
   <td style="text-align:center;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> Observations </td>
   <td style="text-align:center;"> 363,203 </td>
   <td style="text-align:center;"> 363,203 </td>
   <td style="text-align:center;"> 363,203 </td>
   <td style="text-align:center;"> 363,203 </td>
   <td style="text-align:center;"> 363,203 </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> $R^2$ </td>
   <td style="text-align:center;"> 0.103 </td>
   <td style="text-align:center;"> 0.103 </td>
   <td style="text-align:center;"> 0.102 </td>
   <td style="text-align:center;"> 0.103 </td>
   <td style="text-align:center;"> 0.103 </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> $R^2$ (proj. model) </td>
   <td style="text-align:center;"> 0.001 </td>
   <td style="text-align:center;"> 0.001 </td>
   <td style="text-align:center;"> 0.001 </td>
   <td style="text-align:center;"> 0.001 </td>
   <td style="text-align:center;"> 0.001 </td>
  </tr>
</tbody>
<tfoot>
<tr><td style="padding: 0; border: 0;" colspan="100%"><strong>Note: </strong></td></tr>
<tr><td style="padding: 0; border: 0;" colspan="100%">
<sup></sup> The dependent variable is three-factor adjusted gross returns, in annualized percentages. Size variables are normalized according to the Table \@ref(tab:mainResults) caption. $L$, $S$, $D$, $C$, $B$ are portfolio liquidity, stock liquidity, diversification, coverage, and balance, as defined in @pst17L. $\bar{L}$, $\bar{S}$, $\bar{D}$, $\bar{C}$, $\bar{B}$ denote fund-level means. $X$ variables are normalized by interquartile range. Each fund is assigned to one of ten portfolio group clusters each month based on k-means clustering of most recent portfolio holdings. Standard errors are double clustered by fund and year-month $\times$ portfolio group, and reported in parentheses. Asterisks denote statistical significance: $\ast\ast\ast$ p$&lt;$0.01, p$&lt;$0.05, $\ast$ p$&lt;$0.1.</td></tr>
</tfoot>
</table>


A related question is whether funds can actively ameliorate the pernicious effects of decreasing returns to (competitor) scale by choosing more liquid portfolios. I test this by replacing fund-level average measures of portfolio liquidity in equation \@ref(eq:AvgLiqReg) with real time values:
\begin{align}
\begin{split}
R^{FF3}_{i,t+1} = \alpha_i + \alpha_t &+ \gamma_1 CompetitorSize_{i,t} + \gamma_2 \left( CompetitorSize_{i,t} \times PortLiq_{i,t} \right) \\ 
&+ \eta_1 FundSize_{i,t} + \eta_2 \left( FundSize_{i,t} \times PortLiq_{i,t} \right)  \\
&+\gamma_3 PortLiq_{i,t} + \varepsilon_{i,t+1}.
\end{split}
\end{align}
Panel B of Table \@ref(tab:roleOfLiquidity) presents results from the regressions. With the exception of stock liquidity, the interaction terms are all positive and statistically significant, suggesting that increased portfolio liquidity shelters the fund from decreasing returns to scale. Note that the main effect of portfolio liquidity is negative, suggesting that funds make more when they hold more concentrated portfolios. This is consistent with funds responding to time-varying investment opportunities by decreasing portfolio liquidity when expected returns are high.


# Evidence From the 2003 Mutual Fund Scandal {#sec:scandal}




In September 2003, the New York Attorney General's office launched investigations into several high-profile mutual fund families for illegal trading practices. Families were charged with allowing favored clients to trade fund shares at stale prices at the expense of ordinary shareholders [@hw05; @zitzewitz06]. By the end of October 2004, official investigations had been announced against a total of twenty-five mutual fund families. 

@hw05 and @mccabe08 argue that investors penalized tainted funds with large outflows. This is borne out in my data. Figure \@ref(fig:scandalFlows) plots mean net flows by scandal involvement.^[
I follow Table 1 of @hw05 for classifying fund families embroiled in the scandal. The following is the list of fund families tainted by the scandal by month of the news date of investigation.
	September 2003: Alliance Bernstein, Franklin Templeton, Gabelli, Janus, Nations, One Group, Putnam, Strong.
	October 2003: Alger, Federated.
	November 2003: Excelsior/US Trust, Fremont, Loomis Sayles, PBHG.
	December 2003: AIM/Invesco, MFS, Heartland.
	January 2004: Columbia, Scudder, Seligman.
	February 2004: PIMCO.
	March 2004: ING, RS.
	August 2004: Evergreen. 
	October 2004: Sentinel.    
I identify funds belonging to these families as of August 2003 in my sample based on the share class names in the CRSP mutual fund dataset. I classify 289 of the 1,462 funds in my sample in August 2003 with existing holdings and gross returns as members of future tainted families.
Table~\ref{tab:snapShot200308} presents a snapshot of summary statistics as of August 2003 by future scandal involvement. Scandal funds are slightly older, larger, and have higher turnover to portfolio liquidity and expense ratios.]


![(\#fig:scandalFlows)Net flows and relative size of funds involved in the scandal. I categorize funds according to Table 1 in @hw05. The left panel plots mean monthly net flows, defined according to @st98, by scandal involvement. The vertical line corresponds to August 2003, the month before the announcement of the first investigations. The right panel shows the total net assets of funds coming under investigation in a given month, relative to the total size of funds in my sample.](06-scandal_files/figure-latex/scandalFlows-1.pdf) 

The two series track each other closely in the two years prior to the scandal, and diverge abruptly in September 2003. The wedge between the two groups persists until the end of 2006, coincident with the final settlements negotiated with the Securities and Exchange Commission [@zitzewitz09].^[The difference is statistically significant. I estimate a regression using a two year pre- and post-scandal window of observations of the form
$$
flow_{i,t}=\alpha_i + \alpha_t + \gamma Post_{i,t} +\varepsilon_{i,t},
$$
where $Post_{i,t}$ is an indicator for post news date for scandal funds. I find $\gamma=-9.16$\% per year, with t-statistic of $4.6$.] 

I conclude that the scandal caused a significant reallocation of resources away from tainted funds. Unless flows are perfectly offsetting, this shift will cause a relative reduction in the competitor size of the most similar funds. Under decreasing returns to competitor scale, we would expect the investment opportunities of these funds to improve in relative terms, leading them to differentially expand active management and earn higher returns. 

I test these hypotheses by comparing untainted funds with differential pre-scandal similarity to prospective scandal funds. I discard tainted funds as the internal upheaval following the scandal likely had a direct impact on their performance and investment behavior.^[In the aftermath of the investigations, several executives stepped down, and a number of portfolio managers were fired. Perhaps the highest profile casualty of the scandal was Richard S. Strong, founder of Strong Capital Management, who resigned in December 2003. Strong would go on to pay \$60 million in settlements and be barred from the industry. Strong Capital itself was acquired by Wells Fargo in 2004.] I take two approaches. The first is a straightforward difference-in-differences-style comparison of fund outcomes before and after the scandal as a function of their pre-scandal exposure to tainted funds. The second approach links fund outcomes directly to variation in competitor size attributable to abnormal flows among tainted funds. I first present the analysis on fund capital allocation, followed up by the analysis of fund performance.


## Before and After Analysis {#sec:scandalID}

I relate fund-by-fund differences in pre-scandal $[2003m8-W$, $2003m8]$ and post-scandal $[2004m11$, $2004m11+W] $ outcomes to pre-scandal exposure to competition from tainted funds. I consider $W\in\{1,2\}$ year windows. For a fund to be included in the estimation sample, it must have available holdings information for August 2003, and I must observe it both in the pre- and the post-scandal period.

I measure pre-scandal exposure as the proportion of competitor size attributable to prospective tainted funds as of August 2003. Let $\Phi$ denote the set of funds that belong to families later investigated, and define
\begin{equation}
ScandalExposure_i = \frac{\sum_{j\in \Phi} \psi_{i,j,2003m8} FundSize_{j,2003m8}}{\sum_{j\neq i}\psi_{i,j,2003m8} FundSize_{j,2003m8}}.
\end{equation}
On average, $22$\% of untainted funds' competitor size is due to tainted fund families. Exposure ranges from 7\% to over 40\%, with upper quartile 25\% and lower quartile 19\%.

To present interpretable summary statistics, I sort funds into high and low exposure groups depending on whether their $ScandalExposure$ is above or below the cross-sectional median. Table~\ref{tab:snapShotHL200308} gives a snapshot taken in August 2003. High exposure funds are slightly smaller, have higher turnover to portfolio liquidity ratios, expense ratios, $CompetitorSize$, and worse performance. Fund age is almost identical across the two groups, limiting the plausibility of life cycle effects as an explanation for differences in outcome paths. 

Figure \@ref(fig:exposureDID) summarizes the identifying variation in the data. I plot the groupwise cross-sectional mean of within-fund deviations for competitor size, log active share, and log turnover to portfolio liquidity ratio. The differential impact of the scandal across groups is identified by the difference in the pre- and post-scandal period wedges between the series. The $CompetitorSize$ of the low exposure group overall trends upward, despite a small dip in the middle of the scandal period. The $CompetitorSize$ of high exposure funds drops more substantively  during the scandal, and remains flat for almost a year after the end of the scandal period. The historical accident of scandal-related outflows at involved funds appear to have insulated their closest competitors from contemporaneous increases in the aggregate size of the industry. 


![(\#fig:exposureDID)Untainted fund outcomes by exposure to competition from scandal funds. Funds are sorted into high and low exposure groups depending on whether their $ScandalExposure$ is above or below the cross-sectional median. The $\ln(CompetitorSize)$, $\ln(AS)$, and $\ln(TL^{-1/2})$ panels plot cross-sectional means of the variables' deviations from their respective within fund means across exposure groups. The $R^{FF3}$ panel plots the difference between the cross-sectional means of the within fund deviations of three factor adjusted gross returns across the two groups. Vertical lines correspond to August 2003, the month before the announcement of the first investigations, and October 2004, the month of the last investigations according to Table 1 of @hw05.](06-scandal_files/figure-latex/exposureDID-1.pdf) 


The turnover to portfolio liquidity ratio of the low exposure group exhibits a steady decline until late 2005, despite a momentary increase during the scandal. The high exposure group shows parallel trends until the beginning of the scandal period. Consistent with improved investment opportunities during the scandal, high exposure funds substantially decreased portfolio liquidity and increased turnover during 2004. The gap in within-fund turnover to portfolio liquidity ratios only begins to close at the end of 2006 as abnormal flows at scandal funds vanish. Active share of low exposure funds is essentially flat during this period, whereas active share of high exposure funds show steady increases during and after the scandal.

Given the volatility of returns, for easier comparison of fund performance I plot the difference between high and low exposure group cross-sectional means of within-fund three factor adjusted returns. High exposure funds relatively underperform low exposure funds in the pre-scandal period, are essentially even during the scandal, and enjoy a string of relative outperformance in the year after the end of the scandal period. The differential relative before and after performance of the two groups is consistent with decreasing returns to competitor scale.

To formally test for differential differences in before and after outcomes as a function of ex ante exposure to competition from prospective scandal funds, I perform regressions of the form
\begin{equation}
y_{i,t} = \alpha_i + \alpha_t + \gamma \left( \mathbb{I}_t \times ScandalExposure_i \right) + \mathbf{X}_{i,t}\Gamma + \varepsilon_{i,t},
(\#eq:didReg)
\end{equation}
where $\mathbf{X}_{i,t}$ includes log fund size and expense ratio, as dictated by theory. In the regression, exposure is a continuous variable.\footnote{
Unreported binned scatter plots suggest reasonably linear relations between $ScandalExposure$ and outcome variables after residualizing by fund and time fixed effects.
} 
I double cluster standard errors by fund and portfolio group $\times$ time. I normalize $ScandalExposure$ by its interquartile range ($\approx 6$\%).


\begin{table}[ht]
\centering
\caption{Capital Allocation and the Scandal: Before and After Analysis} 
\label{tab:scandalSpillover}
\begingroup\scriptsize
\begin{tabularx}{0.975\textwidth}{lYYYYYYYY}
  \multicolumn{9}{p{.975\textwidth}}{Dependent variables are identified in the column headers. $\ln(C.S.)$ is an abbreviation for $\ln(CompetitorSize)$. For regressions with $\ln(TL^{-1/2})$ as the dependent variable, observations are at the fund-month level. Other specifications are at the fund-report date level. The estimation sample includes only funds not directly involved in the scandal. It covers the period $\{(2003m8-W, 2003m8], [2004m11, 2004m11 + W) \}$, where $W$ corresponds to the number of years specified. $ScandalExposure$ (abbreviated to $ScanEx$) is the fraction of untainted funds' $CompetitorSize$ due to portfolio similarity with future scandal funds in August 2003. I normalize $ScandalExposure$ by its interquartile range. $\mathbb{I}$ is an indicator for the post scandal period. Standard errors are double clustered by fund and portfolio group $\times$ date, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.}\\
\addlinespace \toprule
Dep. Var.: & $\ln(C.S.)$ & $\ln(AS)$ & $\ln(TL^{-1/2})$ & $\ln(L)$ & $\ln(S)$ & $\ln(D)$ & $\ln(C)$ & $\ln(B)$ \\ 
  \midrule \\
 \multicolumn{9}{c}{\textbf{Panel A: 1 year window}}\\
 \midrule
$\mathbb{I}\times ScanEx$ & -0.064*** & 0.026*** & 0.011 & -0.100*** & -0.095*** & -0.049** & -0.026* & -0.026 \\ 
   & (0.019) & (0.006) & (0.031) & (0.024) & (0.018) & (0.022) & (0.014) & (0.017) \\ 
  $\ln(FundSize)$ & 0.130*** & -0.014** & -0.182*** & 0.172*** & 0.083*** & 0.141*** & 0.074*** & 0.077*** \\ 
   & (0.021) & (0.007) & (0.030) & (0.025) & (0.014) & (0.025) & (0.019) & (0.017) \\ 
  $\ln(f)$ & -0.004 & -0.016 & 0.012 & 0.016 & -0.068 & 0.067 & 0.097 & -0.024 \\ 
   & (0.100) & (0.029) & (0.137) & (0.116) & (0.081) & (0.104) & (0.078) & (0.079) \\ 
  $\ln(T)$ &  &  &  & -0.079*** & -0.065*** & -0.045* & 0.018 & -0.064*** \\ 
   &  &  &  & (0.028) & (0.017) & (0.025) & (0.015) & (0.018) \\ 
  $\ln(D)$ &  &  &  &  & -0.228*** &  &  &  \\ 
   &  &  &  &  & (0.028) &  &  &  \\ 
  $\ln(S)$ &  &  &  &  &  & -0.450*** & -0.243*** & -0.238*** \\ 
   &  &  &  &  &  & (0.050) & (0.040) & (0.050) \\ 
  $\ln(B)$ &  &  &  &  &  &  & -0.057* &  \\ 
   &  &  &  &  &  &  & (0.033) &  \\ 
  $\ln(C)$ &  &  &  &  &  &  &  & -0.083* \\ 
   &  &  &  &  &  &  &  & (0.047) \\ 
  Fixed Effects &  &  &  &  &  &  &  &  \\ 
  $\bullet$ Fund & Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  $\bullet$ Time & Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  Observations & 7,079 & 6,072 & 24,192 & 6,893 & 6,893 & 6,893 & 6,893 & 6,893 \\ 
  $R^2$ & 0.926 & 0.914 & 0.895 & 0.962 & 0.987 & 0.941 & 0.942 & 0.892 \\ 
  $R^2$ (proj. model) & 0.052 & 0.022 & 0.026 & 0.077 & 0.156 & 0.121 & 0.084 & 0.062 \\ 
   \midrule \\
 \multicolumn{9}{c}{\textbf{Panel B: 2 year window}} \\
 \midrule $\mathbb{I}\times ScanEx$ & -0.034* & 0.029*** & 0.010 & -0.100*** & -0.105*** & -0.039* & -0.032** & -0.011 \\ 
   & (0.020) & (0.006) & (0.031) & (0.025) & (0.019) & (0.022) & (0.015) & (0.016) \\ 
  $\ln(FundSize)$ & 0.149*** & -0.018*** & -0.205*** & 0.184*** & 0.088*** & 0.148*** & 0.074*** & 0.084*** \\ 
   & (0.017) & (0.006) & (0.025) & (0.022) & (0.013) & (0.021) & (0.016) & (0.015) \\ 
  $\ln(f)$ & -0.097 & 0.004 & 0.113 & -0.073 & -0.169** & 0.040 & 0.105 & -0.061 \\ 
   & (0.073) & (0.027) & (0.117) & (0.108) & (0.076) & (0.091) & (0.072) & (0.071) \\ 
  $\ln(T)$ &  &  &  & -0.063*** & -0.065*** & -0.025 & 0.023 & -0.049*** \\ 
   &  &  &  & (0.024) & (0.014) & (0.022) & (0.014) & (0.015) \\ 
  $\ln(D)$ &  &  &  &  & -0.216*** &  &  &  \\ 
   &  &  &  &  & (0.022) &  &  &  \\ 
  $\ln(S)$ &  &  &  &  &  & -0.425*** & -0.218*** & -0.236*** \\ 
   &  &  &  &  &  & (0.036) & (0.033) & (0.039) \\ 
  $\ln(B)$ &  &  &  &  &  &  & -0.056** &  \\ 
   &  &  &  &  &  &  & (0.025) &  \\ 
  $\ln(C)$ &  &  &  &  &  &  &  & -0.077** \\ 
   &  &  &  &  &  &  &  & (0.034) \\ 
  Fixed Effects &  &  &  &  &  &  &  &  \\ 
  $\bullet$ Fund & Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  $\bullet$ Time & Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  Observations & 13,666 & 11,773 & 46,660 & 13,291 & 13,291 & 13,291 & 13,291 & 13,291 \\ 
  $R^2$ & 0.895 & 0.878 & 0.860 & 0.943 & 0.980 & 0.914 & 0.914 & 0.848 \\ 
  $R^2$ (proj. model) & 0.065 & 0.027 & 0.043 & 0.083 & 0.154 & 0.114 & 0.071 & 0.063 \\ 
   \bottomrule
\end{tabularx}
\endgroup
\end{table}


Table \@ref(tab:scandalSpillover) presents results. The one (two) year window estimate implies a $6.7$\% ($3.5$\%) post-scandal reduction in $CompetitorSize$ for untainted funds at the 75$^{\text{th}}$ percentile of $ScandalExposure$ relative to untainted funds at the 25$^{\text{th}}$ percentile of $ScandalExposure$. The same difference in $ScandalExposure$ is associated with a $2.4$\% ($2.6$\%) relative increase in active share, and a $6.3$\% ($4.4$\%) increase in the turnover to portfolio liquidity ratio. The coefficients also imply a relative decline in portfolio liquidity and its components for high exposure funds. These findings are consistent with high exposure funds increasing activeness in response to softened competition.

The main concern with identification based on comparing pre- and post-event periods across groups is that the measured effect might be the manifestation of favorable trends across the groups in the pre-period. I test for differential trends in the pre-period as a function of $ScandalExposure$ by estimating the regression
\begin{equation}
y_{i,t} = \alpha_i + \alpha_t + \gamma \left(t \times ScandalExposure_i\right) + \mathbf{X}_{i,t}\Gamma + \varepsilon_{i,t},
\end{equation}
where $t$ is a linear time trend and $\mathbf{X}_{i,t}$ includes the usual controls. I estimate this regression on pre-period observations. Differential pre-trends by $ScandalExposure$ would be a concern if the coefficient on the trend interaction was statistically significant and of the same sign as the corresponding interaction coefficient in Table \@ref(tab:scandalSpillover). Results from these specifications fail to reject the null hypothesis of no differential trends in the pre-period (Table~\ref{tab:scandalSpilloverPreTrend}). 



## Linking $CompetitorSize$ Directly to Abnormal Flows {#sec:linkFlows}

The analysis above does not explicitly model fund outcomes as a function of scandal flows. In this section, I explore a more sophisticated approach. I first estimate outflows at tainted funds attributable to the scandal. In turn, I relate untainted fund outcomes to variation in competitor size explained by abnormal tainted competitor outflows.

I use a linear model to decompose variation in fund flows between the effects of the scandal and baseline variation. I pool tainted and untainted funds in the two year window surrounding the scandal period, consisting of observations from September 2001 to October 2006. Consider scandal funds as being from the same cohort $d$ if news of investigation into their trading practices broke in month $d$. Denote the cohort of fund $j$ as $j^{(d)}$. Let $\mathbb{I}_{t\geq j^{(d)}}$ be an indicator for post investigation months for fund $j$, and define $\mathbb{I}_{d,t}$ as cohort $\times$ time dummy variables. I regress flows on the full set of post-investigation cohort $\times$ time indicators, controlling for fund and time fixed effects:
\begin{equation}
flow_{j,t}=\alpha_j+\alpha_t +\beta_{j^{(d)},t} \left( \mathbb{I}_{t\geq j^{(d)}}\mathbb{I}_{j^{(d)},t} \right) + \varepsilon_{j,t}.
(\#eq:cohortReg)
\end{equation}
I interpret the betas as the path of abnormal flows attributable to the scandal for each cohort. I cumulate abnormal flows at each post-scandal date as
\begin{equation}
\hat{f}_{j,t} = \prod_{\tau\geq j^{(d)}}^t \left(1+\hat{\beta}_{j^{(d)},t}\right) - 1.
\end{equation}
I construct $ScandalOutFlow$ for untainted fund $i$ as the similarity- and size-weighted cumulative abnormal negative net flow among tainted funds $j\in\Phi$:
\begin{equation}
ScandalOutFlow_{i,t}= -\sum_{j\in \Phi} \psi_{i,j,2003m8} \left(\hat{f}_{j,t} FundSize_{j,2003m8} \right).
(\#eq:scandalOutFlow)
\end{equation}

Figure \@ref(fig:scandalOutFlow) plots time series characteristics of abnormal flows and $ScandalOutFlow$. Abnormal flows are most negative in the immediate aftermath of the announcement of the first investigations, and gradually converge to zero near the end of 2006. This pattern maps into almost linearly increasing cumulative outflows in the first two years after the scandal, reflected in the observed pattern in $ScandaOutFlow$. Importantly for identifying differential spillover effects of the scandal, total predicted outflows at competing tainted funds vary substantially in the cross-section. 


![(\#fig:scandalOutFlow)Abnormal flows and $ScandalOutFlow$. The left panel shows the cross-sectional mean coefficient on post-scandal cohort $\times$ time fixed effects from Equation \@ref(eq:cohortReg). The right panel shows the time series of cross-sectional percentiles of $ScandalOutFlow$ across untainted funds, calculated according to Equation \@ref(eq:scandalOutFlow).](06-scandal_files/figure-latex/scandalOutFlow-1.pdf) 


I link tainted funds' flows directly to untainted fund outcomes through the reduced form regressions
\begin{equation}
	y_{i,t}=\alpha_i+\alpha_t+\gamma ScandalOutFlow_{i,t} + \mathbf{X}_{i,t}\Gamma + \varepsilon_{i,t},
\end{equation}
where $\mathbf{X}_{i,t}$ includes log size and expense ratio.
Table \@ref(tab:scandalSpilloverIV) presents results. The coefficient on $ScandalOutFlow$ represents the expected difference in outcomes between funds across the variable's interquartile range. Moving from the 25$^{\text{th}}$ to the 75$^{\text{th}}$ percentile of abnormal scandal-affected competitor outflow is associated with an approximately $18$\% relative decline in competitor size. Consistent with the difference-in-differences-style analysis, the results indicate that funds whose competitors were particularly affected by scandal-related outflows expanded active management relative to funds with less affected competitors, increasing active share, turnover to portfolio liquidity ratios, and decreasing portfolio liquidity.



\begin{table}[ht]
\centering
\caption{Capital Allocation and the Scandal: Using Abnormal Flows} 
\label{tab:scandalSpilloverIV}
\begingroup\scriptsize
\begin{tabularx}{0.975\textwidth}{lYYYYYYYY}
  \multicolumn{9}{p{.975\textwidth}}{Dependent variables are identified in the column headers. For regressions with $\ln(TL^{-1/2})$ as the dependent variable, observations are at the fund-month level. Other specifications are at the fund-report date level. The estimation sample includes untainted funds during $\{[2003m9-W, 2004m10+W] \}$, where $W$ corresponds to the number of years specified at the bottom of each panel. $ScandalOutFlow$ is the similarity-weighted cumulative abnormal outflows attributable to the scandal among involved funds. $ScandalOutFlow$ is normalized by its interquartile range. $\ln(C.S.)$ is an abbreviation for $\ln(CompetitorSize)$. Standard errors are double clustered by fund and portfolio group $\times$ time, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.}\\
\addlinespace \toprule
Dep. Var.: & $\ln(C.S.)$ & $\ln(AS)$ & $\ln(TL^{-1/2})$ & $\ln(L)$ & $\ln(S)$ & $\ln(D)$ & $\ln(C)$ & $\ln(B)$ \\ 
  \midrule \\
 \multicolumn{9}{c}{\textbf{Panel A: 1 year window}} \\
 \midrule
$ScandalOutFlow$ & -0.181*** & 0.059*** & 0.114*** & -0.221*** & -0.120*** & -0.181*** & -0.076*** & -0.127*** \\ 
   & (0.016) & (0.007) & (0.024) & (0.023) & (0.015) & (0.021) & (0.015) & (0.014) \\ 
  $\ln(FundSize)$ & 0.092*** & -0.010* & -0.149*** & 0.143*** & 0.080*** & 0.116*** & 0.075*** & 0.056*** \\ 
   & (0.017) & (0.005) & (0.027) & (0.022) & (0.013) & (0.021) & (0.016) & (0.015) \\ 
  $\ln(f)$ & -0.066 & -0.009 & 0.036 & -0.027 & -0.062 & 0.009 & 0.078 & -0.064 \\ 
   & (0.070) & (0.024) & (0.111) & (0.089) & (0.062) & (0.083) & (0.062) & (0.060) \\ 
  $\ln(T)$ &  &  &  & -0.057*** & -0.045*** & -0.038** & 0.011 & -0.052*** \\ 
   &  &  &  & (0.019) & (0.011) & (0.018) & (0.011) & (0.015) \\ 
  $\ln(D)$ &  &  &  &  & -0.267*** &  &  &  \\ 
   &  &  &  &  & (0.024) &  &  &  \\ 
  $\ln(S)$ &  &  &  &  &  & -0.522*** & -0.269*** & -0.318*** \\ 
   &  &  &  &  &  & (0.045) & (0.035) & (0.047) \\ 
  $\ln(B)$ &  &  &  &  &  &  & -0.097*** &  \\ 
   &  &  &  &  &  &  & (0.029) &  \\ 
  $\ln(C)$ &  &  &  &  &  &  &  & -0.155*** \\ 
   &  &  &  &  &  &  &  & (0.043) \\ 
  Fixed Effects &  &  &  &  &  &  &  &  \\ 
  $\bullet$ Fund & Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  $\bullet$ Time & Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  Observations & 12,095 & 10,334 & 39,784 & 11,689 & 11,689 & 11,689 & 11,689 & 11,689 \\ 
  $R^2$ & 0.935 & 0.933 & 0.904 & 0.967 & 0.988 & 0.949 & 0.950 & 0.901 \\ 
  $R^2$ (proj. model) & 0.088 & 0.073 & 0.027 & 0.107 & 0.172 & 0.174 & 0.107 & 0.103 \\ 
   \midrule \\
 \multicolumn{9}{c}{\textbf{Panel B: 2 year window}} \\
 \midrule $ScandalOutFlow$ & -0.168*** & 0.061*** & 0.110*** & -0.209*** & -0.125*** & -0.162*** & -0.075*** & -0.104*** \\ 
   & (0.015) & (0.007) & (0.022) & (0.020) & (0.014) & (0.019) & (0.015) & (0.013) \\ 
  $\ln(FundSize)$ & 0.113*** & -0.012** & -0.182*** & 0.156*** & 0.083*** & 0.128*** & 0.072*** & 0.070*** \\ 
   & (0.014) & (0.005) & (0.023) & (0.019) & (0.012) & (0.018) & (0.015) & (0.013) \\ 
  $\ln(f)$ & -0.132** & 0.011 & 0.135 & -0.110 & -0.169** & -0.016 & 0.076 & -0.090 \\ 
   & (0.059) & (0.023) & (0.098) & (0.096) & (0.070) & (0.080) & (0.061) & (0.063) \\ 
  $\ln(T)$ &  &  &  & -0.049** & -0.049*** & -0.024 & 0.017 & -0.043*** \\ 
   &  &  &  & (0.019) & (0.011) & (0.018) & (0.012) & (0.013) \\ 
  $\ln(D)$ &  &  &  &  & -0.259*** &  &  &  \\ 
   &  &  &  &  & (0.020) &  &  &  \\ 
  $\ln(S)$ &  &  &  &  &  & -0.506*** & -0.254*** & -0.305*** \\ 
   &  &  &  &  &  & (0.035) & (0.031) & (0.038) \\ 
  $\ln(B)$ &  &  &  &  &  &  & -0.088*** &  \\ 
   &  &  &  &  &  &  & (0.023) &  \\ 
  $\ln(C)$ &  &  &  &  &  &  &  & -0.127*** \\ 
   &  &  &  &  &  &  &  & (0.032) \\ 
  Fixed Effects &  &  &  &  &  &  &  &  \\ 
  $\bullet$ Fund & Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  $\bullet$ Time & Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  Observations & 18,904 & 16,211 & 63,055 & 18,309 & 18,309 & 18,309 & 18,309 & 18,309 \\ 
  $R^2$ & 0.907 & 0.898 & 0.869 & 0.951 & 0.982 & 0.924 & 0.922 & 0.860 \\ 
  $R^2$ (proj. model) & 0.103 & 0.086 & 0.046 & 0.117 & 0.181 & 0.164 & 0.095 & 0.096 \\ 
   \bottomrule
\end{tabularx}
\endgroup
\end{table}

In additional analyses I isolate the variation in $CompetitorSize$ attributable to abnormal flows at tainted competitors, and measure its impact on capital allocation. I perform two-stage least squares (2SLS) regressions, instrumenting for $\ln(CompetitorSize)$ by $ScandalOutFlow$ in the specification
\begin{equation}
	y_{i,t}=\alpha_i+\alpha_t + \gamma \ln(CompetitorSize_{i,t}) + \mathbf{X}_{i,t}\Gamma+\varepsilon_{i,t},
\end{equation}
where $y_{i,t}$ is log active share or log turnover-liquidity ratio, and $\mathbf{X}$ the usual controls. Table~\ref{tab:scandal2SLS} presents results. As expected based on the first column of Table \@ref(tab:scandalSpilloverIV), the first stage F-statistics are high, and $ScandalOutFlow$ passes the relevance criterion. Consistent with earlier results, variation in competitor size attributable to $ScandalOutFlow$ is associated with decreased active management and increased portfolio liquidity.


\subsection{Controlling for Sector Level Shocks}

As an additional robustness check to ensure my results are not an artifact of common sector level shocks, I re-estimate the analysis using benchmark $\times$ time fixed effects. The results remain similar (Tables \@ref(tab:scandalSpilloverMXBim), \@ref(tab:scandalSpilloverPreTrendMXBim), \@ref(tab:scandalSpilloverIVMXBim), \@ref(tab:scandal2SLSmXbim)).


\subsection{Fund Performance}

The analysis presented so far is consistent with competitors of scandal-tainted funds reacting to improved investment opportunities by increasing capital allocated to active strategies. According to this line of reasoning we would expect the same funds to experience relatively improved performance. To investigate, in Table \@ref(tab:scandalPerformance) I perform analyses similar to those presented above, but with risk adjusted gross returns as the outcome variable of interest. The results demonstrate that close competitors of tainted funds indeed saw an increase in relative performance following the scandal. 


\begin{table}[ht]
\centering
\caption{Fund Performance and the Scandal} 
\label{tab:scandalPerformance}
\begingroup\scriptsize
\begin{tabularx}{0.975\textwidth}{lYYYYYY}
  \multicolumn{7}{p{.975\textwidth}}{The dependent variable is Fama-French 3 factor adjusted gross returns, in annual percent units. Observations are monthly. The estimation sample includes only funds not tainted by the scandal. In columns (1)-(4) regressions are estimated by ordinary least squares. In columns (5)-(6), regressions are estimated by two stage least squares, instrumenting $\ln(CompetitorSize)$ with $ScandalOutFlow$. In columns (1)-(2), the sample includes $\{(2003m8-W, 2003m8], [2004m11,2004m11+W) \}$, where $W$ corresponds to the number of years specified. In columns (3)-(6), the sample is taken over the period $\{[2003m9-W, 2004m10+W] \}$. $ScandalExposure$ (abbreviated to $ScanEx$) is the fraction of untainted funds' $CompetitorSize$ due to portfolio similarity with future scandal funds in August 2003. I normalize $ScandalExposure$ by its interquartile range. $\mathbb{I}$ is an indicator for the post scandal period. $ScandalOutFlow$ is the similarity-weighted cumulative abnormal outflows attributable to the scandal among involved funds. $ScandalOutFlow$ is normalized by its interquartile range. Benchmarks are the indexes which yield the lowest active share, taken from \citet{petajisto13}. I use the most recently available benchmark when one is missing. Standard errors are double clustered by fund and portfolio group $\times$ month in odd columns, and by fund and benchmark $\times$ month in even columns (5)-(6). Standard errors are reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.}\\
 \addlinespace \toprule
 & (1) & (2) & (3) & (4) & (5) & (6) \\ 
  \midrule \\
 \multicolumn{7}{c}{\textbf{Panel A: 1 year window}} \\
 \midrule
$\mathbb{I}\times ScanEx$ & 5.715*** & 4.058*** &  &  &  &  \\ 
   & (1.130) & (0.681) &  &  &  &  \\ 
  $ScandalOutFlow$ &  &  & 1.687** & 2.691*** &  &  \\ 
   &  &  & (0.829) & (0.673) &  &  \\ 
  $\ln(CompetitorSize)$ &  &  &  &  & -9.574** & -13.913*** \\ 
   &  &  &  &  & (4.667) & (3.546) \\ 
  $\ln(FundSize)$ & -3.131*** & -3.419*** & -4.712*** & -4.547*** & -3.815*** & -3.260*** \\ 
   & (0.677) & (0.537) & (0.666) & (0.510) & (0.744) & (0.590) \\ 
  Fixed Effects &  &  &  &  &  &  \\ 
  $\bullet$ Fund & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  $\bullet$ Month & Yes & No & Yes & No & Yes & No \\ 
  $\bullet$ Benchmark $\times$ Month & No & Yes & No & Yes & No & Yes \\ 
  Observations & 24,909 & 24,909 & 41,333 & 41,333 & 41,333 & 41,333 \\ 
  $R^2$ & 0.111 & 0.208 & 0.101 & 0.209 &  &  \\ 
  $R^2$ (proj. model) & 0.019 & 0.011 & 0.008 & 0.008 &  &  \\ 
  F (first stage) &  &  &  &  & 4.2 & 15.4 \\ 
   \midrule \\
 \multicolumn{7}{c}{\textbf{Panel B: 2 year window}} \\
 \midrule $\mathbb{I}\times ScanEx$ & 2.509*** & 1.842*** &  &  &  &  \\ 
   & (0.861) & (0.462) &  &  &  &  \\ 
  $ScandalOutFlow$ &  &  & 0.405 & 0.969*** &  &  \\ 
   &  &  & (0.491) & (0.365) &  &  \\ 
  $\ln(CompetitorSize)$ &  &  &  &  & -2.489 & -6.202*** \\ 
   &  &  &  &  & (3.011) & (2.386) \\ 
  $\ln(FundSize)$ & -3.714*** & -3.681*** & -4.169*** & -3.973*** & -3.877*** & -3.245*** \\ 
   & (0.501) & (0.333) & (0.474) & (0.313) & (0.588) & (0.426) \\ 
  Fixed Effects &  &  &  &  &  &  \\ 
  $\bullet$ Fund & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  $\bullet$ Month & Yes & No & Yes & No & Yes & No \\ 
  $\bullet$ Benchmark $\times$ Month & No & Yes & No & Yes & No & Yes \\ 
  Observations & 48,230 & 48,230 & 65,463 & 65,463 & 65,463 & 65,463 \\ 
  $R^2$ & 0.083 & 0.209 & 0.087 & 0.212 &  &  \\ 
  $R^2$ (proj. model) & 0.011 & 0.009 & 0.009 & 0.008 &  &  \\ 
  F (first stage) &  &  &  &  & 0.7 & 6.8 \\ 
   \bottomrule
\end{tabularx}
\endgroup
\end{table}


\subsection{Investor Flows}

I have argued that observing a relation between investment opportunities and funds' internal capital allocation after controlling for fund size is indicative of information asymmetry between managers and outside investors. Table~\ref{tab:scandalFlow} provides further evidence of sluggish adjustment in external capital markets to fund investment opportunities. Specifically, I test for differential relative net flows among untainted funds by their pre-scandal exposure to competition from tainted funds. I find no evidence of increased relative net flows to closely competing funds in the year surrounding the scandal, suggesting that investors did not foresee improvements in prospective performance. There is slight evidence of differential investor flows over a two year window, which I interpret as consistent with investors chasing performance instead of anticipating it.


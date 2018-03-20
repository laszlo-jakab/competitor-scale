# Additional Results: Capital Allocation




\begin{table}[ht]
\centering
\caption{Capital Allocation and Competitor Size --- Benchmark $\times$ Quarter FE} 
\label{tab:fundResponseMXBim}
\begingroup\scriptsize
\begin{tabularx}{0.975\textwidth}{lYYYYYYY}
  \multicolumn{8}{p{.975\textwidth}}{\scriptsize Observations are first differences at the fund $\times$ quarter level, from 1980-2016. Dependent variables are noted in the column headers. $AS$ is active share relative to self-declared benchmarks \citep{cp09, petajisto13}, covering years 1980-2009. $TL^{-1/2}$ is the turnover to portfolio liquidity ratio, as in \citet{pst17L}. $S$, $D$, $C$, and $B$ are the components of portfolio liquidity, namely stock liquidity, diversification, coverage, and balance (each calculated with respect to all U.S. equity). $\Delta CS_{i,t}=\ln\left(\sum_{j\neq i} \psi_{i,j,t-1} FundSize_{j,t} \right) - \ln\left(\sum_{j\neq i} \psi_{i,j,t-1} FundSize_{j,t-1}\right)$ is the change in log competitor size, holding previous quarter end similarity weights fixed. Benchmarks are the indexes which yield the lowest active share, taken from \citet{petajisto13}. I use the most recently available benchmark when one is missing. Standard errors are double clustered by fund and benchmark $\times$ quarter, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.} \\ \addlinespace \toprule
Dep. Var.: & $\Delta\ln(AS)$ & $\Delta\ln(TL^{-1/2})$ & $\Delta\ln(L)$ & $\Delta\ln(S)$ & $\Delta\ln(D)$ & $\Delta\ln(C)$ & $\Delta\ln(B)$ \\ 
  \midrule
$\Delta CS$ & -0.023** & -0.374*** & 0.502*** & 0.353*** & 0.403*** & 0.077** & 0.383*** \\ 
   & (0.012) & (0.070) & (0.069) & (0.064) & (0.062) & (0.033) & (0.055) \\ 
  $\Delta\ln(FundSize)$ & -0.014*** & -0.096*** & 0.161*** & 0.080*** & 0.148*** & 0.093*** & 0.088*** \\ 
   & (0.002) & (0.011) & (0.011) & (0.008) & (0.010) & (0.007) & (0.008) \\ 
  $\Delta\ln(f)$ & -0.023 & 0.037 & 0.039* & -0.009 & 0.052** & 0.027** & 0.035* \\ 
   & (0.019) & (0.029) & (0.023) & (0.017) & (0.024) & (0.013) & (0.020) \\ 
  $\Delta \ln(T)$ &  &  & -0.005 & -0.005 & -0.004 & 0.002 & -0.006* \\ 
   &  &  & (0.004) & (0.003) & (0.004) & (0.002) & (0.003) \\ 
  $\Delta\ln(D)$ &  &  &  & -0.352*** &  &  &  \\ 
   &  &  &  & (0.018) &  &  &  \\ 
  $\Delta\ln(S)$ &  &  &  &  & -0.638*** & -0.198*** & -0.544*** \\ 
   &  &  &  &  & (0.017) & (0.014) & (0.021) \\ 
  $\Delta\ln(B)$ &  &  &  &  &  & -0.127*** &  \\ 
   &  &  &  &  &  & (0.011) &  \\ 
  $\Delta\ln(C)$ &  &  &  &  &  &  & -0.292*** \\ 
   &  &  &  &  &  &  & (0.024) \\ 
  Fixed Effects &  &  &  &  &  &  &  \\ 
  $\bullet$ Benchmark $\times$ Quarter & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  Observations & 35,311 & 57,284 & 57,284 & 57,284 & 57,284 & 57,284 & 57,284 \\ 
  $R^2$ & 0.113 & 0.053 & 0.096 & 0.301 & 0.280 & 0.134 & 0.256 \\ 
  $R^2$ (proj. model) & 0.002 & 0.003 & 0.015 & 0.226 & 0.230 & 0.076 & 0.208 \\ 
   \bottomrule
\end{tabularx}
\endgroup
\end{table}


\begin{table}[ht]
\centering
\caption{Capital Allocation and Competitor Size --- Pre-2008 Data} 
\label{tab:fundResponse08}
\begingroup\scriptsize
\begin{tabularx}{0.975\textwidth}{lYYYYYYY}
  \multicolumn{8}{p{.975\textwidth}}{\scriptsize Observations are first differences at the fund $\times$ quarter level, from 1980-2007. Dependent variables are noted in the column headers. $AS$ is active share relative to self-declared benchmarks \citep{cp09, petajisto13}. $TL^{-1/2}$ is the turnover to portfolio liquidity ratio, as in \citet{pst17L}. $S$, $D$, $C$, and $B$ are the components of portfolio liquidity, namely stock liquidity, diversification, coverage, and balance (each calculated with respect to all U.S. equity). $\Delta CS_{i,t}=\ln\left(\sum_{j\neq i} \psi_{i,j,t-1} FundSize_{j,t} \right) - \ln\left(\sum_{j\neq i} \psi_{i,j,t-1} FundSize_{j,t-1}\right)$ is the change in log competitor size, holding previous quarter end similarity weights fixed. Standard errors are double clustered by fund and portfolio group $\times$ quarter, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.} \\ \addlinespace \toprule
Dep. Var.: & $\Delta\ln(AS)$ & $\Delta\ln(TL^{-1/2})$ & $\Delta\ln(L)$ & $\Delta\ln(S)$ & $\Delta\ln(D)$ & $\Delta\ln(C)$ & $\Delta\ln(B)$ \\ 
  \midrule
$\Delta CS$ & -0.040** & -0.535*** & 0.865*** & 0.671*** & 0.669*** & 0.170*** & 0.596*** \\ 
   & (0.018) & (0.066) & (0.072) & (0.076) & (0.063) & (0.029) & (0.061) \\ 
  $\Delta\ln(FundSize)$ & -0.017*** & -0.149*** & 0.224*** & 0.131*** & 0.199*** & 0.118*** & 0.122*** \\ 
   & (0.003) & (0.017) & (0.017) & (0.015) & (0.015) & (0.009) & (0.014) \\ 
  $\Delta\ln(f)$ & -0.024 & 0.003 & 0.050** & -0.004 & 0.064** & 0.037*** & 0.040* \\ 
   & (0.018) & (0.029) & (0.024) & (0.022) & (0.026) & (0.014) & (0.021) \\ 
  $\Delta \ln(T)$ &  &  & -0.005 & -0.003 & -0.004 & 0.003 & -0.006 \\ 
   &  &  & (0.006) & (0.005) & (0.005) & (0.003) & (0.005) \\ 
  $\Delta\ln(D)$ &  &  &  & -0.394*** &  &  &  \\ 
   &  &  &  & (0.025) &  &  &  \\ 
  $\Delta\ln(S)$ &  &  &  &  & -0.639*** & -0.166*** & -0.568*** \\ 
   &  &  &  &  & (0.020) & (0.017) & (0.027) \\ 
  $\Delta\ln(B)$ &  &  &  &  &  & -0.122*** &  \\ 
   &  &  &  &  &  & (0.015) &  \\ 
  $\Delta\ln(C)$ &  &  &  &  &  &  & -0.278*** \\ 
   &  &  &  &  &  &  & (0.029) \\ 
  Fixed Effects &  &  &  &  &  &  &  \\ 
  $\bullet$ Quarter & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  Observations & 31,082 & 32,907 & 32,907 & 32,907 & 32,907 & 32,907 & 32,907 \\ 
  $R^2$ & 0.023 & 0.025 & 0.056 & 0.279 & 0.274 & 0.090 & 0.260 \\ 
  $R^2$ (proj. model) & 0.004 & 0.012 & 0.045 & 0.262 & 0.261 & 0.067 & 0.252 \\ 
   \bottomrule
\end{tabularx}
\endgroup
\end{table}


\begin{table}[ht]
\centering
\caption{Capital Allocation and Competitor Size --- Benchmark $\times$ Quarter FE, Pre-2008 Data} 
\label{tab:fundResponseMXBim08}
\begingroup\scriptsize
\begin{tabularx}{0.975\textwidth}{lYYYYYYY}
  \multicolumn{8}{p{.975\textwidth}}{\scriptsize Observations are first differences at the fund $\times$ quarter level, from 1980-2016. Dependent variables are noted in the column headers. $AS$ is active share relative to self-declared benchmarks \citep{cp09, petajisto13}, covering years 1980-2009. $TL^{-1/2}$ is the turnover to portfolio liquidity ratio, as in \citet{pst17L}. $S$, $D$, $C$, and $B$ are the components of portfolio liquidity, namely stock liquidity, diversification, coverage, and balance (each calculated with respect to all U.S. equity). $\Delta CS_{i,t}=\ln\left(\sum_{j\neq i} \psi_{i,j,t-1} FundSize_{j,t} \right) - \ln\left(\sum_{j\neq i} \psi_{i,j,t-1} FundSize_{j,t-1}\right)$ is the change in log competitor size, holding previous quarter end similarity weights fixed. Benchmarks are the indexes which yield the lowest active share, taken from \citet{petajisto13}. I use the most recently available benchmark when one is missing. Standard errors are double clustered by fund and benchmark $\times$ quarter, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.} \\ \addlinespace \toprule
Dep. Var.: & $\Delta\ln(AS)$ & $\Delta\ln(TL^{-1/2})$ & $\Delta\ln(L)$ & $\Delta\ln(S)$ & $\Delta\ln(D)$ & $\Delta\ln(C)$ & $\Delta\ln(B)$ \\ 
  \midrule
$\Delta CS$ & -0.021* & -0.430*** & 0.588*** & 0.399*** & 0.489*** & 0.072* & 0.479*** \\ 
   & (0.012) & (0.081) & (0.078) & (0.076) & (0.072) & (0.040) & (0.064) \\ 
  $\Delta\ln(FundSize)$ & -0.015*** & -0.137*** & 0.203*** & 0.110*** & 0.185*** & 0.114*** & 0.110*** \\ 
   & (0.003) & (0.015) & (0.015) & (0.012) & (0.013) & (0.008) & (0.012) \\ 
  $\Delta\ln(f)$ & -0.025 & -0.002 & 0.054** & -0.002 & 0.067** & 0.036** & 0.044* \\ 
   & (0.020) & (0.032) & (0.026) & (0.020) & (0.029) & (0.015) & (0.023) \\ 
  $\Delta \ln(T)$ &  &  & -0.006 & -0.004 & -0.005 & 0.002 & -0.007 \\ 
   &  &  & (0.006) & (0.005) & (0.005) & (0.003) & (0.005) \\ 
  $\Delta\ln(D)$ &  &  &  & -0.390*** &  &  &  \\ 
   &  &  &  & (0.023) &  &  &  \\ 
  $\Delta\ln(S)$ &  &  &  &  & -0.643*** & -0.168*** & -0.570*** \\ 
   &  &  &  &  & (0.019) & (0.017) & (0.025) \\ 
  $\Delta\ln(B)$ &  &  &  &  &  & -0.123*** &  \\ 
   &  &  &  &  &  & (0.015) &  \\ 
  $\Delta\ln(C)$ &  &  &  &  &  &  & -0.277*** \\ 
   &  &  &  &  &  &  & (0.030) \\ 
  Fixed Effects &  &  &  &  &  &  &  \\ 
  $\bullet$ Benchmark $\times$ Quarter & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  Observations & 31,082 & 32,907 & 32,907 & 32,907 & 32,907 & 32,907 & 32,907 \\ 
  $R^2$ & 0.114 & 0.063 & 0.105 & 0.325 & 0.309 & 0.128 & 0.297 \\ 
  $R^2$ (proj. model) & 0.002 & 0.007 & 0.022 & 0.253 & 0.258 & 0.065 & 0.250 \\ 
   \bottomrule
\end{tabularx}
\endgroup
\end{table}


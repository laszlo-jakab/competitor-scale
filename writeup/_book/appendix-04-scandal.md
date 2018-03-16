# Additional Results: Mutual Fund Scandal




\begin{table}[ht]
\centering
\caption{Fund Characteristics as of August 2003 by Scandal Involvement} 
\label{tab:snapShot200308}
\begingroup\scriptsize
\begin{tabularx}{0.975\textwidth}{lZZ}
  \multicolumn{3}{p{.975\textwidth}}{Means of various characteristics as of August 2003, depending on whether the family the fund belongs to was later implicated in the late trading scandal. Returns are annualized, in percentages. Fund families are assigned to scandal involvement according to Table 1 of \citet{hg05}.}\\
 \addlinespace \toprule
Scandal involvement & No & Yes \\ 
  \midrule
N & 1,173 & 289 \\ 
  $CompetitorSize \times 10^2$ & 0.41 & 0.49 \\ 
  TNA (100m \$) & 10.72 & 12.52 \\ 
  $R^{FF3}$ & -6.77 & -10.31 \\ 
  Fund age & 11.62 & 14.73 \\ 
  Expense ratio & 1.35 & 1.46 \\ 
  $AS$ & 0.72 & 0.79 \\ 
  $T$ & 0.84 & 1 \\ 
  $L$ & 0.06 & 0.06 \\ 
  $ln(TL^{-1/2})$ & 1.35 & 1.46 \\ 
   \bottomrule
\end{tabularx}
\endgroup
\end{table}


\begin{table}[ht]
\centering
\caption{Snapshot of Untainted Fund Characteristics as of August 2003} 
\label{tab:snapShotHL200308}
\begingroup\scriptsize
\begin{tabularx}{0.975\textwidth}{lZZ}
  \multicolumn{3}{p{.975\textwidth}}{}\\
 \addlinespace \toprule
$ScandalExposure$: & Below median & Above median \\ 
  \midrule
N & 587 & 586 \\ 
  $CompetitorSize \times 10^2$ & 0.38 & 0.44 \\ 
  TNA (100m \$) & 10.97 & 10.47 \\ 
  $R^{FF3}$ & -2.35 & -11.15 \\ 
  Fund age & 11.57 & 11.66 \\ 
  Expense ratio & 1.31 & 1.38 \\ 
  $AS$ & 0.71 & 0.74 \\ 
  $T$ & 0.72 & 0.96 \\ 
  $L$ & 0.06 & 0.05 \\ 
  $ln(TL^{-1/2})$ & 1.18 & 1.51 \\ 
   \bottomrule
\end{tabularx}
\endgroup
\end{table}



\begin{table}[ht]
\centering
\caption{Capital Allocation and the Scandal: Testing for Pre-Trends} 
\label{tab:scandalSpilloverPreTrend}
\begingroup\scriptsize
\begin{tabularx}{0.975\textwidth}{lYYYYYYYY}
  \multicolumn{9}{p{.975\textwidth}}{The estimation sample includes only funds not directly involved in the scandal, over the period $[2003m8-W, 2003m8]$. Dependent variables are noted in the table header. For regressions with $\ln(TL^{-1/2})$ as the dependent variable, observations are at the fund-month level. Other specifications are at the fund-report date level. $ScandalExposure$ (abbreviated $ScanEx$) is the fraction of untainted funds' $CompetitorSize$ due to portfolio similarity with future scandal funds in August 2003. $ScandalExposure$ is normalized by its interquartile range. Standard errors are double clustered by fund and portfolio group $\times$ time, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.}\\
\addlinespace \toprule
Dep. Var.: & $\ln(C.S.)$ & $\ln(AS)$ & $\ln(TL^{-1/2})$ & $\ln(L)$ & $\ln(S)$ & $\ln(D)$ & $\ln(C)$ & $\ln(B)$ \\ 
  \midrule \\
 \multicolumn{9}{c}{\textbf{Panel A: 1 year window}}\\
 \midrule
$t \times ScanEx$ & 0.106 & 0.016 & 0.665 & 0.302 & 0.396 & 0.091 & 0.236 & -0.106 \\ 
   & (0.434) & (0.106) & (0.442) & (0.481) & (0.422) & (0.386) & (0.215) & (0.332) \\ 
  $\ln(FundSize)$ & 0.085 & 0.025 & -0.148*** & 0.090 & 0.053 & 0.075 & 0.023 & 0.063 \\ 
   & (0.059) & (0.026) & (0.048) & (0.059) & (0.052) & (0.058) & (0.037) & (0.047) \\ 
  $\ln(f)$ & 0.080 & 0.065 & 0.059 & 0.042 & 0.011 & 0.045 & -0.059 & 0.101 \\ 
   & (0.188) & (0.064) & (0.217) & (0.187) & (0.095) & (0.183) & (0.105) & (0.138) \\ 
  $\ln(T)$ &  &  &  & -0.008 & -0.000 & -0.009 & -0.011 & -0.001 \\ 
   &  &  &  & (0.019) & (0.015) & (0.019) & (0.015) & (0.014) \\ 
  $\ln(D)$ &  &  &  &  & -0.350*** &  &  &  \\ 
   &  &  &  &  & (0.075) &  &  &  \\ 
  $\ln(S)$ &  &  &  &  &  & -0.527*** & -0.273*** & -0.346*** \\ 
   &  &  &  &  &  & (0.126) & (0.076) & (0.119) \\ 
  $\ln(B)$ &  &  &  &  &  &  & -0.126** &  \\ 
   &  &  &  &  &  &  & (0.061) &  \\ 
  $\ln(C)$ &  &  &  &  &  &  &  & -0.235** \\ 
   &  &  &  &  &  &  &  & (0.117) \\ 
  Fixed Effects &  &  &  &  &  &  &  &  \\ 
  $\bullet$ Fund & Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  $\bullet$ Time & Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  Observations & 3,141 & 2,710 & 12,025 & 3,093 & 3,093 & 3,093 & 3,093 & 3,093 \\ 
  $R^2$ & 0.973 & 0.973 & 0.966 & 0.989 & 0.995 & 0.982 & 0.982 & 0.965 \\ 
  $R^2$ (proj. model) & 0.003 & 0.005 & 0.008 & 0.004 & 0.187 & 0.186 & 0.127 & 0.111 \\ 
   \midrule \\
 \multicolumn{9}{c}{\textbf{Panel B: 2 year window}} \\
 \midrule $t \times ScanEx$ & 0.267 & -0.010 & 0.621** & 0.147 & -0.005 & 0.180 & -0.017 & 0.214 \\ 
   & (0.220) & (0.055) & (0.289) & (0.242) & (0.155) & (0.241) & (0.140) & (0.209) \\ 
  $\ln(FundSize)$ & 0.197*** & -0.012 & -0.194*** & 0.262*** & 0.142*** & 0.221*** & 0.088*** & 0.162*** \\ 
   & (0.033) & (0.009) & (0.039) & (0.042) & (0.032) & (0.038) & (0.021) & (0.035) \\ 
  $\ln(f)$ & -0.021 & -0.021 & 0.164 & 0.013 & -0.078 & 0.068 & 0.018 & 0.058 \\ 
   & (0.079) & (0.033) & (0.113) & (0.107) & (0.080) & (0.093) & (0.061) & (0.082) \\ 
  $\ln(T)$ &  &  &  & -0.016 & -0.017 & -0.008 & -0.009 & -0.001 \\ 
   &  &  &  & (0.027) & (0.019) & (0.024) & (0.015) & (0.018) \\ 
  $\ln(D)$ &  &  &  &  & -0.304*** &  &  &  \\ 
   &  &  &  &  & (0.037) &  &  &  \\ 
  $\ln(S)$ &  &  &  &  &  & -0.538*** & -0.241*** & -0.369*** \\ 
   &  &  &  &  &  & (0.077) & (0.053) & (0.075) \\ 
  $\ln(B)$ &  &  &  &  &  &  & -0.106*** &  \\ 
   &  &  &  &  &  &  & (0.036) &  \\ 
  $\ln(C)$ &  &  &  &  &  &  &  & -0.179*** \\ 
   &  &  &  &  &  &  &  & (0.064) \\ 
  Fixed Effects &  &  &  &  &  &  &  &  \\ 
  $\bullet$ Fund & Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  $\bullet$ Time & Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  Observations & 6,004 & 5,198 & 22,951 & 5,898 & 5,898 & 5,898 & 5,898 & 5,898 \\ 
  $R^2$ & 0.949 & 0.955 & 0.937 & 0.977 & 0.990 & 0.960 & 0.958 & 0.926 \\ 
  $R^2$ (proj. model) & 0.037 & 0.002 & 0.023 & 0.053 & 0.177 & 0.181 & 0.086 & 0.124 \\ 
   \bottomrule
\end{tabularx}
\endgroup
\end{table}


\begin{table}[ht]
\centering
\caption{Capital Allocation and the Scandal: Before and After Analysis --- Benchmark $\times$ Date FE} 
\label{tab:scandalSpilloverMXBim}
\begingroup\scriptsize
\begin{tabularx}{0.975\textwidth}{lYYYYYYYY}
  \multicolumn{9}{p{.975\textwidth}}{Dependent variables are identified in the column headers. $\ln(C.S.)$ is an abbreviation for $\ln(CompetitorSize)$. For regressions with $\ln(TL^{-1/2})$ as the dependent variable, observations are at the fund-month level. Other specifications are at the fund-report date level. The estimation sample includes only funds not directly involved in the scandal. It covers the period $\{(2003m8-W, 2003m8], [2004m11, 2004m11 + W) \}$, where $W$ corresponds to the number of years specified. $ScandalExposure$ (abbreviated to $ScanEx$) is the fraction of untainted funds' $CompetitorSize$ due to portfolio similarity with future scandal funds in August 2003. $ScandalExposure$ is normalized by its interquartile range. $\mathbb{I}$ is an indicator for the post scandal period. Benchmarks are the indexes which yield the lowest active share, taken from \citet{petajisto13}. I use the most recently available benchmark when one is missing. Standard errors are double clustered by fund and benchmark $\times$ date, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.}\\
\addlinespace \toprule
Dep. Var.: & $\ln(C.S.)$ & $\ln(AS)$ & $\ln(TL^{-1/2})$ & $\ln(L)$ & $\ln(S)$ & $\ln(D)$ & $\ln(C)$ & $\ln(B)$ \\ 
  \midrule \\
 \multicolumn{9}{c}{\textbf{Panel A: 1 year window}}\\
 \midrule
$\mathbb{I}\times ScanEx$ & -0.050** & 0.018*** & -0.019 & -0.076*** & -0.067*** & -0.040 & -0.025 & -0.017 \\ 
   & (0.021) & (0.006) & (0.033) & (0.028) & (0.021) & (0.025) & (0.016) & (0.019) \\ 
  $\ln(FundSize)$ & 0.124*** & -0.006 & -0.140*** & 0.148*** & 0.058*** & 0.128*** & 0.062*** & 0.074*** \\ 
   & (0.020) & (0.006) & (0.029) & (0.026) & (0.013) & (0.025) & (0.019) & (0.017) \\ 
  $\ln(f)$ & 0.006 & -0.016 & 0.031 & 0.017 & -0.085 & 0.078 & 0.072 & 0.012 \\ 
   & (0.105) & (0.027) & (0.132) & (0.118) & (0.074) & (0.112) & (0.071) & (0.085) \\ 
  $\ln(T)$ &  &  &  & -0.051* & -0.050*** & -0.023 & 0.028* & -0.052*** \\ 
   &  &  &  & (0.027) & (0.015) & (0.026) & (0.015) & (0.019) \\ 
  $\ln(D)$ &  &  &  &  & -0.193*** &  &  &  \\ 
   &  &  &  &  & (0.023) &  &  &  \\ 
  $\ln(S)$ &  &  &  &  &  & -0.441*** & -0.248*** & -0.222*** \\ 
   &  &  &  &  &  & (0.054) & (0.043) & (0.050) \\ 
  $\ln(B)$ &  &  &  &  &  &  & -0.051* &  \\ 
   &  &  &  &  &  &  & (0.031) &  \\ 
  $\ln(C)$ &  &  &  &  &  &  &  & -0.077* \\ 
   &  &  &  &  &  &  &  & (0.046) \\ 
  Fixed Effects &  &  &  &  &  &  &  &  \\ 
  $\bullet$ Fund & Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  $\bullet$ Benchmark $\times$ Time & Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  Observations & 7,079 & 6,072 & 24,192 & 6,893 & 6,893 & 6,893 & 6,893 & 6,893 \\ 
  $R^2$ & 0.932 & 0.932 & 0.903 & 0.966 & 0.990 & 0.946 & 0.949 & 0.900 \\ 
  $R^2$ (proj. model) & 0.039 & 0.008 & 0.015 & 0.046 & 0.114 & 0.102 & 0.079 & 0.048 \\ 
   \midrule \\
 \multicolumn{9}{c}{\textbf{Panel B: 2 year window}} \\
 \midrule $\mathbb{I}\times ScanEx$ & -0.022 & 0.020*** & -0.013 & -0.067** & -0.076*** & -0.020 & -0.029* & 0.007 \\ 
   & (0.022) & (0.006) & (0.033) & (0.029) & (0.023) & (0.025) & (0.017) & (0.019) \\ 
  $\ln(FundSize)$ & 0.138*** & -0.010* & -0.178*** & 0.165*** & 0.059*** & 0.143*** & 0.067*** & 0.084*** \\ 
   & (0.017) & (0.006) & (0.024) & (0.024) & (0.012) & (0.023) & (0.016) & (0.016) \\ 
  $\ln(f)$ & -0.089 & 0.007 & 0.109 & -0.072 & -0.140** & 0.020 & 0.071 & -0.048 \\ 
   & (0.070) & (0.025) & (0.110) & (0.107) & (0.064) & (0.092) & (0.063) & (0.074) \\ 
  $\ln(T)$ &  &  &  & -0.040* & -0.044*** & -0.013 & 0.028** & -0.041*** \\ 
   &  &  &  & (0.023) & (0.012) & (0.021) & (0.014) & (0.015) \\ 
  $\ln(D)$ &  &  &  &  & -0.172*** &  &  &  \\ 
   &  &  &  &  & (0.019) &  &  &  \\ 
  $\ln(S)$ &  &  &  &  &  & -0.404*** & -0.224*** & -0.203*** \\ 
   &  &  &  &  &  & (0.042) & (0.034) & (0.040) \\ 
  $\ln(B)$ &  &  &  &  &  &  & -0.046** &  \\ 
   &  &  &  &  &  &  & (0.023) &  \\ 
  $\ln(C)$ &  &  &  &  &  &  &  & -0.067** \\ 
   &  &  &  &  &  &  &  & (0.033) \\ 
  Fixed Effects &  &  &  &  &  &  &  &  \\ 
  $\bullet$ Fund & Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  $\bullet$ Benchmark $\times$ Time & Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  Observations & 13,666 & 11,773 & 46,660 & 13,291 & 13,291 & 13,291 & 13,291 & 13,291 \\ 
  $R^2$ & 0.905 & 0.898 & 0.867 & 0.949 & 0.985 & 0.921 & 0.924 & 0.859 \\ 
  $R^2$ (proj. model) & 0.052 & 0.010 & 0.031 & 0.056 & 0.102 & 0.094 & 0.066 & 0.048 \\ 
   \bottomrule
\end{tabularx}
\endgroup
\end{table}


\begin{table}[ht]
\centering
\caption{Capital Allocation and the Scandal: Testing for Pre-Trends --- Benchmark $\times$ Time FE} 
\label{tab:scandalSpilloverPreTrendMXBim}
\begingroup\scriptsize
\begin{tabularx}{0.975\textwidth}{lYYYYYYYY}
  \multicolumn{9}{p{.975\textwidth}}{The estimation sample includes only funds not directly involved in the scandal, over the period $[2003m8-W, 2003m8]$. Dependent variables are noted in the table header. For regressions with $\ln(TL^{-1/2})$ as the dependent variable, observations are at the fund-month level. Other specifications are at the fund-report date level. $ScandalExposure$ (abbreviated $ScanEx$) is the fraction of untainted funds' $CompetitorSize$ due to portfolio similarity with future scandal funds in August 2003. $ScandalExposure$ is normalized by its interquartile range. Benchmarks are the indexes which yield the lowest active share, taken from \citet{petajisto13}. I use the most recently available benchmark when one is missing. Standard errors are double clustered by fund and benchmark $\times$ time, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.}\\
\addlinespace \toprule
Dep. Var.: & $\ln(C.S.)$ & $\ln(AS)$ & $\ln(TL^{-1/2})$ & $\ln(L)$ & $\ln(S)$ & $\ln(D)$ & $\ln(C)$ & $\ln(B)$ \\ 
  \midrule \\
 \multicolumn{9}{c}{\textbf{Panel A: 1 year window}}\\
 \midrule
$t \times ScanEx$ & 0.112 & 0.071 & 0.433 & 0.339 & -0.035 & 0.415 & 0.063 & 0.404 \\ 
   & (0.487) & (0.123) & (0.511) & (0.449) & (0.331) & (0.449) & (0.248) & (0.389) \\ 
  $\ln(FundSize)$ & 0.067 & 0.015 & -0.146*** & 0.082 & 0.079** & 0.052 & 0.003 & 0.055 \\ 
   & (0.056) & (0.014) & (0.048) & (0.052) & (0.035) & (0.054) & (0.037) & (0.040) \\ 
  $\ln(f)$ & 0.133 & 0.037 & 0.071 & 0.142 & 0.073 & 0.126 & -0.036 & 0.171 \\ 
   & (0.195) & (0.049) & (0.218) & (0.155) & (0.088) & (0.150) & (0.087) & (0.131) \\ 
  $\ln(T)$ &  &  &  & -0.009 & -0.004 & -0.009 & -0.013 & 0.001 \\ 
   &  &  &  & (0.021) & (0.015) & (0.020) & (0.014) & (0.017) \\ 
  $\ln(D)$ &  &  &  &  & -0.303*** &  &  &  \\ 
   &  &  &  &  & (0.057) &  &  &  \\ 
  $\ln(S)$ &  &  &  &  &  & -0.615*** & -0.324*** & -0.397*** \\ 
   &  &  &  &  &  & (0.073) & (0.088) & (0.099) \\ 
  $\ln(B)$ &  &  &  &  &  &  & -0.122* &  \\ 
   &  &  &  &  &  &  & (0.065) &  \\ 
  $\ln(C)$ &  &  &  &  &  &  &  & -0.229* \\ 
   &  &  &  &  &  &  &  & (0.121) \\ 
  Fixed Effects &  &  &  &  &  &  &  &  \\ 
  $\bullet$ Fund & Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  $\bullet$ Benchmark $\times$ Time & Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  Observations & 3,141 & 2,710 & 12,025 & 3,093 & 3,093 & 3,093 & 3,093 & 3,093 \\ 
  $R^2$ & 0.976 & 0.981 & 0.968 & 0.991 & 0.997 & 0.985 & 0.985 & 0.969 \\ 
  $R^2$ (proj. model) & 0.003 & 0.003 & 0.006 & 0.004 & 0.191 & 0.188 & 0.132 & 0.108 \\ 
   \midrule \\
 \multicolumn{9}{c}{\textbf{Panel B: 2 year window}} \\
 \midrule $t \times ScanEx$ & 0.351 & -0.011 & 0.851*** & 0.322 & 0.011 & 0.370 & -0.090 & 0.485** \\ 
   & (0.273) & (0.060) & (0.329) & (0.282) & (0.180) & (0.272) & (0.137) & (0.246) \\ 
  $\ln(FundSize)$ & 0.183*** & -0.015 & -0.198*** & 0.266*** & 0.131*** & 0.226*** & 0.089*** & 0.162*** \\ 
   & (0.034) & (0.009) & (0.040) & (0.045) & (0.029) & (0.042) & (0.023) & (0.037) \\ 
  $\ln(f)$ & -0.028 & -0.025 & 0.174 & 0.002 & -0.063 & 0.044 & 0.016 & 0.033 \\ 
   & (0.081) & (0.032) & (0.112) & (0.105) & (0.067) & (0.094) & (0.057) & (0.081) \\ 
  $\ln(T)$ &  &  &  & -0.014 & -0.016 & -0.006 & -0.008 & 0.001 \\ 
   &  &  &  & (0.027) & (0.017) & (0.024) & (0.015) & (0.018) \\ 
  $\ln(D)$ &  &  &  &  & -0.263*** &  &  &  \\ 
   &  &  &  &  & (0.038) &  &  &  \\ 
  $\ln(S)$ &  &  &  &  &  & -0.517*** & -0.244*** & -0.335*** \\ 
   &  &  &  &  &  & (0.082) & (0.059) & (0.084) \\ 
  $\ln(B)$ &  &  &  &  &  &  & -0.089** &  \\ 
   &  &  &  &  &  &  & (0.037) &  \\ 
  $\ln(C)$ &  &  &  &  &  &  &  & -0.157** \\ 
   &  &  &  &  &  &  &  & (0.068) \\ 
  Fixed Effects &  &  &  &  &  &  &  &  \\ 
  $\bullet$ Fund & Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  $\bullet$ Benchmark $\times$ Time & Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  Observations & 6,004 & 5,198 & 22,951 & 5,898 & 5,898 & 5,898 & 5,898 & 5,898 \\ 
  $R^2$ & 0.953 & 0.962 & 0.939 & 0.979 & 0.992 & 0.963 & 0.963 & 0.933 \\ 
  $R^2$ (proj. model) & 0.030 & 0.003 & 0.023 & 0.051 & 0.148 & 0.156 & 0.083 & 0.099 \\ 
   \bottomrule
\end{tabularx}
\endgroup
\end{table}


\begin{table}[ht]
\centering
\caption{Capital Allocation and the Scandal: Using Abnormal Flows --- Benchmark $\times$ Time FE} 
\label{tab:scandalSpilloverIVMXBim}
\begingroup\scriptsize
\begin{tabularx}{0.975\textwidth}{lYYYYYYYY}
  \multicolumn{9}{p{.975\textwidth}}{Dependent variables are identified in the column headers. For regressions with $\ln(TL^{-1/2})$ as the dependent variable, observations are at the fund-month level. Other specifications are at the fund-report date level. The estimation sample includes untainted funds during $\{[2003m9-W, 2004m10+W] \}$, where $W$ corresponds to the number of years specified at the bottom of each panel. $ScandalOutFlow$ is the similarity-weighted cumulative abnormal outflows attributable to the scandal among involved funds. $ScandalOutFlow$ is normalized by its interquartile range. $\ln(C.S.)$ is an abbreviation for $\ln(CompetitorSize)$. Benchmarks are the indexes which yield the lowest active share, taken from \citet{petajisto13}. I use the most recently available benchmark when one is missing. Standard errors are double clustered by fund and benchmark $\times$ time, and reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.}\\
\addlinespace \toprule
Dep. Var.: & $\ln(C.S.)$ & $\ln(AS)$ & $\ln(TL^{-1/2})$ & $\ln(L)$ & $\ln(S)$ & $\ln(D)$ & $\ln(C)$ & $\ln(B)$ \\ 
  \midrule \\
 \multicolumn{9}{c}{\textbf{Panel A: 1 year window}}\\
 \midrule
$ScandalOutFlow$ & -0.199*** & 0.058*** & 0.093*** & -0.246*** & -0.111*** & -0.213*** & -0.075*** & -0.161*** \\ 
   & (0.020) & (0.008) & (0.030) & (0.028) & (0.017) & (0.026) & (0.017) & (0.019) \\ 
  $\ln(FundSize)$ & 0.090*** & -0.006 & -0.122*** & 0.124*** & 0.057*** & 0.106*** & 0.068*** & 0.051*** \\ 
   & (0.017) & (0.005) & (0.027) & (0.022) & (0.012) & (0.021) & (0.016) & (0.015) \\ 
  $\ln(f)$ & -0.066 & -0.010 & 0.041 & -0.031 & -0.074 & 0.011 & 0.065 & -0.049 \\ 
   & (0.075) & (0.023) & (0.108) & (0.089) & (0.055) & (0.087) & (0.057) & (0.065) \\ 
  $\ln(T)$ &  &  &  & -0.048** & -0.036*** & -0.032* & 0.015 & -0.049*** \\ 
   &  &  &  & (0.019) & (0.011) & (0.018) & (0.011) & (0.014) \\ 
  $\ln(D)$ &  &  &  &  & -0.235*** &  &  &  \\ 
   &  &  &  &  & (0.021) &  &  &  \\ 
  $\ln(S)$ &  &  &  &  &  & -0.518*** & -0.265*** & -0.313*** \\ 
   &  &  &  &  &  & (0.047) & (0.036) & (0.046) \\ 
  $\ln(B)$ &  &  &  &  &  &  & -0.091*** &  \\ 
   &  &  &  &  &  &  & (0.027) &  \\ 
  $\ln(C)$ &  &  &  &  &  &  &  & -0.148*** \\ 
   &  &  &  &  &  &  &  & (0.042) \\ 
  Fixed Effects &  &  &  &  &  &  &  &  \\ 
  $\bullet$ Fund & Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  $\bullet$ Benchmark $\times$ Time & Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  Observations & 12,095 & 10,334 & 39,784 & 11,689 & 11,689 & 11,689 & 11,689 & 11,689 \\ 
  $R^2$ & 0.939 & 0.945 & 0.909 & 0.971 & 0.991 & 0.953 & 0.954 & 0.909 \\ 
  $R^2$ (proj. model) & 0.075 & 0.053 & 0.015 & 0.088 & 0.141 & 0.160 & 0.095 & 0.100 \\ 
   \midrule \\
 \multicolumn{9}{c}{\textbf{Panel B: 2 year window}} \\
 \midrule $ScandalOutFlow$ & -0.161*** & 0.059*** & 0.102*** & -0.224*** & -0.107*** & -0.186*** & -0.069*** & -0.133*** \\ 
   & (0.018) & (0.007) & (0.026) & (0.026) & (0.016) & (0.024) & (0.017) & (0.017) \\ 
  $\ln(FundSize)$ & 0.114*** & -0.008 & -0.164*** & 0.143*** & 0.058*** & 0.125*** & 0.069*** & 0.068*** \\ 
   & (0.014) & (0.005) & (0.023) & (0.020) & (0.011) & (0.020) & (0.014) & (0.014) \\ 
  $\ln(f)$ & -0.123** & 0.010 & 0.132 & -0.109 & -0.143** & -0.031 & 0.060 & -0.091 \\ 
   & (0.058) & (0.022) & (0.093) & (0.095) & (0.058) & (0.082) & (0.054) & (0.067) \\ 
  $\ln(T)$ &  &  &  & -0.037** & -0.036*** & -0.019 & 0.019* & -0.039*** \\ 
   &  &  &  & (0.019) & (0.010) & (0.018) & (0.012) & (0.013) \\ 
  $\ln(D)$ &  &  &  &  & -0.212*** &  &  &  \\ 
   &  &  &  &  & (0.018) &  &  &  \\ 
  $\ln(S)$ &  &  &  &  &  & -0.487*** & -0.251*** & -0.282*** \\ 
   &  &  &  &  &  & (0.038) & (0.031) & (0.039) \\ 
  $\ln(B)$ &  &  &  &  &  &  & -0.078*** &  \\ 
   &  &  &  &  &  &  & (0.022) &  \\ 
  $\ln(C)$ &  &  &  &  &  &  &  & -0.116*** \\ 
   &  &  &  &  &  &  &  & (0.032) \\ 
  Fixed Effects &  &  &  &  &  &  &  &  \\ 
  $\bullet$ Fund & Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  $\bullet$ Benchmark $\times$ Time & Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  Observations & 18,904 & 16,211 & 63,055 & 18,309 & 18,309 & 18,309 & 18,309 & 18,309 \\ 
  $R^2$ & 0.913 & 0.913 & 0.875 & 0.955 & 0.986 & 0.930 & 0.930 & 0.871 \\ 
  $R^2$ (proj. model) & 0.077 & 0.058 & 0.033 & 0.094 & 0.130 & 0.144 & 0.083 & 0.086 \\ 
   \bottomrule
\end{tabularx}
\endgroup
\end{table}


\begin{table}[ht]
\centering
\caption{Capital Allocation and the Scandal: Instrumenting Competitor Size with Abnormal Flows} 
\label{tab:scandal2SLS}
\begingroup\scriptsize
\begin{tabularx}{0.975\textwidth}{lYYYYYYY}
  \multicolumn{8}{p{.975\textwidth}}{The estimation sample includes only funds not directly involved in the scandal, over the period $\{[2003m9-W, 2004m10+W] \}$, where $W$ corresponds to the number of years specified. Dependent variables are noted in the column headers. For regressions with $\ln(TL^{-1/2})$ as the dependent variable, observations are at the fund-month level. Other specifications are at the fund-report date level. $ScandalOutFlow$ is the similarity-weighted cumulative abnormal outflows attributable to the scandal among involved funds. $ScandalOutFlow$ is normalized by its interquartile range. I estimate regressions via two stage least squares, instrumenting for $\ln(CompetitorSize_{i,t})$ with $ScandalOutFlow_{i,t}$. The F-statistic of the first stage relation is reported at the bottom of each panel. Standard errors are double clustered by fund and portfolio group $\times$ time, and are reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.}\\
\addlinespace \toprule
Dep. Var.: & $\ln(AS)$ & $\ln(TL^{-1/2})$ & $\ln(L)$ & $\ln(S)$ & $\ln(D)$ & $\ln(C)$ & $\ln(B)$ \\ 
  \midrule \\
 \multicolumn{8}{c}{\textbf{Panel A: 1 year window}}\\
 \midrule
$\ln(CompetitorSize)$ & -0.331*** & -0.642*** & 1.212*** & 1.014*** & 1.077*** & 0.824*** & 0.856*** \\ 
   & (0.044) & (0.134) & (0.087) & (0.115) & (0.086) & (0.137) & (0.073) \\ 
  $\ln(FundSize)$ & 0.020** & -0.088*** & 0.030* & 0.026* & 0.026 & 0.031* & 0.004 \\ 
   & (0.008) & (0.030) & (0.018) & (0.015) & (0.017) & (0.017) & (0.012) \\ 
  $\ln(f)$ & -0.025 & 0.002 & 0.034 & 0.012 & 0.049 & 0.068 & -0.009 \\ 
   & (0.033) & (0.106) & (0.081) & (0.070) & (0.074) & (0.067) & (0.050) \\ 
  $\ln(T)$ &  &  & -0.043*** & -0.041*** & -0.032*** & -0.014 & -0.043*** \\ 
   &  &  & (0.013) & (0.011) & (0.012) & (0.011) & (0.009) \\ 
  $\ln(D)$ &  &  &  & -0.739*** &  &  &  \\ 
   &  &  &  & (0.060) &  &  &  \\ 
  $\ln(S)$ &  &  &  &  & -0.705*** & -0.560*** & -0.528*** \\ 
   &  &  &  &  & (0.036) & (0.059) & (0.040) \\ 
  $\ln(B)$ &  &  &  &  &  & -0.636*** &  \\ 
   &  &  &  &  &  & (0.095) &  \\ 
  $\ln(C)$ &  &  &  &  &  &  & -0.422*** \\ 
   &  &  &  &  &  &  & (0.041) \\ 
  Fixed Effects &  &  &  &  &  &  &  \\ 
  $\bullet$ Fund & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  $\bullet$ Time & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  Observations & 10,334 & 39,784 & 11,689 & 11,689 & 11,689 & 11,689 & 11,689 \\ 
  F (first stage) & 55.4 & 23.0 & 194.7 & 78.1 & 158.2 & 36.2 & 136.6 \\ 
   \midrule \\
 \multicolumn{8}{c}{\textbf{Panel B: 2 year window}} \\
 \midrule $\ln(CompetitorSize)$ & -0.359*** & -0.670*** & 1.240*** & 1.089*** & 1.045*** & 0.802*** & 0.792*** \\ 
   & (0.044) & (0.134) & (0.095) & (0.123) & (0.091) & (0.132) & (0.080) \\ 
  $\ln(FundSize)$ & 0.028*** & -0.106*** & 0.018 & 0.013 & 0.020 & 0.021 & 0.007 \\ 
   & (0.009) & (0.027) & (0.018) & (0.016) & (0.017) & (0.016) & (0.012) \\ 
  $\ln(f)$ & -0.034 & 0.054 & 0.034 & -0.001 & 0.076 & 0.095* & 0.003 \\ 
   & (0.026) & (0.093) & (0.067) & (0.064) & (0.058) & (0.052) & (0.047) \\ 
  $\ln(T)$ &  &  & -0.035*** & -0.037*** & -0.020* & -0.003 & -0.033*** \\ 
   &  &  & (0.013) & (0.011) & (0.012) & (0.011) & (0.009) \\ 
  $\ln(D)$ &  &  &  & -0.775*** &  &  &  \\ 
   &  &  &  & (0.062) &  &  &  \\ 
  $\ln(S)$ &  &  &  &  & -0.657*** & -0.513*** & -0.484*** \\ 
   &  &  &  &  & (0.028) & (0.049) & (0.037) \\ 
  $\ln(B)$ &  &  &  &  &  & -0.606*** &  \\ 
   &  &  &  &  &  & (0.088) &  \\ 
  $\ln(C)$ &  &  &  &  &  &  & -0.408*** \\ 
   &  &  &  &  &  &  & (0.038) \\ 
  Fixed Effects &  &  &  &  &  &  &  \\ 
  $\bullet$ Fund & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  $\bullet$ Time & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  Observations & 16,211 & 63,055 & 18,309 & 18,309 & 18,309 & 18,309 & 18,309 \\ 
  F (first stage) & 65.9 & 24.9 & 170.6 & 78.2 & 133.3 & 36.7 & 97.6 \\ 
   \bottomrule
\end{tabularx}
\endgroup
\end{table}


\begin{table}[ht]
\centering
\caption{Capital Allocation and the Scandal: Instrumenting Competitor Size with Abnormal Flows --- Benchmark $\times$ Time FE} 
\label{tab:scandal2SLSmXbim}
\begingroup\scriptsize
\begin{tabularx}{0.975\textwidth}{lYYYYYYY}
  \multicolumn{8}{p{.975\textwidth}}{The estimation sample includes only funds not directly involved in the scandal, over the period $\{[2003m9-W, 2004m10+W] \}$, where $W$ corresponds to the number of years specified. Dependent variables are noted in the column headers. For regressions with $\ln(TL^{-1/2})$ as the dependent variable, observations are at the fund-month level. Other specifications are at the fund-report date level. $ScandalOutFlow$ is the similarity-weighted cumulative abnormal outflows attributable to the scandal among involved funds. $ScandalOutFlow$ is normalized by its interquartile range. I estimate regressions via two stage least squares, instrumenting for $\ln(CompetitorSize_{i,t})$ with $ScandalOutFlow_{i,t}$. The F-statistic of the first stage relation is reported at the bottom of each panel. Standard errors are double clustered by fund and benchmark $\times$ time, and are reported in parentheses. Asterisks denote statistical significance: *** $p<$0.01, ** $p<$0.05, * $p<$0.1.}\\
\addlinespace \toprule
Dep. Var.: & $\ln(AS)$ & $\ln(TL^{-1/2})$ & $\ln(L)$ & $\ln(S)$ & $\ln(D)$ & $\ln(C)$ & $\ln(B)$ \\ 
  \midrule \\
 \multicolumn{8}{c}{\textbf{Panel A: 1 year window}}\\
 \midrule
$\ln(CompetitorSize)$ & -0.299*** & -0.476*** & 1.230*** & 0.970*** & 1.131*** & 0.856*** & 0.954*** \\ 
   & (0.045) & (0.152) & (0.098) & (0.141) & (0.099) & (0.184) & (0.087) \\ 
  $\ln(FundSize)$ & 0.021** & -0.078*** & 0.014 & 0.011 & 0.012 & 0.021 & -0.008 \\ 
   & (0.009) & (0.030) & (0.019) & (0.015) & (0.018) & (0.018) & (0.013) \\ 
  $\ln(f)$ & -0.022 & 0.017 & 0.031 & 0.001 & 0.051 & 0.061 & 0.006 \\ 
   & (0.030) & (0.103) & (0.078) & (0.065) & (0.074) & (0.065) & (0.054) \\ 
  $\ln(T)$ &  &  & -0.034*** & -0.033*** & -0.026** & -0.010 & -0.038*** \\ 
   &  &  & (0.012) & (0.010) & (0.011) & (0.011) & (0.009) \\ 
  $\ln(D)$ &  &  &  & -0.706*** &  &  &  \\ 
   &  &  &  & (0.074) &  &  &  \\ 
  $\ln(S)$ &  &  &  &  & -0.716*** & -0.573*** & -0.553*** \\ 
   &  &  &  &  & (0.038) & (0.075) & (0.042) \\ 
  $\ln(B)$ &  &  &  &  &  & -0.659*** &  \\ 
   &  &  &  &  &  & (0.128) &  \\ 
  $\ln(C)$ &  &  &  &  &  &  & -0.452*** \\ 
   &  &  &  &  &  &  & (0.044) \\ 
  Fixed Effects &  &  &  &  &  &  &  \\ 
  $\bullet$ Fund & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  $\bullet$ Time & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  Observations & 10,334 & 39,784 & 11,689 & 11,689 & 11,689 & 11,689 & 11,689 \\ 
  F (first stage) & 44.4 & 9.8 & 158.2 & 47.4 & 130.8 & 21.7 & 120.8 \\ 
   \midrule \\
 \multicolumn{8}{c}{\textbf{Panel B: 2 year window}} \\
 \midrule $\ln(CompetitorSize)$ & -0.369*** & -0.641*** & 1.375*** & 1.208*** & 1.229*** & 1.031*** & 1.026*** \\ 
   & (0.054) & (0.163) & (0.113) & (0.190) & (0.111) & (0.230) & (0.102) \\ 
  $\ln(FundSize)$ & 0.033*** & -0.092*** & -0.010 & -0.011 & -0.005 & 0.002 & -0.016 \\ 
   & (0.010) & (0.028) & (0.021) & (0.018) & (0.020) & (0.022) & (0.014) \\ 
  $\ln(f)$ & -0.031 & 0.055 & 0.040 & 0.014 & 0.072 & 0.079 & 0.020 \\ 
   & (0.025) & (0.090) & (0.067) & (0.066) & (0.059) & (0.053) & (0.048) \\ 
  $\ln(T)$ &  &  & -0.026** & -0.027** & -0.016 & -0.007 & -0.028*** \\ 
   &  &  & (0.013) & (0.012) & (0.012) & (0.012) & (0.009) \\ 
  $\ln(D)$ &  &  &  & -0.818*** &  &  &  \\ 
   &  &  &  & (0.100) &  &  &  \\ 
  $\ln(S)$ &  &  &  &  & -0.686*** & -0.593*** & -0.533*** \\ 
   &  &  &  &  & (0.034) & (0.082) & (0.040) \\ 
  $\ln(B)$ &  &  &  &  &  & -0.763*** &  \\ 
   &  &  &  &  &  & (0.159) &  \\ 
  $\ln(C)$ &  &  &  &  &  &  & -0.483*** \\ 
   &  &  &  &  &  &  & (0.045) \\ 
  Fixed Effects &  &  &  &  &  &  &  \\ 
  $\bullet$ Fund & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  $\bullet$ Time & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  Observations & 16,211 & 63,055 & 18,309 & 18,309 & 18,309 & 18,309 & 18,309 \\ 
  F (first stage) & 46.6 & 15.5 & 147.3 & 40.2 & 123.3 & 20.1 & 102.0 \\ 
   \bottomrule
\end{tabularx}
\endgroup
\end{table}

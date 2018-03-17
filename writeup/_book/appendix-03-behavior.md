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
$\Delta CS$ & -0.036*** & -0.350*** & 0.517*** & 0.395*** & 0.374*** & 0.081** & 0.341*** \\ 
   & (0.013) & (0.076) & (0.078) & (0.072) & (0.068) & (0.038) & (0.060) \\ 
  $\Delta\ln(FundSize)$ & -0.015*** & -0.178*** & 0.209*** & 0.100*** & 0.190*** & 0.112*** & 0.111*** \\ 
   & (0.003) & (0.017) & (0.017) & (0.012) & (0.015) & (0.010) & (0.011) \\ 
  $\Delta\ln(f)$ & -0.017 & 0.068 & -0.010 & -0.023 & 0.003 & 0.020 & -0.014 \\ 
   & (0.015) & (0.042) & (0.033) & (0.027) & (0.032) & (0.025) & (0.026) \\ 
  $\Delta \ln(T)$ &  &  & -0.013* & -0.006 & -0.012* & 0.001 & -0.013** \\ 
   &  &  & (0.007) & (0.005) & (0.006) & (0.004) & (0.005) \\ 
  $\Delta\ln(D)$ &  &  &  & -0.335*** &  &  &  \\ 
   &  &  &  & (0.016) &  &  &  \\ 
  $\Delta\ln(S)$ &  &  &  &  & -0.572*** & -0.196*** & -0.457*** \\ 
   &  &  &  &  & (0.017) & (0.013) & (0.019) \\ 
  $\Delta\ln(B)$ &  &  &  &  &  & -0.113*** &  \\ 
   &  &  &  &  &  & (0.011) &  \\ 
  $\Delta\ln(C)$ &  &  &  &  &  &  & -0.225*** \\ 
   &  &  &  &  &  &  & (0.021) \\ 
  Fixed Effects &  &  &  &  &  &  &  \\ 
  $\bullet$ Benchmark $\times$ Quarter & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  Observations & 34,984 & 57,146 & 57,146 & 57,146 & 57,146 & 57,146 & 57,146 \\ 
  $R^2$ & 0.125 & 0.060 & 0.099 & 0.262 & 0.254 & 0.134 & 0.216 \\ 
  $R^2$ (proj. model) & 0.003 & 0.014 & 0.033 & 0.195 & 0.206 & 0.079 & 0.168 \\ 
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
$\Delta CS$ & -0.047** & -0.482*** & 0.871*** & 0.717*** & 0.614*** & 0.176*** & 0.519*** \\ 
   & (0.022) & (0.069) & (0.091) & (0.098) & (0.066) & (0.038) & (0.057) \\ 
  $\Delta\ln(FundSize)$ & -0.017*** & -0.216*** & 0.249*** & 0.131*** & 0.225*** & 0.132*** & 0.132*** \\ 
   & (0.003) & (0.020) & (0.025) & (0.019) & (0.021) & (0.013) & (0.016) \\ 
  $\Delta\ln(f)$ & -0.026* & 0.032 & 0.038 & -0.011 & 0.055 & 0.056** & 0.011 \\ 
   & (0.014) & (0.045) & (0.035) & (0.031) & (0.034) & (0.026) & (0.030) \\ 
  $\Delta \ln(T)$ &  &  & -0.020** & -0.010 & -0.018** & -0.001 & -0.019*** \\ 
   &  &  & (0.009) & (0.007) & (0.008) & (0.005) & (0.006) \\ 
  $\Delta\ln(D)$ &  &  &  & -0.379*** &  &  &  \\ 
   &  &  &  & (0.023) &  &  &  \\ 
  $\Delta\ln(S)$ &  &  &  &  & -0.587*** & -0.166*** & -0.499*** \\ 
   &  &  &  &  & (0.019) & (0.015) & (0.025) \\ 
  $\Delta\ln(B)$ &  &  &  &  &  & -0.108*** &  \\ 
   &  &  &  &  &  & (0.014) &  \\ 
  $\Delta\ln(C)$ &  &  &  &  &  &  & -0.230*** \\ 
   &  &  &  &  &  &  & (0.027) \\ 
  Fixed Effects &  &  &  &  &  &  &  \\ 
  $\bullet$ Quarter & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  Observations & 30,779 & 32,500 & 32,500 & 32,500 & 32,500 & 32,500 & 32,500 \\ 
  $R^2$ & 0.024 & 0.036 & 0.070 & 0.247 & 0.255 & 0.099 & 0.221 \\ 
  $R^2$ (proj. model) & 0.005 & 0.025 & 0.060 & 0.233 & 0.242 & 0.078 & 0.214 \\ 
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
$\Delta CS$ & -0.035*** & -0.401*** & 0.640*** & 0.474*** & 0.485*** & 0.094** & 0.448*** \\ 
   & (0.013) & (0.091) & (0.095) & (0.090) & (0.084) & (0.047) & (0.072) \\ 
  $\Delta\ln(FundSize)$ & -0.015*** & -0.210*** & 0.242*** & 0.122*** & 0.221*** & 0.130*** & 0.128*** \\ 
   & (0.003) & (0.019) & (0.024) & (0.017) & (0.021) & (0.013) & (0.016) \\ 
  $\Delta\ln(f)$ & -0.025 & 0.034 & 0.041 & -0.009 & 0.057 & 0.053* & 0.016 \\ 
   & (0.015) & (0.047) & (0.036) & (0.031) & (0.036) & (0.029) & (0.030) \\ 
  $\Delta \ln(T)$ &  &  & -0.020** & -0.010 & -0.018** & -0.001 & -0.019*** \\ 
   &  &  & (0.009) & (0.007) & (0.008) & (0.005) & (0.007) \\ 
  $\Delta\ln(D)$ &  &  &  & -0.373*** &  &  &  \\ 
   &  &  &  & (0.021) &  &  &  \\ 
  $\Delta\ln(S)$ &  &  &  &  & -0.588*** & -0.167*** & -0.497*** \\ 
   &  &  &  &  & (0.018) & (0.015) & (0.023) \\ 
  $\Delta\ln(B)$ &  &  &  &  &  & -0.107*** &  \\ 
   &  &  &  &  &  & (0.014) &  \\ 
  $\Delta\ln(C)$ &  &  &  &  &  &  & -0.225*** \\ 
   &  &  &  &  &  &  & (0.027) \\ 
  Fixed Effects &  &  &  &  &  &  &  \\ 
  $\bullet$ Benchmark $\times$ Quarter & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ 
  Observations & 30,779 & 32,500 & 32,500 & 32,500 & 32,500 & 32,500 & 32,500 \\ 
  $R^2$ & 0.128 & 0.073 & 0.112 & 0.289 & 0.286 & 0.135 & 0.257 \\ 
  $R^2$ (proj. model) & 0.004 & 0.020 & 0.044 & 0.223 & 0.238 & 0.075 & 0.210 \\ 
   \bottomrule
\end{tabularx}
\endgroup
\end{table}


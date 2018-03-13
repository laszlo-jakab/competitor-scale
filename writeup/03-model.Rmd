# Theoretical Motivation {#sec:model}

In neoclassical models of capital allocation, firms trade off the benefit of allocating additional capital to their core competence with increasing marginal costs due to decreasing returns to scale. Firms optimally diversify across segments in which they have varying degrees of skill until marginal costs and benefits are equalized. I motivate my study by considering the impact of time-varying investment opportunities (due to competition, for instance) in two such theories of mutual fund behavior, @bg04, and @pst17L. 

Consider fund $i$ managing $q_{i,t}$ assets in @bg04. The fund posts a fixed expense ratio $f$,^[Following Berk and Green, I assume that the fixed expense ratio $f$ satisfies $f<f^\ast$, where $f^\ast$ is the expense ratio corresponding to profit maximizing fund size $q^\ast$.] and splits assets between active and passive management according to $q_{i,t}=A_{i,t}+P_{i,t}$. While active management allows the fund to take advantage of positive NPV investment opportunities in its area of core competence, it also subjects the fund to quadratic trading costs. I parametrize costs as $C(A_{i,t})=\frac{c_t}{M_t}A_{i,t}^2$, where $A_{i,t}$ is the amount actively managed, $M_t$ the size of the market, and $c_t$ a constant representing period by period trading costs. Normalizing trading costs by $M_t$ implies that price impact per dollar of investment is lower when total market capitalization is higher. With the normalization, the model's predictions are in terms of $FundSize_{i,t}=q_{i,t}/M_t$, instead of the dollar value of assets under management.


Let $\mu_{i,t}=E(R_{t+1}\mid R_1,\ldots,R_t)$ be the fund's expected skill, inferred from publicly available information. In addition, suppose that the returns to skill depend on time-varying external factors $x_{i,t}$, such that expected effective skill is $\mu_{i,t}g(x_{i,t})$. 
%For convenience, I will later parametrize the function as the product of baseline skill and competitor size $\mu_i(X_{i,t})=\mu_i CompetitorSize^{-\gamma}$. 
The fund's net alpha becomes
\begin{equation}
\frac{A_{i,t}}{q_{i,t}}\mu_{i,t}g(x_{i,t})-\frac{c_t A_{i,t}^2}{q_{i,t}M_t}-f. 
\end{equation}
I focus on competitor size as the external constraint of interest. However, $x_{i,t}$ could be any time-varying external factor affecting the fund's investment opportunities.

Following equation (26) in @bg04, the fund's profit maximizing choice for the amount of assets to keep under active management, conditional on overall size and market conditions, is $A_{i,t}^\ast(\mu_{i,t}g(x_{i,t}))=\frac{\mu_{i,t}g(x_{i,t}) M_t}{2c_t}$. This implies that the fraction of assets under active management is governed by the first-order condition:
\begin{equation}
\frac{A_{i,t}^\ast}{q_{i,t}}=\frac{\mu_{i,t}g(x_{i,t})}{2c_t(q_{i,t}/M_t)}.
(\#eq:FOC)
\end{equation}
Conditional on its size, the fund optimally responds to deterioration in the NPV of investment opportunities by scaling back active management. 


## Symmetric Information

In perfect capital markets investors are symmetrically informed of the fund's time varying investment opportunities, and the capital allocated to the fund increases with the square of $\mu_{i,t}g(x_{i,t})$. The market clearing zero net alpha condition implies fund size of:
\begin{equation}
\frac{q_{i,t}^\ast}{M_t}=\frac{(\mu_{i,t}g(x_{i,t}))^2}{4c_t f}.
(\#eq:zeroAlpha)
\end{equation}
Combining equation \@ref(eq:FOC) and \@ref(eq:zeroAlpha), the equilibrium fraction of assets under active management is:
\begin{equation}
\frac{A_{i,t}^\ast}{q_{i,t}^\ast}=\frac{2f}{\mu_{i,t}g(x_{i,t})}.
(\#eq:capMkt)
\end{equation}
In perfect capital markets with symmetrically informed fund managers and outside investors, the share of assets under active management is decreasing in the profitability of investment opportunities $\mu_{i,t}g(x_{i,t})$, conditional on fund expense ratio. 

Testing the two above predictions separately would require modeling the evolution of $\mu_{i,t}$. However, we can combine the equilibrium conditions to eliminate fund skill and take logs to obtain
\begin{equation}
2\ln(A_{i,t}^\ast/q^\ast_{i,t})=\ln(f) - \ln(c_t) - \ln(q^\ast_{i,t}/M_t).
(\#eq:csEq)
\end{equation}
This leads to the first hypothesis.

Hypothesis 1: **Symmetric Information**

*If managers and investors share the same beliefs about the fund's investment opportunities, the share of assets under active management is fully determined by fund size and expense ratio. Business conditions such as competition play no role in determining capital allocation beyond their effect on fund size.*

## Better Informed Managers

Suppose that managers observe $x_{i,t}$, but investors do not. Investors allocate funds as if $g(x_{i,t})=1$,
\begin{equation}
\frac{A_{i,t}^\ast}{q_{i,t}^\ast}=\frac{2f}{\mu_{i,t}}.
\end{equation}
The equilibrium relation between the share under active management, fund size, and expense ratio now contains an additional term
\begin{equation}
2\ln(A_{i,t}^\ast/q^\ast_{i,t})=\ln(f) - \ln(c_t) - \ln(q^\ast_{i,t}/M_t) + 2\ln(g(x_{i,t}))
(\#eq:csEQa)
\end{equation}
This gives an alternative hypothesis.

Hypothesis 2: *Asymmetric Information*

*If managers have superior information about the fund's time-varying investment opportunities relative to outside investors, the share of assets under active management will be positively related to variation in the profitability of opportunities. Business conditions such as competition play an additional role in determining capital allocation beyond their effect on fund size.*

Note that under asymmetric information, net alpha is equal to $f_{i,t}(g(x_{i,t})^2-1)$. If managers are better informed of investment opportunities than outside investors, we would expect fund to make more when they take more active positions. In the cross-section, conditional on size, we would expect more active funds to perform better, potentially rationalizing findings that variables such as active share or industry concentration predict returns [@cp09; @ksz05].


## Similar Hypotheses Based on an Alternative Approach

I develop hypotheses 1 and 2 based on @bg04 and its particular assumptions, including fixed expense ratios and a particular cost structure. A different approach based on @pst17L yields similar implications without assuming fixed expense ratios, and with the additional feature of multi-dimensional, micro-founded trading costs. 

@pst17L derive from first principles that larger funds that trade more and hold less liquid portfolios incur higher trading costs.^[The key assumptions are that funds (expect to) turn over their portfolios proportionately, and incur trading costs for each stock that increase in the size of the trade relative to the stock's market capitalization.] Specifically, trading costs are quadratic in $TL^{-1/2}$, the ratio of turnover $T$ to the (square root of) portfolio liquidity $L$. In their model, funds trade off the costs and benefits of higher turnover and lower portfolio liquidity. The assumption is that funds can exploit a greater number of opportunities by trading more; conversely, they can increase alpha by focusing on their best ideas by holding less liquid portfolios. The fund's first-order condition, given fund size and trading opportunities, is 
\begin{equation}
(T_{i,t}L_{i,t}^{-\frac{1}{2}})^\ast = \frac{\mu_{i,t}g(x_{i,t})}{2c_t(q_{i,t}/M_t)}.
\label{eq:PSTfoc}
\end{equation}
Under symmetric information, the market clearing zero net alpha condition implies the same fund size $\frac{q_{i,t}^\ast}{M_t}=\frac{(\mu_{i,t}g(x_{i,t}))^2}{4c_t f_{i,t}}$ as before. In perfect capital markets with symmetrically informed outside investors, equilibrium turnover-liquidity ratio is negatively related to profit opportunities:
\begin{equation}
(T_{i,t}L_{i,t}^{-\frac{1}{2}})^\ast=\frac{2f_{i,t}}{\mu_{i,t}g(x_{i,t})}.
\label{eq:PSTcapMkt}
\end{equation}
With symmetric information, we have the equilibrium relation
\begin{equation}
2\ln(TL^{-1/2})^\ast=\ln(f_{i,t}) - \ln(c_t) - \ln(q^\ast_{i,t}/M_t).
\label{eq:csEqTL}
\end{equation}
With asymmetric information, the information wedge influences internal capital allocation beyond its effect on fund size
\begin{equation}
2\ln(TL^{-1/2})^\ast=\ln(f_{i,t}) - \ln(c_t) - \ln(q^\ast_{i,t}/M_t)+2\ln(g(x_{i,t})).
\label{eq:csEqaTL}
\end{equation}

The approach based on the \citet*{pst17L} model reproduces hypotheses 1 and 2, with turnover to portfolio liquidity ratio $TL^{-1/2}$ taking the place of share of assets under active management. Ultimately, both the share of actively managed assets and the turnover to portfolio liquidity ratio measure the extent to which fund managers engage in active pursuit of profitable investment opportunities. An advantage of this formulation of the model is that portfolio liquidity is a multidimensional concept. Portfolio liquidity can be decomposed into a product of stock liquidity (market capitalization of holdings) and diversification, the latter of which can be further decomposed as a product of coverage (number of holdings relative to number of tradeable stocks) and balance (a measure of portfolio concentration). This framework allows the researcher to study each dimension, potentially allowing for a richer characterization of fund behavior.

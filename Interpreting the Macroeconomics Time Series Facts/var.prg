' Programa que reproduz os var de sims
' Interpreting Macroeconomics Time series facts, based on imf course

' Series obtained from IFS

genr lcp = log(cmp)
genr lp = log(cpi)
genr lm = log(m1)
genr lxr = log(xr)
genr ly = log(y)

' estimations - 14 lags var

smpl 1958:04 1991:02

var var_sims.ls 1 14 r lxr lcp lm lp ly
freeze(irf_var) var_sims.impulse(48, m) r lxr lcp lm lp ly @ r lxr lcp lm lp ly

'formating the graph
irf_var.addtext(t, font(15), [+/b]) Interpreting Macroeconomics Time Series Facts
irf_var.area(I)

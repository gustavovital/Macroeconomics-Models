# Script com o objetivo de replicar os modelos econometricos da CP apresentados no
# wp01 do bcb, intitulado "Implementing Inflation Target in Brazil".
# 
# Autor: @gustavoovital
# Data: 17/03/2020

# Pacotes necessários ----

source('getExpectations.R')

library(BETS)
library(sidrar)


API <- '/t/1737/n1/all/v/2266/p/all/d/v2266%2013'
IPCA <- get_sidra(api = API)
IPCA <- ts(IPCA[,11], start = c(1979, 12), freq = 12)
IPCA <- (IPCA/stats::lag(IPCA, -12) -1)*100


# Script com o objetivo de replicar os modelos econometricos apresentados no
# wp01 do bcb, intitulado "Implementing Inflation Target in Brazil".
# 
# Autor: @gustavoovital
# Data: 13/03/2020

# Pacotes necessários ----

library(BETS)
library(sidrar)
library(mFilter)
library(tidyverse)
library(dynlm)

# Base de dados ----

NFSP <- BETSget(7869)
PIB <-BETSget(22109)
SELIC <- BETSget(4189)

API <- '/t/1737/n1/all/v/2266/p/all/d/v2266%2013'
IPCA <- get_sidra(api = API)

# Manipulação das séries ----

IPCA <- ts(IPCA[,11], start = c(1979, 12), freq = 12)
IPCA <- (IPCA/stats::lag(IPCA, -12) -1)*100

LOG_NFSP <- log(NFSP/100 + 1)
LOG_NFSP <- na.omit(LOG_NFSP)

r <- log((1 + SELIC)/(1 + IPCA))

# criando uma função para conversão para trimestral ----

month_to_quarter <- function(your_ts) {
  
  serie <- ts(subset(your_ts, cycle(your_ts) == 3 |cycle(your_ts) == 6 |cycle(your_ts) == 9 |cycle(your_ts) == 12))
  
  return(serie)
  
}

# Acertando as series ----

r <- ts(month_to_quarter(r), start = c(1986, 2), frequency = 4)
LOG_NFSP <- ts(month_to_quarter(LOG_NFSP), start = c(1999, 4), frequency = 4)

# Estimação do Hiato pelo filtro HP e tendencia linear ----

# metodo HP

h <- hpfilter(PIB, type = 'lambda')$cycle

# # método de tendencia linear
# 
# ts.plot(hp_gap, PIB)

# Criando a base de dados ----

cut_series <- function(your_ts){
  
  serie <- window(your_ts, start = c(2003, 01), end = c(2018,04))
  return(serie)
}

data <- tibble(hiato = cut_series(h),
               r = cut_series(r),
               nfsp = cut_series(LOG_NFSP))

# Estimação das IS ----

is.curve <- dynlm(hiato ~ L(hiato, 1) + L(hiato, 2) + L(r, 1), data = data)
is.fiscal <- dynlm(hiato ~ L(hiato, 1) + L(hiato, 2) + L(r, 1) + L(nfsp, 1), data = data)

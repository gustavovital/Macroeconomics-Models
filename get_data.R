# Script para download das series temporais

# Autor: gustavo vital
# Data: 26/06/2020

library(tidyverse)
library(lubridate)
library(BETS)

# series mensais ----

exp_ipca <- gexpectations('IPCA')
ipca <- BETSget(433)
ibcbr <- BETSget(24364)
selic <- BETSget(4189)
NFSP <- BETSget(7869)
PIB <-BETSget(22109)
meta <- BETSget(13521)
cambio <- BETSget(11753)

NFSP <- NFSP %>% na.omit()

ppi <- read_csv('ppi.csv')
ppi <- ts(ppi[,2], start = c(1960, 01), frequency = 4)

interest_us <- read_csv('interestrate_us.csv')
interest_us <- ts(interest_us[,2], start = c(2000, 02), frequency = 12)

# salvando as séries ----

write.csv(selic, 'Data/selic.csv')
write.csv(ibcbr, 'Data/ibcbr.csv')
write.csv(ipca, 'Data/ipca.csv')
write.csv(data, 'Data/expectations.csv')

# montly to quarter ----

month_to_quarter <- function(your_ts) {
  
  serie <- ts(subset(your_ts, cycle(your_ts) == 3 |cycle(your_ts) == 6 |cycle(your_ts) == 9 |cycle(your_ts) == 12))
  return(serie)
  
}

# manipulação das séires ----

interest_rate <- log(1 + (selic - exp_ipca))
cambio <- log(cambio)
interest_us <- log(interest_us)
NFSP <- log(1 - NFSP)

# passando para quarter ----

cambio_quarter <- month_to_quarter(cambio)
NFSP_quarter <- month_to_quarter(NFSP)

# taxas de juros
interest_rate_quarter <- month_to_quarter(interest_rate)
interest_us_quarter <- month_to_quarter(interest_us)

# inflação
ppi_quarter <- month_to_quarter(ppi)
ipca_quarter <- month_to_quarter(ipca)
exp_ipca_quarter <- month_to_quarter(exp_ipca)
meta <- c(rep(8,4), rep(6,4), rep(4,4), rep(3.5, 4), rep(4,4), rep(5.5,4), rep(4.5, 14*4), rep(4.25,4), rep(4,4))

PIB <- PIB

# salvando as series ----

write.csv(as.numeric(PIB), 'Data/pib.csv')
write.csv(as.numeric(cambio_quarter), 'Data/cambio_quarter.csv')
write.csv(as.numeric(NFSP_quarter), 'Data/NFSP_quarter.csv')
write.csv(as.numeric(interest_rate_quarter), 'Data/interest_rate_quarter.csv')
write.csv(as.numeric(interest_us_quarter), 'Data/interest_us_quarter.csv')
write.csv(as.numeric(ppi_quarter), 'Data/ppi_quarter.csv')
write.csv(as.numeric(ipca_quarter), 'Data/ipca_quarter.csv')
write.csv(as.numeric(exp_ipca_quarter), 'Data/exp_ipca_quarter.csv')
write.csv(meta, 'Data/meta.csv')

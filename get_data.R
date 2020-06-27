# Script para download das series temporais

# Autor: gustavo vital
# Data: 26/06/2020

library(lubridate)
library(BETS)

data <- gexpectations('IPCA')
ipca <- BETSget(433)
ibcbr <- BETSget(24364)
selic <- BETSget(4189)

write.csv(selic, 'Data/selic.csv')
write.csv(ibcbr, 'Data/ibcbr.csv')
write.csv(ipca, 'Data/ipca.csv')
write.csv(data, 'Data/expectations.csv')


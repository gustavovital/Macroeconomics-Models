# Script com o objetivo de baixar toda a série de expectativa do BCB-SGS
# do top 5 a curto prazo
# 
# Autor: gustavovital@id.uff.br
# Data: 21/02/2020

# Pacotes necessários: ----

install.packages('devtools', dependencies = TRUE)
devtools::install_github('wilsonfreitas/rbcb')

library(rbcb)
library(tidyverse)

# Pegando as expectativas do BCB top5, para todos os periodos de curto 
# prazo, tal qual nos data os varios valores de dia ainda

gexpectations <- 
  
  function(serie, start = '2003-01-01') {
    
    # a partir do rbcb pego a(s) serie(s) necessária(s)
    
    exp <- 
      get_top5s_monthly_market_expectations(serie, start_date = start) %>% 
      filter(type == 'C')
    
    # Função para o controle dos meses de referencia (fara com que seja possível uma
    # comparação com o próximo mes)
    
    sum_date <- function(date) {
      month(date) <- month(date) + 1
      return(date)
    }
    
    # seleciono todas as datas em relação aos meses que fazem a previsão para o mes 
    # seguinte. I.e data[i] == reference_month[i+1]
    
    expectativa <- c()
    datas <- c()
    mes.referencia <- c()
    
    for(i in 1:nrow(exp)){ 
      if(paste(substr(lapply(exp$date[i], sum_date)[[1]],6, 7),
               substr(lapply(exp$date[i], sum_date)[[1]],1, 4),
               sep = '/') == exp$reference_month[i]){
        expectativa <- c(expectativa, exp$mean[i])
        datas <- c(datas, exp$date[i])
        mes.referencia <- c(mes.referencia, exp$reference_month[i])
      }
    }
    
    # modifico o vetor 'datas' para formato Date, dada a origin == '1970-01-01'
    
    datas <- as.Date(datas, origin = "1970-01-01")
    
    # crio um tibble contendo mes de referencia, data, e valores das expectativas
    
    exp.controle <- tibble(Data = datas,
                           Referencia = mes.referencia, 
                           Expectativa = expectativa) 
    
    # seleciono as maiores datas de cada mes com a função tapply. feito isso, faço um
    # subset no dataframe afim de remover valores indesejados das outras datas. Isso é,
    # fico somente com um dataframe que apresente mes de referencia sempre 1 maior que 
    # o ultimo valor do mes anterior, tendo assim as expectativas no periodo t+1. Alem 
    # disso, é necessário inverter a série, visto que essa foi calculada no maior valor 
    # para o menor valor
    
    exp.final <- 
      exp.controle[exp.controle$Data %in% 
                     as.Date(tapply(exp.controle$Data, substr(exp.controle$Data, 1, 7), max), 
                             origin = '1970-01-01'),]
    
    expectativas <- ts(rev(exp.final$Expectativa), start = c(2003, 01), freq = 12)
    
    return(expectativas)
  }

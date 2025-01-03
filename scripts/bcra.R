# API BCRA: https://www.bcra.gob.ar/Catalogo/apis.asp?fileName=principales-variables-v3

library(httr)
library(tidyverse)
library(jsonlite)

variables <- GET(glue::glue('https://api.bcra.gob.ar/estadisticas/v3.0/Monetarias'))
text <- rawToChar(variables$content)
Encoding(text) <- "UTF-8"
lista_variables <- as.data.frame(fromJSON(text))



id_variable <- 126

data_api <- GET(glue::glue('https://api.bcra.gob.ar/estadisticas/v3.0/Monetarias/{id_variable}/'))

data <-  as.data.frame(fromJSON(rawToChar(data_api$content))$results) %>% 
  mutate(fecha = as.Date(fecha),
         valor = as.numeric(valor))


ggplot(data,aes(x=fecha,y=valor,group=1))+
  geom_line()+
  scale_y_continuous()+
  labs(x='',y='',title=glue::glue('{lista_variables %>% filter(results.idVariable == id_variable) %>% pull(results.descripcion)}'),
       subtitle='')+
  theme_minimal()

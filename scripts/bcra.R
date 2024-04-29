# API BCRA: https://www.bcra.gob.ar/Catalogo/apis.asp?fileName=principales-variables-v1
library(httr)
library(tidyverse)
library(jsonlite)

variables <- GET(glue::glue('https://api.bcra.gob.ar/estadisticas/v1/PrincipalesVariables'))
lista_variables <- as.data.frame(fromJSON(rawToChar(variables$content)))


reservas <- GET(glue::glue('https://api.bcra.gob.ar/estadisticas/v1/DatosVariable/1/1990-01-01/{Sys.Date()}'))

data = as.data.frame(fromJSON(rawToChar(reservas$content))$results) %>% 
  mutate(fecha = lubridate::dmy(fecha),
         valor = as.numeric(valor))


ggplot(data,aes(x=fecha,y=valor,group=1))+
  geom_line()+
  scale_y_continuous()+
  labs(x='',y='',title='Reservas Internacionales del BCRA',
       subtitle='En millones de dólares - cifras provisorias sujetas a cambio de valuación')+
  theme_minimal()
# API BCRA: https://www.bcra.gob.ar/Catalogo/apis.asp?fileName=principales-variables-v1
library(httr)
library(tidyverse)
library(jsonlite)

variables <- GET(glue::glue('https://api.bcra.gob.ar/estadisticas/v1/PrincipalesVariables'))
lista_variables <- as.data.frame(fromJSON(rawToChar(variables$content)))

id_variable <- 1
fecha_desde <- '1990-01-01'
fecha_hasta <- Sys.Date()

data_api <- GET(glue::glue('https://api.bcra.gob.ar/estadisticas/v1/DatosVariable/{id_variable}/{fecha_desde}/{Sys.Date()}'))

data <-  as.data.frame(fromJSON(rawToChar(data_api$content))$results) %>% 
  mutate(fecha = lubridate::dmy(fecha),
         valor = as.numeric(valor))


ggplot(data,aes(x=fecha,y=valor,group=1))+
  geom_line()+
  scale_y_continuous()+
  labs(x='',y='',title='Reservas Internacionales del BCRA',
       subtitle='En miles de millones de dólares - cifras provisorias sujetas a cambio de valuación')+
  theme_minimal()

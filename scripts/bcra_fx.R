############
library(httr)
library(tidyverse)
library(jsonlite)
library(glue)
############
## Conexión a la API Estadísticas cambiarias del BCRA
# Manual de desarrollo: https://www.bcra.gob.ar/Catalogo/Content/files/pdf/estadisticascambiarias-v1.pdf 

# Divisas disponibles:
divisas <- GET('https://api.bcra.gob.ar/estadisticascambiarias/v1.0/Maestros/Divisas')
divisas_df <- as.data.frame(fromJSON(rawToChar(divisas$content))[[2]])

# Ejemplo cotizaciones:
moneda <- 'XAU'
fecha_desde <- '2020-01-01'
fecha_hasta <- Sys.Date()
cotizaciones <- GET(glue::glue('https://api.bcra.gob.ar/estadisticascambiarias/v1.0/Cotizaciones/{moneda}?fechadesde={fecha_desde}&fechahasta={fecha_hasta}'))
cotizaciones_df <- as.data.frame(fromJSON(rawToChar(cotizaciones$content))[[3]])

cotizaciones_df2 <- cotizaciones_df %>% unnest(detalle) %>% 
  mutate(fecha = as.Date(fecha))
ggplot(cotizaciones_df2,aes(x=fecha,y=tipoPase,group=1))+
  geom_line()+
  scale_y_continuous()+
  labs(x='',y='',title=glue::glue('Cotización {unique(cotizaciones_df2$descripcion)}'),
       subtitle='')+
  theme_minimal()

### Código para obtener todas las cotizaciones disponibles
list_cotizaciones <- list()
fecha_desde <- '2020-01-01'
fecha_hasta <- Sys.Date()
for (i in 1:nrow(divisas_df)){
  print(divisas_df[i,])
  cotizacion <- GET(glue::glue('https://api.bcra.gob.ar/estadisticascambiarias/v1.0/Cotizaciones/{divisas_df$codigo[i]}?fechadesde={fecha_desde}&fechahasta={fecha_hasta}'))
  list_cotizaciones[[i]] <- as.data.frame(fromJSON(rawToChar(cotizacion$content))[[3]])
}

cotizaciones_todas <- do.call(rbind,list_cotizaciones) %>% unnest(detalle) %>% 
  mutate(fecha=as.Date(fecha))

cotizaciones_todas %>% 
  filter(codigoMoneda %in% c('USD','BRL','CNY','EUR','GBP') &
           fecha > '2023-01-01') %>% 
  ggplot(aes(x=fecha,y=tipoCotizacion,group=codigoMoneda,color=descripcion))+
  geom_line()+
  scale_y_continuous()+
  geom_text(data=cotizaciones_todas %>% 
              filter(codigoMoneda %in% c('USD','BRL','CNY','EUR','GBP') &
                       fecha == max(fecha)),aes(label=codigoMoneda),
            hjust=-.1)+
  ghibli::scale_color_ghibli_d(name = 'MononokeMedium')+
  labs(x='',y='',title=glue::glue('Estadísticas cambiarias: cotizaciones por moneda'),
       subtitle='',
       caption = 'Fuente: API BCRA')+
  theme_minimal()+
  theme(legend.position = 'none')

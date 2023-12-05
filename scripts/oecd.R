library(tidyverse)

# OECD
# COMPOSITE LEADING INDICATORS

#https://data-explorer.oecd.org/vis?fs[0]=Topic%2C1%7CEconomy%23ECO%23%7CLeading%20indicators%23ECO_LEA%23&pg=0&fc=Topic&snb=1&tm=kei&df[ds]=dsDisseminateFinalDMZ&df[id]=DSD_STES%40DF_CLI&df[ag]=OECD.SDD.STES&df[vs]=4.0&pd=%2C&dq=.M.LI...AA...H&ly[rw]=TIME_PERIOD&ly[cl]=REF_AREA&to[TIME_PERIOD]=false&lo=10&lom=LASTNPERIODS

library(rsdmx)

Url <- "https://sdmx.oecd.org/public/rest/data/OECD.SDD.STES,DSD_STES@DF_CLI,4.0/.M.LI...AA...H?startPeriod=1990-01&dimensionAtObservation=AllDimensions"
dataset <- readSDMX(Url)
stats <- as.data.frame(dataset) %>% 
  janitor::clean_names() 

write_csv(stats,"data/oecd_cli.csv")

# stats_mod <- stats %>% 
#   mutate(fecha = as.Date(paste0(time_period,"-01"))) %>% 
#   filter(fecha >= "2019-01-01" & 
#            ref_area %in% c("G20","AUS","BRA","CAN","CHN",
#                            "ESP","FRA","GBR","IND","ITA","JPN",
#                            "MEX","USA")) %>% 
#   group_by(ref_area) %>% 
#   mutate(indice = 100*obs_value/first(obs_value)) 
# 
# stats_mod %>% 
#   ggplot(aes(x=fecha,y=indice,group=ref_area,color=ref_area))+
#   geom_point()+
#   geom_line()+
#   scale_x_date(date_breaks = "6 months")+
#   theme(axis.text.x = element_text(angle=90),
#         legend.position = "bottom")+
#   comunicacion::scale_color_dnmye()
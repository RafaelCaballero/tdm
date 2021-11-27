require(tidyr)
require(dplyr)
require(stringr)
file = "E:/docencia/2122/tfg/meteo/data/" 
df <- read.csv(paste(file,"ContaminacionPlazaEliptica.csv",sep=""))
df<- df%>% select(!starts_with("V"))
df<- df%>% select(!(source_file))
# poner horas en la misma columna
df_2<- df %>% gather(key="HORA",value="VALOR",-MAGNITUD,-ANO,-MES,-DIA) %>%
               arrange(MAGNITUD,ANO,MES,DIA,HORA)
# quitar la H
horas <- as.integer(str_sub(df_2$HORA,start=2))
df_2$HORA <- horas

# convertir magnitud en columnas
df_3 <- df_2 %>% spread(MAGNITUD,VALOR)

#install.packages("Amelia")
library(Amelia)
missmap(df_3)

#install.packages("naniar")
library(naniar)
gg_miss_var(df_3)

write.csv(df_3,paste(file,"contaminacionPlazaElipticaLargoHs.csv",sep=""),row.names = F)


url2 = "https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/contaminantes.csv"
df_contaminantes = read.csv(url2,encoding="UTF-8")

df_m <- left_join(df_2,df_contaminantes)
df_m <- df_m%>% select(!(MAGNITUD))
df_3 <- df_m %>% spread(Descr,VALOR)
#####
install.packages("corrplot")
library(corrplot)
# vamos a hacer los nombres más pequeños quitando la palabra "bebidas"
M <- cor(df_3[,5:ncol(df_3)] %>% drop_na())
corrplot(M, method="number", type="upper")

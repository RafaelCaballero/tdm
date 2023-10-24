
### Ejercicio 1
require(dplyr)
df_usa <- read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/tusa2020.csv",
                   encoding="UTF-8",  
                   colClasses=c("X_id"="character", "userid"="character","RT_source"="character" ) )
df_rt <- df_usa %>% inner_join(df_usa, by=c("RT_source"="X_id"),suffix=c("",".original")) %>%
         select("screen_name.original","text.original")
df_rt %>% count(screen_name.original, sort=TRUE) %>% slice_head()

### Ejercicio 2
require(dplyr)
df_paro = read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/parocomunidades.csv",encoding="latin1")
#a
df_Asturias <- df_paro %>% filter(Comunidad=="Asturias") 
#b
df_Asturias_est <- df_Asturias %>% summarise("Min."=min(Total),"Max."=max(Total),"Media"=mean(Total))
#c
df_Asturias_est <- df_Asturias_est %>% inner_join(df_Asturias,by=c("Max."="Total")) %>% rename("Periodo.Max"="Periodo")
df_Asturias_est <- df_Asturias_est %>% inner_join(df_Asturias,by=c("Min."="Total")) %>% rename("Periodo.Min"="Periodo")
df_Asturias_est <- df_Asturias_est %>% select(-contains("Comunidad")) # ver ?select

### Ejercicio 3
df_paro = read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/parocomunidades.csv",encoding="latin1")
df_paro_com <- df_paro %>% group_by(Comunidad)
df_paro_media<- df_paro_com %>% summarise(media=mean(Total))

#a
df_paro_com %>% summarise(media=mean(Total)) %>% arrange(desc(media))
#b 
df_paro_com %>% summarise(media=mean(Total),maximo=max(Total),minimo=min(Total),desv=sd(Total)) %>% arrange(desc(desv))

#c
df_paro_media %>% summarise(Media.Final=mean(media))

df_paro %>% summarise(Media.Final=mean(Total))

### Ejercicio 4
df_paro_periodo <- df_paro %>% group_by(Periodo)
#a
df_anualidad <- df_paro_periodo %>% summarise(media=mean(Total)) %>% arrange(Periodo)

#b 
df_anualidad %>%  filter(media>15) %>% summarise(media.Final = mean(media))

### Ejercicio 5
df_spotify <- read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/top10s.csv")

#a
df_spotify %>% count(top.genre) %>% arrange(desc(n))

#b
anual <- df_spotify %>% group_by(year)
res <- anual %>% summarise(mean(nrgy))
plot(res,type="l",col="blue")

#c) 
anual_dance <- anual %>% filter(top.genre=="dance pop")
res2 <- anual_dance %>% summarise(mean(nrgy))

plot(res2,type="l",col="red")


### Ejercicio 6
require(dplyr)
require(tidyr)

df_pisa <- read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/PisaDataClean.csv")

#a
media <- mean(df_pisa$RPC); desv <- sd(df_pisa$RPC)

# b
df_pisa  %>%  filter(RPC<media-desv) %>% summarise(media_fe=mean(MAT_FE),media_ma=mean(MAT_MA))
df_pisa  %>%  filter(RPC>media+desv) %>% summarise(media_fe=mean(MAT_FE),media_ma=mean(MAT_MA))

#c
df_pisa$media <- (df_pisa$SCI+df_pisa$REA+df_pisa$MAT)/3

#d
require(tidyr)
df_pisa$media<-NULL
df_pisa_largo<-df_pisa %>% gather(key="materia",value="nota",-PAIS, -RPC)

pisa_por_paises <- df_pisa_largo %>% group_by(PAIS)
res <- pisa_por_paises %>% summarise(mean(nota))


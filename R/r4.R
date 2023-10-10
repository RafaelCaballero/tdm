
### La tabla en un vistazo: summary()

df_paro = read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/parocomunidades.csv",encoding="latin1")
summary(df_paro)

require(dplyr)
fich = "https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/valores.csv"
df_valores = read.csv(fich)

df_valores %>% select(starts_with("SPX")) %>% summary


#### Datos de campos tipo carácter
count(df_paro$Comunidad) # error

df_paro %>% count(Comunidad) # no es lo mismo, aunque lo parezca

summary(as.factor(df_paro$Comunidad))


#### Ejercicio 1
require(dplyr)
df_usa <- read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/tusa2020.csv",
                   encoding="UTF-8",  
                   colClasses=c("X_id"="character", "userid"="character","RT_source"="character" ) )


### Summarise: ejemplos
df_valores %>% summarise("media SPX Apertura" = mean(SPX_Index_Open), "núm.valores" = n())

#### Ejercicios 2,3,4
df_paro = read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/parocomunidades.csv",encoding="latin1")


#### GROUP BY: varias columnas. Ejemplo
fich = "https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/valores.csv"
df_valores <- read.csv(fich)
df_SPX <- df_valores %>% select(fecha, SPX_Index_Closing,   SPX_Index_Volatility, SPX_Index_Volume)
cor(df_SPX[,2:ncol(df_SPX)])

require(tidyr)
df_SPX <- df_SPX %>% separate(col=fecha, into=c("day", "month", "year"),sep="/")


##### Encadenando Group By: intento 1
encadenados <- df_SPX %>% group_by(year) %>% group_by(month)
encadenados %>% summarise(media=mean(SPX_Index_Closing))

#### Encadenando Group By: intento 2

encadenados <- df_SPX %>% group_by(year) %>% group_by(month,.add=TRUE)
res <- encadenados %>% summarise(media=mean(SPX_Index_Closing))
X = as.Date(paste(res$year,res$month,"01"),"%Y %m %d")
plot(X,res$media,"l",xlab="Año",ylab="SPX",col="blue")

#### Group By encadenados: ventajas
poraño <- df_SPX %>% group_by(year)
pormes <- poraño%>% group_by(month, .add=TRUE)

res <- poraño %>% summarise(mediaClosing=mean(SPX_Index_Closing))

require(ggplot2) # install.packages("ggplot2")
res %>%
ggplot(aes(x = year, y = mediaClosing, fill = year)) +
  geom_bar(stat = "identity") +
  theme_classic() +
  labs( x = "Año",
        y = "Valor medio al cierre",
        title = "Evolución anual de SPX"
  )

#### Group By de varios atributos simultáneamente
porañomes <- df_SPX %>% group_by(year,month)

res <- porañomes %>% summarise(media=mean(SPX_Index_Closing))
res %>%
  ggplot(aes(x = year, y = media, fill = month)) +
  geom_bar(stat = "identity") +
  theme_classic() +
  labs( x = "Año",
        y = "Valor medio al cierre",
        title = "Evolución anual de SPX"
  )


  
### ejercicio 5
# fuente: https://www.kaggle.com/leonardopena/top-spotify-songs-from-20102019-by-year
df_spotify <- read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/top10s.csv")

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
df_valores %>% summarise("media SPX Apertura" = mean(SPX_Index_Open), 
                         "núm.valores" = n())

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

##################### Visualización

#url = "https://ucmdrive.ucm.es/s/zbjRbYfNtwmicGX/download/ventas.csv"
url = "https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/ventasmini.csv"
df = read.csv(url, sep=",", encoding="UTF-8", colClasses=c("CENTRO"="character", "REF.CENTER"="character" , "REF.CENTRAL"="character"))
library(dplyr)
dfArea <- df %>%
  filter(CENTRO=="3156", AREA== "TEXTIL") %>%
  group_by(N.Mes) %>% 
  summarise(total=sum(VENTAS))

### BARPLOTS
barplot(dfArea$total,
        main="ÁREA - TEXTIL",
        xlab="Mes",
        col="darkmagenta",
        names.arg=dfArea$N.Mes
)

# (II)
dfArea <- df %>% filter(CENTRO=="3156", AREA== "TEXTIL") %>%
          group_by(N.Mes,MES) %>% 
          summarise(total=sum(VENTAS))


barplot(dfArea$total,
        main="ÁREA - TEXTIL",
        xlab="Mes",
        col="darkmagenta",
        names.arg=dfArea$MES,
        ylim = range(pretty(c(0,max(dfArea$total))))
)

# (III)
library(dplyr)
library(tidyr)
dfAreaCentro <- df %>% filter(AREA=="TEXTIL") %>%
                group_by(N.Mes,MES,CENTRO) %>%
                summarise(total=sum(VENTAS))

datosCentros <- as.data.frame(dfAreaCentro) %>% 
                spread(CENTRO,total) %>%
                select(-c(1,2))

barplot(t(datosCentros),
        main="ÁREA - TEXTIL",
        xlab="Mes",
        col=c("darkblue","red"),
        beside=T,
        names.arg=dfAreaCentro$MES,
        legend= colnames(datosCentros),
        args.legend = list(x = "topleft"),
        ylim = range(pretty(c(0,max(datosCentros)))),
        
)
box()

### diagrama de barras con ggplot
meses <- factor(dfAreaCentro$MES, level = unique(dfAreaCentro$MES))

dfAreaCentro <- df %>% filter(AREA=="ALIMENTACION ") %>%
  group_by(N.Mes,MES,CENTRO) %>%
  summarise(total=sum(VENTAS))

dfAreaCentro %>% 
  ggplot(aes(x =  meses, y = total)) + 
  geom_bar(fill="lightblue", stat = "identity") +
  theme_dark() +
  labs( x = "Meses",
        y = "Ventas",
        title = "ÁREA - TEXTIL"
  ) 

### Añadiendo una línea
dfAreaCentro %>% 
  ggplot(aes(x = meses, y = total)) + 
  geom_bar(fill="lightblue", stat = "identity") +
  theme_dark() +
  labs( x = "Mes",
        y = "Ventas",
        title = "ÁREA - TEXTIL"
  ) + 
  geom_hline(yintercept=750, color="magenta",linewidth=2)

#### Otra forma
meses <- factor(dfAreaCentro$MES, level = unique(dfAreaCentro$MES))
g <- dfAreaCentro %>% 
  ggplot(aes(x = meses , y = total)) + 
  geom_bar(fill="lightblue", stat = "identity") +
  theme_dark() +
  labs( x = "Mes",
        y = "Ventas",
        title = "ÁREA - TEXTIL"
  ) 

g + geom_hline(yintercept=750, color="darkblue",linewidth=2)

#### ticks
g + scale_y_continuous("Ventas", breaks=seq(0,1500,100))

#### texto
g+ annotate(geom="text", x=6, y=1300, label="Rebajas de verano",
           color="darkgoldenrod1")
 
#### Diagrama de barras - apiladas

dfAreaCentro %>% 
ggplot(aes(x = meses, y = total, 
           fill = CENTRO)) +
  geom_bar(stat = "identity") +
  theme_classic() +
  labs( x = "Mes",
        y = "Ventas",
        title = "ÁREA - TEXTIL"
  )
### Con valores uno al lado del otro
#install.packages("hrbrthemes")
#library(hrbrthemes)

dfAreaCentro %>% 
  ggplot(aes(x = meses, y = total ,fill = CENTRO)) +
  geom_bar(position="dodge",stat = "identity") +
  #theme_dark() +
  labs( x = "Mes",
        y = "Ventas",
        title = "ÁREA - TEXTIL"
  )



##### Histogramas
dfAreaMes <-df %>% filter(CENTRO=="3156", AREA=="ALIMENTACION") %>% 
            group_by(REF.CENTRAL) %>%  summarise(total=sum(VENTAS)) %>%
            filter(total<1000)
hist(dfAreaMes$total,breaks=30,col="blue",main="Histograma",
     xlab="total",ylab="cantidad",
     ylim=c(0,5000) )

## gplots2
ggplot(dfAreaMes, aes(x=total)) + geom_histogram()

ggplot(dfAreaMes, aes(x=total)) + geom_histogram(bins=10)

ggplot(dfAreaMes, aes(x=total)) + geom_histogram(color="blue", fill="cyan")

ggplot(dfAreaMes, aes(x=total)) + 
  geom_histogram(color="blue", fill="cyan") + 
   geom_vline(aes(xintercept=mean(total)),
           color="blue", linetype="dashed", size=1)

###### Pie charts

# Ejemplo 5
x <- c(15.29, 9.65, 44.54, 12.38)
labels <- c("0-14", "15-24", "25-54", "55-64")
colores = rainbow(length(x))

pie(x,labels=paste(x," %"),radius=1,
    main="Distribución …", col = colores)

legend("topright",paste(labels," años"),
       cex = 0.8, fill = colores)

#### Pie chart ggplots

dfTotalMes <- df %>% filter(AREA=="TEXTIL") %>%
  group_by(N.Mes,MES) %>%
  summarise(total=sum(VENTAS)) 

dfTotalMes  %>%
  ggplot(aes(x = "", y = total,fill = MES)) +
  geom_bar(stat = "identity") +
  coord_polar("y", start=0) + 
  theme_void()


# ejemplo 6
install.packages("plotrix")
library(plotrix)
pie3D(x,labels=paste(x," %"),explode = 0.1, main = "Distribución… ",    col = colores)
legend("bottomleft",paste(labels," años"), cex = 0.6, fill = colores)

###### Correlaciones
# Ejemplo 7

#url = "https://ucmdrive.ucm.es/s/zbjRbYfNtwmicGX/download/ventas.csv"
library(dplyr)
library(tidyr)
url = "https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/ventasmini.csv"
df = read.csv(url, sep=",", encoding="UTF-8", colClasses=c("CENTRO"="character", "REF.CENTER"="character" , "REF.CENTRAL"="character"))

dfMesCat <- df %>%filter(CENTRO=="3156",SECCION=="BEBIDAS") %>% 
            group_by(N.Mes,CATEGORIA) %>% summarise(total=sum(VENTAS))

df_cats <- dfMesCat %>% spread(CATEGORIA, total)

M <- cor(df_cats[,2:9]) # quitamos el mes
M


# Ejemplo 8
install.packages("corrplot")
library(corrplot)
# vamos a hacer los nombres más pequeños quitando la palabra "bebidas"
colnames(df_cats) <- gsub("BEBIDAS ","",colnames(df_cats))
M <- cor(df_cats[,2:9])
corrplot(M, method="number", type="upper")

### Ejemplo 9
corrplot(M, method="circle", type="upper", order="hclust")

############ TREEMAP
# ejemplo 10
install.packages("treemap")
library(treemap)
library(dplyr)
# seleccionamos solo alimentación y frescos porque son los que ocupan casi la totalidad
df_area <- df %>% filter(CENTRO=="3156" & (AREA=="ALIMENTACION" | AREA=="FRESCOS")) %>%
          group_by(AREA,SECCION) %>% summarise(total=sum(VENTAS))

treemap(df_area, # dataframe
        index=c("AREA","SECCION"), # grupos y subgrupos
        vSize="total", # variable que determinará el área del rectángulo
        type="index",  # cómo se determina el color. En este caso por grupos
        title = "VENTAS por secciones en las áreas ALIMENTACION y FRESCOS",
        fontsize.labels=c(15,12), # Tamaño de las etiquetas
        fontcolor.labels=c("white","orange"), # Color de las etiquetas
        fontface.labels=c(2,1),               # Tipo de font (ver ayuda)        
        bg.labels=c("transparent"),           # Fondo de las etiquetas        
        align.labels=list(c("center", "center"), c("right", "bottom")), # situación de las etiqs.
        overlap.labels=1,       # si se tolera superposición de etiqs        
        inflate.labels=F,       # Si T, el tamaño de la etq. depende del área        
        force.print.labels=T # muestra las etiquetas, incluso si no caben
        )

## Ejemplo 11
grafica_area_centro = 
  function(centro,color,df) {
    dfAreaCentro <- df %>% filter(CENTRO==centro) %>% 
      group_by(AREA) %>% summarise(total=sum(VENTAS));
    barplot(dfAreaCentro$total,
            main=paste("CENTRO ",centro),
            xlab="Área",
            ylab="Ventas",
            ylim = c(0,4000000),
            col=color,
            names.arg=dfAreaCentro$AREA
    )
    box()
    return
  }

par(mfrow=c(1,2))
grafica_area_centro("3156","red",df)
grafica_area_centro("3908","blue",df)

### LAYOUT 12
layout(matrix(c(	1, 1, 1,
                 2, 3, 4,
                 2, 3, 4), nrow=3,
              byrow=TRUE))
layout.show(n=4)

### Ejemplo 13
library(dplyr)
library(maditr)
# totales por mes de cada segmento para el área frescos 
df_cat_seg <- df %>% filter(CENTRO=="3156") %>% filter(SECCION=="BEBIDAS") %>% 
  group_by(N.Mes,CATEGORIA) %>% 
  summarise(total=sum(VENTAS)) %>%
  spread(CATEGORIA,total)

# Quitamos la columna mes y convertimos a matriz
data <- as.matrix(df_cat_seg[,2:ncol(df_cat_seg)])

# Los valores NA evitan que se reordene
heatmap(t(data),scale="row",Colv = NA, Rowv = NA,xlab="MES",  main="Mapa de ….")

### Ejemplo 14
dfArea <- df %>% filter(CENTRO=="3156" & AREA=="TEXTIL") %>% 
         group_by(N.Mes) %>% summarise(total=sum(VENTAS))

boxplot(dfArea$total, horizontal = TRUE, axes = FALSE)
text(x=fivenum(dfArea$total), labels =fivenum(dfArea$total), y=1.25)

### Ejemplo 15
dfAreaCentro <- df %>% filter( AREA=="TEXTIL") %>%  group_by(N.Mes,MES,CENTRO) %>%  summarise(total=sum(VENTAS))

boxplot(total~as.numeric(CENTRO), data=dfAreaCentro,  main="Ventas en textil por centro y mes",
        xlab="centro", ylab="ventas",col=c("orange","gold") ) 

library(ggplot2)
dfAreaCentro %>% ggplot( aes(x=CENTRO, y=total, color=CENTRO)) +
  geom_boxplot()

meses <- factor(dfAreaCentro$MES, level = unique(dfAreaCentro$MES))
dfAreaCentro %>% ggplot( aes(x=meses,
                        y=total, color=meses)) +
  geom_boxplot()+
  labs( x = "Mes",
        y = "Ventas",
        title = "ÁREA - TEXTIL",
        color = "Mes"
  )

# en horizontal
p <- dfAreaCentro %>% ggplot( aes(y=CENTRO,
                             x=total, color=CENTRO)) +
  geom_boxplot(outlier.colour="red", 
               outlier.size=4)+
  labs( y = "Mes",
        x = "Ventas",
        title = "ÁREA - TEXTIL",
        color = "Mes"
  )
p

### mostrando los puntos
p + geom_jitter(shape=16, position=position_jitter(0.2))

# con notch
boxplot(total~as.numeric(CENTRO), data=dfAreaCentro,  main="Ventas en textil por centro y mes",
        xlab="centro", ylab="ventas",col=c("orange","gold"), notch=T ) 

dfAreaCentro %>% ggplot( aes(x=CENTRO, y=total, color=CENTRO)) +
  geom_boxplot(notch=T)

### Ejemplo 16
install.packages("ggplot2")
library(ggplot2)
library(dplyr)
library(tidyr)
dfMesArea <- df %>% filter(CENTRO=="3156" & 
                             AREA=="FRESCOS") %>% 
  group_by(N.Mes,SECCION) %>% 
  summarise(total=sum(VENTAS)) %>%
  spread(SECCION, total)

ggplot(data=dfMesArea, 
       aes(CHARCUTERIA , CARNICERIA)) +
  geom_point()+ theme_classic()

### mejorado
dfMesArea2 <- df %>% filter(AREA=="FRESCOS") %>%    group_by(N.Mes,CENTRO,SECCION) %>%   summarise(total=sum(VENTAS)) %>%
  spread(SECCION, total)

ggplot(data=dfMesArea2,    aes(CHARCUTERIA , CARNICERIA,     color=CENTRO, size=3)) +
  geom_point()

#### Ejemplo 17
g <- ggplot(data=dfMesArea2, aes(CHARCUTERIA , CARNICERIA, color=CENTRO, size=3)) +
  geom_point() +scale_size(guide= 'none') + geom_smooth(method="lm", size=2)
g

### Ejemplo 18
g+ geom_abline(intercept=0,slope=1, color="magenta",size=2)


### Ejemplo 19
g  + geom_text(label=dfMesArea2$N.Mes, vjust=-1.5, show.legend = FALSE, color="black")

### Ejemplo 20
g + ggtitle("Comparativa con año anterior") +xlab("Ventas este año") + ylab("Ventas año anterior") +
  theme(
    plot.title = element_text(color="red", size=14, face="bold.italic"),
    axis.title.x = element_text(color="blue", size=12, face="bold"),
    axis.title.y = element_text(color="blue", size=12, face="bold") )

##### Ejemplo 21
dfTotalesMes <- df %>%  filter(CENTRO=="3156") %>%
  group_by(N.Mes) %>% 
  summarise(total=sum(VENTAS), total.AA=sum(VENTAS.AA))

dfFundido <- dfTotalesMes %>% gather("total","Ventas",-N.Mes)

ggplot(data=dfFundido, aes(y=Ventas , x=N.Mes, color=total, size=2,group=total)) +
  geom_line(size=1.5) + geom_point() +scale_size(guide= 'none') +
  scale_x_discrete(limits=dfFundido$N.Mes) 


#### Ejemplo 21
    











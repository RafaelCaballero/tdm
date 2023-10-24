
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

## Ejercicio 7
library(dplyr)
url = "https://ucmdrive.ucm.es/s/zbjRbYfNtwmicGX/download/ventas.csv"
df = read.csv(url, sep=";", encoding="UTF-8", colClasses=c("CENTRO"="character", "REF.CENTER"="character" ,                                                "REF.CENTRAL"="character"))


df2 <- df %>%filter(CENTRO=="3156") %>% group_by(AREA) %>% 
  summarise(total=sum(VENTAS))

barplot(df2$total,
        main="VENTAS POR ÁREA",
        xlab="ÁREA",
        col="darkred",
        names.arg=df2$AREA
)

## Ejercicio 8
dfSeccion <- df %>%
  filter(CENTRO=="3156", AREA== "FRESCOS") %>%
  group_by(SECCION) %>% 
  summarise(total=sum(VENTAS))

x <- dfSeccion$total
colores = rainbow(length(x))
pie(x,labels=x,radius=1,
    main="Distribución …", col = colores)
legend("topright", dfSeccion$SECCION,
       cex = 0.6, fill = colores)

## Ejercicio 9

df9 <- df %>% 
filter(CENTRO=="3156", AREA!= "GENERALES") %>% 
group_by(N.Mes, AREA) %>% 
summarise(media=mean(VENTAS)) %>%
spread(AREA,media) 

M <- cor(df9[,2:ncol(df9)])
corrplot(M, method="circle", type="upper", order="hclust")
  
## Ejercicio 10
# seleccionamos solo alimentación y frescos porque son los que ocupan casi la totalidad
df_area <- df %>% filter(CENTRO=="3156", AREA=="FRESCOS") %>%
  group_by(SECCION, CATEGORIA) %>% summarise(total=sum(VENTAS))

treemap(df_area, # dataframe
        index=c("SECCION","CATEGORIA"), # grupos y subgrupos
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

## Ejercicio 11
pdf("graficas.pdf")
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
dev.off()

## Ejercicio 12
url = "https://ucmdrive.ucm.es/s/zbjRbYfNtwmicGX/download/ventas.csv"
df = read.csv(url, sep=";", encoding="UTF-8", colClasses=c("CENTRO"="character", "REF.CENTER"="character" , "REF.CENTRAL"="character"))
dfbebidas <- df %>% filter(SECCION=="BEBIDAS") %>%
             group_by(N.Mes) %>% summarise(total=sum(VENTAS))
boxplot(dfbebidas$total, horizontal = TRUE, axes = FALSE, col="red")
text(x=fivenum(dfbebidas$total), labels =fivenum(dfbebidas$total), y=1.25)

# Ejercicio 13

# Ejercicio 14
ggplot(data=dfFundido, aes(y=Ventas , x=N.Mes, color=total, size=2,group=total)) +
  geom_point() +scale_size(guide= 'none') +
  scale_x_discrete(limits=dfFundido$N.Mes) 


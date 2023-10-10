
### P1
library(dplyr)
df_usa <- read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/tusa2020.csv",
                   encoding="UTF-8",colClasses=c("X_id"="character", "userid"="character" ))
df_usa %>% select(screen_name,retweet_count,text) %>% slice_max(retweet_count)

#P2
# a)
sum(duplicated(df))>0
# b)
df2 = df[!duplicated(df),]
# c)
sum(duplicated(df[,c("b","c")]))

# P3 
df_usa[df_usa==""] <- NA
sum(is.na(df_usa$text))

# P4
library(readxl)
excel_file = "./data/valores.xlsx"
df_SPX <- read_excel(excel_file) %>% select(fecha,SPX_Index_Open,SPX_Index_Closing)

df_SPX["bonificado"] = ifelse((df_SPX$SPX_Index_Closing-df_SPX$SPX_Index_Open)*100/df_SPX$SPX_Index_Open>1,"SI","NO")
df_SPX %>% filter(bonificado=="SI")
df_SPX %>% filter(bonificado=="SI") %>% count()

# P5

hoy <- df_SPX$SPX_Index_Closing[1:(nrow(df_SPX)-1)]
maC1ana <- df_SPX$SPX_Index_Closing[2:nrow(df_SPX)]
fechamaC1ana <- df_SPX$fecha[2:nrow(df_SPX)]
bonificado <- (maC1ana-hoy)*100/hoy>1
fechamaC1ana[bonificado]

# Otra forma
hoy <- df_SPX$SPX_Index_Closing[1:(nrow(df_SPX)-1)]
diferencias <- diff(df_SPX$SPX_Index_Closing)
fechamaC1ana <- df_SPX$fecha[2:nrow(df_SPX)]
bonificado <- (diferencias)*100/hoy>1

# P6
df_usa <- df_usa %>% select(!(coordinates))


# Ejercicio 7
s = factor(c("limones", "fresas", "fresas", "fresas", "limones", "ciruelas"))
sum(s=="limones")*1.85

# Ejercicio 8
m = matrix(1:12, nrow = 3, ncol = 4)
#     [,1] [,2] [,3] [,4]
#[1,]    1    4    7   10
#[2,]    2    5    8   11
#[3,]    3    6    9   12


### Ejercicio 9
m = rbind(c(20,0,3),c(0,8,0),c(4,5,0))
m[m==0]=1

#### Ejercicio 10
lista[[3]][2] = "frescos" # cambia el segundo elemento del array 3

lista[[4]][1]="desconocido"  # cambia el primer elemento y el tipo del resto

### Ejercicio 11
lista[[7]] <- lista[[7]]+1

#### Ejercicio 12
## Equivale a lista[[3]]

#### Ejercicio 13
lista$fechaini <- lista$fechaini+10


# P14
cantidad = c(1,2,5,1,3,4,8)
producto = c("13.1532","02.5333","08.1532","13.1532","11.1111","13.1532","03.1532")
df_ventas = data.frame(cantidad,producto) 
df_ventas %>% filter(str_sub(producto,end=2)=="13") %>% count

#### P15
library(stringr)
df_usa <- read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/tusa2020.csv",
                   encoding="UTF-8",colClasses=c("X_id"="character", "userid"="character" ))
palabras <- unlist(str_split(df_usa$text," "))
comparacionT <- palabras == "@realDonaldTrump"
sum(comparacionT)
comparacionB <- palabras == "@JoeBiden"
sum(comparacionB)


#### P16
puesto <- c("Chief Executive Officer","Chief Manager Officer",
             "Chief Technical Officer","Manager","Product Manager","Programmer","Scientist",
             "Marketer","Lawyer","Secretary")
nombre <- c("Herminia","Bertoldo","Casilda","Aniceto", "Prudencio","Gertrudis","Agapita",
             "Bonifacio","Patrocinia","Tiburcio")
df_puestos = data.frame(puesto,nombre)

# a) 
df_puestos %>% filter(str_detect(puesto,"Manager")) %>% select(nombre)

# b) 
df_puestos %>% filter(str_detect(puesto,"Manager",negate=TRUE)) %>%
               filter(str_detect(puesto,"Chief",negate=TRUE)) %>%
              select(nombre)

# c) 
df_puestos %>% filter(str_detect(puesto,"Manager",negate=TRUE) | puesto=="Product Manager") %>%
  filter(str_detect(puesto,"Chief",negate=TRUE)) %>%
  select(nombre)




#### Ejercicio 17
library(dplyr)
library(stringr)

url = "https://es.wikipedia.org/wiki/Anexo:Comunidades_y_ciudades_aut%C3%B3nomas_de_Espa%C3%B1a"
df_comunidades <- read_html(url) %>%
  html_node("table") %>%
  html_table() %>%
  setNames(c("indice","nombre", "capital", "poblacion","porcentaje_pob", "densidad","superficie","porcentaje_sup","mapa","percapita"))

## Paso 1
mitades <- str_length(df_comunidades$nombre)/2
df_comunidades$nombre <- str_sub(df_comunidades$nombre,end=mitades)

## Paso 2
df_comunidades$capital <- str_replace(df_comunidades$capital,"\\[(.)*\\]","")

## Paso 3
df_comunidades$poblacion <- str_replace(df_comunidades$poblacion,"^(&)*0","")
df_comunidades$poblacion <- str_replace(df_comunidades$poblacion,"(.)*\\.(&)*(\\d)*$","")
df_comunidades$poblacion <- str_replace(df_comunidades$poblacion,"(\\.(.)*)$","")

#### Ejercicio 18
formato = "%Y-m-dTH:M:S.000Z"
formato = "%Y-%m-%dT%H:%M:%S.000Z"
df_usa$emitido = strptime(df_usa$created_at,formato)
max(df_usa$emitido)
min(df_usa$emitido)
max(df_usa$emitido)-min(df_usa$emitido) # b
emitido_o = df_usa$emitido[order(df_usa$emitido)] # c
# Time difference of 755.2466 days


###### Carga de datos
library(dplyr)
df_usa <- read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/tusa2020.csv",
                   encoding="UTF-8",  colClasses=c("X_id"="character", "userid"="character",
                                                   "RT_source"="character") )

###### Detección de filas duplicadas (I)
#
v <- c(1, 1, 9, 8, 9, 6)
duplicated(v)
sum(duplicated(v)) # número de duplicados
v[duplicated(v)] # valores duplicados
v[!duplicated(v)] # quitar valores duplicados ( el operador ! cambia la lista a TRUE FALSE TRUE TRUE FALSE TRUE


# Ejercicio 2
df_d <- data.frame(a=c(1,2,4,1,2),b=c(3,4,4,3,1),c=c(1,1,1,1,1))

#### Detección de columnas duplicadas
duplicated(data.frame(t(df_d)))
df_d <- data.frame(a=c(1,2,4,1,2),b=c(3,4,4,3,1),c=c(1,1,1,1,1),d=c(3,4,4,3,1))

###### Detección de filas duplicadas (II)
#

unique(df_d)

library(dplyr)

# filas duplicadas
distinct(df_d) # o df_d %>% distinct()

# solo considerar filas b,c, para detectar duplicados 
# pero mantener todas
df_d %>% distinct(b,c, .keep_all=TRUE) 


##### Contando valores:  count
#
library(dplyr)

df_usa %>% filter(retweet_count > 1000) %>% count


# Otra utilidad es contar la cantidad de valores diferentes en una columna
count(df_usa,lang)

# el resultado es una lista y puede ser utilizado como un dataframe
df_usa %>% count(lang) %>% slice_max(n,n=5)


### Valores especiales
df_magic <- data.frame(a=c(1,2,4,99,2),b=c(99,99,4,3,1),c=c(99,99,1,1,1))
summary(df_magic)

## Valores especiales: tratamiento
df_magic[df_magic==99] = NA
summary(df_magic)

##### la función ifelse
df_magic <- data.frame(a=c(1,2,4,99,2),b=c(99,99,4,3,1),c=c(99,99,1,1,1))


# cambiar 99 por NA solo en la columna "a"
df_magic$a[df_magic$a==99] <- NA 
df_magic$a <- ifelse(df_magic$a==99,NA,df_magic$a) # equivalente 

# en la columna a, cambiar cada 99 por lo que tenga la columna b de la misma fila
df_magic$a[df_magic$a==99] <- df$b[df$a==99]
df_magic$a <- ifelse(df_magic$a==99,df_magic$b,df_magic$a) # equivalente


# Pregunta 2
library(readxl)
excel_file = "./data/valores.xlsx"
df_SPX <- read_excel(excel_file) %>% select(fecha,SPX_Index_Open,SPX_Index_Closing)

df_SPX <- valores %>% select(fecha,SPX_Index_Open,SPX_Index_Closing)


### Ignorando los huecos
df_magic <- data.frame(a=c(1,2,4,99,2),b=c(99,99,4,3,1),c=c(99,99,1,1,1))
df_magic[df_magic==99] <- NA
summary(df_magic)

### Ignorando los huecos (II)
mean(df_magic$a)
mean(df_magic$a, na.rm = TRUE)


### ¿Cúantos valores missing hay?
sum(df_usa$nRTin==NA) ## mal, no se puede comparer con NA (pensar por qué…)

# mejor así 
sum(is.na(df_usa$nRTin))

# alternativa
df_usa$ nRTin %>% is.na %>% sum


#### Missing en tidyverse
library(tidyverse)  # si no está install.packages(tidyverse)
df_usa <- read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/tusa2020.csv",
                   encoding="UTF-8",  colClasses=c("X_id"="character", "userid"="character" ) )

df_usa %>% drop_na()

df_usa %>% drop_na(text) %>% count

#### Valores missing gráficamente
sum(is.na(df_usa))
#install.packages("Amelia")
library(Amelia)
missmap(df_usa)

#### Valores missing gráficamente (II)
install.packages("naniar")
library(naniar)
gg_miss_var(df_usa)


### Valores missing gráficamente (III)
gg_miss_case_cumsum(df_usa,breaks = 400)

### Valores missing gráficamente (IV)
install.packages("naniar")
library(naniar)
gg_miss_fct(x = df_usa, fct = RT)



##### Variables categóricas: toman una cantidad finita de valores
#
data = c("mandarinas postre", "mandarinas zumo", "limones", "limones", "limones", "pomelos", "freson", "freson")
print(data)

print(is.factor(data)) # no es un factor, solo un vector normal

segmento = factor(data) # lo convertimos a factor
print(segmento)
print(is.factor(segmento))

summary(segmento) # esto se puede hacer por ser un factor

##### Factores: acceso
s = factor(c("limones", "fresas", "fresas", "fresas", "limones", "ciruelas"))

s[2:4]

s[-1]

s[2] = "ciruelas"
s[3] = "pomelos"     # qué ocurre?


#### Ejercicio 7
s = factor(c("limones", "fresas", "fresas", "fresas", "limones", "ciruelas"))


#### Matrices, ejemplos
m1 = rbind(c(20,30),c(60,80))
m1
m2 = m1/10
m2
m3 <- matrix (
  c(2 , 4, 3, 6, 5, 7), # datos
  nrow =2, # filas
  ncol =3, # columnas
  byrow = TRUE)
m1 * m2
m1 %*% m2


#### Matrices: acceso
m3[2,3] 
m3[ , 2]  
m3[2, ]  

##### Ejercicio 8
m = matrix(1:12, nrow = 3, ncol = 4)

#### Matrices: asignación
m3[2,3] = 5
m3[ , 2] =  0

## Ejercicio 9
m = rbind(c(20,0,3),c(0,8,0),c(4,5,0))


#### Listas
cadena = "areas"
nareas = 3
areas  = c("Alimentación","bazar","textil")
secciones =  c(140, 200, 137)
en_todos = c(TRUE, FALSE, FALSE)
fechaIni = as.Date('2020-2-2')
fechaFin = as.Date('2020-10-30')

lista = list(cadena, nareas, areas, secciones,en_todos,fechaIni,fechaFin)
print(lista)


#### Listas: acceso y modificación
lista[2]=4
lista2 = c(lista,3)
length(lista)
lista[2]
lista[[2]]    # qué diferencia ¿hay?

#### Ejercicio 5
lista[[3]][2] = "frescos"

lista[[4]][1]="desconocido"


##### Listas: nombres/atributos
names(lista) = c("descripcion","areas","secciones", "cantidad", "en_todos","fechaini","fechafin")
lista


##### Mostrando información: print y cat
#

# cat solo puede imprimir tipos basicos, no  dataframes
df <- data.frame(v=c(3,4,5,4,3,8,10))
cat(df)   

#cat no incluye salto de lmnea al final, print sm
cat("todo "); cat("junto")

print("esto"); print("separado")

cat("ahora\n"); cat("separado\n")



##### print en pipelines
#

# print ademas de imprimir devuelve el valor que ha impreso, mientras que cat devuelve NULL 
x = print(4)
x

x = cat(4)
x

# Esto  permite utilizar print con estilos de programacisn "pipeline"

library(dplyr)
df %>%  print %>%  sum %>% print

#### scan para escribir en ficheros
#
#scan permite escribir en ficheros, no solo en pantalla

sink("data/results.txt")
cat('La media es ')
cat(mean(df$v))
cat(".\n")
sink()

#Otra forma:
cat('La mediana: ', median(df$v), file="data/results2.txt")

#Y aun otra, abriendo un fichero que ya existe y añadiendo líneas nuevas
cat('El máximo: ', max(df$v), ' y el mínimo: ',min(df$v), '\n', file="data/results.txt", append = TRUE)


#### paste para convertir a caracteres

# Paste convierte a carácter y junta, añadiendo distintos valores en una sola cadena
s = paste("hola", " gente")
print(s)


#Útil también para combinar columnas generando valores de texto, en este caso indicamos que no añada espacios son sep=“”
df_tweet = read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/user_coords.csv",encoding="UTF-8") 
df_tweet$coordinates = paste('(',df_tweet$lat,'.', df_tweet$long, ')', sep="")


#### Funciones comunes para tratar texto
library(stringr) # install.packages("stringr")
str_length("abracadabra")

#### Una para todas…
str_length("abracadabra")


library(dplyr)
df_usa <- read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/tusa2020.csv",
                   encoding="UTF-8",colClasses=c("X_id"="character", "userid"="character" ))
df_usa %>% filter(str_length(text)==max(str_length(text)))

# si queremos saber cuántos caracteres tiene
df_usa %>% filter(str_length(text)==max(str_length(text))) %>% select(text) %>% str_length

### str_sub(string,start,end)
### localizar subcadenas por posición
cantidad = c(1,2,5,1,3,4,8)
producto = c("13.1532","02.5333","08.1532","13.1532","11.1111","13.1532","03.1532")
df_ventas = data.frame(cantidad,producto) 

df_ventas %>% filter(str_sub(producto,start=4)=="1532") %>% select(cantidad) %>% sum

#### str_sub(string,start,end) (II)
## modificar subcadenas
id_prod <- str_sub(df_ventas$producto,start=4)
df_ventas$producto <- ifelse(id_prod=="1532","9999",id_prod)

### str_pad, str_trim, str_trunc añadir y quitar espacios y otros caracteres
#
str_trim(" fuera espacio que sobra   ",side="both")
"fuera espacio que sobra"

str_pad("hola",10,side="right",pad="*")
"hola******"


######## str_to_lower, str_to_upper…
frase <- "cuando despertó, el dinosaurio todavía estaba allí"
str_to_upper(frase)
#"CUANDO DESPERTÓ, EL DINOSAURIO TODAVÍA ESTABA ALLÍ"
str_to_lower(frase)
#"cuando despertó, el dinosaurio todavía estaba allí"
str_to_title(frase)
#"Cuando Despertó, El Dinosaurio Todavía Estaba Allí"
str_to_sentence(frase)
#"Cuando despertó, el dinosaurio todavía estaba allí"

#### str_split para separar cadenas
s = str_split("el que habla no sabe el que sabe no habla", " ")
unlist(s)
sum(unlist(s)=="que")


### Ejercicio 10
df_usa <- read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/tusa2020.csv",
                   encoding="UTF-8",colClasses=c("X_id"="character", "userid"="character" ))


#### Detección: str_detect
#

lenguajes <- c("R","Python","Matlab","Java","C","C++", "C#")
str_detect(lenguajes,"C")

str_subset(lenguajes,"C")

str_which(lenguajes,"C")

sum(str_detect(df_usa$text,"@realDonaldTrump"))

## para comparar
palabras <- unlist(str_split(df_usa$text," "))
comparacionT <- palabras == "@realDonaldTrump"
sum(comparacionT)

#### Ejercicio 11
puestos <- c("Chief Executive Officer","Chief Financial Officer",
"Chief Technical Officer","Manager","Product Manager","Programmer","Scientist",
"Marketer","Lawyer","Secretary")
nombres <- c("Herminia","Bertoldo","Casilda","Aniceto", "Prudencio","Gertrudis","Agapita",
             "Bonifacio","Patrocinia","Tiburcio")
df_puestos = data.frame(puestos,nombres)


### Localización: str_locate, str_locate_all 

s = unlist(str_split("infame turba de nocturnas aves"," "))
str_locate(s,"ur")


### Localización: str_replace, str_replace_all 

s = unlist(str_split("infame turba de nocturnas aves"," "))
str_replace(s,"ur","e")

str_replace_all(c("abracadabra","mañana","alabanza"),"a","")

### Expresiones regulares: posición

frases <- c("passwd:albricias.","user:bertoldo", "passwd:gominolas.", "user:casilda passwords.")
str_detect(frases,"^(passwd)") %>% sum

str_detect(frases,"\\.$") %>% sum

#### Cuantificadores y caracteres comodín
frases <- c("password:albricias.","user:bertoldo", "passwd:gominolas.", "user:casilda passwords.")
str_detect(frases,"^(passw(or)?d)") %>% sum

### Expresiones regulares: | or

frases <- c("DNI:08933432","NIE:45454X", "passwd:gominolas.", "DNI:casilda passwords.")
str_detect(frases,"^(DNI|NIE):") %>% sum

### Expresiones regulares: secuencias
frases <- c("passwd:albricias.","user:bertoldo", "passwd:gominolas.", "user:casilda passwords.")
str_replace(frases,"^(passwd:(\\w)*)","passwd:*****")



#### Ejercicio 17 (difícil) OJO No carga
library(dplyr)  
library(stringr)
library(rvest)
url = "https://es.wikipedia.org/wiki/Anexo:Comunidades_y_ciudades_aut%C3%B3nomas_de_Espa%C3%B1a"
df_comunidades <- read_html(url) %>%
  html_node("table") %>%
  html_table() %>%
  setNames(c("indice","nombre", "capital", "poblacion","porcentaje_pob", "densidad","superficie","porcentaje_sup","mapa","percapita"))

#####

sFecha = "24/12/2020 11:55pm"
formato = "%d/%m/%Y %I:%M%p"
fecha1 = as.Date(sFecha,formato)  # Date
fecha2 = strptime(sFecha,formato) #POXIS 

#### Otras posibilidades
install.packages("lubridate")
library(lubridate)
seconds_to_period(62460055)

t<- seconds_to_period(62460055)
year(t); month(t); mday(t); hour(t); minute(t); second(t);

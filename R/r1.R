########### Introducción a R

########### Sesión 1

# RStudio: librerías
install.packages("dplyr")
library(dplyr)

#Si se quiere (y funciona) se puede instalar la librería tidyverse que incluye dplyr
install.packages("tidyverse")
library(tidyverse)

##
typeof(3.5)

### P5
x= 2
y = x^3
x = y+x
y = x-1
print(x)
print(y)

## P6
a = c("Bertoldo", "Herminia", "Aniceto")
b = c(1, 2, 3, "vaya")
c = c(4, 5, 6, FALSE, TRUE)


## CSV, carga: ejemplo
df_tweet = read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/user_coords.csv",encoding="UTF-8") 

# P7
# https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/parocomunidades.csv

### Excel 
# Librerías
install.packages("readxl")
install.packages("writexl")


library(readxl)
library(writexl)

# lectura simple
excel_file = "./data/valores.xlsx"
df_valores = read_excel(excel_file)

# nombres de las hojas
print(excel_sheets(excel_file))

# lectura de una sección de una hoja
df_SPX <- read_excel(excel_file,
                   sheet     = "InduSPX",
               	   range     = "H1:M2632")

# una nueva columna				   
df_SPX$diferencia <- df_SPX$SPX_Index_Closing - df_SPX$SPX_Index_Open


# escritura
# por desgracia no incluye la posibilidad de decir 
# en qué hoja
write_xlsx(df_SPX, "./data/spx.xlsx")


## Dataframes: creación desde vectores
año = 2000:2020
peru = c(1955.588006,	1941.475342,	2021.240038,	2145.643889,	2417.034363,	2729.499172,
  	     3154.331349,	3606.070689,	4220.616378,	4196.311627,	5082.353706,	5869.323882,	
		 6528.971775,	6756.752996,	6672.877373,	6229.100674,	6204.996457,	6710.507602,
		 6957.793411,	7027.612207,	6126.87454)
bolivia = c(997.5817489,	948.8702113,	904.2257999,	907.5374158,	967.4064586,	1034.3118,
		1218.87407,	1372.628368,	1715.208393,	1754.209464,	1955.460181,	2346.337844,	
		2609.880562,	2908.200371,	3081.878824,	3035.971655,	3076.656439,	3351.124344,
		3548.59078,	3552.068144,	3143.045494)
ecuador = c(1445.279324,	1894.616196,	2172.101877,	2425.851842,	2691.277685,	3002.138604,
		3328.884156,	3567.837186,	4249.01897,	4231.619235,	4633.591284,	5200.555108,
		5682.046108,	6056.331213,	6377.093929,	6124.490887,	6060.092962,	6213.503127,
		6295.934662,	6222.524653,	5600.389615)
colombia = c(2520.481089,	2439.682456,	2396.627127,	2281.401762,	2782.623185,	3414.465158,
		3741.092837,	4714.073055,	5472.53653,	5193.241458,	6336.709474,	7335.166934,
		8050.255372,	8218.347844,	8114.343921,	6175.87603,	5870.777957,	6376.706716,
		6729.583332,	6424.979492,	5332.773524)


df = data.frame(año, peru,bolivia,ecuador,colombia) 
nrow(df)
ncol(df)

## Dataframes: acceso por posición
df[1,2] # fila, columna

# filas 1 a 3, columna 4, como un vector
df[1:3,4] 

# filas 1 a 3, todas las columnas
df[1:3,] 

df[ , 2] # solo columna 2, todas las filas
df[2]     # igual a lo anterior

df[c(1,3),] # filas 1 y 3

df[-c(3)] # todas ls columnas, menos la 3

## Dataframes: acceso por nombre
df$peru  # seleccionar la columna peru
df[["peru"]]  # lo mismo

# varias columnas: usamos un vector
df[c("peru","colombia")]  

# columna peru de la 4 fila: 2 formas
df[4,"peru"]

df$peru[4]   # igual a lo anterior


### Dataframes: acceso por columnas  (dplyr) select
library(dplyr)

select(df,"peru", "bolivia")

df %>% select("peru", "bolivia")

# todas las columnas menos peru (!)
df %>% select(!(peru))

# Dataframes: renombramiento de columnas rename
df %>% select(año, peru) %>% rename(Perú=peru, Año=año)

# Dataframes: acceso por filas  (dplyr) slice

# la quinta fila 
df %>% slice(5)
df %>% slice(2:5)


# Dataframes: acceso por filas  slice_head, slice_tail, slice_sample

# 4 primeros
df %>% slice_head(n = 4)

# 4 últimos
df %>% slice_tail(n = 4)

# muestra de 4
df %>% slice_sample(n = 4)

# muestra de 4 con reemplazamiento
df %>% slice_sample(n = 4, replace = TRUE)
 

# Dataframes: acceso por filas  slice_min, slice_max

# antes de devolver las primeras filas ordena por la columna que se indica
df %>% slice_max(peru,n = 4)

# Si solo estamos interesados en las columna año y peru...
df %>% 
slice_max(peru,n = 4) %>% 
select(año, peru)


#### Dataframes: reordenando filas con arrange
#
df %>% arrange(desc(peru))

###
nombre    = c("Bertoldo",	"Herminia",	"Aniceto",	"Casilda")
apellido1 = c("Cacaseno",	"Arribas",	"Cacaseno",	"Congosto")
apellido2 = c("Peláez",     "Llopis",   "Winfinkel", "Zafrón")

dfNombre = data.frame(nombre, apellido1,apellido2) 
dfOrdenado = dfNombre %>% arrange(apellido1,apellido2,nombre)
dfOrdenado



#### Dataframes: acceso por filas  filter
# filter: filas que cumplen una condición
df %>% filter(año==2019)

# Solo datos a partir de 2010
df %>% filter (año >= 2010)

# filas en las que el dato de Per? supere al de colombia
df %>% filter (peru>=colombia)

#### Dataframes: filter (II)

# años posteriores a 2010 en los que la renta per capita 
# de Perú supera la media de rentas per capita del país para los 
# años incluídos en df
df %>% filter(peru>mean(peru)) %>% filter(año>2010)

# lo mismo de otra forma 
df %>% filter(peru>mean(peru), año>2010)

# P3 esto es esquivalente?
df %>% filter(año>2010) %>%  filter(peru>mean(peru))

### Dataframes: filter (III)
# Cuando se quiere que se cumpla al menos una 
# condición se unen con el s?mbolo |
df %>% filter(peru>ecuador | peru>colombia)

### Dataframes:  (algunas) funciones de agregación
# Las 3 primeras filas del dataframe f
df %>% filter(row_number()<=3)
# otra forma
df[1:3,]

#Fila correspondiente al año de m?xima diferencia en 
# renta per capita entre Bolivia y Ecuador
df %>% filter(abs(bolivia-ecuador)==max(abs(bolivia-ecuador)))

### Ejercicio P11
#a) 
df_paro = read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/parocomunidades.csv",encoding="latin1") 


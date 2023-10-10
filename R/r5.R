

################### Sesion 5

require(dplyr)
require(tidyr)
require(stringr)
require(writexl)

#### Funciones de usuario

### Un ejemplo
url <- "https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/clientes.csv"
df_clientes <- read.csv(url)
sum(df_clientes$entregado)/length(df_clientes$entregado)
url2 <- "https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/clientes2.csv"
df_clientes2 <- read.csv(url2)
sum(df_clientes2$entregado)/length(df_clientes2$entregado)

### Un ejemplo (II)
proporcion1s<- function(vector) {
  valor <- sum(vector)/length(vector)
  return (valor)
}

proporcion1s(df_clientes$entregado)
proporcion1s(df_clientes2$entregado)


### ejercicio 1
por2(3)
por2(5)
por2(c(2,3,4))

# ejercicio 2
negativos(c(8,-6,4,-1))

# ejercicio 3
salida <- "data/"
url <- "https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/clientes.csv"

# para probar
divide("2910167")

divide("7248498")

# ejercicio 4

divide("2910167","si2910167","resto")

# ejercicio 5

divide(c("2910167","7248498"),"sicods","resto")


#####  Param. por defecto
divide <- function(codigo,fich1="cli1",fich2="cli2") {
  salida <- "data/"
  url <- "https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/clientes.csv"
  df_clientes <- read.csv(url)
  df_cli1 <- df_clientes %>% filter(cliente==codigo)
  df_cli2 <- df_clientes %>% filter(!cliente==codigo)
  write.csv(df_cli1, paste(salida,fich1,".csv",sep=""), row.names=FALSE)
  write.csv(df_cli2, paste(salida,fich2,".csv",sep=""), row.names=FALSE)
}

divide("2910167","si2910167","resto")

divide("2910167")

# Encapsulando
suma1 <- function(x) { # mal
  x<-x+1
}

n = 5
suma1(n)
n

# segunda versi?n

suma1 <- function(x) { 
  return(x+1)
}
n = 5
n<-suma1(n)
n


## Utilizando funciones de usuario
moda <- function(df,v){
  which.max(tabulate(df[,v]))
}

df_clientes %>% moda("cliente")


###############Familia apply
############ 

### apply
# matriz de 5x6 valores aleatorios
X <- matrix(rnorm(30), nrow=5, ncol=6)

# Sumar los valores por columnas
apply(X, 2, sum)

#sapply ejemplos
df_p = data.frame(a=c(2,3,4,5,6),b=c(10,15,30,0,40))
sapply(df_p,print)
sapply(df_p,sum)
sapply(df_p,function(x) sum(x)*min(x))
sapply(df_p,function(x) sum(x)*(sum(x)>20))

# sapply y las funciones de usuario
negativos <- function(v) return (sum(v<0))
sapply(na.omit(df), negativos)
sapply(na.omit(df), function(v) return(sum(v<0)) )


#### lapply, sapply
df_usa <- read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/tusa2020.csv",
                   encoding="UTF-8",  
                   colClasses=c("X_id"="character", "userid"="character","RT_source"="character" ) )
df_usa$minustext <- unlist(lapply(df_usa$text,tolower))
df_usa$minustext <- sapply(df_usa$text,tolower)


## split y sapply: una buena pareja

###### Paso 1
urlCli <- "https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/clientes.csv"
urlGes <- "https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/clientegestor.csv"

df_clientes <- read.csv(urlCli)
df_gestor <- read.csv(urlGes)

# cada cliente con su gestor, pero sin perder clientes
df_cli_ges <- df_clientes %>% left_join(df_gestor)

# una lista con los datos de cada gestor
l_gestor<-split(df_cli_ges,df_cli_ges$gestor)

# función para grabar 
grabar <- function(df) {
  gestor <- df$gestor[1] # todos tienen el mismo
  fichero <- paste("data/reparto/",gestor,".csv",sep="")
  write.csv(df,fichero,row.names=FALSE)
}

# grabar
sapply(l_gestor,grabar)

##### t apply
tapply(df_cli_ges$tasas,df_cli_ges$gestor,sum)

# otra forma 
df_cli_ges %>% group_by(gestor) %>% summarise(TotalTasas=sum(tasas))

### instrucciones de control
## if

REF = c("13183686","14382832","72456","16624629","18439216","5577","21732490")
VENTAS = c(4,814,2303,2424,1343,237,0)
VENTAS.AA = c(0,695,2320,2210,1177,146,63)
MES<-1:7
DESCRIPCION = c("PLÁTANO AMERICANO","BANANA GRANEL","PLÁTANO CANARIO AHORRO EAN 24",
                "PLÁTANO CANARIO I.G. VARIABLE","PLÁTANO DE CANARIAS E. NATUR","MANZANA GRAN SMITH KG",
                "MANZANA G. SMITH 900G MARLENE")

df = data.frame(REF,MES, DESCRIPCION,VENTAS, VENTAS.AA) 

ventas <- function(r){
  if (r$VENTAS > r$VENTAS.AA) 
    cat(r$DESCRIPCION," vendió más que el año pasado en el mes ",r$MES)
}

ventas(df[1,])

ventas(df[4,])

## else
masomenos <- function(df,fila) {
  r = df[fila,]
  cat(" el producto", r$DESCRIPCION," vendió ")
  if (r$VENTAS > r$VENTAS.AA) {
    cat(" MÁS ")
  }
  else {
    cat("MENOS ")
  }
  cat("que el año pasado en el mes ",r$MES,"\n")
}
masomenos(df,4)

#### for 
for (x in c(1,2,4,6,3)) 
  print(x)

for (x in 1:5) {
  if (x%%2==0) cat(x,"es par\n")
  else cat(x,"es impar\n")
}

# for: columnas
minidf = data.frame(a=c(1,2,3),b=c(2,4,5),c=c(6,8,10))
for (r in minidf) print(r)
# for: columnas de otra forma
for (c in names(minidf))  print(minidf[c])

# por columnas y filas
for (r in minidf){
  for (c in r) {
    cat(c, ' ')
  }
  cat("\n")
}

# por filas y columnas, usando la posición
for (i in 1:nrow(minidf)) {
  for (j in 1:ncol(minidf)){
    cat(minidf[i,j],' ')
  }
  cat("\n")
}

### while 
i = 1
while (i < 6) {
  print(i)
  i = i+1
}

# while búsqueda en dataframe
df = read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/parocomunidades.csv",encoding="latin1")

# esto no es necesario, pero solo por recordarlo
df = na.omit(df)
df <- df %>% arrange(Comunidad,Periodo) 

anterior = df[1,]
fila=2
encontrado=FALSE # de momento

while(!encontrado && fila<nrow(df)) {
    r = df[fila,]
    ## seguimos con la misma comunidad?
    if (r$Comunidad == anterior$Comunidad && anterior$Total!=0){
      decremento <- (anterior$Total-r$Total)*100/anterior$Total
      if (decremento>20){
        cat(anterior$Comunidad,anterior$Total,anterior$Periodo,
            r$Comunidad,r$Total,r$Periodo,"\n")
        encontrado=TRUE
      }
    }
    # preparamos la siguiente iteración
    anterior = r
    fila = fila+1
  }


#####
## repeat
x = 1
repeat {
  print(x)
  x = x+1
  if (x == 6){
    break
  }
}

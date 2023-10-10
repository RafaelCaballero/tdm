
# Ejercicio 1
por2 <- function(n){ return (2*n) }


# Ejercicio 2
negativos <- function(v){
  return (sum(v<0))
} 

# Ejercicio 3
salida <- "data/"
url <- "https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/clientes.csv"

#a)
df_cli1 <- df_clientes %>% filter(cliente=="2910167")
df_cli2 <- df_clientes %>% filter(!cliente=="2910167")

#b)
write.csv(df_cli1, paste(salida,"cli1.csv",sep=""), row.names=FALSE)
write.csv(df_cli2, paste(salida,"cli2.csv",sep=""), row.names=FALSE)

#c) 
divide <- function(codigo) {
  salida <- "data/"
  url <- "https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/clientes.csv"
  df_clientes <- read.csv(url)
  df_cli1 <- df_clientes %>% filter(cliente==codigo)
  df_cli2 <- df_clientes %>% filter(!cliente==codigo)
  write.csv(df_cli1, paste(salida,"cli1.csv",sep=""), row.names=FALSE)
  write.csv(df_cli2, paste(salida,"cli2.csv",sep=""), row.names=FALSE)
}


divide("2910167")

divide("7248498")

# Ejercicio 4

divide <- function(codigo,fich1,fich2) {
  salida <- "data/"
  url <- "https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/clientes.csv"
  df_clientes <- read.csv(url)
  df_cli1 <- df_clientes %>% filter(cliente==codigo)
  df_cli2 <- df_clientes %>% filter(!cliente==codigo)
  write.csv(df_cli1, paste(salida,fich1,".csv",sep=""), row.names=FALSE)
  write.csv(df_cli2, paste(salida,fich2,".csv",sep=""), row.names=FALSE)
}

# Ejercicio 5
# a): Nada

# Ejercicio 6

sapply(df_p,function(x) c(max(x),min(x)))

# versión con nombres de filas
l = sapply(df_p,function(x) c(max(x),min(x)))
rownames(l) = c("max","min")
l

## Ejercicio 7

ficheros<-dir("data/reparto")

ficheros<-dir("data/reparto/")

convierte  <- function(nombre){
  fichero_csv <- paste("data/reparto/",nombre,sep="")
  cat(fichero_csv,"-->")
  df <- read.csv(fichero_csv)
  sin_ext <- str_sub(nombre,end=-4)
  fichero_excel <- paste("data/reparto_excel/",sin_ext,"xlsx",sep="")
  print(fichero_excel)
  write_xlsx(df, fichero_excel)
}
sapply(ficheros,convierte)

## Ejercicio 8

ficheros<-dir("data/reparto")

maxTasa <- function(nombre){
  fichero <- paste("data/reparto/",nombre,sep="")
  print(fichero)
  df <- read.csv(fichero)
  print("leido")
  salida <- df %>% slice_max(tasas)
  return(salida)
}

sapply(ficheros,maxTasa)


# ejercicio 9
ventas <- function(r){
  MES=2
  DESCRIPCION=3
  VENTAS=4
  VENTAS.AA=5
  if (r[VENTAS] > r[VENTAS.AA]) 
    cat(r[DESCRIPCION]," vendió más que el año pasado en el mes ",r[MES],"\n")
}

apply(df,1,ventas)


### Ejercicio 10
diagonal <- function(df,x) {
  for (i in 1:nrow(df)){
    df[i,i]=x
  }
  return (df)
}
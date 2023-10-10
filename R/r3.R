#### sesión 3

### Recordatorio: algunas cosas que ya sabemos
#install.packages("readxl")
require(readxl) # carga la librería si no está ya cargada
excel_file = "./data/valores.xlsx"
df_valores = read_excel(excel_file)

# dplyr::select: quedarse solo con algunas columnas
require(dplyr)
df_valores %>% select(fecha,INDU_Index_Open)
df_valores %>% select(!(fecha)) # todas menos fecha
df_valores %>% select(starts_with("SPX_Index")) # el nombre empieza con SPX_Index

# dplyr::rename para cambiar los nombres
df_valores %>% rename(date=fecha)

###### Algunas cosas que ya sabemos (II)
# dplyr:arrange para ordenar
df_valores %>% arrange(desc(fecha))

#dplyr::filter: para quedarse solo con algunas filas
df_valores %>% filter(INDU_Index_Closing < INDU_Index_Open )

# dplyr:slice, slice_max, slice_min,slice_sample para mostrar unas pocas columas
df_valores %>% slice_max(INDU_Index_Closing)

# dplyr:mutate para crear nuevas columnas
df_SPX_diff <- df_valores %>% mutate(diffSPX = INDU_Index_Closing - INDU_Index_Open)

###### Algunas cosas que ya sabemos (III)


# If_else: operaciones condicionales
df_SPX_diff <- df_SPX_diff %>% mutate(move=ifelse(diffSPX>0,"UP","DOWN")) %>% select(diffSPX,move)

# funciones para contar, sumar, etc
df_SPX_diff %>% count()
df_SPX_diff %>% count(move)
df_SPX_diff %>% count(move,name="Total por tipo",sort=TRUE)

# dplyr:distinct elimina duplicados
df_abc = data.frame(a=c(1,4,3,4,5), b= c(1,4,3,4,4),c=rep(3,5)) 
df_abc %>% distinct

# is.na para saber si un valor es NA
is.na(c(NA,2,3,4,NA))

# dropna() para quitar las filas con NA
require(dplyr)
require(tidyr) # install.packages("tidyr")
df_usa <- read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/tusa2020.csv",
                   encoding="UTF-8",  colClasses=c("X_id"="character", "userid"="character" ) )

df_usa %>% drop_na(quote_count) %>% count

#### Leyendo fichero SAS 
# Alternativa "sas7bdat"
install.packages(c("haven", "sas7bdat"))
require(haven)
salary <- read_sas("http://www.principlesofeconometrics.com/sas/salary.sas7bdat")
# para jugar un poco, correlaciones entre las variables
cor(salary)

usa <- read_sas("http://www.principlesofeconometrics.com/sas/usa.sas7bdat")
cor(usa)
plot(usa$GDP,usa$B,type="o",col="red")


############ Cambiando la forma del dataframe

## Filas que se hacen columnas: tidyr:spread
df_paro = read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/parocomunidades.csv",encoding="latin1")
df_comunidad<- df_paro %>% spread(Comunidad,Total) # las comunidades como columnas, datos por año
spread(df_paro,Periodo,Total) # los periodos como columnas, datos por comunidad




##### Spread: detalles importantes

## año duplicado
df_paro_copy <- df_paro
df_paro_copy[df_paro$Comunidad=="Andalucía" & df_paro$Periodo==2005,]$Periodo <- 2006
df_paro_copy %>% spread(Comunidad,Total)
# sin años
df_paro %>% select(!(Periodo))  %>% spread(Comunidad,Total)

## Spread: detalles importantes (II)
# faltan años
df_prueba<- df_paro %>% filter(Comunidad != 'Andalucía' | Periodo>2005) %>% spread(Comunidad,Total)

##### Columnas que se hacen filas: tidyr:gather
res<- df_comunidad %>% gather(key="Comunidad",value="Total",-Periodo)

####### Ejercicio 

df_prods <- data.frame(producto_id=c("1532","1777","2311","6766","3901","9781","4561"),
            area = c(1,2,1,3,4,1,5),           
           centro_1=c(123,341,11,133,781,19,22),centro_2=c(123,341,11,133,781,19,22))


####### Uniendo columnas: tidyr:unite
df_prods %>% unite(col="prodRef",producto_id,area,sep=".")


######## Separando columnas: tidyr:separate
df_usa <- read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/tusa2020.csv",
                   encoding="UTF-8",  colClasses=c("X_id"="character", "userid"="character" ) )
df_usa_sep<- df_usa %>% separate(col=created_at,into=c("year","month","day"),sep="-")


####### Partiendo un dataframe: Split (base)
require(dplyr)
df_usa <- read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/tusa2020.csv",
                   encoding="UTF-8",  colClasses=c("X_id"="character", "userid"="character" ) )

mini_df_usa <- df_usa %>% select(userid,screen_name,lang) 
lista<-split(mini_df_usa,mini_df_usa$lang)
lista[["es"]] %>% arrange(screen_name)
sapply(lista,nrow)

##### Ejercicio 3
url = "https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv"

###################################################################################
########## Combinando dataframes ########################


#### Concatenar columnas
refs = c("13183686","14382832","72456","16624629","18439216","5577","21732490")
ventas = c(4,814,2303,2424,1343,237,0)
ventasAA = c(0,695,2320,2210,1177,146,63)
descripcion = c("PLÁTANO AMERICANO","BANANA GRANEL","PLÁTANO CANARIO AHORRO EAN 24",
                "PLÁTANO CANARIO I.G. VARIABLE","PLÁTANO DE CANARIAS E. NATUR","MANZANA GRAN SMITH KG",
                "MANZANA G. SMITH 900G MARLENE")

df_ventas_anuales = data.frame(refs, descripcion,ventas, ventasAA) 

# productos de oferta
oferta = rep(FALSE,nrow(df_ventas_anuales))
agotados = rep(FALSE,nrow(df_ventas_anuales))
oferta[4] = TRUE; agotados[1] = TRUE
df_nuevas_cols = data.frame(oferta,agotados) 

# Concatenar columnas (II)
cbind(df_ventas_anuales,df_nuevas_cols)
data.frame(df_ventas_anuales,df_nuevas_cols)
require(dplyr)
df_ventas_anuales %>% bind_cols(df_nuevas_cols)

##### Concatenar columnas: problemas con cbind
refs = c("686","832","456","629","216","577","490")
df_nuevas_cols = data.frame(oferta,agotados,refs) 
df_nuevas_cols2 <- cbind(df_ventas_anuales,df_nuevas_cols)
colnames(df_nuevas_cols2)
#"refs"        "descripcion" "ventas"      "ventasAA"    "oferta"      "agotados"    "refs"       
df_nuevas_cols2$refs
# "13183686" "14382832" "72456"    "16624629" "18439216" "5577"     "21732490"


#### Concatenar columnas: solución con data.frame
df_nuevas_cols2 <-data.frame(df_ventas_anuales,df_nuevas_cols)

#### Concatenar columnas: solución con bind_cols
df_nuevas_cols2 <-df_ventas_anuales %>% bind_cols(df_nuevas_cols)

df_nuevas_cols2 <-df_ventas_anuales %>% bind_cols(df_nuevas_cols,.name_repair = "check_unique")

#### Problema 4
ref_disponibles = c("72456", "5577")

####  Concatenar filas
df1 <- data.frame(a=c(0,1,2), b=c(3,4,5), c=c(6,7,8))
df2 <- data.frame(a=c(9,10,11), b=c(12,13,14), c=c(15,16,17))

df3 <- rbind(df1,df2)

df3 <- df1 %>% bind_rows(df2)



#### Concatenar filas: nombres diferentes de columnas
df1 <- data.frame(a=c(0,1,2), b=c(3,4,5), c=c(6,7,8))
df2 <- data.frame(a=c(9,10,11), c=c(12,13,14), d=c(15,16,17))
rbind(df1,df2) # error

df3 <- df1 %>% bind_rows(df2) # rellena con NA

df3 <- df1 %>% bind_rows(df2,.id="origen") # apunta el origen

########## Operaciones con conjuntos

### Operaciones con conjuntos: union
df1 <- data.frame(a=c(0,0,2), b=c(1,1,3))
df2 <- data.frame(a=c(0,0,0,0), b=c(1,1,4,4))
df3 <- df1 %>% union(df2)

### Operaciones con conjuntos: intersección
df1 <- data.frame(a=c(0,0,2), b=c(1,1,3))
df2 <- data.frame(a=c(0,0,0,0), b=c(1,1,4,4))
df3 <- df1 %>% intersect(df2)

#### Operaciones con conjuntos: diferencia
df1 <- data.frame(a=c(0,0,2), b=c(1,1,3))
df2 <- data.frame(a=c(2,2,0,0), b=c(3,3,4,4))
df3 <- df1 %>% setdiff(df2)

############# Joins

## inner_join
df1 <- data.frame(ciudad=c("Alicante","Vigo","A Coruña","Alicante","Almeria"), centro=c(300,400,500,600,700))
df2 <- data.frame(nombre=c("A Coruña","Alicante"), comunidad=c("Galicia","Valencia"),otro=c(1000,2000))

df3 <- inner_join(df1,df2,by=c("ciudad"="nombre"))

## Ejercicio 8
df_usa <- read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/tusa2020.csv",
                   encoding="UTF-8",  
                   colClasses=c("X_id"="character", "userid"="character","RT_source"="character" ) )

# campos df_original:   X_id,text,userid,screen_name,created_at,lang
# campos df_rt: X_id,userid,screen_name,created_at,RT_source


#### Merge: ejemplo
refs = c("13183686","14382832","72456","16624629","18439216","5577","21732490")
ventas = c(4,814,2303,2424,1343,237,0)
descripcion = c("PLÁTANO AMERICANO","BANANA GRANEL","PLÁTANO CANARIO AHORRO EAN 24",
                "PLÁTANO CANARIO I.G. VARIABLE","PLÁTANO DE CANARIAS E. NATUR","MANZANA GRAN SMITH KG",
                "MANZANA G. SMITH 900G MARLENE")
df_ventas = data.frame(refs, descripcion,ventas) 

referencias = c("5577","72456","unareferenciarara")
caducado = c(30,45,111)
df_caducado = data.frame(referencias, caducado) 

merge(df_ventas, df_caducado, by.x = "refs", by.y = "referencias",all.x=TRUE,all.y=FALSE)

res <- left_join(df_ventas, df_caducado, by=c("refs"="referencias"))

### nest_join
df1 <- data.frame(ciudad=c("Alicante","Vigo","A Coruña","Alicante","Almeria"), centro=c(300,400,500,600,700))
df2 <- data.frame(nombre=c("A Coruña","Alicante"), comunidad=c("Galicia","Valencia"),otro=c(1000,2000))

nest_join(df1,df2,by=c("ciudad"="nombre"))

### match
match(c(3,7,9,1,3,7,8), c(6,5,4,3,2,1))

### match: ejemplo
df1 <- data.frame(ciudad=c("Alicante","Vigo","A Coruña","Alicante","Almeria"), centro=c(300,400,500,600,700))
df2 <- data.frame(nombre=c("A Coruña","Alicante"), comunidad=c("Galicia","Valencia"),otro=c(1000,2000))

df1bis <- df1 %>% left_join(df2, by=c("ciudad"="nombre"))
df1bis$otro <- NULL

# con match
df1$comunidad = df2$comunidad[match(df1$ciudad,df2$nombre)]

### Ejercicio 13
refs = c("13183686","14382832","72456","16624629","18439216","5577","21732490")
ventas = c(4,814,2303,2424,1343,237,0)
descripcion = c("PLÁTANO AMERICANO","BANANA GRANEL","PLÁTANO CANARIO AHORRO EAN 24",
                "PLÁTANO CANARIO I.G. VARIABLE","PLÁTANO DE CANARIAS E. NATUR","MANZANA GRAN SMITH KG",
                "MANZANA G. SMITH 900G MARLENE")
df = data.frame(refs, descripcion,ventas) 

refs = c("5577","72456","unareferenciarara")
df_retirar = data.frame(refs) 



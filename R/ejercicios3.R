
## Problema 1
#a)
df_periodo<- df_paro %>% spread(Periodo,Total)

#b)
df_periodo<- df_paro %>% filter(Periodo<=2010) %>% spread(Periodo,Total)

## Problema 2
df_prods <- data.frame(producto_id=c("1532","1777","2311","6766","3901","9781","4561"),
                       area = c(1,2,1,3,4,1,5),           
                       centro_1=c(123,341,11,133,781,19,22),centro_2=c(123,341,11,133,781,19,22))
#a)
df_prods_centro<- df_prods %>% gather(key="centro",value="ventas",-producto_id,-area)
#b)
require(stringr)
df_prods_centro$centro <- as.integer(str_sub(df_prods_centro$centro,start=8))

# otra forma
df_prods_centro$centro <- df_prods_centro$centro %>% str_sub(start=8) %>% as.integer

## Problema 3

#a)
df_vino <- read.csv(url,sep=";")


#b)
df_vino$calidad <- NA
df_vino$calidad[df_vino$quality<=4] = "malo"
df_vino$calidad[5<=df_vino$quality & df_vino$quality<=7] = "regular"
df_vino$calidad[8<=df_vino$quality] = "bueno"
## otra forma
df_vino$calidad <- ifelse(df_vino$quality<=4,"malo",ifelse(df_vino$quality>=5 & df_vino$quality<=7, "regular","bueno"))

#c)
lista<-split(df_vino,df_vino$calidad)

#d)
lista[["bueno"]] %>% select(quality,alcohol) %>% arrange(desc(quality))

# Problema 4
refs = c("13183686","14382832","72456","16624629","18439216","5577","21732490")
ventas = c(4,814,2303,2424,1343,237,0)
ventasAA = c(0,695,2320,2210,1177,146,63)
descripcion = c("PLÁTANO AMERICANO","BANANA GRANEL","PLÁTANO CANARIO AHORRO EAN 24",
                "PLÁTANO CANARIO I.G. VARIABLE","PLÁTANO DE CANARIAS E. NATUR","MANZANA GRAN SMITH KG",
                "MANZANA G. SMITH 900G MARLENE")
df_ventas_anuales = data.frame(refs, descripcion,ventas, ventasAA) 

ref_disponibles = c("72456", "5577")

df_disponibles <- df_ventas_anuales
df_disponibles$disponibles <-df_ventas_anuales$refs %in% ref_disponibles 

### Problema 5
require(dplyr)
fich = "https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/valores.csv"
df_valores = read.csv(fich)
fich2 = "https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/valores2.csv"
df_valores2 = read.csv(fich2)

df_valores_nuevos<- df_valores %>% bind_rows(df_valores2)

### Problemas 6
df_valores_sinrep <- df_valores %>% union(df_valores2)
cat(nrow(df_valores_nuevos)- nrow(df_valores_sinrep),"valores repetidos")


### Problema 7
#En ambos casos es euivalente a distinct()

### Problema 8
df_usa <- read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/tusa2020.csv",
                   encoding="UTF-8",  
                   colClasses=c("X_id"="character", "userid"="character","RT_source"="character" ) )
#a)
lista<- split(df_usa,df_usa$RT)
df_original<-lista[["false"]]
df_rt <- lista[["true"]]

#b)
require(dplyr)
df_original <- df_original %>% select(X_id,text,userid,screen_name,created_at,lang)
df_rt <- df_rt %>% select(X_id,userid,screen_name,created_at,RT_source)

#c)

df_rt_completo <- df_rt %>% inner_join(df_original,by=c("RT_source"="X_id"))

df_rt_completo <- df_rt %>% inner_join(df_original,
                                       by=c("RT_source"="X_id"), 
                                       suffix = c("", ".original"))

#d)

nrow(df_rt_completo)/nrow(df_rt)*100

#e) 

###  2020-10-30T13:04:26.000Z
formato = "%Y-%m-%dT%H:%M:%S.000Z"
df_rt_completo$created_at <- strptime(df_rt_completo$created_at,formato)
df_rt_completo$created_at.original <- strptime(df_rt_completo$created_at.original,formato)

min(df_rt_completo$created_at-df_rt_completo$created_at.original)

max(df_rt_completo$created_at-df_rt_completo$created_at.original)

##### Ejercicio 9 
# inner_join mantiene el orden natural

#### Ejercicio 10
refs = c("13183686","14382832","72456","16624629","18439216","5577","21732490")
ventas = c(4,814,2303,2424,1343,237,0)
descripcion = c("PLÁTANO AMERICANO","BANANA GRANEL","PLÁTANO CANARIO AHORRO EAN 24",
                "PLÁTANO CANARIO I.G. VARIABLE","PLÁTANO DE CANARIAS E. NATUR","MANZANA GRAN SMITH KG",
                "MANZANA G. SMITH 900G MARLENE")
df_ventas = data.frame(refs, descripcion,ventas) 

referencias = c("5577","72456","unareferenciarara")
caducado = c(30,45,111)
df_caducado = data.frame(referencias, caducado) 

#a
df_ventas_completado <- df_ventas %>% left_join(df_caducado,by=c("refs"="referencias"))
#b 
df_ventas_completado$caducado[is.na(df_ventas_completado$caducado)] <- 0
# c
df_ventas_completado %>% slice_max(caducado) %>% select(descripcion,caducado)

### Ejercicio 11
merge(df_ventas, df_caducado, by.x = "refs", by.y = "referencias", all.x = TRUE, all.y==FALSE)


### Ejercicio 12
df1 = read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/parocomunidades.csv",encoding="latin1")
df1 = df1[df1$Periodo==2019,]
df2 = read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/poblacion_comunidades.csv",encoding="UTF-8")
df2$poblacion = as.numeric(gsub(" ","",df2$poblacion))
df1 %>% inner_join(df2, by=c("Comunidad"="nombre"))

### Ejercicio 13
refs = c("13183686","14382832","72456","16624629","18439216","5577","21732490")
ventas = c(4,814,2303,2424,1343,237,0)
descripcion = c("PLÁTANO AMERICANO","BANANA GRANEL","PLÁTANO CANARIO AHORRO EAN 24",
                "PLÁTANO CANARIO I.G. VARIABLE","PLÁTANO DE CANARIAS E. NATUR","MANZANA GRAN SMITH KG",
                "MANZANA G. SMITH 900G MARLENE")
df = data.frame(refs, descripcion,ventas) 

refs = c("5577","72456","unareferenciarara")
df_retirar = data.frame(refs) 

anti_join(df,df_retirar)




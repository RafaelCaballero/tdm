###### Soluciones curso de R. DC-a 1

#P1 da "double" porque por defecto convierte 3 en 3.0

#P2 da "integer" porque lo ha convertido las funciones as_a son muy C:tiles para esto

#P3 "character"

#P4 logical, ya que puede dar True o False. "3"+4 devuelve un error de tipo

#P5 x 10, y 9

#P6 a "character", b "character", c "double"

# P7 
df_paro = read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/parocomunidades.csv",encoding="latin1") 

# P8

#P8 a) 
df %>% slice_max(colombia,n=3) %>% select(a??o,ecuador)
# P8 b)
df %>% slice_max(colombia,n=3) %>% select(a??o,ecuador) %>% slice_max(ecuador,n=3)
#P8 c)
df %>% slice_max(bolivia,prop=0.25)

#P9
dfOrdenado = dfNombre %>% arrange(apellido1,apellido2,nombre) %>% select(apellido1,apellido2,nombre)

#P10 
#No es lo mismo porque solo calcular? la media de los a?os a partir de 2010


# P11
#a)
df_paro = read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/parocomunidades.csv",encoding="latin1") 
df_paro2 = df_paro %>% arrange(Periodo,desc(Total))

#b) 
df_paro %>% filter(Comunidad=='Galicia' | Comunidad=='Asturias')

# c)
df_valores %>% filter(INDU_Index_Open > mean(INDU_Index_Open)+2*sd(INDU_Index_Open)) %>% select(fecha,INDU_Index_Open) %>% arrange(INDU_Index_Open)

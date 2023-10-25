library("openxlsx")

# creamos un excel de prueba, puedes usar cualquier otro
df1 <- read.csv("https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/catastro.csv")
write.xlsx(df1,"pruebaR.xlsx",colNames = TRUE, borders = "columns")

url <- "https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/clientes.csv"
df2 <- read.csv(url)


wb <- loadWorkbook("pruebaR.xlsx") 
addWorksheet(wb,"clientes") 
writeData(wb,"clientes",df2) 
saveWorkbook(wb,"pruebaR2.xlsx",overwrite = TRUE) 

url <- "https://raw.githubusercontent.com/RafaelCaballero/tdm/master/datos/convertir.csv"
df_convertir <- read.csv(url)
wb <- loadWorkbook("pruebaR2.xlsx") 
addWorksheet(wb,"convertir") 
writeData(wb,"convertir",df_convertir) 
saveWorkbook(wb,"pruebaR3.xlsx",overwrite = TRUE) 


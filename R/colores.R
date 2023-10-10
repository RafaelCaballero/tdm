#install.packages("openxlsx")
require(openxlsx)

url = "https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv"
df_vino <- read.csv(url,sep=";")
# columna nueva
df_vino$calidad <- ifelse(df_vino$quality<=4,"malo",ifelse(df_vino$quality>=5 & df_vino$quality<=7, "regular","bueno"))

wb <- createWorkbook() # un libro para trabajar

addWorksheet(wb, "Hoja1", gridLines = TRUE) #Añadimos una hoja

writeData(wb, "Hoja1", df_vino) # "colocamos" el dataframe en la hoja Excel

# Estilos
redStyle <- createStyle(fontColour = "#000000", bgFill = "#FF0000")
greenStyle <- createStyle(fontColour = "#000000", bgFill = "#00FF00")

# reglas condicionales
conditionalFormatting(wb, "Hoja1", cols = 1:ncol(df_vino),
                      rows = 1:nrow(df_vino), rule = "malo", style = redStyle,
                      type = "contains")

conditionalFormatting(wb, "Hoja1", cols = 1:ncol(df_vino),
                      rows = 1:nrow(df_vino), rule = "bueno", style = greenStyle,
                      type = "contains")

file ="data/vinos.xlsx"
saveWorkbook(wb, file, overwrite = TRUE)
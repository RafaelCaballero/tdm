#install.packages("openxlsx")
require(openxlsx)

url = "https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv"
df_vino <- read.csv(url,sep=";")

wb <- createWorkbook() # un libro para trabajar

addWorksheet(wb, "Hoja1", gridLines = TRUE) # añadimos una hoja

writeData(wb, "Hoja1", df_vino) # "colocamos" el dataframe en la hoja Excel

# el estilo, fuente rojo: #FF00000, fondo blanco
redStyle <- createStyle(fontColour = "#FF0000", bgFill = "#FFFFFF")

yellowStyle <- createStyle(fontColour = "#FFFF00", bgFill = "#FFFFFF")

greenStyle <- createStyle(fontColour = "#0000FF", bgFill = "#FFFFFF")


conditionalFormatting(wb, "Hoja1", cols = 12:12, rows = 1:nrow(df_vino), 
                      type = "between", rule = c(0, 4),
                      style = redStyle)

conditionalFormatting(wb, "Hoja1", cols = 12:12, rows = 1:nrow(df_vino), 
                      type = "between", rule = c(5, 7),
                      style = yellowStyle)
conditionalFormatting(wb, "Hoja1", cols = 12:12, rows = 1:nrow(df_vino), 
                      type = "between", rule = c(8, 10),
                      style = greenStyle)
## Grabamos el resultado
file ="data/vinos2.xlsx"
saveWorkbook(wb, file, overwrite = TRUE)
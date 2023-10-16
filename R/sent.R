install.packages("syuzhet")
install.packages("RColorBrewer")
install.packages("tm")

library(syuzhet)
library(RColorBrewer)
library(tm)

url <- "https://www.gutenberg.org/cache/epub/56454/pg56454.txt"
libro <- scan(url, fileEncoding = "UTF-8", what = character(), sep = "\n", allowEscapes = T)

scores <- get_nrc_sentiment(libro, lang="spanish")

summary(scores)

print(length(libro))
print(nrow(scores))
libro[scores$sadness==max(scores$sadness)]

evolución <- (scores$negative *-1) + scores$positive
print(mean(evolución))
simple_plot(evolución)


barplot(
  colSums(prop.table(scores[])),
  space = 0.2,
  horiz = FALSE,
  las = 1,
  cex.names = 0.7,
  col = brewer.pal(n = 8, name = "Set3"),
  main = "'El Terror', Episodios Nacionales, Benito Pérez Galdós",
  sub = "Curso R",
  xlab="emociones", ylab = NULL)



####



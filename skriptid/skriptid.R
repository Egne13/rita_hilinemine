library(ggplot2)
library(zoo)

bussiajad <- c(8*60 + 5, 8*60 + 16, 8*60 + 28, 8*60 + 38, 8*60 + 48, 8*60 + 59)
soidud <- c(13, 14, 13, 13, 13, 13)
kodu_kuni_peatus <- 300 / 60
peatus_kuni_too <- 240 / 60
koosolekuaeg <- 9 * 60 + 5

lahkumis_ajad <- seq(7*60 + 30, 8*60 + 59, by = 1)

hilinemine <- sapply(lahkumis_ajad, function(lahkub_kodust) {
  peatusesse_jouab <- lahkub_kodust + kodu_kuni_peatus
  buss_idx <- which(bussiajad >= peatusesse_jouab)[1]
  if (is.na(buss_idx)) return(1)
  saabumine_toole <- bussiajad[buss_idx] + soidud[buss_idx] + peatus_kuni_too
  if (saabumine_toole > koosolekuaeg) return(1) else return(0)
})

df <- data.frame(
  lahkumisaeg = lahkumis_ajad,
  hilineb = hilinemine
)

df$hilinemise_toenaosus <- zoo::rollmean(df$hilineb, k = 5, fill = NA)

ggplot(df, aes(x = lahkumisaeg, y = hilinemise_toenaosus)) +
  geom_line(color = "blue") +
  scale_x_continuous(
    name = "Kodust lahkumise kellaaeg",
    breaks = seq(450, 540, 10),
    labels = function(x) sprintf("%02d:%02d", x %/% 60, x %% 60)
  ) +
  ylab("Hilinemise tõenäosus") +
  ggtitle("Rita hilinemise tõenäosus sõltuvalt kodust lahkumise ajast") +
  theme_minimal()


###  Teine varjant, kui lisada juurde busside 8:28, 8:38 ja 8:48 aegadele 20% võimaluse, et need ei tule üldse või hilinevad

library(ggplot2)
library(zoo)

set.seed(123) # et tulemus oleks korduv

bussiajad <- c(8*60 + 5, 8*60 + 16, 8*60 + 28, 8*60 + 38, 8*60 + 48, 8*60 + 59)
soidud <- c(13, 14, 13, 13, 13, 13)
kodu_kuni_peatus <- 300 / 60
peatus_kuni_too <- 240 / 60
koosolekuaeg <- 9 * 60 + 5

# Bussidel 8:28, 8:38 ja 8:48 on 20% tõenäosus, et nad hilinevad või jäävad tulemata
hilinemise_tod <- c(FALSE, FALSE, TRUE, TRUE, TRUE, FALSE)
hilinemise_prob <- c(0, 0, 0.2, 0.2, 0.2, 0)

lahkumis_ajad <- seq(7*60 + 30, 8*60 + 59, by = 1)

# Simuleerime iga lahkumisaja jaoks 1000 korda, kas Rita hilineb
simulatsioonid <- 1000

hilinemise_tulemused <- sapply(lahkumis_ajad, function(lahkub_kodust) {
  peatusesse_jouab <- lahkub_kodust + kodu_kuni_peatus
  
  # Iga simulatsiooni jaoks kontrollime, milline buss tuleb ja kas see hilineb
  tulemus <- replicate(simulatsioonid, {
    # Juhuslikult määrame, kas bussid hilinevad või mitte (neil, kellel prob > 0)
    buss_hilinemine <- runif(length(bussiajad)) < hilinemise_prob
    # Kui buss hilineb või ei tule, siis sõidu kestus +5 minutit
    soidud_mod <- soidud + ifelse(buss_hilinemine, 5, 0)
    
    # Leiame esimese bussi, mis jõuab peale peatusesse jõudmist
    buss_idx <- which(bussiajad >= peatusesse_jouab)[1]
    
    # Kui bussi pole, siis hilineb kindlalt
    if (is.na(buss_idx)) return(1)
    
    saabumine_toole <- bussiajad[buss_idx] + soidud_mod[buss_idx] + peatus_kuni_too
    
    if (saabumine_toole > koosolekuaeg) return(1) else return(0)
  })
  
  mean(tulemus)
})

df2 <- data.frame(
  lahkumisaeg = lahkumis_ajad,
  hilinemise_toenaosus = hilinemise_tulemused
)

ggplot(df2, aes(x = lahkumisaeg, y = hilinemise_toenaosus)) +
  geom_line(color = "red") +
  scale_x_continuous(
    name = "Kodust lahkumise kellaaeg",
    breaks = seq(450, 540, 10),
    labels = function(x) sprintf("%02d:%02d", x %/% 60, x %% 60)
  ) +
  ylab("Hilinemise tõenäosus (arvestades bussi hilinemisi)") +
  ggtitle("Rita hilinemise tõenäosus koos busside hilinemisega") +
  theme_minimal()

##### mõlevad varjandid koos vaadates

Selgitus: Punane joon (Koos busside hilinemisega) näitab, kuidas hilinemine muutub, kui bussid võivad hilineda.
Sinine joon (Ilma busside hilinemiseta) on algne puhas stsenaarium.
Kasutame zoo::rollmean() et graafik oleks siledam.

library(ggplot2)
library(zoo)

set.seed(123) # Korduvuse tagamiseks

bussiajad <- c(8*60 + 5, 8*60 + 16, 8*60 + 28, 8*60 + 38, 8*60 + 48, 8*60 + 59)
soidud <- c(13, 14, 13, 13, 13, 13)
kodu_kuni_peatus <- 300 / 60
peatus_kuni_too <- 240 / 60
koosolekuaeg <- 9 * 60 + 5

hilinemise_tod <- c(FALSE, FALSE, TRUE, TRUE, TRUE, FALSE)
hilinemise_prob <- c(0, 0, 0.2, 0.2, 0.2, 0)

lahkumis_ajad <- seq(7*60 + 30, 8*60 + 59, by = 1)
simulatsioonid <- 1000

# Ilma busside hilinemiseta arvutused
hilinemine_tavaline <- sapply(lahkumis_ajad, function(lahkub_kodust) {
  peatusesse_jouab <- lahkub_kodust + kodu_kuni_peatus
  buss_idx <- which(bussiajad >= peatusesse_jouab)[1]
  if (is.na(buss_idx)) return(1)
  saabumine_toole <- bussiajad[buss_idx] + soidud[buss_idx] + peatus_kuni_too
  if (saabumine_toole > koosolekuaeg) return(1) else return(0)
})

# Koos busside hilinemise võimalusega arvutused
hilinemine_hilinevad <- sapply(lahkumis_ajad, function(lahkub_kodust) {
  peatusesse_jouab <- lahkub_kodust + kodu_kuni_peatus
  tulemus <- replicate(simulatsioonid, {
    buss_hilinemine <- runif(length(bussiajad)) < hilinemise_prob
    soidud_mod <- soidud + ifelse(buss_hilinemine, 5, 0)
    buss_idx <- which(bussiajad >= peatusesse_jouab)[1]
    if (is.na(buss_idx)) return(1)
    saabumine_toole <- bussiajad[buss_idx] + soidud_mod[buss_idx] + peatus_kuni_too
    if (saabumine_toole > koosolekuaeg) return(1) else return(0)
  })
  mean(tulemus)
})

df <- data.frame(
  lahkumisaeg = rep(lahkumis_ajad, 2),
  hilinemise_toenaosus = c(hilinemine_tavaline, hilinemine_hilinevad),
  stsenaarium = rep(c("Ilma busside hilinemiseta", "Koos busside hilinemisega"), each = length(lahkumis_ajad))
)

# Liikuva keskmise arvutamine iga stsenaariumi jaoks
library(dplyr)
df <- df %>%
  group_by(stsenaarium) %>%
  mutate(hilinemise_toenaosus_sile = zoo::rollmean(hilinemise_toenaosus, k = 5, fill = NA))

ggplot(df, aes(x = lahkumisaeg, y = hilinemise_toenaosus_sile, color = stsenaarium)) +
  geom_line(size = 1) +
  scale_x_continuous(
    name = "Kodust lahkumise kellaaeg",
    breaks = seq(450, 540, 10),
    labels = function(x) sprintf("%02d:%02d", x %/% 60, x %% 60)
  ) +
  ylab("Hilinemise tõenäosus") +
  ggtitle("Rita hilinemise tõenäosus: ilma ja koos busside hilinemisega") +
  theme_minimal() +
  theme(legend.title = element_blank())





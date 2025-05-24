### R-kood

Simuleerime, millisele bussile Rita jõuab

Arvutame, kas ta jõuab koosolekule õigeks ajaks

Arvutame hilinemise tõenäosuse

Joonistame graafiku

###

# Paketi laadimine
library(ggplot2)

# Bussi väljumisajad minutites (alates südaööst)
bussiajad <- c(8*60 + 5, 8*60 + 16, 8*60 + 28, 8*60 + 38, 8*60 + 48, 8*60 + 59)

# Vastavad sõiduajad (minutites)
soidud <- c(13, 14, 13, 13, 13, 13)

# Rita kõndimisajad
kodu_kuni_peatus <- 300 / 60   # 5 min
peatus_kuni_too <- 240 / 60    # 4 min

# Koosoleku aeg minutites (alates südaööst)
koosolekuaeg <- 9 * 60 + 5  # 9:05 → 545 minutit

# Loome ajaskaala kodust lahkumise ajaks (alates 7:30 kuni 8:59)
lahkumis_ajad <- seq(7*60 + 30, 8*60 + 59, by = 1)

# Funktsioon: kas Rita jõuab õigeks ajaks
hilinemine <- sapply(lahkumis_ajad, function(lahkub_kodust) {
  peatusesse_jouab <- lahkub_kodust + kodu_kuni_peatus
  
  # Leida esimene buss, millele ta jõuab
  buss_idx <- which(bussiajad >= peatusesse_jouab)[1]
  
  # Kui ta ei jõua ühelegi bussile, siis hilineb
  if (is.na(buss_idx)) return(1)
  
  # Arvutada, mis kell ta jõuab tööle
  saabumine_toole <- bussiajad[buss_idx] + soidud[buss_idx] + peatus_kuni_too
  
  # Kui ta jõuab hiljem kui 9:05, siis hilineb (1), muidu ei hiline (0)
  if (saabumine_toole > koosolekuaeg) return(1) else return(0)
})

# Koostada andmetabel
df <- data.frame(
  lahkumisaeg = lahkumis_ajad,
  hilineb = hilinemine
)

# Arvutada liikuva akna keskmine (tõenäosuse sujuvamaks muutmiseks)
df$hilinemise_toenaosus <- zoo::rollmean(df$hilineb, k = 5, fill = NA)

# Joonistada graafik
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

install.packages("zoo")
library(zoo)

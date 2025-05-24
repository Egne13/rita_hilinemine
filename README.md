# rita_hilinemine

See projekt analüüsib hilinemisi RITA andmestikus. 
Eesmärk on leida mustrid ja teha visualiseeringud, mis aitavad mõista, millal ja miks hilinemised tekivad.

# Rita hilinemine

See projekt analüüsib, milline on töötaja Rita tööle hilinemise tõenäosus sõltuvalt kodust lahkumise ajast.

## 📋 Ülesande kirjeldus

Rita sõidab tööle Tallinna linnaliinibussiga nr 8, peatustest Zoo → Toompark.  
Ta peab jõudma kontorisse iga päev hiljemalt **kell 9:05**, sest siis algab koosolek.

- Busside väljumisajad: 8:05, 8:16, 8:28, 8:38, 8:48, 8:59  
- Bussisõit kestab tavaliselt 13 minutit, v.a. 8:16 (14 min)  
- Kodust peatusesse: 300 sekundit (5 min)  
- Peatusest kontorisse: 240 sekundit (4 min)

## 🧪 Analüüs

Projekt modelleerib:
- Hilinemise tõenäosust vastavalt kodust lahkumise ajale
- Stsenaariumi, kus mõned bussid võivad hilineda või üldse mitte saabuda

## 📈 Tulemused

Graafikud salvestatakse kausta `tulemused/` ja need näitavad hilinemise tõenäosust:

- Ilma busside hilinemiseta
- Koos võimaliku bussihilinemisega (nt buss ei tule, hilineb)

## 📁 Kaustastruktuur

rita_hilinemine/
├── skriptid/
│ └── analüüs.R
├── tulemused/
│ └── hilinemise_tõenäosus.png
└── README.md

## 🔧 Kasutus

Projekt töötab **RStudio** ja **R** abil.  
Vajalikud paketid: `ggplot2`, `zoo`, `dplyr`


🧑‍💻 Autor
Projekti koostas: Egne13

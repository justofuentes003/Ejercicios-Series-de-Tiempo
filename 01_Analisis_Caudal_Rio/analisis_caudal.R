# ANÁLISIS DE CAUDALES DEL RÍO SINÚ - INGENIERÍA
# ---------------------------------------------

# 1. Cargar librerías
# install.packages(c("tidyverse", "lubridate", "zoo")) # Ejecutar solo la primera vez
library(tidyverse)
library(lubridate)
library(zoo) # Para calcular promedios móviles

# 2. Cargar los datos
# datos_caudal <- read_csv("data/caudal_rio_sinu.csv")
datos_caudal <- read.csv(("01_Analisis_Caudal_Rio/data/caudal_rio_sinu.csv"))

# 3. Procesamiento y análisis de series de tiempo
# Convertir la fecha a formato de fecha y ordenar
datos_caudal <- datos_caudal %>%
  mutate(Fecha = as.Date(Fecha)) %>%
  arrange(Fecha)

# Calcular un promedio móvil de 3 meses para suavizar la serie
datos_caudal <- datos_caudal %>%
  mutate(PromedioMovil_m3s = rollmean(Caudal_m3s, k = 3, fill = NA, align = "right"))

print("Resumen de datos con promedio móvil:")
print(tail(datos_caudal)) # Mostramos las últimas filas

# 4. Visualización
grafico_caudales <- ggplot(datos_caudal, aes(x = Fecha)) +
  geom_line(aes(y = Caudal_m3s, color = "Caudal Mensual"), size = 1) +
  geom_line(aes(y = PromedioMovil_m3s, color = "Tendencia (Promedio Móvil)"), size = 1.2, linetype = "dashed") +
  scale_color_manual(values = c("Caudal Mensual" = "deepskyblue3", "Tendencia (Promedio Móvil)" = "firebrick")) +
  labs(
    title = "Serie de Tiempo de Caudales Medios Mensuales",
    subtitle = "Río Sinú - Estación Montería (2022-2023)",
    x = "Fecha",
    y = "Caudal (m³/s)",
    color = "Leyenda"
  ) +
  theme_minimal() +
  theme(legend.position = "top")

print(grafico_caudales)

# 5. Guardar el gráfico y los datos procesados
if (!dir.exists("output")) dir.create("output")

ggsave("01_Analisis_Caudal_Rio/output/grafico_caudales_rio_sinu.png", plot = grafico_caudales, width = 10, height = 6)
write_csv(datos_caudal, "01_Analisis_Caudal_Rio/output/datos_caudal_procesados.csv")

print("¡Análisis completado! El gráfico y los datos procesados se han guardado en la carpeta 'output'.")


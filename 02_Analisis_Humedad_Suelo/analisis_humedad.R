# EJERCICIO 02: ANÁLISIS DE HUMEDAD DEL SUELO
# -------------------------------------------

# 1. Cargar librerías
library(tidyverse)
library(lubridate)

# 2. Cargar los datos (usando la ruta desde la raíz del proyecto)
datos_humedad <- read_csv("02_Analisis_Humedad_Suelo/data/humedad_suelo_soya.csv")

# 3. Procesamiento y definición de umbrales
datos_humedad <- datos_humedad %>%
  mutate(Fecha = as.Date(Fecha))

# Umbrales agronómicos críticos (ejemplo para un suelo franco-arcilloso)
capacidad_campo <- 0.35  # Humedad ideal después de drenar
umbral_riego <- 0.22      # Punto para empezar a regar
punto_marchitez <- 0.10   # Punto de no retorno para la planta

# 4. Visualización
grafico_humedad <- ggplot(datos_humedad, aes(x = Fecha, y = Humedad_Volumetrica)) +
  # Líneas de umbrales críticos
  geom_hline(yintercept = capacidad_campo, linetype = "dashed", color = "blue", size = 1) +
  geom_hline(yintercept = umbral_riego, linetype = "dashed", color = "orange", size = 1) +
  geom_hline(yintercept = punto_marchitez, linetype = "dashed", color = "red", size = 1) +
  
  # Serie de tiempo
  geom_line(color = "darkgreen", size = 1.2) +
  geom_point(color = "darkgreen", size = 3) +
  
  # Anotaciones para explicar los umbrales
  annotate("text", x = max(datos_humedad$Fecha), y = capacidad_campo, label = "Capacidad de Campo", hjust = 1.1, vjust = -0.5, color = "blue") +
  annotate("text", x = max(datos_humedad$Fecha), y = umbral_riego, label = "Umbral de Riego", hjust = 1.1, vjust = -0.5, color = "orange") +
  annotate("text", x = max(datos_humedad$Fecha), y = punto_marchitez, label = "Punto de Marchitez", hjust = 1.1, vjust = -0.5, color = "red") +
  
  labs(
    title = "Evolución de la Humedad del Suelo - Cultivo de Soya",
    subtitle = "La línea de humedad cruzó el umbral de riego el 8 de Agosto.",
    x = "Fecha",
    y = "Humedad Volumétrica (m³/m³)"
  ) +
  theme_minimal() +
  ylim(0, 0.40) # Ajustar el eje Y para una mejor visualización

print(grafico_humedad)

# 5. Guardar el gráfico
ggsave(
  "02_Analisis_Humedad_Suelo/output/grafico_humedad_suelo.png", 
  plot = grafico_humedad, 
  width = 10, 
  height = 6
)

print("¡Análisis de humedad completado! Gráfico guardado en la carpeta 'output' del ejercicio.")

# EJERCICIO 03: PREDICCIÓN DE DEMANDA CON ARIMA
# ----------------------------------------------

# 1. Cargar librerías
# La primera vez, debes instalar el paquete que contiene 'forecast'
# install.packages("fpp2") 
library(tidyverse)
library(fpp2) # Carga la librería 'forecast' y otras herramientas útiles

# 2. Cargar los datos
demanda_df <- read_csv(
  "03_Prediccion_Demanda_Producto/data/demanda_yogurt.csv",
  show_col_types = FALSE
)

# 3. Preparar el objeto de Serie de Tiempo (ts)
# Los modelos de predicción en R necesitan un objeto 'ts' que entienda
# la frecuencia de los datos (en este caso, mensual = 12).
demanda_ts <- ts(
  demanda_df$Demanda_Litros, 
  start = c(2021, 1), # Comienza en Enero de 2021
  frequency = 12       # Frecuencia mensual
)

# 4. Construir el modelo ARIMA automáticamente
# La función auto.arima() prueba diferentes modelos ARIMA y elige el mejor.
# ¡Es una herramienta increíblemente poderosa!
modelo_arima <- auto.arima(demanda_ts)

print("Resumen del modelo ARIMA seleccionado:")
print(summary(modelo_arima))

# 5. Generar la predicción para los próximos 12 meses
# El parámetro 'h' define el horizonte de predicción.
prediccion <- forecast(modelo_arima, h = 12)

# 6. Visualizar la predicción
# autoplot() es una función especializada para graficar predicciones.
grafico_prediccion <- autoplot(prediccion) +
  labs(
    title = "Predicción de Demanda de Yogurt para los Próximos 12 Meses",
    subtitle = "Modelo ARIMA ajustado automáticamente",
    x = "Año",
    y = "Demanda (Litros)"
  ) +
  theme_minimal()

print(grafico_prediccion)

# 7. Guardar resultados
# Guardar el gráfico
ggsave(
  "03_Prediccion_Demanda_Producto/output/grafico_prediccion_demanda.png",
  plot = grafico_prediccion,
  width = 10, height = 6
)

# Guardar la tabla con los valores de la predicción
write.csv(
  as.data.frame(prediccion), 
  "03_Prediccion_Demanda_Producto/output/valores_prediccion.csv"
)

print("¡Predicción completada! El gráfico y los valores se han guardado en la carpeta 'output'.")

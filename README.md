# IA_introduccion

# Distribuciones Gaussianas en ℝ²

Este repositorio contiene un proyecto en MATLAB donde se generan y analizan dos clases de datos en el plano ℝ². Cada clase está formada por 100 puntos distribuidos normalmente (gaussianamente) alrededor de un centroide específico.

## 📌 Objetivo

Simular dos conjuntos de datos en dos dimensiones con distribución normal y analizarlos como dos clases distintas, estimando sus parámetros estadísticos (media y matriz de covarianza) y visualizando sus respectivas distribuciones.

## 🔢 Descripción del experimento

1. Se generan dos grupos de 100 puntos cada uno:
   - Clase 1: centrada en el punto (1, 0)
   - Clase 2: centrada en el punto (0, 1)

2. Cada grupo se distribuye de forma gaussiana con desviación estándar igual a 1.

3. Se calculan las siguientes estadísticas por clase:
   - Vector de medias (\( \mu \))
   - Matriz de covarianza (\( \Sigma \))

4. Se visualizan:
   - Los datos generados por clase
   - Las curvas de nivel de las distribuciones gaussianas estimadas

## 📂 Archivos

- `generar_datos.m`: Script para generar los puntos de cada clase.
- `calcular_gaussianas.m`: Script para calcular media, covarianza y graficar las curvas de nivel.
- `README.md`: Este archivo.

## 📷 Ejemplo de salida

![Ejemplo de gráfico](ruta/a/la/imagen_ejemplo.png)

## ⚙️ Requisitos

- MATLAB R2020 o superior
- Estadística y Machine Learning Toolbox (para `mvnpdf`)

## 📚 Conceptos involucrados

- Distribución normal multivariada
- Cálculo de media y covarianza
- Visualización con `scatter` y `contour`
- Clasificación de datos sintéticos




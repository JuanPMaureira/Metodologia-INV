# Bitácora de resultados por etapa — Área Educación

Índice vivo del trabajo: para cada entrega indica qué contiene, en qué archivo está y en qué estado se encuentra.
Se actualiza cada vez que se cierra o cambia algo. Las decisiones y los cambios al protocolo se anotan aparte en `bitacora_decisiones.md`.

Las entregas y sus semanas vienen de la sección 11 del enunciado.

## Resumen

| Entrega | Semana | Peso | Estado |
|---|---|---|---|
| E1. Protocolo y muestra | 1 | 10 % | En curso: faltan el protocolo final y datos del registro de búsqueda |
| E2. Calibración | 2 | 15 % | En curso: selección de los 20 artículos lista; falta la codificación independiente |
| E3. Base componente A | 5 | 20 % | No iniciada (hay trabajo previo de descarga de textos) |
| E4. Base componente B | 6 | 10 % | No iniciada |
| E5. Informe de resultados | 8 | 20 % | No iniciada |
| E6. Manuscrito | 10 | 25 % | No iniciada |

## E1. Protocolo y muestra

| Resultado | Archivo | Estado | Última actualización |
|---|---|---|---|
| Protocolo del área (v1.0) | Documento de Word de Martín; aún no está en el repositorio (`docs/protocolo_E1.pdf` por crear) | Incompleto: roles y coordinador de datos por definir; declaración de IA por actualizar | 2026-10-15 |
| Registro de búsqueda | `docs/registro_busqueda_EDU.md` | Parcial: fecha (8 oct) y N total (91.185) listos; faltan hora, consulta exacta, ajustes de sintaxis, responsable y N por año de WoS | 2026-10-15 |
| Universo exportado | `data/raw/wos_edu/savedrecs*.txt` (92 lotes) y `output/lotes_EDU.csv` | Listo: 91.185 registros únicos | 2026-10-14 |
| Script de muestreo | `R/01_muestreo_EDU.R` | Listo | 2026-10-14 |
| Lista ordenada | `output/lista_ordenada_EDU.csv` (85.611 filas) | Listo | 2026-10-14 |
| Cuotas por año | `output/cuotas_EDU.csv` (2025: 166; 2026: 134) | Listo | 2026-10-14 |
| Conteos para el diagrama de flujo | `output/flujo_EDU.csv` | Listo | 2026-10-14 |
| Versión de R usada | `output/sessionInfo_EDU.txt` (Windows) y `output/sessionInfo_verificacion_Linux.txt` | Listo | 2026-10-14 |
| Checklist de la E1 | `docs/estado_E1.md` | Vigente | 2026-10-15 |

Cifras clave: universo WoS 91.185 (2025: 50.362; 2026: 40.823); compartidos con otras áreas, eliminados: 5.574; universo exclusivo de Educación: 85.611; muestra n = 300, semilla 2026.

## E2. Calibración

Contenido esperado: resultados de calibración, kappas, bitácora y libro de códigos versión 2.

| Resultado | Archivo | Estado | Última actualización |
|---|---|---|---|
| Selección de los 20 artículos de calibración (8 con declaración, 12 por sorteo, 18 de reserva) | `data/calibracion/seleccion_calibracion_EDU.csv`, `data/calibracion/con_declaracion_EDU.csv` y `R/03_seleccion_calibracion_EDU.R` | Listo. Los 8 con declaración se buscaron en las plataformas de las revistas (Frontiers y MDPI); los 12 del sorteo usan `set.seed(2026)` fuera de las posiciones ≤250 (2025) y ≤200 (2026) | 2026-10-15 |
| Codificación independiente de 20 artículos (intraequipo) | Por crear | Pendiente | |
| Kappas de calibración | Por crear | Pendiente | |
| Libro de códigos v2 | Por crear | Pendiente | |
| Bitácora de desacuerdos | Por crear | Pendiente | |

## E3. Base componente A

Contenido esperado: base completa y validada, submuestra de doble codificación e informe de concordancia. Aquí aparece el texto literal de cada declaración de IA (variable D03).

| Resultado | Archivo | Estado | Última actualización |
|---|---|---|---|
| Descarga de textos completos en acceso abierto | `R/02_descarga_textos_EDU.R` y `output/descarga_textos_EDU.csv` (450 candidatos: 104 descargados) | Trabajo previo, en curso. Los PDF no se suben al repositorio | 2026-10-13 |
| Base de codificación (una fila por artículo, en .xlsx y .csv) | Por crear | Pendiente | |
| Diccionario de variables | Por crear | Pendiente | |
| Informe de concordancia (doble codificación del 20 %) | Por crear | Pendiente | |

## E4. Base componente B

| Resultado | Archivo | Estado | Última actualización |
|---|---|---|---|
| Corpus enriquecido (120 declaraciones positivas) con registro de búsqueda | Por crear | Pendiente | |

## E5. Informe de resultados

| Resultado | Archivo | Estado | Última actualización |
|---|---|---|---|
| Resultados de RQ1 a RQ5 con scripts, tablas y figuras | Por crear | Pendiente | |

## E6. Manuscrito

| Resultado | Archivo | Estado | Última actualización |
|---|---|---|---|
| Borrador del artículo, con revista objetivo y sus normas | Por crear | Pendiente | |

## Registro de actualizaciones

| Fecha | Cambio | Quién |
|---|---|---|
| 2026-10-15 | Se agrega la selección de los 20 artículos de calibración (E2) y su script. | JPM con Claude |
| 2026-10-15 | Se crea esta bitácora. Se agregan fecha de búsqueda (8 oct) y N de WoS (91.185) al registro de búsqueda. | JPM con Claude |
| 2026-10-14 | Se ajustan los nombres de archivos al protocolo, se amplía el script de muestreo y se crean README, registro de búsqueda y bitácora de decisiones. | JPM con Claude |

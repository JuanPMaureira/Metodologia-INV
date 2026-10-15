# Registro de búsqueda — Área Educación (E1)

Plantilla de la sección 4 del protocolo, prellenada con lo que se puede obtener de los archivos exportados.
Los campos marcados **PENDIENTE** solo se pueden completar desde WoS (pantalla de resultados e historial de búsqueda) o por quien ejecutó la búsqueda.

| Campo | Valor |
|---|---|
| Fecha y hora de ejecución de la búsqueda (hora de Chile) | **8 de octubre de 2026** (fecha informada por el equipo; todos los lotes se consideran descargados en la misma sesión). Hora: **PENDIENTE** (Martín, si la recuerda o la ve en el historial de WoS). |
| Responsable | **PENDIENTE** (confirmar quién ejecutó la búsqueda y la exportación). |
| Consulta exacta ejecutada | **PENDIENTE** (copiar desde el historial de búsqueda de WoS). La consulta del protocolo es: `WC=("Education & Educational Research" OR "Education, Scientific Disciplines" OR "Education, Special" OR "Psychology, Educational") AND PY=(2025-2026) AND DT=(Article) AND LA=(English OR Spanish)` |
| Ajustes de sintaxis respecto del enunciado | **PENDIENTE** (si no hubo ajustes, escribir "ninguno"). |
| Filtros aplicados (ediciones) | SCIE, SSCI y ESCI. Consistente con los archivos: los 91.185 registros pertenecen a al menos una de las tres. |
| N universo total (archivos) | **91.185** registros únicos por UT, sin UT repetidos entre lotes. |
| N universo total (pantalla de WoS) | **91.185** (informado por el equipo). Coincide con la suma de los lotes: el control "suma de lotes = N" se cumple. |
| N 2025 / N 2026 (archivos) | 50.362 / 40.823 |
| N 2025 / N 2026 (filtro Publication Years de WoS) | **PENDIENTE** |
| N por edición (archivos) | SCIE 13.970 · SSCI 42.738 · ESCI 40.933. No son excluyentes (un registro puede estar en más de un índice; la suma es 97.641). |
| Formato de exportación | Texto plano, registro completo (encabezado `FN Clarivate Analytics Web of Science`, `VR 1.0`, con resumen y referencias). |
| Número de lotes | 100 archivos descargados; 8 eran copias exactas de otro lote y se descartaron; **92 lotes conservados** (91 de 1.000 registros y 1 de 185). Detalle y huella md5 de cada lote en `output/lotes_EDU.csv`. |
| Lotes descartados (duplicados exactos) | `(15)` = `(14)`; `(19)` = `(18)`; `(34)` = `(33)`; `(45)` = `(44)`; `(54)` = `(53)`; `(63)` = `(60)`; `(64)` = `(61)`; `(65)` = `(62)`. Ningún UT nuevo en los descartados. |
| Archivos exportados | `data/raw/wos_edu/savedrecs.txt`, `savedrecs (1).txt`, … `savedrecs (99).txt` (92 archivos, sin los ocho descartados). |
| Observaciones | Ver abajo. |

## Observaciones para confirmar

1. **Cruce con las otras áreas.** Los 4.164 registros compartidos con Salud y los 1.410 con Computación/Ingeniería se detectaron por las categorías WC del propio registro. No se cruzó con los UT exportados por los otros equipos (`data/ut_otras_areas.csv` no existe). Falta confirmar que ambos equipos ejecutaron su consulta el mismo día.
2. **Computer Science, Artificial Intelligence.** Ningún registro del universo final de Educación tiene esa categoría (0 de 85.611).

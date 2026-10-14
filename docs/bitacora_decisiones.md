# Bitácora de decisiones y cambios al protocolo — Área Educación

Según el protocolo (sección 1), todo cambio posterior a la versión 1.0 se registra con fecha y justificación.

## A. Verificación de sintaxis (sección 3 del protocolo)

Evidencia obtenida de los archivos exportados (2026-10-14). Lo que depende de la pantalla de WoS queda pendiente.

| Punto | Resultado | Estado |
|---|---|---|
| WC acepta los nombres de categoría | Los 91.185 registros tienen al menos una de las cuatro categorías de Educación. | Listo (falta copiar la consulta exacta al registro) |
| PY=(2025-2026) recupera ambos años | Archivos: 2025 = 50.362; 2026 = 40.823. Ningún registro sin PY ni fuera de 2025-2026. | Falta contrastar con el filtro Publication Years de WoS |
| Registros Early Access | 52.420 registros son Early Access (27.540 de 2025 y 24.880 de 2026) y **todos traen PY asignado**; ninguno quedó sin año. | Listo |
| DT=(Article) con doble tipo | Article: 91.125 · Article; Retracted Publication: 39 · Article; Proceedings Paper: 18 · Article; Data Paper: 2 · Article; Publication with Expression of Concern: 1. Ningún Review. | Listo |
| Misma consulta en Salud y Computación/Ingeniería el mismo día | No se puede comprobar desde los archivos. | **PENDIENTE** (confirmar con los otros equipos) |

## B. Decisiones abiertas (sección 8 del protocolo)

| Tema | Situación | Propuesta |
|---|---|---|
| Registros con Computer Science, Artificial Intelligence sin otra categoría de Computación/Ingeniería | No hay ninguno en el universo final (0 de 85.611). | Cerrada: no requiere decisión. |
| Article; Proceedings Paper y Article; Early Access | Hay 18 Proceedings Paper en el universo final. Early Access no se distingue en la lista (todos tienen PY). | Mantenerlos (no son Review), salvo instrucción del profesor. Hay que confirmarlo con él. |
| Early Access sin PY | No existen en este universo. | Cerrada: no requiere decisión. |
| Lista común de UT entre áreas | Pendiente. El cruce actual usa solo las categorías WC. | **Abierta**: acordar con Salud y Computación/Ingeniería. Si entregan sus UT, copiar en `data/ut_otras_areas.csv` (columna `UT`) y volver a correr `R/01_muestreo_EDU.R`. |
| Plazo de espera para solicitudes al autor (E3) | Sin definir. | **Abierta**. El protocolo sugiere 10 días hábiles. |
| Retractados | 35 registros marcados (`marca_retractado`) en el universo final. | Se tratan como E4 si salen sorteados. |

## C. Cambios propuestos al protocolo (v1.0 → v1.1)

Fecha: 2026-10-14. Los cambios ajustan el texto a lo que ya se hizo en el repositorio.

1. **Sección 5, nombres de los lotes.** Los lotes quedaron con el nombre que entrega WoS (`savedrecs.txt`, `savedrecs (1).txt`, …) y no como `wos_edu_00001-01000.txt`. Justificación: el protocolo pide no modificar los archivos crudos, el script ya los lee con ese patrón y `output/lotes_EDU.csv` guarda el nombre, el número de registros y la huella md5 de cada uno.
2. **Sección 6, salidas del script.** `cuotas_EDU.csv`, `flujo_EDU.csv` y `sessionInfo_EDU.txt` ya tienen los nombres del protocolo. Se agregan `lotes_EDU.csv` y la columna `A08_sugerido` en `lista_ordenada_EDU.csv`.
3. **Sección 6, pasos 3 y 4.** El script ahora excluye y cuenta aparte los `Article; Review` y los registros fuera de rango (PY o idioma). En esta exportación ambos conteos son 0.
4. **Sección 9, estructura del repositorio.** El repositorio incluye `docs/` con esta bitácora, el registro de búsqueda y el estado del checklist. Los PDF de textos completos y el archivo `.rar` dejan de versionarse (`.gitignore`).
5. **Sección 10, declaración de IA.** El texto propuesto nombra a Claude Opus 5.5. Debe reemplazarse por la herramienta y la versión que efectivamente se usaron (incluida la ayuda con el repositorio y los documentos), y por los autores reales de cada script.

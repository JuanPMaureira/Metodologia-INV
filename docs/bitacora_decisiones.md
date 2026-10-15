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

## D. Reemplazos en la selección de calibración (E2)

Fecha: 2026-10-15. Regla aplicada: un artículo cuyo texto no se puede conseguir se reemplaza por el siguiente de la reserva, en orden (`data/calibracion/seleccion_calibracion_EDU.csv`).

| Artículo sin acceso (orden en la selección) | DOI | Reemplazado por (reserva) | DOI |
|---|---|---|---|
| 12 | 10.1108/JPCC-09-2024-0166 | 21 | 10.1007/s10639-024-13003-4 |
| 14 | 10.1080/14767724.2026.2673130 | 22 | 10.5209/rced.96906 |
| 15 | 10.1080/00219266.2024.2420013 | 23 | 10.1186/s12909-025-07133-7 |
| 19 | 10.1080/08841241.2022.2109093 | 24 | 10.1038/s41539-026-00405-x |

El artículo 16 (10.51865/JESP.2026.1.20) se consiguió después y se mantiene. Cada reemplazo ocupa el mismo N.º de las planillas de codificación que el artículo al que reemplaza. `R/03_seleccion_calibracion_EDU.R` reproduce el sorteo original (antes de los reemplazos); la tabla vigente es el CSV. La reserva 25 y siguientes quedan sin usar.

## E. Roles del equipo y hora de descarga

Fecha: 2026-10-15. Cierra los puntos "roles E1" y "coordinador de datos" del protocolo (sección 1, hoy "por definir") y completa la hora del registro de búsqueda.

| Integrante | Iniciales (A08) | Rol E1 | Responsabilidades | Roles CRediT iniciales |
|---|---|---|---|---|
| Martín Eduardo Soto Cabezas | MSC | **Coordinador de datos** | Descarga y exportación de las bases de WoS; integridad de la base; registro de búsqueda; mantiene el repositorio (Git) y ejecuta los scripts. Codifica. | Data curation; Software; Investigation |
| Juan Pablo Maureira Sanhueza | JPM | **Coordinador de codificación y confiabilidad** (propuesto) | Calibración (E2): planillas, bitácora de desacuerdos y libro de códigos v2; cálculo de concordancia; documentación en `docs/`. Codifica. | Investigation; Validation; Formal analysis |

Ambos son codificadores (la codificación de los componentes A y B es humana, sección 12 del enunciado) y comparten Writing – original draft y Writing – review & editing. Conceptualization y Methodology corresponden al equipo y al Dr. José Alejandro González Campos.

**Hora de descarga.** Martín terminó de descargar las bases el 8 de octubre de 2026 a las 21:54 (hora de Chile). Esa hora queda en el registro de búsqueda como hora de la descarga.

**Pendiente:** el rol de JPM es una propuesta redactada a partir del trabajo realizado; confirmarlo entre ambos. Copiar esta tabla a la sección 1 del documento del protocolo (Word de Martín).

## F. Protocolo v1.1

Fecha: 2026-10-15. El protocolo pasa de la versión 1.0 (Word de Martín, 7 de octubre) a la 1.1, guardada en `docs/protocolo_E1.docx` y `docs/protocolo_E1.pdf`. Incorpora:

- Sección 1: roles de MSC y JPM, coordinador de datos y roles CRediT (sección E de esta bitácora).
- Secciones 3 y 8: resultados de la verificación de sintaxis (sección A) y estado de las decisiones abiertas (sección B).
- Sección 4: hora de descarga (21:54), responsable, N total y por edición, y lotes.
- Secciones 5 y 6: nombres de los lotes tal como los entrega WoS y salidas del script (`lotes_EDU.csv`, `A08_sugerido`) (sección C, puntos 1 a 3).
- Sección 9: estructura real del repositorio y checklist al día (sección C, punto 4).
- Sección 10: declaración de IA con las herramientas y versiones usadas (sección C, punto 5).

**Pendiente:** confirmar con Martín las versiones de IA de la sección 10 (el borrador v1.0 nombraba Claude Opus 5.5; en las actualizaciones de octubre se usó claude-sonnet-5-5), actualizar esa sección si se usa IA en la codificación de contraste, y pasar el repositorio a privado.

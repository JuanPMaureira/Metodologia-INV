# Estado de la Etapa 1 (E1) — Área Educación

Checklist de la sección 9 del protocolo, con corte al 2026-10-14.

| Ítem | Estado | Qué falta |
|---|---|---|
| Protocolo completo, exportado a PDF (`docs/protocolo_E1.pdf`) | **Pendiente** | Definir roles E1 y coordinador de datos (hoy "por definir"); actualizar la sección 10 (declaración de IA); incorporar los cambios de `docs/bitacora_decisiones.md`; exportar a PDF. |
| Registro de búsqueda completo | **Parcial** | `docs/registro_busqueda_EDU.md` está prellenado desde los archivos. Falta lo que solo se ve en WoS: fecha y hora de la búsqueda, consulta exacta, ajustes de sintaxis, responsable y N de la pantalla (total y por año). |
| Universo exportado en `data/raw/wos_edu/` | **Listo** | 92 lotes, 91.185 registros únicos. Falta explicar el lote de 185 registros fuera de secuencia (ver registro de búsqueda). |
| Script de muestreo ejecutado sin errores desde cero | **Listo** | `R/01_muestreo_EDU.R` se ejecutó en Windows (Martín) y se volvió a ejecutar en Linux: misma lista, mismos conteos. |
| `lista_ordenada_EDU.csv`, `cuotas_EDU.csv`, `flujo_EDU.csv` | **Listo** | Nombres ajustados al protocolo. La lista incluye la columna `A08_sugerido`. |
| Suma de lotes = N del registro de búsqueda | **Pendiente** | La suma de los lotes es 91.185 (`output/lotes_EDU.csv`). Falta el N de la pantalla de WoS para compararlo. |
| README que permita reproducir la lista | **Listo** | `README.md`. |
| Repositorio privado | **Pendiente** | El repositorio es público. Ver sección "Repositorio" del README. |

## Resultados clave del muestreo

- Universo WoS tras depurar duplicados: 91.185 (2025: 50.362; 2026: 40.823).
- Compartidos con otras áreas, eliminados: 5.574 (Salud 4.164; Computación/Ingeniería 1.410; ambas 0).
- Universo exclusivo de Educación: 85.611 (2025: 47.257; 2026: 38.354).
- Muestra n = 300: 166 artículos de 2025 y 134 de 2026 (asignación proporcional).
- Semilla 2026.
